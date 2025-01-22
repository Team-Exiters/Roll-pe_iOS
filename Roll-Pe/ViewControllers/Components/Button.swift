//
//  Button.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import UIKit
import SnapKit



class RollpeButtonPrimary: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    private func setupButton(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8
        
        self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        
        self.backgroundColor = UIColor(named: "rollpe_main")
        
        if let customFont = UIFont(name: "Pretendard-SemiBold", size: 16) {
            self.titleLabel?.font = customFont
        } else {
            self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
    }
}
