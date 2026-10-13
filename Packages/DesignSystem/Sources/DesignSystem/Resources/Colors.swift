import SwiftUI

extension Color {
  public static var brand: Color {
    Color(red: 187 / 255, green: 59 / 255, blue: 226 / 255)
  }

  public static var primaryBackground: Color {
    Color(red: 16 / 255, green: 21 / 255, blue: 35 / 255)
  }

  public static var secondaryBackground: Color {
    Color(red: 30 / 255, green: 35 / 255, blue: 62 / 255)
  }

  public static var label: Color {
    Color(.label)
  }
}

extension Color: @retroactive RawRepresentable {
  public init?(rawValue: Int) {
    let red = Double((rawValue & 0xFF0000) >> 16) / 0xFF
    let green = Double((rawValue & 0x00FF00) >> 8) / 0xFF
    let blue = Double(rawValue & 0x0000FF) / 0xFF
    // Bits 24-31 hold 255 - alpha so values saved without alpha decode as opaque.
    let opacity = Double(0xFF - ((rawValue >> 24) & 0xFF)) / 0xFF
    self = Color(red: red, green: green, blue: blue, opacity: opacity)
  }

  public var rawValue: Int {
    guard let coreImageColor else {
      return 0
    }
    let red = Self.clampedComponent(coreImageColor.red)
    let green = Self.clampedComponent(coreImageColor.green)
    let blue = Self.clampedComponent(coreImageColor.blue)
    let alpha = Self.clampedComponent(coreImageColor.alpha)
    return ((0xFF - alpha) << 24) | (red << 16) | (green << 8) | blue
  }

  private static func clampedComponent(_ value: CGFloat) -> Int {
    min(max(Int(value * 255 + 0.5), 0), 255)
  }

  private var coreImageColor: CIColor? {
    CIColor(color: .init(self))
  }
}

extension Color {
  init(hex: Int, opacity: Double = 1.0) {
    let red = Double((hex & 0xFF0000) >> 16) / 255.0
    let green = Double((hex & 0xFF00) >> 8) / 255.0
    let blue = Double((hex & 0xFF) >> 0) / 255.0
    self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
  }
}
