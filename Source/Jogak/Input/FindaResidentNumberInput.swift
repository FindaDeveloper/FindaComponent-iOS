//
//  FindaResidentNumberInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/03.
//

import UIKit

public class FindaResidentNumberInput: UIView {
    
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
    
    public lazy var titleLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .caption, color: .mono700)
        v.text = "주민등록번호"
        return v
    }()
    
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
    
    public lazy var hypen: UIView = {
        let v = UIView()
        v.backgroundColor = .mono900
        return v
    }()
    
    public lazy var postTextField: UITextField = {
        let v = UITextField()
        v.font = UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)
        v.addTarget(self, action: #selector(_editingDidBegin(_:)), for: .editingDidBegin)
        v.addTarget(self, action: #selector(_editingChanged(_:)), for: .editingChanged)
        v.addTarget(self, action: #selector(_editingDidEnd(_:)), for: .editingDidEnd)
        v.textAlignment = type == .onlyGender ? .center : .left
        v.isSecureTextEntry = type != .onlyGender
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
    
    public lazy var genderLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .jumbo, color: .mono900)
        v.text = " •  •  •  •  •  • "
        return v
    }()
    
    public lazy var birthBorder: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
        return v
    }()
    
    public lazy var postBorder: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
        return v
    }()
    
    public lazy var errorIcon: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(findaAsset: .error)
        return v
    }()
    
    public lazy var errorLabel = FindaLabel(style: .regular, size: .caption, color: .red500)
    
    public lazy var birthBorderHeightConstraint = birthBorder.heightAnchor.constraint(equalToConstant: 1)
    
    public lazy var postBorderHeightConstraint = postBorder.heightAnchor.constraint(equalToConstant: 1)
    
    private func setLayout() {
        addSubviews([titleLabel, birthTextField, hypen, postTextField, birthBorder, postBorder, errorIcon, errorLabel])
        
        titleLabel.setConstraint(
            top: top,
            left: left,
            right: right
        )
        birthTextField.setConstraint(
            top: titleLabel.bottom,
            left: left,
            right: hypen.left,
            margins: .init(top: 4, right: -14)
        )
        hypen.setConstraint(
            centerX: centerX,
            centerY: birthTextField.centerY,
            width: 10,
            height: 2
        )
        switch type {
        case .all:
            postTextField.setConstraint(
                top: birthTextField.top,
                left: hypen.right,
                right: right,
                margins: .init(left: 16)
            )
        case .onlyGender:
            postTextField.setConstraint(
                top: birthTextField.top,
                left: hypen.right,
                margins: .init(left: 16),
                width: 16
            )
            addSubview(genderLabel)
            genderLabel.setConstraint(
                top: postTextField.top,
                left: postTextField.right,
                right: right,
                margins: .init(top: 1, left: 6)
            )
        case .withoutGender:
            addSubview(genderLabel)
            genderLabel.setConstraint(
                top: birthTextField.top,
                left: hypen.right,
                margins: .init(top: 1, left: 15),
                width: 16
            )
            postTextField.setConstraint(
                top: birthTextField.top,
                left: genderLabel.right,
                right: right,
                margins: .init(left: 5)
            )
        }
        birthBorder.setConstraint(
            top: birthTextField.bottom,
            left: birthTextField.left,
            right: birthTextField.right,
            margins: .init(top: 6, left: 0, bottom: 0, right: 0)
        )
        birthBorderHeightConstraint.isActive = true
        
        postBorder.setConstraint(
            top: postTextField.bottom,
            left: postTextField.left,
            right: postTextField.right,
            margins: .init(top: 6, left: 0, bottom: 0, right: 0)
        )
        postBorderHeightConstraint.isActive = true
        
        errorIcon.setConstraint(
            top: birthBorder.top,
            left: left,
            margins: .init(top: 6)
        )
        errorLabel.setConstraint(
            top: errorIcon.top,
            left: errorIcon.right,
            margins: .init(top: 1, left: 4)
        )
        setConstraint(
            bottom: errorIcon.bottom
        )
    }
    
    private func refreshStatus() {
        titleLabel.textColor = status.color
        postBorder.backgroundColor = status.borderColor
        birthBorder.backgroundColor = status.borderColor
        postBorderHeightConstraint.constant = status.borderHeight
        birthBorderHeightConstraint.constant = status.borderHeight * (type == .withoutGender ? 0 : 1)
        
        errorIcon.isHidden = status != .error
        errorLabel.isHidden = status != .error
        
        postTextField.isUserInteractionEnabled = status != .disable
        birthTextField.isUserInteractionEnabled = status != .disable
        
        birthTextField.isUserInteractionEnabled = type != .withoutGender
    }
    
    //MARK: Data
    
    public private(set) var type: RrnType
    
    public enum RrnType {
        case all
        case onlyGender
        case withoutGender
        
        var postPlaceholder: String {
            switch self {
            case .all: return " •  •  •  •  •  •  • "
            case .onlyGender: return "•"
            case .withoutGender: return " •  •  •  •  •  • "
            }
        }
    }
    
    public var placeholder: String {
        didSet {
            refreshStatus()
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
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
    
    public var status: Status {
        didSet {
            refreshStatus()
        }
    }
    
    public enum Status: Int {
        case basic
        case focused
        case error
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
            case .onlyGender: maxLength = 1
            case .withoutGender: maxLength = 6
            }
        }
        
        return (textField.text?.count ?? 0) < maxLength
    }
}
