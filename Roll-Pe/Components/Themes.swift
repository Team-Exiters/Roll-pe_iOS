//
//  Themes.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/28/25.
//

import UIKit
import SnapKit

// 화이트
class themeWhite: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .rollpeWhite
        self.layer.cornerRadius = 24
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.rollpeBlack.cgColor
        
        self.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
}

// 블랙
class themeBlack: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .rollpeBlack
        self.layer.cornerRadius = 24
        self.layer.masksToBounds = true
        
        self.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
}

// 생일
class themeBirthday: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.backgroundColor = .rollpePink
        self.layer.cornerRadius = 24
        self.layer.masksToBounds = true
        
        let iconView: UIImageView = UIImageView()
        let icon: UIImage = UIImage.iconBirthdayCake
        iconView.image = icon
        iconView.contentMode = .scaleAspectFit
        
        self.addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(27.6)
            make.height.equalTo(iconView.snp.width).dividedBy(getImageRatio(image: icon))
        }
        
        self.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
}
