//
//  Menu.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/23/25.
//

import UIKit
import SnapKit

func MenuBlock() -> UIView {
    let view: UIView = UIView()
    view.layer.backgroundColor = UIColor.rollpePrimary.cgColor
    view.layer.cornerRadius = 4
    
    let imageView: UIImageView = UIImageView()
    let image: UIImage! = UIImage(named: "icon_hamburger")
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.tintColor = .rollpeSecondary
    
    view.addSubview(imageView)
    
    imageView.snp.makeConstraints { make in
        make.center.equalToSuperview()
        make.width.equalTo(16)
        make.height.equalTo(12)
    }
    
    view.snp.makeConstraints { make in
        make.width.height.equalTo(28)
    }
    
    return view
}
