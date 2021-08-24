//
//  TextViewController.swift
//  PhoneNumberFilter
//
//  Created by Molder on 2021/8/12.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 註冊 textField editing Changed 監聽
        self.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
    }

    // 自定義 textField editing Changed 監聽事件
    @objc func textFieldDidChange(_ textField: UITextField) {
        // 過濾注音符號
        guard let text = textField.text, textField.markedTextRange?.start == nil else { return }
        // log 當下輸入的字串
        print(text)
        // 字串過濾
        let new = phoneNumberReplace(text: text)
        // 過濾後的字串
        print(new)
        // 顯示在 textField
        self.textField.text = new
    }
}

// MARK: TextFieldDelegate
extension TextViewController : UITextFieldDelegate {
    // textField 輸入長度限制
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        let limitation = 30
        return newLength <= limitation
    }
}

// MARK: 過濾Func
extension TextViewController {
    
    /// 輸入門號的過濾與前三碼 886 轉為 0
    /// - Parameter text: 輸入的號碼
    /// - Returns: 轉換後的號碼
    func phoneNumberReplace(text: String) -> String {
        
        // 過濾數字以外的字元，包含中英、符號、表情符號
        let charset = CharacterSet(charactersIn: "0123456789").inverted
        let tmpTextArray = text.components(separatedBy: charset)
        var newTmpText = ""
        for tmpText in tmpTextArray {
            if tmpText != "" {
                newTmpText = newTmpText + tmpText
            }
        }

        if newTmpText.count >= 3 {
            // 取 newTmpText 字串前三碼
            let start = newTmpText.index(newTmpText.startIndex, offsetBy: 0)
            let end = newTmpText.index(newTmpText.startIndex, offsetBy: 3)
            let range = start..<end
            var tmpFront = String(newTmpText[range])
            if tmpFront == "886" {
                tmpFront = tmpFront.replacingOccurrences(of: "886", with: "0")
            }
            
            // 取 newTmpText 字串去掉前三碼剩下的字串
            let index = newTmpText.index(newTmpText.startIndex, offsetBy: 3)
            let tmpBehind = String(newTmpText[index...])
            
            let newText = tmpFront + tmpBehind
            return newText
        } else {
            return newTmpText
        }
    }
}
