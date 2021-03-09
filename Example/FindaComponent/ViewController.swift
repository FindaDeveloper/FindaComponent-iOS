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
        
        let v = FindaBasicInput(placeholder: "대출 희망 금액")
        v.formatting = FindaBasicInput.numberFormatting
        view.addSubview(v)
        v.setConstraints(
            top: safeArea.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            margins: .init(top: 20, left: 20, right: -20)
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

