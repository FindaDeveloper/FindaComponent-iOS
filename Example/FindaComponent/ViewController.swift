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
        
        let header = FindaBasicHeader()
        header.titleLabel.text = "핀다 대출신청"
        header.backButtonIcon = (UIImage(named: "go_back"), { print("back") })
        header.rightButtonType = .Icon(image: UIImage(named: "close"), click: { print("icon")})
        header.rightButtonType = .Text(title: "취소", click: { print("text") })
        view.addSubview(header)
        header.setConstraint(
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

