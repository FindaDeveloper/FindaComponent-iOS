//
//  FindaCertificateInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/04.
//

import UIKit

/// SMS 인증을 위한 Input View
public class FindaCertificateInput: UIView {
    
    /**
     - Parameters:
        - placeholder: textField의 placeholder
        - certificateSecond: 인증 제한 시간 (단위: 초)
     */
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
    
    /// 제목 레이블
    public lazy var titleLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .caption, color: .mono700)
        v.text = "인증번호"
        return v
    }()
    
    /// 텍스트 필드
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
    
    /// 제한 시간 레이블
    public lazy var timerLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .h2, color: .blue500)
        v.text = String(format: "%02d:%02d", certificateSecond / 60, certificateSecond % 60)
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
    
    /// 재요청 버튼
    public lazy var retryButton = FindaButton(type: .line, size: .small, title: "인증번호 재요청", click: {})
    
    private func setLayout() {
        addSubviews([titleLabel, textField, timerLabel, border, errorIcon, errorLabel, retryButton])
        
        titleLabel.setConstraints(
            top: top,
            left: left,
            right: right
        )
        textField.setConstraints(
            top: titleLabel.bottom,
            left: left,
            right: retryButton.left,
            margins: .init(top: 4, right: -12)
        )
        timerLabel.setConstraints(
            right: textField.right,
            centerY: textField.centerY
        )
        border.setConstraints(
            top: textField.bottom,
            left: textField.left,
            right: timerLabel.right,
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
        retryButton.setConstraints(
            right: right,
            bottom: border.top,
            width: 118
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
        
        textField.isUserInteractionEnabled = status != .disable
        
        timerLabel.textColor = status == .error ? .red500 : .blue500
    }
    
    //MARK: Data
    
    /// 인증 제한 시간 타이머
    public var timer: Timer?
    
    /// 타이머를 초기화하고 시작함
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
    
    /// 인증 제한 시간 (단위: 초)
    public var certificateSecond: Int
    
    /**
     retryButton의 clickAction
     
     - NOTE: 해당 프로퍼티로 설정하지 않고 retryButton.click 으로 접근하면 타이머 재시작을 보장하지 않음
     */
    public var clickRetryButton: Action? {
        didSet {
            retryButton.click = { [weak self] in
                self?.clickRetryButton?()
                self?.startTimer(self?.certificateSecond ?? 0)
            }
        }
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
    
    /**
     textField의 값이 변경될 때, 유효성을 검사하여 status를 변경
     true 반환 시 .focused, false 반환 시 .error
     */
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

extension FindaCertificateInput: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length != 0 { return true }
        return (textField.text?.count ?? 0) < 6
    }
}
