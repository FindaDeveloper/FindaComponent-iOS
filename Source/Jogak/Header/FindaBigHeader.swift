//
//  FindaBigHeader.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/09.
//

import UIKit

/**
 제목과 우측 아이콘이 있는 높이가 78로 고정된 Header.
 */
public class FindaBigHeader: UIView {
    
    public typealias Icon = (image: UIImage?, imageClick: Action)
    
    /**
     - Parameters:
        - title: 제목 텍스트 (title.count <= 8)
     */
    public init(title: String) {
        super.init(frame: .zero)
        setLayout()
        titleLabel.text = title
    }
    
    //MARK: View
    
    /**
     제목 레이블
     */
    public lazy var titleLabel = FindaLabel(style: .bold, size: .jumbo)
    
    /**
     오른쪽 기준 첫번째 아이콘 버튼
     */
    public lazy var iconButton1: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.addTarget(self, action: #selector(clickIconButton1), for: .touchUpInside)
        return v
    }()
    
    /**
     오른쪽 기준 두번째 아이콘 버튼
     */
    public lazy var iconButton2: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.addTarget(self, action: #selector(clickIconButton2), for: .touchUpInside)
        return v
    }()
    
    /**
     오른쪽 기준 세번째 아이콘 버튼
     */
    public lazy var iconButton3: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.addTarget(self, action: #selector(clickIconButton3), for: .touchUpInside)
        return v
    }()
    
    private func setLayout() {
        addSubview(titleLabel)
        addSubview(iconButton1)
        addSubview(iconButton2)
        addSubview(iconButton3)
        
        titleLabel.setConstraint(
            top: top,
            left: left,
            margins: .init(top: 24, left: 20)
        )
        iconButton1.setConstraint(
            right: right,
            centerY: titleLabel.centerY,
            margins: .init(right: -12),
            width: 40,
            height: 40
        )
        iconButton2.setConstraint(
            right: iconButton1.left,
            centerY: titleLabel.centerY
        )
        iconButton3.setConstraint(
            right: iconButton2.left,
            centerY: titleLabel.centerY
        )
        setConstraint(
            height: 78
        )
    }
    
    // MARK: Data
    
    /**
     iconButton1(오른쪽 기준 첫번째 아이콘 버튼)의 데이터
     */
    public var icon1: Icon? {
        didSet {
            if let it = icon1 {
                iconButton1.setImage(it.image, for: .normal)
            }
        }
    }
    
    /**
     iconButton2(오른쪽 기준 두번째 아이콘 버튼)의 데이터
     */
    public var icon2: Icon? {
        didSet {
            if let it = icon2 {
                iconButton2.setImage(it.image, for: .normal)
            }
        }
    }
    
    /**
     iconButton3(오른쪽 기준 세번째 아이콘 버튼)의 데이터
     */
    public var icon3: Icon? {
        didSet {
            if let it = icon3 {
                iconButton3.setImage(it.image, for: .normal)
            }
        }
    }
    
    @objc private func clickIconButton1() {
        self.icon1?.imageClick()
    }
    
    @objc private func clickIconButton2() {
        self.icon2?.imageClick()
    }
    
    @objc private func clickIconButton3() {
        self.icon3?.imageClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
