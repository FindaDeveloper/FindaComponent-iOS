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
        UITextField.appearance().tintColor = .blue500
    }
}

extension UIFont {
    
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
    
    /**
     뷰의 constraints를 설정합니다
     
     - NOTE: 보편적인 constraint만을 설정합니다.
     
     - Parameters:
        - top: topAnchor.constraint(equalTo: top, constant: margins.top)
        - left: leftAnchor.constraint(equalTo: left, constant: margins.left)
        - right: rigthAnchor.constraint(equalTo: right, constant: margins.right)
        - bottom: bottomAnchor.constraint(equalTo: bottom, constant: margins.bottom)
        - centerX: centerXAnchor.constraint(equalTo: centerX)
        - centerY: centerYAnchor.constraint(equalTo: centerY)
        - margins: top, left, right, bottom의 constant를 설정합니다.
        - width: widthAnchor.constraint(equalToConstant: width)
        - height: heightAnchor.constraint(equalToConstant: height)
     */
    func setConstraints(
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
    
    /// .view.safeAreaLayoutGuide
    var safeArea: UILayoutGuide { view.safeAreaLayoutGuide }
    
    /// 디바이스의 safeAreaInsets.bottom 을 반환 (default: 0)
    var safeAreaInsetBottom: CGFloat {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        } else {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
    }
}

public extension UIEdgeInsets {
    
    /// Parameters의 기본값이 0으로 설정되어 있는 초기화
    init(top: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
    
    /**
     - NOTE: setConstraints()의 margins에서 사용하면 의도를 무시할 수 있습니다.
     
     - Parameters:
        - horizontal: .left, .right에 할당
        - vertical: .top, .bottom에 할당
     */
    init(horizontal: CGFloat = 0, vertical: CGFloat = 0) {
        self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
    }
}

public extension UIView {
    
    
    /**
     views 배열의 순서대로 addSubview()
     
     - Parameters:
        - views: 추가할 뷰
     */
    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
    
    /**
     isUserInteractionEnabled 를 활성화하고 tapGestureReconizer 를 추가함
     
     - Parameters:
        - tapGestureRecognizer: 추가할 UITapGestureRecognizer
     */
    func addTapGesture(_ tapGestureRecognizer: UITapGestureRecognizer) {
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGestureRecognizer)
    }
}

public extension UIStackView {
    
    /// views 배열의 순서대로 addArrangedSubview()
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}

/// Parameters 와 Return 값이 존재하지 않는 UserInteraction 에서 사용
public typealias Action = (() -> Void)

func fcLog(_ log: Any...) {
    print("[FindaComponentLog]", log)
}

func fcError(_ log: String) {
    fatalError("[FindaComponentError] \(log)")
}
