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
        
        let basicInput = FindaBasicInput(placeholder: "대출 희망 금액")
        basicInput.title = "대출 희망 금액 입력"
        basicInput.unit = "만 원"
        basicInput.subLabel.text = "0 원"
        basicInput.subLabel.text = nil
        basicInput.validation = { textField in
            (textField.text?.count ?? 0) < 9
        }
        basicInput.textField.keyboardType = .numberPad
        basicInput.errorLabel.text = "1조 넘기는건 좀 아니지..."
        basicInput.formatting = FindaBasicInput.numberFormatting
        view.addSubview(basicInput)
        basicInput.setConstraint(
            top: safeArea.top,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        
        let dummyInput = FindaBasicInput(placeholder: "더미")
        view.addSubview(dummyInput)
        dummyInput.setConstraint(
            top: basicInput.bottom,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        
        let disableInput = FindaBasicInput(placeholder: "그림의 떡")
        disableInput.status = .disable
        view.addSubview(disableInput)
        disableInput.setConstraint(
            top: dummyInput.bottom,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

