//
//  ActionProtocol.swift
//  AlertUI
//
//  Created by Andris Lejasmeiers on 25/11/2023.
//  Copyright © 2023 SIA GrottiApps. All rights reserved.
//

public protocol ActionProtocol {
  var title: String? { get }
  var style: ActionStyle { get }
  var isPreferred: Bool { get }
  var handler: (() -> Void)? { get }
}

public enum ActionStyle {
  case `default`
  case cancel
  case destructive
}
