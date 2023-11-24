//
//  AlertViewModel.swift
//  AlertUI
//
//  Created by Andris Lejasmeiers on 05/02/2023.
//  Copyright © 2023 SIA GrottiApps. All rights reserved.
//

import Foundation

public struct AlertViewModel: AlertViewModelProtocol {
  public struct Action: AlertViewModelActionProtocol {
    public let title: String?
    public let style: AlertViewModelActionStyle
    public let handler: (() -> Void)?

    public init(title: String?, style: AlertViewModelActionStyle, handler: (() -> Void)?) {
      self.title = title
      self.style = style
      self.handler = handler
    }
  }

  public let title: String?
  public let message: String?
  public let actions: [AlertViewModelActionProtocol]
  public let preferredAction: AlertViewModelActionProtocol?

  public init(
    title: String?,
    message: String? = nil,
    actions: [AlertViewModelActionProtocol] = [],
    preferredAction: AlertViewModelActionProtocol? = nil
  ) {
    self.title = title
    self.message = message
    self.actions = actions
    self.preferredAction = preferredAction
  }
}

public extension AlertViewModel {
  init(
    title: String?,
    message: String? = nil,
    actions: [Action] = [],
    preferredAction: Action? = nil
  ) {
    self.title = title
    self.message = message
    self.actions = actions
    self.preferredAction = preferredAction
  }
}

public extension AlertViewModel.Action {
  init(title: String, retry handler: @escaping () -> Void) {
    self.init(title: title, style: .default, handler: handler)
  }

  init(title: String, dismiss handler: (() -> Void)?) {
    self.init(title: title, style: .cancel, handler: handler)
  }

  init(title: String, cancel handler: (() -> Void)?) {
    self.init(title: title, style: .cancel, handler: handler)
  }

  init(title: String, destructive handler: (() -> Void)?) {
    self.init(title: title, style: .destructive, handler: handler)
  }
}
