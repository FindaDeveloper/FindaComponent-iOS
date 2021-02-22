//
//  FindaBasicHeader.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/13.
//

import UIKit

/**
 제목, 뒤로가기 버튼, 우측 버튼이 존재하는 높이 50의 Header
 */
public class FindaBasicHeader: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    // MARK: View
    
    /**
     제목 레이블
     */
    public lazy var titleLabel = FindaLabel(style: .regular, size: .paragraph, color: .mono800)
    
    /**
     뒤로가기 버튼
     */
    public lazy var backButton: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.setImage(UIImage(findaAsset: .goBack), for: .normal)
        v.addTarget(self, action: #selector(_clickBackButton), for: .touchUpInside)
        return v
    }()
    
    /**
     우측 아이콘 버튼
     */
    public lazy var rightIconButton: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.addTarget(self, action: #selector(_clickRightButton), for: .touchUpInside)
        return v
    }()
    
    /**
     우측 텍스트 버튼
     */
    public lazy var rightTextButton: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .paragraph, color: .mono800)
        v.addTapGesture(.init(target: self, action: #selector(_clickRightButton)))
        return v
    }()
    
    private func setLayout() {
        addSubviews([titleLabel, backButton, rightIconButton, rightTextButton])
        
        titleLabel.setConstraint(
            centerX: centerX,
            centerY: centerY
        )
        backButton.setConstraint(
            left: left,
            centerY: centerY,
            margins: .init(left: 12),
            width: 40,
            height: 40
        )
        rightIconButton.setConstraint(
            right: right,
            centerY: centerY,
            margins: .init(right: -12),
            width: 40,
            height: 40
        )
        rightTextButton.setConstraint(
            right: right,
            centerY: centerY,
            margins: .init(right: -20),
            height: 40
        )
        setConstraint(
            height: 50
        )
    }
    
    // MARK: Data
    
    public typealias Icon = (image: UIImage?, imageClick: Action)
    
    public enum RightButtonType {
        case Text(title: String, click: Action)
        case Icon(image: UIImage?, click: Action)
    }
    
    /**
     backButton(뒤로가기 버튼)의 데이터
     */
    public var clickBackButton: Action?
    
    /**
     rightIconButton, rightTextButton(우측 버튼)의 데이터
     nil일 경우 우측 버튼을 전부 미노출시킨다.
     */
    public var rightButtonType: RightButtonType? {
        didSet {
            switch rightButtonType {
            case .Icon(let image, let click):
                rightIconButton.setImage(image, for: .normal)
                rightButtonClick = click
                rightIconButton.isHidden = false
                rightTextButton.isHidden = true
            case .Text(let title, let click):
                rightTextButton.text = title
                rightButtonClick = click
                rightIconButton.isHidden = true
                rightTextButton.isHidden = false
                if title.count > 13 {
                    fcLog("\(self.rightTextButton)의 text 길이가 13자리를 초과하였습니다.")
                }
            case .none:
                rightIconButton.isHidden = true
                rightTextButton.isHidden = true
                break 
            }
        }
    }
    
    private var rightButtonClick: Action?
    
    @objc private func _clickBackButton() {
        self.clickBackButton?()
    }
    
    @objc private func _clickRightButton() {
        self.rightButtonClick?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
