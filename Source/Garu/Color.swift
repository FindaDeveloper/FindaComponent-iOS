//
//  Color.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/09.
//

import UIKit

/// 색상
public class Color {
    
    // MARK: MONO
    public static let mono000 = UIColor(hex: "#FFFFFF")
    public static let mono100 = UIColor(hex: "#F4F4F4")
    public static let mono200 = UIColor(hex: "#E9E9E9")
    public static let mono300 = UIColor(hex: "#DADADA")
    public static let mono400 = UIColor(hex: "#C7C7C7")
    public static let mono500 = UIColor(hex: "#A1A1A1")
    public static let mono600 = UIColor(hex: "#767676")
    public static let mono700 = UIColor(hex: "#484848")
    public static let mono800 = UIColor(hex: "#2D2D2D")
    public static let mono900 = UIColor(hex: "#1A1A1A")
    
    // MARK: NAVY
    public static let navy100 = UIColor(hex: "#AAB3BD")
    public static let navy200 = UIColor(hex: "#9BA6B3")
    public static let navy300 = UIColor(hex: "#7F8FA0")
    public static let navy500 = UIColor(hex: "#65798E")
    public static let navy700 = UIColor(hex: "#475B73")
    public static let navy900 = UIColor(hex: "#3D4D62")
    
    // MARK: BLUE
    public static let blue100 = UIColor(hex: "#E6F1FF")
    public static let blue200 = UIColor(hex: "#B0D4FD")
    public static let blue300 = UIColor(hex: "#60A9FF")
    public static let blue500 = UIColor(hex: "#227FEC")
    public static let blue700 = UIColor(hex: "#1D6ECC")
    public static let blue900 = UIColor(hex: "#215899")
    public static let accentBlue = UIColor(hex: "#0094FF")
    
    // MARK: YELLOW
    public static let yellow100 = UIColor(hex: "#FFF9B0")
    public static let yellow200 = UIColor(hex: "#FFF47D")
    public static let yellow300 = UIColor(hex: "#FFF046")
    public static let yellow500 = UIColor(hex: "#FFEA00")
    public static let yellow700 = UIColor(hex: "#FFDE31")
    public static let yellow900 = UIColor(hex: "#FFD231")
    
    // MARK: RED
    public static let red500 = UIColor(hex: "#D74861")
    public static let red700 = UIColor(hex: "#C13E55")
    public static let accentRed = UIColor(hex: "#EC2857")
}

public extension UIColor {
    
    // MARK: MONO
    static var mono000: UIColor { Color.mono000 }
    static var mono100: UIColor { Color.mono100 }
    static var mono200: UIColor { Color.mono200 }
    static var mono300: UIColor { Color.mono300 }
    static var mono400: UIColor { Color.mono400 }
    static var mono500: UIColor { Color.mono500 }
    static var mono600: UIColor { Color.mono600 }
    static var mono700: UIColor { Color.mono700 }
    static var mono800: UIColor { Color.mono800 }
    static var mono900: UIColor { Color.mono900 }
    
    // mono with alpha
    static var mono000op50: UIColor { Color.mono000.withAlphaComponent(0.5) }
    static var mono100op50: UIColor { Color.mono100.withAlphaComponent(0.5) }
    static var mono900op50: UIColor { Color.mono900.withAlphaComponent(0.5) }
    
    // MARK: NAVY
    static var navy100: UIColor { Color.navy100 }
    static var navy200: UIColor { Color.navy200 }
    static var navy300: UIColor { Color.navy300 }
    static var navy500: UIColor { Color.navy500 }
    static var navy700: UIColor { Color.navy700 }
    static var navy900: UIColor { Color.navy900 }
    
    // navy with alpha
    static var navy100op50: UIColor { Color.navy100.withAlphaComponent(0.5) }
    
    // MARK: BLUE
    static var blue100: UIColor { Color.blue100 }
    static var blue200: UIColor { Color.blue200 }
    static var blue300: UIColor { Color.blue300 }
    static var blue500: UIColor { Color.blue500 }
    static var blue700: UIColor { Color.blue700 }
    static var blue900: UIColor { Color.blue900 }
    
    // accent
    static var accentBlue: UIColor { Color.accentBlue }
    
    // MARK: YELLOW
    static var yellow100: UIColor { Color.yellow100 }
    static var yellow200: UIColor { Color.yellow200 }
    static var yellow300: UIColor { Color.yellow300 }
    static var yellow500: UIColor { Color.yellow500 }
    static var yellow700: UIColor { Color.yellow700 }
    static var yellow900: UIColor { Color.yellow900 }
    
    // MARK: RED
    static var red500: UIColor { Color.red500 }
    static var red700: UIColor { Color.red700 }
    
    // accnet
    static var accentRed: UIColor { Color.accentRed }
}

public extension UIColor {
    
    /**
     HEX String으로 UIColor 생성
     - Parameters:
        - hex: 색상코드
        - alpha: 하위 뷰에 영향이 있는 색상코드의 알파값
     */
    convenience init(hex: String, alpha: CGFloat = 1) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff)) / 255

                    self.init(red: r, green: g, blue: b, alpha: alpha)
                    return
                }
            }
        }

        self.init(red: 1, green: 0, blue: 0, alpha: 1)
    }
}
