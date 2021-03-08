//
//  FindaResidentNumberInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/03.
//

import UIKit

/// UITextField 2개를 이용하여 주민등록 번호를 받는 Input View
public class FindaResidentNumberInput: UIView {
    
    /**
     - Parameters:
        - rrnType: 주민등록번호 입력 타입
        - placeholder: birthTextField의 placeholder
     */
    public init(
        rrnType: RrnType,
        placeholder: String = "앞자리 입력"
    ) {
        self.type = rrnType
        self.status = .basic
        self.placeholder = placeholder
        super.init(frame: .zero)
        setLayout()
        refreshStatus()
    }
    
    //MARK: View
    
    /// 제목 레이블
    public lazy var titleLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .caption, color: .mono700)
        v.text = "주민등록번호"
        return v
    }()
    
    /// 앞자리 텍스트 필드
    public lazy var birthTextField: UITextField = {
        let v = UITextField()
        v.font = UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)
        v.addTarget(self, action: #selector(_editingDidBegin(_:)), for: .editingDidBegin)
        v.addTarget(self, action: #selector(_editingChanged(_:)), for: .editingChanged)
        v.addTarget(self, action: #selector(_editingDidEnd(_:)), for: .editingDidEnd)
        v.keyboardType = .numberPad
        v.textColor = .mono900
        v.delegate = self
        v.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.mono500,
                NSAttributedString.Key.font: UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)!
            ]
        )
        v.tag = 0
        return v
    }()
    
    
    /// 하이픈
    public lazy var hypen: UIView = {
        let v = UIView()
        v.backgroundColor = .mono900
        return v
    }()
    
    /// 주민번호 뒷자리 텍스트 필드
    public lazy var postTextField: UITextField = {
        let v = UITextField()
        v.font = UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)
        v.addTarget(self, action: #selector(_editingDidBegin(_:)), for: .editingDidBegin)
        v.addTarget(self, action: #selector(_editingChanged(_:)), for: .editingChanged)
        v.addTarget(self, action: #selector(_editingDidEnd(_:)), for: .editingDidEnd)
        v.textAlignment = type == .untilGender ? .center : .left
        v.isSecureTextEntry = type != .untilGender
        v.keyboardType = .numberPad
        v.textColor = .mono900
        v.delegate = self
        v.attributedPlaceholder = NSAttributedString(
            string: type.postPlaceholder,
            attributes: [
                .foregroundColor: UIColor.mono500,
                NSAttributedString.Key.font: UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)!
            ]
        )
        v.tag = 1
        return v
    }()
    
    /**
     설정하지 않을 경우 •••••• 등 마스킹을 표현하지만 type이 .withoutGender이면 뒷자리 첫번째 숫자를 표현
     */
    public lazy var genderLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .jumbo, color: .mono900)
        v.text = " •  •  •  •  •  • "
        return v
    }()
    
    /// birthTextField 보더
    public lazy var birthBorder: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
        return v
    }()
    
    /// postTextField 보더
    public lazy var postBorder: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
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
    
    private lazy var birthBorderHeightConstraint = birthBorder.heightAnchor.constraint(equalToConstant: 1)
    
    private lazy var postBorderHeightConstraint = postBorder.heightAnchor.constraint(equalToConstant: 1)
    
    private func setLayout() {
        addSubviews([titleLabel, birthTextField, hypen, postTextField, birthBorder, postBorder, errorIcon, errorLabel])
        
        titleLabel.setConstraints(
            top: top,
            left: left,
            right: right
        )
        birthTextField.setConstraints(
            top: titleLabel.bottom,
            left: left,
            right: hypen.left,
            margins: .init(top: 4, right: -14)
        )
        hypen.setConstraints(
            centerX: centerX,
            centerY: birthTextField.centerY,
            width: 10,
            height: 2
        )
        switch type {
        case .all:
            postTextField.setConstraints(
                top: birthTextField.top,
                left: hypen.right,
                right: right,
                margins: .init(left: 16)
            )
        case .untilGender:
            postTextField.setConstraints(
                top: birthTextField.top,
                left: hypen.right,
                margins: .init(left: 16),
                width: 16
            )
            addSubview(genderLabel)
            genderLabel.setConstraints(
                top: postTextField.top,
                left: postTextField.right,
                right: right,
                margins: .init(top: 1, left: 6)
            )
        case .postWithoutGender:
            addSubview(genderLabel)
            genderLabel.setConstraints(
                top: birthTextField.top,
                left: hypen.right,
                margins: .init(top: 1, left: 15),
                width: 16
            )
            postTextField.setConstraints(
                top: birthTextField.top,
                left: genderLabel.right,
                right: right,
                margins: .init(left: 5)
            )
        }
        birthBorder.setConstraints(
            top: birthTextField.bottom,
            left: birthTextField.left,
            right: birthTextField.right,
            margins: .init(top: 6, left: 0, bottom: 0, right: 0)
        )
        birthBorderHeightConstraint.isActive = true
        
        postBorder.setConstraints(
            top: postTextField.bottom,
            left: postTextField.left,
            right: postTextField.right,
            margins: .init(top: 6, left: 0, bottom: 0, right: 0)
        )
        postBorderHeightConstraint.isActive = true
        
        errorIcon.setConstraints(
            top: birthBorder.top,
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
        postBorder.backgroundColor = status.borderColor
        birthBorder.backgroundColor = status.borderColor
        postBorderHeightConstraint.constant = status.borderHeight
        birthBorderHeightConstraint.constant = status.borderHeight * (type == .postWithoutGender ? 0 : 1)
        
        errorIcon.isHidden = status != .error
        errorLabel.isHidden = status != .error
        
        postTextField.isUserInteractionEnabled = status != .disable
        birthTextField.isUserInteractionEnabled = status != .disable
        
        birthTextField.isUserInteractionEnabled = type != .postWithoutGender
    }
    
    //MARK: Data
    
    /// 주민등록번호 입력 타입
    public private(set) var type: RrnType
    
    /// 주민등록번호 입력 타입
    public enum RrnType {
        
        /// 전부 받음
        case all
        
        /// 앞자리 및 성별
        case untilGender
        
        /// 성별을 제외한 뒷자리
        case postWithoutGender
        
        var postPlaceholder: String {
            switch self {
            case .all: return " •  •  •  •  •  •  • "
            case .untilGender: return "•"
            case .postWithoutGender: return " •  •  •  •  •  • "
            }
        }
    }
    
    /**
     .birthTextField의 placeholder
     - NOTE: 할당 시 재변경을 보장해 주지 않음
     */
    public var placeholder: String
    
    @objc private func _editingChanged(_ textField: UITextField) {
        status = .focused
    }
    
    @objc private func _editingDidBegin(_ textField: UITextField) {
        if status != .error {
            status = .focused
        }
    }
    
    @objc private func _editingDidEnd(_ textField: UITextField) {
        if status != .error {
            status = .basic
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

extension FindaResidentNumberInput: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length != 0 { return true }
        
        var maxLength = 0
        
        if textField.tag == 0 {
            maxLength = 6
        } else {
            switch type {
            case .all: maxLength = 7
            case .untilGender: maxLength = 1
            case .postWithoutGender: maxLength = 6
            }
        }
        
        return (textField.text?.count ?? 0) < maxLength
    }
}
