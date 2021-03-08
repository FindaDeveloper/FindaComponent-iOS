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
        
        let v = FindaSelectButtonGroup(maxColumn: 3, buttonSize: .small)
        view.addSubview(v)
        v.setConstraints(
            top: safeArea.top,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        v.datas = [
            ("1", nil),
            ("1", nil),
            ("1", nil),
            ("1", nil),
            ("1", nil),
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

