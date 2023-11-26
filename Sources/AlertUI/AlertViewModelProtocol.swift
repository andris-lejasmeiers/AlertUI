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
}
