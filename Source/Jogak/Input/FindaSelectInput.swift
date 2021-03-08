//
//  FindaSelectInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/05.
//

import UIKit

/// 선택 Input View
public class FindaSelectInput: UIView {
    
    /**
     - Parameters:
        - placeholder: textField의 placeholder
     */
    public init(placeholder: String) {
        self.placeholder = placeholder
        self.status = .basic
        super.init(frame: .zero)
        setLayout()
        refreshStatus()
        
        addTapGesture(.init(target: self, action: #selector(_clickSelf)))
    }
    
    //MARK: View
    
    private lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.spacing = 4
        return v
    }()
    
    /// 제목 레이블
    public lazy var titleLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .caption, color: .mono700)
        v.isHidden = true
        return v
    }()
    
    /// 텍스트 필드
    public lazy var textField: UITextField = {
        let v = UITextField()
        v.font = UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)
        v.textColor = .mono900
        v.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.mono500,
                NSAttributedString.Key.font: UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)!
            ]
        )
        return v
    }()
    
    /// 확장 아이콘
    public lazy var dropdownIcon: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(findaAsset: .dropdownUnselect)
        return v
    }()
    
    /// 에러 아이콘
    public lazy var errorIcon: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(findaAsset: .error)
        return v
    }()
    
    /// 에러 레이블
    public lazy var errorLabel = FindaLabel(style: .regular, size: .caption, color: .red500)
    
    /// 보더
    public lazy var border: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
        return v
    }()
    
    private lazy var borderHeightConstraint = border.heightAnchor.constraint(equalToConstant: 1)
    
    private func setLayout() {
        addSubviews([stackView, dropdownIcon, border, errorIcon, errorLabel])
        
        stackView.addArrangedSubviews([titleLabel, textField])
        
        stackView.setConstraints(
            top: top,
            left: left,
            right: right
        )
        dropdownIcon.setConstraints(
            right: stackView.right,
            centerY: textField.centerY
        )
        border.setConstraints(
            top: stackView.bottom,
            left: left,
            right: right,
            margins: .init(top: 6, left: 0, bottom: 0, right: 0)
        )
        borderHeightConstraint.isActive = true
        
        errorIcon.setConstraints(
            top: border.top,
            left: left,
            margins: .init(top: 6)
        )
        errorLabel.setConstraints(
            top: errorIcon.top,
            left: errorIcon.right,
            margins: .init(top: 1, left: 4)
        )
        setConstraints(
            bottom: errorIcon.bottom
        )
    }
    
    private func refreshStatus() {
        titleLabel.textColor = status.color
        border.backgroundColor = status.borderColor
        borderHeightConstraint.constant = status.borderHeight
        
        errorIcon.isHidden = status != .error
        errorLabel.isHidden = status != .error
        
        dropdownIcon.isHidden = status == .disable
        
        textField.isUserInteractionEnabled = false
    }
    
    //MARK: Data
    
    /// 클릭 액션
    public var click: Action?
    
    @objc private func _clickSelf() {
        status = .focused
        click?()
    }
    
    /**
     .textField의 placeholder
     - NOTE: 할당 시 재변경을 보장해 주지 않음
     */
    public var placeholder: String
    
    /**
     .titleLabel의 text
     - NOTE: titleLabel의 hidden을 동시에 설정하려면 해당 프로퍼티로 접근해야 함.
     */
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title == nil
        }
    }
    
    /// 뷰의 상태
    public var status: Status {
        didSet {
            refreshStatus()
        }
    }
    
    /// 뷰의 상태
    public enum Status: Int {
        
        /// 기본
        case basic
        
        /// 입력 중
        case focused
        
        /// 에러
        case error
        
        /// 비활성화
        case disable
        
        var borderHeight: CGFloat {
            switch self {
            case .basic:
                return 1
                
            case .focused,
                 .error:
                return 2
                
            case .disable:
                return 0
            }
        }
        
        var color: UIColor {
            switch self {
            case .basic,
                 .disable:
                return .mono700
                
            case .focused:
                return .blue500
                
            case .error:
                return .red500
            }
        }
        
        var borderColor: UIColor {
            switch self {
            case .basic,
                 .disable:
                return .mono200
                
            case .focused:
                return .blue500
                
            case .error:
                return .red500
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
