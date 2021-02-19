//
//  FindaTextButton.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/17.
//

import UIKit
import SwiftUI

public class FindaUnderlineTextButton: UIButton {

    /**
     - Parameters:
        - title: 버튼 제목
        - click: 버튼 클릭 동작
     */
    public init(title: String, click: @escaping Action) {
        super.init(frame: .zero)
        self.click = click
        
        setAttributedTitle(
            NSMutableAttributedString(
                string: title,
                attributes: [
                    NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.foregroundColor: Color.navy700
                ]),
            for: .normal
        )
        
        titleLabel?.font = UIFont(
            name: TypographyStyle.regular.rawValue,
            size: TypographySize.caption.rawValue
        )
        
        contentEdgeInsets = .init(horizontal: 8, vertical: 4)
        
        addTarget(self, action: #selector(clickSelf), for: .touchUpInside)
    }
    
    //MARK: Data
    
    /**
     버튼 클릭
     */
    var click: Action?
    
    @objc private func clickSelf() {
        click?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class FindaDetailTextButton: UIView {
    
    /**
     - Parameters:
        - title: 버튼 제목
        - icon: 상세 이미지
        - accentColor: titleLabel과 detailIcon의 tintColor. nil(기본값)일 경우 titleLabel은 navy700, detailIcon은 navy500
     - nil일 경우
     */
    public init(title: String, icon: UIImage?, accentColor: UIColor? = nil, click: @escaping Action) {
        super.init(frame: .zero)
        setLayout()
        titleLabel.text = title
        
        icon?.withRenderingMode(.alwaysTemplate)
        
        if let it = accentColor {
            titleLabel.textColor = it
            detailIcon.tintColor = it
        } else {
            detailIcon.tintColor = .navy500
        }
        detailIcon.image = icon
        
        self.click = click
        addTapGesture(.init(target: self, action: #selector(clickSelf)))
    }
    
    //MARK: View
    
    /**
     버튼 제목 레이블
     */
    public lazy var titleLabel = FindaLabel(style: .regular, size: .caption, color: .navy700)
    
    /**
     상세 아이콘 뷰
     */
    public lazy var detailIcon = UIImageView()
    
    private func setLayout() {
        addSubviews([titleLabel, detailIcon])
        
        titleLabel.setConstraint(
            top: top,
            left: left,
            margins: .init(top: 6, left: 8),
            height: 19
        )
        detailIcon.setConstraint(
            top: titleLabel.top,
            left: titleLabel.right,
            margins: .init(left: 4, right: -6),
            width: 16,
            height: 16
        )
        setConstraint(
            right: detailIcon.right,
            bottom: titleLabel.bottom,
            margins: .init(right: 6, bottom: 6)
        )
    }
    
    //MARK: Data
    
    /**
     버튼 클릭
     */
    var click: Action?
    
    @objc private func clickSelf() {
        click?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
