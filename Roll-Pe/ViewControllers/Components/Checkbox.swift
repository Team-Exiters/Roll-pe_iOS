//
//  Checkbox.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/24/25.
//

import UIKit
import SnapKit

class Checkbox: UIButton {
    var isChecked: Bool = false {
        didSet {
            updateCheckbox()
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
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        self.backgroundColor = .rollpePrimary
        
        self.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        self.addTarget(self, action: #selector(check), for: .touchUpInside)
        
        updateCheckbox()
    }
    
    @objc func check(_ sender: UIGestureRecognizer) {
        isChecked.toggle()
    }
    
    private func updateCheckbox() {
        if isChecked {
            let checkmarkView = UIView()
            checkmarkView.backgroundColor = .rollpeMain
            checkmarkView.layer.cornerRadius = 1
            checkmarkView.tag = 2
            checkmarkView.isUserInteractionEnabled = false
            
            self.addSubview(checkmarkView)
            
            checkmarkView.snp.makeConstraints { make in
                make.size.equalTo(10)
                make.center.equalToSuperview()
            }
        } else {
            self.subviews.filter { $0.tag == 2 }.forEach { $0.removeFromSuperview() }
        }
    }
}
