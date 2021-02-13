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
    public init(title: String, icon: Icon) {
        super.init(frame: .zero)
        setLayout()
        titleLabel.text = title
        self.icon = icon
    }
    
    //MARK: View
    
    /**
     제목 레이블
     */
    public lazy var titleLabel = FindaLabel(style: .bold, size: .jumbo)
    
    /**
     아이콘 버튼
     */
    public lazy var iconButton: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.addTarget(self, action: #selector(clickIconButton), for: .touchUpInside)
        return v
    }()
    
    private func setLayout() {
        addSubview(titleLabel)
        addSubview(iconButton)
        
        titleLabel.setConstraint(
            top: top,
            left: left,
            margins: .init(top: 24, left: 20)
        )
        iconButton.setConstraint(
            right: right,
            centerY: titleLabel.centerY,
            margins: .init(right: -12),
            width: 40,
            height: 40
        )
        setConstraint(
            height: 78
        )
    }
    
    // MARK: Data
    
    /**
     iconButton(아이콘 버튼)의 데이터
     */
    public var icon: Icon? {
        didSet {
            if let it = icon {
                iconButton.setImage(it.image, for: .normal)
            }
        }
    }
    
    @objc private func clickIconButton() {
        self.icon?.imageClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
