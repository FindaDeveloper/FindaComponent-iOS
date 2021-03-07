//
//  FindaSelectButtonGroup.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/03/05.
//

import UIKit

public class FindaSelectButtonGroup: UIView {
    
    public init(row: Int, buttonSize: ButtonSize) {
        self.row = max(min(row, 3), 1)
        self.buttonSize = buttonSize
        super.init(frame: .zero)
        setLayout()
        
        if row < 1 { fcLog("\(self)의 row가 0 이하입니다.") }
    }
    
    public typealias Data = (text: String, subText: String?)
    
    //MARK: View
    
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
    
    public lazy var collectionViewHeight = collectionView.heightAnchor.constraint(equalToConstant: 100)
    
    private func setLayout() {
        addSubview(collectionView)
        
        collectionView.setConstraint(
            top: top,
            left: left,
            right: right
        )
        collectionViewHeight.isActive = true
        
        setConstraint(
            bottom: collectionView.bottom
        )
    }
    
    //MARK: Data
    
    public var notifySelected: ((IndexPath, Data?) -> Void)?
    
    public var datas = [Data]() {
        didSet {
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            collectionViewHeight.constant = collectionView.contentSize.height
            collectionView(collectionView, didSelectItemAt: IndexPath(item: 0, section: 0))
        }
    }
    
    public var selectedData: Data?
    
    public let row: Int
    
    public let buttonSize: ButtonSize
    
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
        cellWidth -= CGFloat((row - 1) * 10)
        cellWidth /= CGFloat(row)
        return CGSize(width: cellWidth - 0.01, height: buttonSize.value)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.reloadData()
        collectionView.layoutIfNeeded()
        let v = collectionView.cellForItem(at: indexPath) as! FindaSelectButton
        v.isSelect = true
        selectedData = v.data
        notifySelected?(indexPath, v.data)
    }
}

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
        
        stackView.setConstraint(
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
