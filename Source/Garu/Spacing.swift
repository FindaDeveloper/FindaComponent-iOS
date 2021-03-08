//
//  Spacing.swift
//  FindaComponent
//
//  Created by 박영진 on 2021/02/09.
//

import Foundation

public let MINI     = Spacing.mini.rawValue
public let X_SMALL  = Spacing.xSmall.rawValue
public let SMALL    = Spacing.small.rawValue
public let MEDIUM   = Spacing.medium.rawValue
public let LARGE    = Spacing.large.rawValue
public let X_LARGE  = Spacing.xLarge.rawValue
public let JUMBO    = Spacing.jumbo.rawValue
public let MEGA     = Spacing.mega.rawValue
public let ULTRA    = Spacing.ultra.rawValue

/*
 간격
 */
public enum Spacing: CGFloat {
    case mini   = 4
    case xSmall = 8
    case small  = 12
    case medium = 16
    case large  = 20
    case xLarge = 24
    case jumbo  = 32
    case mega   = 40
    case ultra  = 60
}
