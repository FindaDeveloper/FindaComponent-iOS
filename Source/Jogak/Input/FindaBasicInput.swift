//
//  FindaBasicInput.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/22.
//

import UIKit

/// UITextField 기반 Input View
public class FindaBasicInput: UIView {
    
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
        v.addTarget(self, action: #selector(_editingDidBegin(_:)), for: .editingDidBegin)
        v.addTarget(self, action: #selector(_editingChanged(_:)), for: .editingChanged)
        v.addTarget(self, action: #selector(_editingDidEnd(_:)), for: .editingDidEnd)
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
    
    /// 단위 레이블
    public lazy var unitLabel = FindaLabel(style: .regular, size: .jumbo, color: .mono900)
    
    /// 에러 아이콘
    public lazy var errorIcon: UIImageView = {
        let v = UIImageView()
        v.image = UIImage(findaAsset: .error)
        return v
    }()
    
    /// 에러 레이블
    public lazy var errorLabel = FindaLabel(style: .regular, size: .caption, color: .red500)
    
    /// 서브 레이블
    public lazy var subLabel = FindaLabel(style: .regular, size: .caption, color: .mono600)
    
    /// 보더
    public lazy var border: UIView = {
        let v = UIView()
        v.backgroundColor = .mono200
        return v
    }()
    
    private lazy var borderHeightConstraint = border.heightAnchor.constraint(equalToConstant: 1)
    
    private func setLayout() {
        addSubviews([stackView, unitLabel, border, errorIcon, errorLabel, subLabel])
        
        stackView.addArrangedSubviews([titleLabel, textField])
        
        stackView.setConstraints(
            top: top,
            left: left,
            right: right
        )
        unitLabel.setConstraints(
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
        subLabel.setConstraints(
            top: border.top,
            right: right,
            margins: .init(top: 5)
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
    }
    
    //MARK: Data
    
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
        subLabel.text = formatting?(textField) ?? ""
        status = (validation?(textField) ?? true) ? .focused : .error
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
    
    /// textField의 값이 변경될 때, subLabel의 text를 결정
    public var formatting: ((UITextField) -> String)?
    
    public static let numberFormatting: ((UITextField) -> String) = { textField in
        guard let text = textField.text?.replacingOccurrences(of:"[^0-9]", with: "", options: .regularExpression),
              let number = Int(text) else {
            return "0만 원"
        }
        
        if number == 0 {
            return "0만 원"
        }
        
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

extension FindaBasicInput: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length != 0 { return true }
        return (textField.text?.count ?? 0) < (unitLabel.text?.count ?? 0 > 0 ? 10 : 13)
    }
}
