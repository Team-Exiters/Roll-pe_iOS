//
//  Themes.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/28/25.
//

import UIKit
import SnapKit

// 화이트
func themeWhite() -> UIView {
    let view: UIView = UIView()
    
    view.backgroundColor = .rollpeWhite
    view.layer.cornerRadius = 24
    view.layer.masksToBounds = true
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.rollpeBlack.cgColor
    
    view.snp.makeConstraints { make in
        make.size.equalTo(48)
    }
    
    return view
}

// 블랙
func themeBlack() -> UIView {
    let view: UIView = UIView()
    
    view.backgroundColor = .rollpeBlack
    view.layer.cornerRadius = 24
    view.layer.masksToBounds = true
    
    view.snp.makeConstraints { make in
        make.size.equalTo(48)
    }
    
    return view
}

// 생일
func themeBirthday() -> UIView {
    let view: UIView = UIView()
    
    view.backgroundColor = .rollpePink
    view.layer.cornerRadius = 24
    view.layer.masksToBounds = true
    
    let iconView: UIImageView = UIImageView()
    let icon: UIImage = UIImage.iconBirthdayCake
    iconView.image = icon
    iconView.contentMode = .scaleAspectFit
    
    view.addSubview(iconView)
    
    iconView.snp.makeConstraints { make in
        make.center.equalToSuperview()
        make.width.equalTo(27.6)
        make.height.equalTo(iconView.snp.width).dividedBy(getImageRatio(image: icon))
    }
    
    view.snp.makeConstraints { make in
        make.size.equalTo(48)
    }
    
    return view
}
