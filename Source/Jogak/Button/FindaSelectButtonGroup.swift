//
//  FindaSelectButtonGroup.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/05.
//

import UIKit

/// 단일 선택 버튼(FindaSelectButton)의 그룹
public class FindaSelectButtonGroup: UIView {
    
    /**
     - Parameters:
        - maxColumn: 한 줄당 최대 버튼 개수 (min 1, max 3)
        - buttonSize: 버튼 크기
     */
    public init(maxColumn: Int, buttonSize: ButtonSize) {
        self.maxColumn = max(min(maxColumn, 3), 1)
        self.buttonSize = buttonSize
        super.init(frame: .zero)
        setLayout()
        
        if maxColumn < 1 { fcLog("\(self)의 maxColumn가 0 이하입니다.") }
    }
    
    /// 버튼 데이터 (text, subText)
    public typealias Data = (text: String, subText: String?)
    
    //MARK: View
    
    /// 버튼 리스트 뷰
    public lazy var collectionView: UICollectionView = {
        let fl = UICollectionViewFlowLayout()
        fl.minimumLineSpacing = 10
        let v = UICollectionView(frame: .zero, collectionViewLayout: fl)
        v.register(FindaSelectButton.self, forCellWithReuseIdentifier: "FindaSelectButton")
        v.backgroundColor = .clear
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    private lazy var collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 0)
    
    private func setLayout() {
        addSubview(collectionView)
        
        collectionView.setConstraints(
            top: top,
            left: left,
            right: right
        )
        collectionViewHeight.isActive = true
        
        setConstraints(
            bottom: collectionView.bottom
        )
    }
    
    //MARK: Data
    
    /// 버튼이 선택될 때 index와 data를 알림
    public var notifySelected: ((IndexPath, Data?) -> Void)?
    
    /// 버튼을 만들 데이터 리스트
    public var datas = [Data]() {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionViewHeight.constant = collectionView.contentSize.height
            collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    }
    
    /// 선택된 버튼의 데이터
    public var selectedData: Data?
    
    /// 선택된 버튼의 인덱스
    public var selectedIndex: IndexPath?
    
    /// 한 줄당 최대 버튼 개수
    public let maxColumn: Int
    
    /// 버튼 크기
    public let buttonSize: ButtonSize
    
    /// 버튼 크기
    public enum ButtonSize {
        case small
        case large
        
        var value: CGFloat {
            switch self {
            case .small: return 40
            case .large: return 60
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FindaSelectButtonGroup: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        datas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let v = collectionView.dequeueReusableCell(withReuseIdentifier: "FindaSelectButton", for: indexPath) as! FindaSelectButton
        v.data = datas[indexPath.item]
        v.isSelect = false
        return v
    }
}

extension FindaSelectButtonGroup: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var cellWidth = collectionView.bounds.width
        cellWidth -= CGFloat((maxColumn - 1) * 10)
        cellWidth /= CGFloat(maxColumn)
        return CGSize(width: cellWidth - 0.01, height: buttonSize.value)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        if let v = collectionView.cellForItem(at: indexPath) as? FindaSelectButton {
            v.isSelect = true
            selectedData = v.data
            selectedIndex = indexPath
            notifySelected?(indexPath, v.data)
        }
    }
}

/**
 단일 선택 버튼
 
 - NOTE: FindaSelectButtonGroup을 이용하여 단일 선택을 보장하세요.
 */
public class FindaSelectButton: UICollectionViewCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
        
        layer.cornerRadius = 4
        layer.borderColor = UIColor.mono200.cgColor
    }
    
    //MARK: View
    
    public lazy var stackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        return v
    }()
    
    public lazy var label: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .paragraph, color: .mono600)
        v.textAlignment = .center
        v.numberOfLines = 2
        return v
    }()
    
    public lazy var subLabel: FindaLabel = {
        let v = FindaLabel(style: .regular, size: .caption, color: .mono600)
        v.textAlignment = .center
        return v
    }()
    
    private func setLayout() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubviews([label, subLabel])
        
        stackView.setConstraints(
            centerX: centerX,
            centerY: centerY
        )
    }
    
    private func refreshStatus() {
        layer.borderWidth = isSelect ? 0 : 1
        
        backgroundColor = isSelect ? .blue100 : .clear
        
        label.setLabel(
            style: isSelect ? .bold : .regular,
            size: .paragraph,
            color: isSelect ? .blue700 : .mono600
        )
        subLabel.setLabel(
            style: isSelect ? .bold : .regular,
            size: .caption,
            color: isSelect ? .blue700 : .mono600
        )
    }
    
    //MARK: Data
    
    public var data: FindaSelectButtonGroup.Data? {
        didSet {
            if let it = data {
                label.text = it.text
                subLabel.text = it.subText
                subLabel.isHidden = it.subText == nil
            }
        }
    }
    
    public var isSelect: Bool = false {
        didSet {
            refreshStatus()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
