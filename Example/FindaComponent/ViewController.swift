//
//  ViewController.swift
//  FindaComponent
//
//  Created by ParkYoungjin0303 on 02/07/2021.
//  Copyright (c) 2021 ParkYoungjin0303. All rights reserved.
//

import UIKit
import FindaComponent

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectGroup = FindaSelectButtonGroup(row: 3, buttonSize: .small)
        view.addSubview(selectGroup)
        selectGroup.setConstraint(
            top: safeArea.top,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        selectGroup.datas = [
            ("SKT", nil),
            ("KT", nil),
            ("LG U+", nil),
        ]
        
        let selectGroup1 = FindaSelectButtonGroup(row: 2, buttonSize: .large)
        view.addSubview(selectGroup1)
        selectGroup1.setConstraint(
            top: selectGroup.bottom,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        selectGroup1.datas = [
            ("1\n하나", nil),
            ("2\n둘", nil),
            ("3\n셋", nil),
            ("4\n넷", nil),
            ("5\n다섯", nil),
        ]
        
        let selectGroup2 = FindaSelectButtonGroup(row: 0, buttonSize: .large)
        view.addSubview(selectGroup2)
        selectGroup2.setConstraint(
            top: selectGroup1.bottom,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        selectGroup2.datas = [
            ("1", "작은 하나"),
            ("2", "작은 둘"),
            ("3", "작은 셋"),
            ("4", "작은 넷"),
            ("5", "작은 다섯"),
        ]
        selectGroup2.notifySelected = { indexPath, data in
            print("selectGroup2", indexPath.item, data ?? "nil")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

