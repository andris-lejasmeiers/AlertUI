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
  convenience init(viewModel: AlertViewModelProtocol) {
    self.init(
      title: viewModel.title,
      message: viewModel.message,
      preferredStyle: .init(style: viewModel.style)
    )
    if #available(iOS 16.0, *) {
      severity = .init(severity: viewModel.severity)
    }
    for item in viewModel.actions {
      let action = UIAlertAction(action: item)
      addAction(action)
      if item.isPreferred {
        preferredAction = action
      }
    }
    for model in viewModel.textFields {
      addTextField {
        $0.placeholder = model.placeholder
        $0.text = model.text
        $0.keyboardType = .init(type: model.keyboardType)
        $0.isSecureTextEntry = model.isSecureTextEntry
        if let type = model.textContentType {
          $0.textContentType = .init(type: type)
        }
        $0.clearButtonMode = .init(mode: model.clearButtonMode)
        $0.accessibilityLabel = model.accessibilityLabel
        $0.accessibilityHint = model.accessibilityHint
        $0.setDelegate(proxy: .init(delegate: model))
      }
    }
  }
}

public extension UIAlertController.Style {
  init(style: AlertStyle) {
    self = switch style {
    case .actionSheet:
      .actionSheet
    case .alert,
         .currentContext,
         .custom,
         .formSheet,
         .fullScreen,
         .overCurrentContext,
         .overFullScreen,
         .pageSheet,
         .popover:
      .alert
    }
  }
}

@available(iOS 16.0, *)
public extension UIAlertControllerSeverity {
  init(severity: AlertSeverity) {
    self = switch severity {
    case .error,
         .informational,
         .success,
         .warning:
      .default
    case .critical:
      .critical
    }
  }
}

public extension UIAlertAction {
  convenience init(action: ActionProtocol) {
    self.init(
      title: action.title,
      style: .init(style: action.style)
    ) { _ in
      action.handler?()
    }
  }
}

public extension UIAlertAction.Style {
  init(style: ActionStyle) {
    self = switch style {
    case .default:
      .default
    case .cancel:
      .cancel
    case .destructive:
      .destructive
    }
  }
}

public extension UIKeyboardType {
  init(type: KeyboardType) {
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

public extension UITextContentType {
  init(type: ContentType) {
    switch type {
    case .name:
      self = Self.name
    case .namePrefix:
      self = Self.namePrefix
    case .givenName:
      self = Self.givenName
    case .middleName:
      self = Self.middleName
    case .familyName:
      self = Self.familyName
    case .nameSuffix:
      self = Self.nameSuffix
    case .nickname:
      self = Self.nickname
    case .jobTitle:
      self = Self.jobTitle
    case .organizationName:
      self = Self.organizationName
    case .location:
      self = Self.location
    case .fullStreetAddress:
      self = Self.fullStreetAddress
    case .streetAddressLine1:
      self = Self.streetAddressLine1
    case .streetAddressLine2:
      self = Self.streetAddressLine2
    case .addressCity:
      self = Self.addressCity
    case .addressState:
      self = Self.addressState
    case .addressCityAndState:
      self = Self.addressCityAndState
    case .sublocality:
      self = Self.sublocality
    case .countryName:
      self = Self.countryName
    case .postalCode:
      self = Self.postalCode
    case .telephoneNumber:
      self = Self.telephoneNumber
    case .emailAddress:
      self = Self.emailAddress
    case .URL:
      self = Self.URL
    case .creditCardNumber:
      self = Self.creditCardNumber
    case .username:
      self = Self.username
    case .password:
      self = Self.password
    case .newPassword:
      self = Self.newPassword
    case .oneTimeCode:
      self = Self.oneTimeCode
    }
  }
}

private class DelegateProxy: NSObject, UITextFieldDelegate {
  private let delegate: TextFieldProtocol

  init(delegate: TextFieldProtocol) {
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
