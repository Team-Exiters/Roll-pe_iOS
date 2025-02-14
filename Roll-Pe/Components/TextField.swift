//
//  TextField.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/23/25.
//

import UIKit
import SnapKit

class TextField: UITextField, UITextFieldDelegate {
    var maxLength = 50 {
        didSet {
            setup()
        }
    }
    
    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.rollpeGray])
        }
    }
    
    let BORDER_WIDTH: CGFloat = 2
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.delegate = self
        
        // 입력 설정
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        
        self.contentVerticalAlignment = .center
        
        // 스타일
        self.backgroundColor = .rollpePrimary
        self.textColor = UIColor.rollpeSecondary
        self.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        
        self.clearButtonMode = .never
        
        // focus에 따라 스타일 변화
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        updateBorderColor()
    }
    
    // focus
    @objc private func editingDidBegin() {
        self.layer.borderColor = UIColor.rollpeSecondary.cgColor
    }
    
    // unfocus
    @objc private func editingDidEnd() {
        updateBorderColor()
    }
    
    // text 유무에 따른 border update
    private func updateBorderColor() {
        if let text = self.text, !text.isEmpty {
            self.layer.borderColor = UIColor.rollpeSecondary.cgColor
        } else {
            self.layer.borderColor = UIColor.rollpeGray.cgColor
        }
    }
    
    // 여백
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    // 글자수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
    }
}

// picker 전용 textfield
class TextFieldForPicker: UITextField, UITextFieldDelegate {
    override var placeholder: String? {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.rollpeGray])
        }
    }
    
    let BORDER_WIDTH: CGFloat = 2
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.delegate = self
        
        // 입력 설정
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        
        self.contentVerticalAlignment = .center
        
        // 스타일
        self.backgroundColor = .rollpePrimary
        self.textColor = UIColor.rollpeSecondary
        self.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        
        self.clearButtonMode = .never
        
        // focus에 따라 스타일 변화
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        
        updateBorderColor()
    }
    
    // focus
    @objc private func editingDidBegin() {
        self.layer.borderColor = UIColor.rollpeSecondary.cgColor
    }
    
    // unfocus
    @objc private func editingDidEnd() {
        updateBorderColor()
    }
    
    // text 유무에 따른 border update
    private func updateBorderColor() {
        if let text = self.text, !text.isEmpty {
            self.layer.borderColor = UIColor.rollpeSecondary.cgColor
        } else {
            self.layer.borderColor = UIColor.rollpeGray.cgColor
        }
    }
    
    // 여백
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    // 입력 방지
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}
