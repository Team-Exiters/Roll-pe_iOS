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

// 추모
class themeMemorial: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .rollpeThemeMemorial
        self.layer.cornerRadius = 24
        self.layer.masksToBounds = true
        
        self.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
    }
}

// 축하
class themeCongrats: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .rollpeThemeCongrats
        self.layer.cornerRadius = 24
        self.layer.masksToBounds = true
        
        let iconView: UIImageView = UIImageView()
        let icon: UIImage = .iconBirthdayCake
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
