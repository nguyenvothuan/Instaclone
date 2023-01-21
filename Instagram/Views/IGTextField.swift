//
//  IGTextField.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/17/23.
//

import UIKit

class IGTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        leftViewMode = .always
        layer.cornerRadius = 8
        layer.borderWidth = 1
        backgroundColor = .secondarySystemBackground
        layer.borderColor = UIColor.secondaryLabel.cgColor
        autocapitalizationType = .none
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

}
