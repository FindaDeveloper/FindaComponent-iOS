//
//  FindaComponent.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/08.
//

import Foundation

public class FindaFont {
    
    /**
     Spoqa Han Sans 폰트를 사용하려면 초기화가 필요합니다.
     */
    public static func initialize() {
        UIFont.fontsURLs().forEach {
            UIFont.register(from: $0)
        }
    }
}

public extension UIFont {
    
    static func register(from url: URL) {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            return
        }
        let font = CGFont(fontDataProvider)!
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            return
        }
    }
    
    static func fontsURLs() -> [URL] {
        let bundle = Bundle(identifier: "org.cocoapods.FindaComponent")!
        let fileNames = ["SpoqaHanSansNeo-Light", "SpoqaHanSansNeo-Regular", "SpoqaHanSansNeo-Bold"]
        return fileNames.map({ bundle.url(forResource: $0, withExtension: "ttf")! })
    }
}
