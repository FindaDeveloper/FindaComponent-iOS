//
//  FindaBasicHeader.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/13.
//

import UIKit

/// 제목, 뒤로가기 버튼, 우측 버튼이 존재하는 높이 50의 Header
public class FindaBasicHeader: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    // MARK: View
    
    /// 제목 레이블
    public lazy var titleLabel = FindaLabel(style: .regular, size: .paragraph, color: .mono800)
    
    /// 뒤로가기 버튼
    public lazy var backButton: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.setImage(UIImage(findaAsset: .goBack), for: .normal)
        v.addTarget(self, action: #selector(_clickBackButton), for: .touchUpInside)
        return v
    }()
    
    /// 우측 아이콘 버튼
    public lazy var rightIconButton: UIButton = {
        let v = UIButton()
        v.contentEdgeInsets = .init(horizontal: 8, vertical: 8)
        v.addTarget(self, action: #selector(_clickRightButton), for: .touchUpInside)
        return v
    }()
    
    /// 우측 텍스트 버튼
    public lazy var rightTextButton: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .paragraph, color: .mono800)
        v.addTapGesture(.init(target: self, action: #selector(_clickRightButton)))
        return v
    }()
    
    private func setLayout() {
        addSubviews([titleLabel, backButton, rightIconButton, rightTextButton])
        
        titleLabel.setConstraints(
            centerX: centerX,
            centerY: centerY
        )
        backButton.setConstraints(
            left: left,
            centerY: centerY,
            margins: .init(left: 12),
            width: 40,
            height: 40
        )
        rightIconButton.setConstraints(
            right: right,
            centerY: centerY,
            margins: .init(right: -12),
            width: 40,
            height: 40
        )
        rightTextButton.setConstraints(
            right: right,
            centerY: centerY,
            margins: .init(right: -20),
            height: 40
        )
        setConstraints(
            height: 50
        )
    }
    
    // MARK: Data
    
    /// 우측 버튼의 형태
    public enum RightButtonType {
        
        /// 텍스트 형태
        case text(title: String, click: Action)
        
        /// 아이콘 형태
        case icon(image: UIImage?, click: Action)
    }
    
    
    /// 뒤로가기 버튼(backButton)의 액션
    public var clickBackButton: Action?
    
    /// 우측 버튼(rightIconButton, rightTextButton)의 액션
    private var rightButtonClick: Action?
    
    /**
     - 우측 버튼을 아래 중 하나로 결정
        - .icon: rightIconButton (아이콘)
        - .text: rightTextButton (텍스트)
        - nil: 미노출
     */
    public var rightButtonType: RightButtonType? {
        didSet {
            switch rightButtonType {
            case .icon(let image, let click):
                rightIconButton.setImage(image, for: .normal)
                rightButtonClick = click
                rightIconButton.isHidden = false
                rightTextButton.isHidden = true
                
            case .text(let title, let click):
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
