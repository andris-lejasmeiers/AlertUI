//
//  AlertViewModelProtocol.swift
//  AlertUI
//
//  Created by Andris Lejasmeiers on 05/02/2023.
//  Copyright © 2023 SIA GrottiApps. All rights reserved.
//

public protocol AlertViewModelProtocol {
  var title: String? { get }
  var message: String? { get }
  var actions: [ActionProtocol] { get }
  var textFields: [TextFieldProtocol] { get }
  var style: AlertStyle { get }
  var severity: AlertSeverity { get }
}

public enum AlertStyle {
  case alert
  case actionSheet
  case fullScreen
  case pageSheet
  case formSheet
  case currentContext
  case custom
  case overFullScreen
  case overCurrentContext
  case popover
}

public enum AlertSeverity {
  case informational
  case success
  case warning
  case error
  case critical
}
