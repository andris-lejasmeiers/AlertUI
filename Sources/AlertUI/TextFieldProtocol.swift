//
//  TextFieldProtocol.swift
//  AlertUI
//
//  Created by Andris Lejasmeiers on 25/11/2023.
//  Copyright © 2023 SIA GrottiApps. All rights reserved.
//

public protocol TextFieldProtocol {
  var placeholder: String? { get }
  var text: String? { get }
  var keyboardType: KeyboardType { get }
  var isSecureTextEntry: Bool { get }
  var textContentType: ContentType? { get }
  var clearButtonMode: ViewMode { get }
  var accessibilityLabel: String? { get }
  var accessibilityHint: String? { get }
  /// return NO to disallow editing.
  var shouldBeginEditing: ((String?) -> Bool)? { get }
  /// became first responder
  var didBeginEditing: ((String?) -> Void)? { get }
  /// return YES to allow editing to stop and to resign first responder status. NO to disallow the
  /// editing session to end
  var shouldEndEditing: ((String?) -> Bool)? { get }
  /// may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or
  /// endEditing:YES called
  var didEndEditing: ((String?) -> Void)? { get }
  /// return NO to not change text
  var shouldChangeCharactersInRange: ((String?, (location: Int, length: Int), String) -> Bool)? {
    get
  }
  /// called when clear button pressed. return NO to ignore (no notifications)
  var shouldClear: ((String?) -> Bool)? { get }
  /// called when 'return' key pressed. return NO to ignore.
  var shouldReturn: ((String?) -> Bool)? { get }
}

public enum KeyboardType {
  /// Default type for the current input method.
  case `default`
  /// Displays a keyboard which can enter ASCII characters
  case asciiCapable
  /// Numbers and assorted punctuation.
  case numbersAndPunctuation
  /// A type optimized for URL entry (shows . / .com prominently).
  case URL
  /// A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
  case numberPad
  /// A phone pad (1-9, *, 0, #, with letters under the numbers).
  case phonePad
  /// A type optimized for entering a person's name or phone number.
  case namePhonePad
  /// A type optimized for multiple email address entry (shows space @ . prominently).
  case emailAddress
  /// A number pad with a decimal point.
  case decimalPad
  /// A type optimized for twitter text entry (easy access to @ #)
  case twitter
  /// A default keyboard type with URL-oriented addition (shows space . prominently).
  case webSearch
  /// A number pad (0-9) that will always be ASCII digits.
  case asciiCapableNumberPad
}

public enum ViewMode {
  case never
  case whileEditing
  case unlessEditing
  case always
}

public enum ContentType {
  case name
  case namePrefix
  case givenName
  case middleName
  case familyName
  case nameSuffix
  case nickname
  case jobTitle
  case organizationName
  case location
  case fullStreetAddress
  case streetAddressLine1
  case streetAddressLine2
  case addressCity
  case addressState
  case addressCityAndState
  case sublocality
  case countryName
  case postalCode
  case telephoneNumber
  case emailAddress
  case URL
  case creditCardNumber
  case username
  case password
  case newPassword
  case oneTimeCode
}
