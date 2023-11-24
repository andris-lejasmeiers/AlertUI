//
//  UIAlertController+AlertViewModelProtocol.swift
//  AlertUI
//
//  Created by Andris Lejasmeiers on 05/02/2023.
//  Copyright © 2023 SIA GrottiApps. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public extension UIAlertController {
  convenience init(viewModel: AlertViewModelProtocol, style: Style) {
    self.init(title: viewModel.title, message: viewModel.message, preferredStyle: style)
    viewModel.actions.forEach {
      addAction(.init(action: $0))
    }
    if let action = viewModel.preferredAction {
      preferredAction = .init(action: action)
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
#endif
