//
//  FindaTextButton.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/17.
//

import UIKit
import SwiftUI

/// 밑줄이 있는 텍스트 버튼
public class FindaUnderlineTextButton: UIButton {

    /**
     - Parameters:
        - title: 버튼 제목
        - click: 버튼 클릭 액션
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
    
    /// 버튼 클릭
    var click: Action?
    
    @objc private func clickSelf() {
        click?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// 디테일 아이콘(>)이 있는 텍스트 버튼
public class FindaDetailTextButton: UIView {
    
    /**
     - Parameters:
        - title: 버튼 제목
        - icon: 상세 이미지
        - accentColor: titleLabel과 detailIcon의 tintColor. nil(기본값)일 경우 titleLabel은 navy700, detailIcon은 navy500
     */
    public init(title: String, accentColor: UIColor? = nil, click: @escaping Action) {
        super.init(frame: .zero)
        setLayout()
        titleLabel.text = title
        
        detailIcon.image = UIImage(findaAsset: .detailDeep)?.withRenderingMode(.alwaysTemplate)
        
        if let it = accentColor {
            detailIcon.tintColor = it
            titleLabel.textColor = it
        } else {
            detailIcon.tintColor = .navy500
        }
        
        self.click = click
        addTapGesture(.init(target: self, action: #selector(clickSelf)))
    }
    
    //MARK: View
    
    /// 버튼 제목 레이블
    public lazy var titleLabel = FindaLabel(style: .regular, size: .caption, color: .navy700)
    
    /// 상세 아이콘
    public lazy var detailIcon = UIImageView()
    
    private func setLayout() {
        addSubviews([titleLabel, detailIcon])
        
        titleLabel.setConstraints(
            top: top,
            left: left,
            margins: .init(top: 6, left: 8),
            height: 19
        )
        detailIcon.setConstraints(
            top: titleLabel.top,
            left: titleLabel.right,
            margins: .init(left: 4, right: -6),
            width: 16,
            height: 16
        )
        setConstraints(
            right: detailIcon.right,
            bottom: titleLabel.bottom,
            margins: .init(right: 6, bottom: 6)
        )
    }
    
    //MARK: Data
    
    /// 버튼 클릭
    var click: Action?
    
    @objc private func clickSelf() {
        click?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
