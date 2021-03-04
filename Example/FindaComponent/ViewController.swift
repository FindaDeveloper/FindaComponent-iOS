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
        
        let rrnAll = FindaResidentNumberInput(rrnType: .all)
        view.addSubview(rrnAll)
        rrnAll.setConstraint(
            top: basicInput.bottom,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        let rrnOnlyGender = FindaResidentNumberInput(rrnType: .onlyGender)
        view.addSubview(rrnOnlyGender)
        rrnOnlyGender.setConstraint(
            top: rrnAll.bottom,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        let rrnWithoutGender = FindaResidentNumberInput(rrnType: .withoutGender)
        view.addSubview(rrnWithoutGender)
        rrnWithoutGender.genderLabel.text = "3"
        rrnWithoutGender.birthTextField.text = "020303"
        rrnWithoutGender.titleLabel.text = "주민등록번호 뒷자리"
        rrnWithoutGender.setConstraint(
            top: rrnOnlyGender.bottom,
            left: view.left,
            right: view.right,
            margins: .init(top: 20, left: 20, right: -20)
        )
        
        let certificateInput = FindaCertificateInput(certificateSecond: 5)
        view.addSubview(certificateInput)
        certificateInput.setConstraint(
            top: rrnWithoutGender.bottom,
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

