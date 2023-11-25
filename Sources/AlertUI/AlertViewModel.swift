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

  public struct TextField: AlertViewModelTextFieldProtocol {
    public let placeholder: String?
    public let text: String?
    public let keyboardType: AlertViewModelTextFieldKeyboardType
    public let isSecureTextEntry: Bool
    public let textContentType: String?
    public let clearButtonMode: ViewMode
    public let accessibilityLabel: String?
    public let accessibilityHint: String?

    public var shouldBeginEditing: ((String?) -> Bool)? = nil
    public var didBeginEditing: ((String?) -> Void)? = nil
    public var shouldEndEditing: ((String?) -> Bool)? = nil
    public var didEndEditing: ((String?) -> Void)? = nil
    public var shouldChangeCharactersInRange: (
      (String?, (location: Int, length: Int), String) -> Bool
    )? = nil
    public var shouldClear: ((String?) -> Bool)? = nil
    public var shouldReturn: ((String?) -> Bool)? = nil

    init(
      placeholder: String? = nil,
      text: String? = nil,
      keyboardType: AlertViewModelTextFieldKeyboardType = .default,
      isSecureTextEntry: Bool,
      textContentType: String? = nil,
      clearButtonMode: ViewMode = .never,
      accessibilityLabel: String? = nil,
      accessibilityHint: String? = nil,
      shouldBeginEditing: ((String?) -> Bool)? = nil,
      didBeginEditing: ((String?) -> Void)? = nil,
      shouldEndEditing: ((String?) -> Bool)? = nil,
      didEndEditing: ((String?) -> Void)? = nil,
      shouldChangeCharactersInRange: (
        (String?, (location: Int, length: Int), String) -> Bool
      )? = nil,
      shouldClear: ((String?) -> Bool)? = nil,
      shouldReturn: ((String?) -> Bool)? = nil
    ) {
      self.placeholder = placeholder
      self.text = text
      self.keyboardType = keyboardType
      self.isSecureTextEntry = isSecureTextEntry
      self.textContentType = textContentType
      self.clearButtonMode = clearButtonMode
      self.accessibilityLabel = accessibilityLabel
      self.accessibilityHint = accessibilityHint
      self.shouldBeginEditing = shouldBeginEditing
      self.didBeginEditing = didBeginEditing
      self.shouldEndEditing = shouldEndEditing
      self.didEndEditing = didEndEditing
      self.shouldChangeCharactersInRange = shouldChangeCharactersInRange
      self.shouldClear = shouldClear
      self.shouldReturn = shouldReturn
    }
  }

  public let title: String?
  public let message: String?
  public let actions: [AlertViewModelActionProtocol]
  public let preferredAction: AlertViewModelActionProtocol?
  public let textFields: [AlertViewModelTextFieldProtocol]

  public init(
    title: String?,
    message: String? = nil,
    actions: [AlertViewModelActionProtocol] = [],
    preferredAction: AlertViewModelActionProtocol? = nil,
    textFields: [AlertViewModelTextFieldProtocol] = []
  ) {
    self.title = title
    self.message = message
    self.actions = actions
    self.preferredAction = preferredAction
    self.textFields = textFields
  }
}

public extension AlertViewModel {
  init(
    title: String?,
    message: String? = nil,
    actions: [Action] = [],
    preferredAction: Action? = nil,
    textFields: [TextField] = []
  ) {
    self.title = title
    self.message = message
    self.actions = actions
    self.preferredAction = preferredAction
    self.textFields = textFields
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
