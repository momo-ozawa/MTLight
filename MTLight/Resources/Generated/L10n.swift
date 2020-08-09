// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// Balances
  internal static let balances = L10n.tr("Localizable", "Balances")
  /// d
  internal static let d = L10n.tr("Localizable", "d")
  /// Decoding error occurred
  internal static let decodingErrorOccurred = L10n.tr("Localizable", "Decoding error occurred")
  /// Incorrect path error occurred
  internal static let incorrectPathErrorOccurred = L10n.tr("Localizable", "Incorrect path error occurred")
  /// JPY
  internal static let jpy = L10n.tr("Localizable", "JPY")
  /// MMMM yyyy
  internal static let mmmmYyyy = L10n.tr("Localizable", "MMMM yyyy")
  /// Total Balance
  internal static let totalBalance = L10n.tr("Localizable", "Total Balance")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: nil, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    Bundle(for: BundleToken.self)
  }()
}
// swiftlint:enable convenience_type
