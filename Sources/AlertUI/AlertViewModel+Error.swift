//
//  AlertViewModel+Error.swift
//  AlertUI
//
//  Created by Andris Lejasmeiers on 13/03/2023.
//  Copyright © 2023 SIA GrottiApps. All rights reserved.
//

import Foundation

public enum RecoveryOptionType {
  case `default`
  case cancel
  case destructive
}

public protocol ExtendedRecoverableError: Error {
  func recoveryOptionType(optionIndex recoveryOptionIndex: Int) -> RecoveryOptionType
}

public extension AlertViewModel {
  init(
    title: String? = nil,
    error: Error,
    messageSeparator: String = " ",
    preRecoveryHandler preRecovery: ((Int) -> Void)? = nil,
    postRecoveryHandler postRecovery: ((Int) -> Void)? = nil
  ) {
    let message = Self.makeMessage(error: error, separator: messageSeparator)
    let actions = Self.makeActions(
      error: error,
      preRecoveryHandler: preRecovery,
      postRecoveryHandler: postRecovery
    )
    self = .init(title: title, message: message, actions: actions)
  }
}

public extension AlertViewModel {
  static func makeMessage(error: Error, separator: String = " ") -> String {
    var components = [String?]()
    if let localized = error as? LocalizedError {
      components.append(localized.errorDescription)
      components.append(localized.failureReason)
      components.append(localized.recoverySuggestion)
      components.append(localized.helpAnchor)
    }
    if components.isEmpty {
      components.append(error.localizedDescription)
    }
    return components.compactMap { $0 }.joined(separator: separator)
  }
}

public extension AlertViewModel {
  static func makeActions(
    error: Error,
    preRecoveryHandler preRecovery: ((Int) -> Void)?,
    postRecoveryHandler postRecovery: ((Int) -> Void)?
  ) -> [AlertViewModel.Action] {
    var actions = [AlertViewModel.Action]()
    guard let recoverable = error as? RecoverableError else {
      return actions
    }
    for (index, title) in recoverable.recoveryOptions.enumerated() {
      let type = (error as? ExtendedRecoverableError)?.recoveryOptionType(optionIndex: index)
      func recover() {
        preRecovery?(index)
        if recoverable.attemptRecovery(optionIndex: index) {
          postRecovery?(index)
          return
        }
        recoverable.attemptRecovery(optionIndex: index) { recovered in
          guard recovered else {
            recover()
            return
          }
          postRecovery?(index)
        }
      }
      actions.append(
        .init(title: title, style: .init(recoveryOptionType: type), handler: recover)
      )
    }
    return actions
  }
}

private extension ActionStyle {
  init(recoveryOptionType: RecoveryOptionType?) {
    self = switch recoveryOptionType {
    case .cancel:
      .cancel
    case .destructive:
      .destructive
    case .default,
         .none:
      .default
    }
  }
}
