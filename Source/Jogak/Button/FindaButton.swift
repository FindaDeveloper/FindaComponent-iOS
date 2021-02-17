//
//  FindaButton.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/17.
//

import UIKit

public class FindaButton: UIView {
    
    public init(type: Type, size: Size, title: String, click: @escaping Action) {
        self.type = type
        self.size = size
        self.click = click
        self.status = .enable
        super.init(frame: .zero)
        setLayout()
        refreshStatus()
        titleLabel.text = title
    }
    
    //MARK: View
    
    /**
     아이콘 뷰
     */
    public lazy var iconView: UIImageView = {
        let v = UIImageView()
        v.isHidden = true
        return v
    }()
    
    /**
     버튼 제목 레이블
     */
    public var titleLabel = FindaLabel()
    
    private lazy var titleLabelRightConstraint =
        titleLabel.centerX.constraint(equalTo: centerX, constant: 0)
    
    private func setLayout() {
        clipsToBounds = true
        
        layer.cornerRadius = 4
        
        addSubviews([titleLabel, iconView])
        
        titleLabelRightConstraint.isActive = true
        
        titleLabel.setConstraint(
            centerY: centerY
        )
        iconView.setConstraint(
            right: titleLabel.left,
            centerY: centerY,
            margins: .init(right: -8),
            width: 16,
            height: 16
        )
        setConstraint(
            height: size.heightSize()
        )
    }
    
    private func refreshStatus() {
        backgroundColor = FindaButton.colorTable[status.rawValue][type.rawValue]
        titleLabel.setLabel(style: type.titleStyle(), size: size.fontSize(), color: FindaButton.titleColorTable[status.rawValue][type.rawValue])
        
        if type == .line {
            layer.borderWidth = 1
            layer.borderColor = Color.navy100.withAlphaComponent(status == Status.disable ? 0.4 : 1).cgColor
        } else {
            layer.borderWidth = 0
        }
    }
    
    //MARK: Data
    
    /**
     아이콘 이미지
     */
    public var icon: UIImage? {
        didSet {
            if let it = icon {
                iconView.image = it
                iconView.isHidden = false
                titleLabelRightConstraint.constant = 4
            } else {
                iconView.isHidden = true
                titleLabelRightConstraint.constant = 0
            }
        }
    }
    
    /**
     버튼 클릭
     */
    public var click: Action?
    
    /**
     버튼 타입 (배경, 제목을 결정함)
     */
    public let type: Type
    
    public enum `Type`: Int {
        case primary
        case secondary
        case secondaryRegular
        case line
        case dark
        
        func titleStyle() -> TypographyStyle {
            self == .secondaryRegular || self == .line ? .regular : .bold
        }
    }
    
    /**
     버튼 크기 (버튼, 제목 크기를 결정함)
     */
    public let size: Size
    
    public enum Size {
        case small
        case medium
        case large
        
        func heightSize() -> CGFloat {
            switch self {
            case .small:    return 34
            case .medium:   return 44
            case .large:    return 52
            }
        }
        
        func fontSize() -> TypographySize {
            switch self {
            case .small:    return .caption
            case .medium:   return .paragraph
            case .large:    return .h2
            }
        }
    }
    
    /**
     버튼 상태
     */
    public var status: Status {
        didSet {
            refreshStatus()
        }
    }
    
    public enum Status: Int {
        case enable
        case hover
        case disable
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if status != .disable {
            status = .hover
            click?()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if status != .disable {
            status = .enable
        }
    }
    
    private static let colorTable: [[UIColor]] = [
        //Primary   Secondary   SecondaryRegular  Line           Dark
        [.blue500,  .mono200,   .mono200,         .mono000,      .navy900],                   // enable
        [.blue700,  .mono300,   .mono300,         .mono100,      UIColor(hex: "#364353")],    // hover
        [.mono200,  .mono200,   .mono200,         .mono000op50,  .clear]                      // disable
    ]
    
    private static let titleColorTable: [[UIColor]] = [
        //Primary   Secondary   SecondaryRegular Line           Dark
        [.mono000,  .navy700,   .navy700,        .navy700,      .mono000],   // enable
        [.mono200,  .navy500,   .navy500,        .navy300,      .mono300],   // hover
        [.navy100,  .navy100,   .navy100,        .navy200,      .clear]      // disable
    ]
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
