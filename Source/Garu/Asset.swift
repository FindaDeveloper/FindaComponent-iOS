//
//  Asset.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/22.
//

import Foundation

/**
 Logo, Icon, Illustration등의 이미지
 */
public enum Asset: String {
    case close
    case detailDeep
    case error
    case goBack
}

public extension UIImage {
    
    convenience init?(findaAsset: Asset) {
        self.init(named: findaAsset.rawValue, in: Bundle(for: FindaResources.self), compatibleWith: nil)
    }
}
