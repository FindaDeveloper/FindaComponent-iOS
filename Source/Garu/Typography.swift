//
//  Typography.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/07.
//

import Foundation
import UIKit

/// 폰트 사이즈
public enum TypographySize: CGFloat, CaseIterable {
    case mini       = 9
    case small      = 11
    case caption    = 13
    case paragraph  = 15
    case h2         = 17
    case h1         = 20
    case jumbo      = 23
    case mega       = 29
}

/// 폰트 스타일
public enum TypographyStyle: String, CaseIterable {
    case light      = "SpoqaHanSansNeo-Light"
    case regular    = "SpoqaHanSansNeo-Regular"
    case bold       = "SpoqaHanSansNeo-Bold"
}

/// 폰트 사이즈와 스타일을 포함한 UILabel
public class FindaLabel: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /**
     - Parameters:
        - style: 폰트 스타일
        - size: 폰트 사이즈
        - color: 폰트 색상
        - text: 텍스트
     */
    public init(style: TypographyStyle, size: TypographySize, color: UIColor, text: String? = nil) {
        super.init(frame: .zero)
        setLabel(style: style, size: size, color: color, text: text)
        self.numberOfLines = 0
    }
    
    /**
     - Parameters:
        - style: 폰트 스타일
        - size: 폰트 사이즈
        - color: 폰트 색상
        - nil 은 기본값 유지
     - text: 텍스트
     */
    public func setLabel(style: TypographyStyle? = nil, size: TypographySize? = nil, color: UIColor? = nil, text: String? = nil) {
        if let style = style?.rawValue,
           let size = size?.rawValue {
            self.font = UIFont(name: style, size: size)
        }
        if let it = color {
            self.textColor = it
        }
        if let it = text {
            self.text = it
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
