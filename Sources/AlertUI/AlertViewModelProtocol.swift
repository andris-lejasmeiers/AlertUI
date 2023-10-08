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
  var actions: [AlertViewModelActionProtocol] { get }
}

public protocol AlertViewModelActionProtocol {
  var title: String? { get }
  var style: AlertViewModelActionStyle { get }
  var handler: (() -> Void)? { get }
}

public enum AlertViewModelActionStyle: Int {
  case `default`
  case cancel
  case destructive
}
