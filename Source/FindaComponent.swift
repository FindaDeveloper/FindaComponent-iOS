//
//  FindaComponent.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/08.
//

import Foundation

public class FindaResources {
    
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

public extension UIView {
    
    var top:        NSLayoutYAxisAnchor { topAnchor }
    var left:       NSLayoutXAxisAnchor { leftAnchor }
    var right:      NSLayoutXAxisAnchor { rightAnchor }
    var bottom:     NSLayoutYAxisAnchor { bottomAnchor }
    var centerX:    NSLayoutXAxisAnchor { centerXAnchor }
    var centerY:    NSLayoutYAxisAnchor { centerYAnchor }
    
    func setConstraint(
        top:        NSLayoutYAxisAnchor?    = nil,
        left:       NSLayoutXAxisAnchor?    = nil,
        right:      NSLayoutXAxisAnchor?    = nil,
        bottom:     NSLayoutYAxisAnchor?    = nil,
        centerX:    NSLayoutXAxisAnchor?    = nil,
        centerY:    NSLayoutYAxisAnchor?    = nil,
        margins:    UIEdgeInsets            = .zero,
        width:      CGFloat?                = nil,
        height:     CGFloat?                = nil
    ) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let it = top     { topAnchor.constraint(equalTo: it, constant: margins.top).isActive = true }
        if let it = left    { leftAnchor.constraint(equalTo: it, constant: margins.left).isActive = true }
        if let it = right   { rightAnchor.constraint(equalTo: it, constant: margins.right).isActive = true }
        if let it = bottom  { bottomAnchor.constraint(equalTo: it, constant: margins.bottom).isActive = true }
        
        if let it = centerX { centerXAnchor.constraint(equalTo: it).isActive = true }
        if let it = centerY { centerYAnchor.constraint(equalTo: it).isActive = true }
        
        if let it = width   { widthAnchor.constraint(equalToConstant: it).isActive = true }
        if let it = height  { heightAnchor.constraint(equalToConstant: it).isActive = true }
    }
}

public extension UILayoutGuide {
    var top:        NSLayoutYAxisAnchor { topAnchor }
    var left:       NSLayoutXAxisAnchor { leftAnchor }
    var right:      NSLayoutXAxisAnchor { rightAnchor }
    var bottom:     NSLayoutYAxisAnchor { bottomAnchor }
}

public extension UIViewController {
    var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }
    
    var safeAreaInsetBottom: CGFloat {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
    }
}

public extension UIEdgeInsets {
    
    init(top: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

public extension UIView {
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    func addTapGesture(_ tapGestureRecognizer: UITapGestureRecognizer) {
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGestureRecognizer)
    }
}

public extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}

public typealias Action = (() -> Void)

func fcLog(_ log: String) {
    print("[FindaComponentLog] \(log)")
}
