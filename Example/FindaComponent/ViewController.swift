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
        
//        let detailButton = FindaDetailTextButton(title: "테스트", click: {})
        let detailButton = FindaDetailTextButton(title: "테스트", accentColor: .accentBlue, click: {})
        view.addSubview(detailButton)
        detailButton.setConstraints(
            top: safeArea.top,
            left: view.left,
            margins: .init(top: 20, left: 20)
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

