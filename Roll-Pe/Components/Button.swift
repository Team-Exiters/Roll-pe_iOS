//
//  Button.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import UIKit
import SnapKit

class PrimaryButton: UIButton {
    init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame)
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
        self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.backgroundColor = UIColor.rollpeMain
        self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
}

class SecondaryButton: UIButton {
    init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    private func setupButton(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: "rollpe_main"), for: .normal)
        self.layer.cornerRadius = 8
        self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        self.backgroundColor = UIColor.rollpePrimary
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.rollpeMain.cgColor
        self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
}

class BackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        let image: UIImage = .iconChevronLeft
        self.tintColor = .rollpeSecondary
        self.setImage(image, for: .normal)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(self.snp.width).dividedBy(getImageRatio(image: image))
        }
    }
}
