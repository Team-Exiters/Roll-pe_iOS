//
//  TextField.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/23/25.
//

import UIKit
import SnapKit

class TextField: UITextField {
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
        // 입력 설정
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        
        self.contentVerticalAlignment = .center
        
        // 스타일
        self.backgroundColor = UIColor(named: "rollpe_primary")
        self.textColor = UIColor.rollpeSecondary
        self.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        self.layer.masksToBounds = true
        
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        
        // focus에 따라 스타일 변화
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
    }
    
    // focus
    @objc private func editingDidBegin() {
        self.layer.borderColor = UIColor.rollpeSecondary.cgColor
    }

    // unfocus
    @objc private func editingDidEnd() {
        self.layer.borderColor = UIColor.rollpeGray.cgColor
    }
    
    // 여백
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 0))
    }
}
