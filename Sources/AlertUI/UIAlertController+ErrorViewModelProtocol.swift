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
    self = switch type {
    case .default:
      .default
    case .asciiCapable:
      .asciiCapable
    case .numbersAndPunctuation:
      .numbersAndPunctuation
    case .URL:
      .URL
    case .numberPad:
      .numberPad
    case .phonePad:
      .phonePad
    case .namePhonePad:
      .namePhonePad
    case .emailAddress:
      .emailAddress
    case .decimalPad:
      .decimalPad
    case .twitter:
      .twitter
    case .webSearch:
      .webSearch
    case .asciiCapableNumberPad:
      .asciiCapableNumberPad
    }
  }
}

public extension UITextField.ViewMode {
  init(mode: ViewMode) {
    self = switch mode {
    case .never:
      .never
    case .whileEditing:
      .whileEditing
    case .unlessEditing:
      .unlessEditing
    case .always:
      .always
    }
  }
}

public extension UITextContentType {
  init(type: ContentType) {
    self = switch type {
    case .name:
      Self.name
    case .namePrefix:
      Self.namePrefix
    case .givenName:
      Self.givenName
    case .middleName:
      Self.middleName
    case .familyName:
      Self.familyName
    case .nameSuffix:
      Self.nameSuffix
    case .nickname:
      Self.nickname
    case .jobTitle:
      Self.jobTitle
    case .organizationName:
      Self.organizationName
    case .location:
      Self.location
    case .fullStreetAddress:
      Self.fullStreetAddress
    case .streetAddressLine1:
      Self.streetAddressLine1
    case .streetAddressLine2:
      Self.streetAddressLine2
    case .addressCity:
      Self.addressCity
    case .addressState:
      Self.addressState
    case .addressCityAndState:
      Self.addressCityAndState
    case .sublocality:
      Self.sublocality
    case .countryName:
      Self.countryName
    case .postalCode:
      Self.postalCode
    case .telephoneNumber:
      Self.telephoneNumber
    case .emailAddress:
      Self.emailAddress
    case .URL:
      Self.URL
    case .creditCardNumber:
      Self.creditCardNumber
    case .username:
      Self.username
    case .password:
      Self.password
    case .newPassword:
      Self.newPassword
    case .oneTimeCode:
      Self.oneTimeCode
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
