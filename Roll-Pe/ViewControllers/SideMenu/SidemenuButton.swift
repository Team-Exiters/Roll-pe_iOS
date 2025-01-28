//
//  SidemenuButton.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/29/25.
//

import UIKit
import SnapKit

let ButtonSideMenu: UIButton = {
    let button: UIButton = UIButton()
    button.backgroundColor = .rollpePrimary
    button.layer.cornerRadius = 4
    
    button.snp.makeConstraints { make in
        make.size.equalTo(28)
    }
    
    let icon: UIImageView = UIImageView()
    let image: UIImage = .iconHamburger
    icon.image = image
    icon.contentMode = .scaleAspectFit
    icon.tintColor = .rollpeSecondary
    
    button.addSubview(icon)
    
    icon.snp.makeConstraints { make in
        make.center.equalToSuperview()
        make.width.equalTo(16)
        make.height.equalTo(icon.snp.width).dividedBy(getImageRatio(image: image))
    }
    
    return button
}()

/*
 
 ButtonSideMenu 사용 방법
 
 let sideMenuView = SidemenuView(menuIndex: index)
 let buttonSideMenu: UIButton = ButtonSideMenu
 
 view.addSubview(buttonSideMenu)
 
 buttonSideMenu.snp.makeConstraints { make in
     make.top.equalToSuperview().offset(80)
     make.trailing.equalToSuperview().inset(20)
 }
 
 buttonSideMenu.rx.tap
     .subscribe(onNext: {
         self.view.addSubview(sideMenuView)
         sideMenuView.showMenu()
     })
     .disposed(by: disposeBag)
 
*/
