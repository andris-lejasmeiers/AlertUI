//
//  UIAlertController+AlertViewModelProtocol.swift
//  AlertUI
//
//  Created by Andris Lejasmeiers on 05/02/2023.
//  Copyright © 2023 SIA GrottiApps. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import UIKit

public extension UIAlertController {
  convenience init(viewModel: AlertViewModelProtocol, style: Style) {
    self.init(title: viewModel.title, message: viewModel.message, preferredStyle: style)
    viewModel.actions.forEach {
      addAction(.init(action: $0))
    }
    if let model = viewModel.preferredAction {
      preferredAction = .init(action: model)
    }
    viewModel.textFields.forEach { model in
      addTextField {
        $0.placeholder = model.placeholder
        $0.text = model.text
        $0.keyboardType = .init(type: model.keyboardType)
        $0.isSecureTextEntry = model.isSecureTextEntry
        if let type = model.textContentType {
          $0.textContentType = .init(rawValue: type)
        }
        $0.clearButtonMode = .init(mode: model.clearButtonMode)
        $0.accessibilityLabel = model.accessibilityLabel
        $0.accessibilityHint = model.accessibilityHint
        $0.setDelegate(proxy: .init(delegate: model))
      }
    }
  }
}

public extension UIAlertAction {
  convenience init(action: AlertViewModelActionProtocol) {
    self.init(
      title: action.title,
      style: .init(style: action.style)
    ) { _ in
      action.handler?()
    }
  }
}

public extension UIAlertAction.Style {
  init(style: AlertViewModelActionStyle) {
    self = Self(rawValue: style.rawValue) ?? .default
  }
}

public extension UIKeyboardType {
  init(type: AlertViewModelTextFieldKeyboardType) {
    switch type {
    case .default:
      self = .default
    case .asciiCapable:
      self = .asciiCapable
    case .numbersAndPunctuation:
      self = .numbersAndPunctuation
    case .URL:
      self = .URL
    case .numberPad:
      self = .numberPad
    case .phonePad:
      self = .phonePad
    case .namePhonePad:
      self = .namePhonePad
    case .emailAddress:
      self = .emailAddress
    case .decimalPad:
      self = .decimalPad
    case .twitter:
      self = .twitter
    case .webSearch:
      self = .webSearch
    case .asciiCapableNumberPad:
      self = .asciiCapableNumberPad
    }
  }
}

public extension UITextField.ViewMode {
  init(mode: ViewMode) {
    switch mode {
    case .never:
      self = .never
    case .whileEditing:
      self = .whileEditing
    case .unlessEditing:
      self = .unlessEditing
    case .always:
      self = .always
    }
  }
}

private class DelegateProxy: NSObject, UITextFieldDelegate {
  private let delegate: AlertViewModelTextFieldProtocol

  init(delegate: AlertViewModelTextFieldProtocol) {
    self.delegate = delegate
  }

  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    delegate.shouldBeginEditing?(textField.text) ?? true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate.didBeginEditing?(textField.text)
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    delegate.shouldEndEditing?(textField.text) ?? true
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate.didEndEditing?(textField.text)
  }

  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    delegate.shouldChangeCharactersInRange?(
      textField.text,
      (location: range.location, length: range.length),
      string
    ) ?? true
  }

  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    delegate.shouldClear?(textField.text) ?? true
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    delegate.shouldReturn?(textField.text) ?? true
  }
}

private var proxyDelegateKey: UInt8 = 0

private extension UITextField {
  func setDelegate(proxy: DelegateProxy) {
    objc_setAssociatedObject(self, &proxyDelegateKey, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    delegate = proxy
  }
}

#endif
