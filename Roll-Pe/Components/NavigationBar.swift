//
//  NavigationBar.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/31/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class NavigationBar: UIView {
    let disposeBag: DisposeBag = DisposeBag()
    weak var parentViewController: UIViewController?
    
    var menuIndex: Int = 0
    
    // 사이드 메뉴 표시 기본값 false
    var showSideMenu = false {
        didSet {
            if showSideMenu {
                setup()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.backgroundColor = .rollpePrimary
        
        // 뒤로가기
        let backButton = BackButton()
        
        self.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        backButton.rx.tap
            .subscribe(onNext: {
                self.goToBack()
            })
            .disposed(by: disposeBag)
        
        // 로고
        let logo: UIButton = UIButton()
        let logoImage: UIImage = .imgLogo
        logo.setImage(logoImage, for: .normal)
        
        self.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(48)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage))
            make.center.equalToSuperview()
        }
        
        logo.rx.tap
            .subscribe(onNext: {
                self.goToHome()
            })
            .disposed(by: disposeBag)
        
        // 사이드 메뉴
        if showSideMenu {
            let sideMenuView = SidemenuView(menuIndex: menuIndex)
            sideMenuView.parentViewController = parentViewController
            
            let buttonSideMenu: UIButton = ButtonSideMenu()
            
            self.addSubview(buttonSideMenu)
            
            buttonSideMenu.snp.makeConstraints { make in
                make.trailing.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
            buttonSideMenu.rx.tap
                .subscribe(onNext: {
                    self.parentViewController?.view.addSubview(sideMenuView)
                    sideMenuView.showMenu()
                })
                .disposed(by: disposeBag)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(68)
        }
    }
    
    // 뒤로가기
    private func goToBack() {
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    // 홈으로 가기
    private func goToHome() {
        
    }
}
