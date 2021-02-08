//
//  Typography.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/07.
//

import Foundation
import UIKit

/**
 폰트 사이즈
 */
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

/**
 폰트 스타일
 */
public enum TypographyStyle: String, CaseIterable {
    case light      = "SpoqaHanSansNeo-Light"
    case regular    = "SpoqaHanSansNeo-Regular"
    case bold       = "SpoqaHanSansNeo-Bold"
}

/**
 폰트 사이즈와 스타일을 포함한 UILabel
 */
public class FindaLabel: UILabel {
    
    /**
     - Parameters:
        - style: 폰트 스타일
        - size: 폰트 사이즈
     */
    public init(style: TypographyStyle, size: TypographySize) {
        super.init(frame: .zero)
        self.font = UIFont(name: style.rawValue, size: size.rawValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
