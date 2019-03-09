//
//  InscriptionPageItem.swift
//  EseoKami
//
//  Created by Romain Rabouan on 30/12/2018.
//  Copyright © 2018 Romain Rabouan. All rights reserved.
//

import UIKit
import BLTNBoard
import ParkedTextField

class InscriptionPageItem: BLTNPageItem {
    @objc public var textField: UITextField!
    @objc public var textFieldMdp: UITextField!
    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(placeholder: "Entre ton email ESEO", returnKey: .done, delegate: self)

        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        actionButton?.isEnabled = false
        textFieldMdp = interfaceBuilder.makeTextField(placeholder: "Entre ton mot de passe ESEO", returnKey: .done, delegate: self)
        textFieldMdp.isSecureTextEntry = true
         [textField, textFieldMdp].forEach({ $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)})
        return [textField, textFieldMdp]
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let mail = textField.text, !mail.isEmpty,
            let password = textFieldMdp.text, !password.isEmpty
            else {
                actionButton?.isEnabled = false
                return
        }
        actionButton?.isEnabled = true
    }
    
    override func tearDown() {
        super.tearDown()
        
        textField?.delegate = nil
        textFieldMdp?.delegate = nil
    }
    
    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }
}

extension InscriptionPageItem: UITextFieldDelegate {
    @objc open func isInputValid(text: String?) -> Bool {
        if text == nil || text!.isEmpty {
            return false
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
