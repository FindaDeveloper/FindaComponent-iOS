//
//  FindaBasicInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/22.
//

import UIKit

public class FindaBasicInput: UIView {
    
    public init(placeholder: String) {
        self.placeholder = placeholder
        self.status = .basic
        super.init(frame: .zero)
        setLayout()
        refreshStatus()
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
        v.addTarget(self, action: #selector(_editingDidBegin(_:)), for: .editingDidBegin)
        v.addTarget(self, action: #selector(_editingChanged(_:)), for: .editingChanged)
        v.addTarget(self, action: #selector(_editingDidEnd(_:)), for: .editingDidEnd)
        v.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: UIColor.mono500,
                NSAttributedString.Key.font: UIFont(name: TypographyStyle.regular.rawValue, size: TypographySize.jumbo.rawValue)!
            ]
        )
        v.delegate = self
        return v
    }()
    
    public lazy var unitLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .jumbo, color: .mono900)
        v.isHidden = true
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
        addSubviews([stackView, unitLabel, border, errorIcon, errorLabel, subLabel])
        
        stackView.addArrangedSubviews([titleLabel, textField])
        
        stackView.setConstraint(
            top: top,
            left: left,
            right: right
        )
        unitLabel.setConstraint(
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
        
        textField.isUserInteractionEnabled = status != .disable
    }
    
    //MARK: Data
    
    public var placeholder: String {
        didSet {
            refreshStatus()
        }
    }
    
    public var title: String? {
        didSet {
            titleLabel.text = title
            titleLabel.isHidden = title == nil
        }
    }
    
    public var unit: String? {
        didSet {
            unitLabel.text = unit
            unitLabel.isHidden = unit == nil
        }
    }
    
    public var validation: ((UITextField) -> Bool)?
    
    @objc private func _editingChanged(_ textField: UITextField) {
        subLabel.text = formatting?(textField) ?? ""
        if validation?(textField) ?? true {
            status = .focused
        } else {
            status = .error
        }
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
    
    public var formatting: ((UITextField) -> String)?
    
    public static let numberFormatting: ((UITextField) -> String) = { textField in
        guard let text = textField.text else { return "0만 원" }
        guard let number = Int(text) else { return "0만 워" }
        
        var result = ""
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        let hundredMillion: Int = number / 10000
        let tenThousand: Int = number % 10000
        
        if hundredMillion != 0 {
            result.append("\(formatter.string(from: NSNumber(value: hundredMillion))!)억 ")
        }
        
        if tenThousand != 0 {
            result.append("\(formatter.string(from: NSNumber(value: tenThousand))!)만 ")
        }
        
        result.append("원")
        
        return result
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

extension FindaBasicInput: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length != 0 { return true }
        return (textField.text?.count ?? 0) < (unitLabel.text?.count ?? 0 > 0 ? 10 : 13)
    }
}
