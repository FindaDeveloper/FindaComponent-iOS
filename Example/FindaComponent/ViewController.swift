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
        
        let button = FindaButton(type: .primary, size: .small, title: "버튼") { print("button") }
        view.addSubview(button)
        button.setConstraint(
            left: view.left,
            right: view.right,
            bottom: view.bottom,
            margins: .init(top: 0, left: 20, bottom: -20 - safeAreaInsetBottom, right: -20)
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

