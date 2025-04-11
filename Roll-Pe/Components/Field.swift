//
//  TextField.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/23/25.
//

import UIKit
import SnapKit

fileprivate let BORDER_WIDTH: CGFloat = 2

// text field 뼈대
class BaseTextField: UITextField, UITextFieldDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // placeholder
    override var placeholder: String? {
        didSet {
            setupPlaceholder()
        }
    }
    
    var placeholderColor: UIColor = .rollpeGray {
        didSet {
            setupPlaceholder()
        }
    }
    
    
    // 글자 수 제한
    var maxLength = 50 {
        didSet {
            self.delegate = self
        }
    }
    
    private func setup() {
        self.delegate = self
        
        // 입력 설정
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        self.contentVerticalAlignment = .center
        self.clearButtonMode = .never
    }
    
    // placeholder 설정
    private func setupPlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
    }
    
    // 글자 수 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)
        
        return newString.count <= maxLength
    }
}

// text field
class RoundedBorderTextField: BaseTextField {
    override var text: String? {
        didSet {
            updateBorderColor()
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        // 스타일
        self.backgroundColor = .rollpePrimary
        self.textColor = .rollpeSecondary
        self.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        
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
    
    // 최소 높이 설정
    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        let font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) ?? .systemFont(ofSize: 20)
        let minimumHeight = font.lineHeight + 16 + 16
        return CGSize(
            width: baseSize.width,
            height: ((text?.isEmpty) != nil) ? minimumHeight : max(baseSize.height, minimumHeight)
        )
    }
}

// 수정 방지 전용 textfield
class RoundedBorderTextFieldPicker: RoundedBorderTextField {
    // 입력 방지
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

// picker
class RoundedBorderPicker: UIButton {
    var text: String = "" {
        didSet {
            updateText()
            updateBorderColor()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        updateBorderColor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        updateBorderColor()
    }
    
    private func setup() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        self.backgroundColor = .rollpePrimary
        
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) ?? .systemFont(ofSize: 20)
        
        config.attributedTitle = AttributedString(
            text,
            attributes: AttributeContainer([
                .font: font,
                .foregroundColor: UIColor.rollpeSecondary
            ])
        )
        
        self.configuration = config
        self.contentHorizontalAlignment = .left
    }
    
    private func updateText() {
        var config = self.configuration ?? .plain()
        
        let font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) ?? .systemFont(ofSize: 20)
        config.attributedTitle = AttributedString(
            text,
            attributes: AttributeContainer([
                .font: font,
                .foregroundColor: UIColor.rollpeSecondary
            ])
        )
        self.configuration = config
    }
    
    private func updateBorderColor() {
        layer.borderColor = !text.isEmpty ? UIColor.rollpeSecondary.cgColor : UIColor.rollpeGray.cgColor
    }
    
    // 최소 높이 설정
    override var intrinsicContentSize: CGSize {
        let baseSize = super.intrinsicContentSize
        let font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) ?? .systemFont(ofSize: 20)
        let minimumHeight = font.lineHeight + 16 + 16
        return CGSize(
            width: baseSize.width,
            height: text.isEmpty ? minimumHeight : max(baseSize.height, minimumHeight)
        )
    }
}
