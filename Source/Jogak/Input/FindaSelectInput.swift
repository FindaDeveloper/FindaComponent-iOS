//
//  FindaSelectInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/05.
//

import UIKit

public class FindaSelectInput: UIView {
    
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
    
    public lazy var titleLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .caption, color: .mono700)
        v.isHidden = true
        return v
    }()
    
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
    
    public lazy var dropdownIcon: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(findaAsset: .dropdownUnselect)
        return v
    }()
    
    public lazy var errorIcon: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(findaAsset: .error)
        return v
    }()
    
    public lazy var errorLabel = FindaLabel(style: .regular, size: .caption, color: .red500)
    
    public lazy var subLabel = FindaLabel(style: .regular, size: .caption, color: .mono600)
    
    public lazy var border: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
        return v
    }()
    
    public lazy var borderHeightConstraint = border.heightAnchor.constraint(equalToConstant: 1)
    
    private func setLayout() {
        addSubviews([stackView, dropdownIcon, border, errorIcon, errorLabel, subLabel])
        
        stackView.addArrangedSubviews([titleLabel, textField])
        
        stackView.setConstraint(
            top: top,
            left: left,
            right: right
        )
        dropdownIcon.setConstraint(
            right: stackView.right,
            centerY: textField.centerY
        )
        border.setConstraint(
            top: stackView.bottom,
            left: left,
            right: right,
            margins: .init(top: 6, left: 0, bottom: 0, right: 0)
        )
        borderHeightConstraint.isActive = true
        
        errorIcon.setConstraint(
            top: border.top,
            left: left,
            margins: .init(top: 6)
        )
        errorLabel.setConstraint(
            top: errorIcon.top,
            left: errorIcon.right,
            margins: .init(top: 1, left: 4)
        )
        subLabel.setConstraint(
            top: border.top,
            right: right,
            margins: .init(top: 5)
        )
        setConstraint(
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
    
    public var click: Action?
    
    @objc private func _clickSelf() {
        status = .focused
        click?()
    }
    
    public var placeholder: String
    
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title == nil
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
