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
        
        let bigHeader = FindaBigHeader(title: "MY 대출")
        bigHeader.icon1 = (UIImage(named: "close"), { print("1") })
        bigHeader.icon2 = (UIImage(named: "close"), { print("2") })
        bigHeader.icon3 = (UIImage(named: "close"), { print("3") })
        view.addSubview(bigHeader)
        bigHeader.setConstraint(
            top: safeArea.top,
            left: view.left,
            right: view.right
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

