//
//  TestTextField.swift
//  PhoneNumberFilter
//
//  Created by Molder on 2021/8/24.
//

import UIKit

class TestTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) { return false }
        return super.canPerformAction(action, withSender: sender)
    }
}
