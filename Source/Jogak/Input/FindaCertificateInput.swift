//
//  FindaCertificateInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/04.
//

import UIKit

public class FindaCertificateInput: UIView {
    
    public init(
        placeholder: String = "6자리 입력",
        certificateSecond: Int = 180
    ) {
        self.certificateSecond = certificateSecond
        self.placeholder = placeholder
        self.status = .basic
        super.init(frame: .zero)
        setLayout()
        refreshStatus()
        startTimer(certificateSecond)
    }
    
    //MARK: View
    
    public lazy var titleLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .caption, color: .mono700)
        v.text = "인증번호"
        return v
    }()
    
    public lazy var textField: UITextField = {
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
        return v
    }()
    
    public lazy var timerLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .h2, color: .blue500)
        v.text = String(format: "%02d:%02d", certificateSecond / 60, certificateSecond % 60)
        return v
    }()
    
    public lazy var errorIcon: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(findaAsset: .error)
        return v
    }()
    
    public lazy var errorLabel = FindaLabel(style: .regular, size: .caption, color: .red500)
    
    public lazy var border: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
        return v
    }()
    
    public lazy var borderHeightConstraint = border.heightAnchor.constraint(equalToConstant: 1)
    
    public lazy var retryButton = FindaButton(type: .line, size: .small, title: "인증번호 재요청", click: {})
    
    private func setLayout() {
        addSubviews([titleLabel, textField, timerLabel, border, errorIcon, errorLabel, retryButton])
        
        titleLabel.setConstraint(
            top: top,
            left: left,
            right: right
        )
        textField.setConstraint(
            top: titleLabel.bottom,
            left: left,
            right: retryButton.left,
            margins: .init(top: 4, right: -12)
        )
        timerLabel.setConstraint(
            right: textField.right,
            centerY: textField.centerY
        )
        border.setConstraint(
            top: textField.bottom,
            left: textField.left,
            right: timerLabel.right,
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
        retryButton.setConstraint(
            right: right,
            bottom: border.top,
            width: 118
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
        
        timerLabel.textColor = status == .error ? .red500 : .blue500
    }
    
    //MARK: Data
    
    public var timer: Timer?
    
    public func startTimer(_ seconds: Int) {
        timer?.invalidate()
        
        var leftSeconds = seconds
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            leftSeconds -= 1
            
            self.timerLabel.text = String(
                format: "%02d:%02d",
                leftSeconds / 60,
                leftSeconds % 60
            )
            
            if leftSeconds == 0 {
                self.status = .error
                timer.invalidate()
            }
        }
    }
    
    public var certificateSecond: Int
    
    public var clickRetryButton: Action? {
        didSet {
            retryButton.click = { [weak self] in
                self?.clickRetryButton?()
                self?.startTimer(self?.certificateSecond ?? 0)
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
            titleLabel.isHidden = title == nil
        }
    }
    
    public var unit: String? {
        didSet {
            timerLabel.text = unit
            timerLabel.isHidden = unit == nil
        }
    }
    
    public var validation: ((UITextField) -> Bool)?
    
    @objc private func _editingChanged(_ textField: UITextField) {
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

extension FindaCertificateInput: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length != 0 { return true }
        return (textField.text?.count ?? 0) < 6
    }
}
