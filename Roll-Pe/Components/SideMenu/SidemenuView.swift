//
//  SidemenuView.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/21/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import SafariServices

class SidemenuView: UIView {
    let disposeBag = DisposeBag()
    
    // 투명도
    private let ALPHA: CGFloat = 0.5
    
    // 애니메이션 시간
    private let ANIMATION_DURATION: CGFloat = 0.25
    
    // 메뉴 뷰 너비
    private let MENU_VIEW_WIDTH = UIScreen.main.bounds.width * 0.8
    
    // 뒷배경
    private let background: UIButton = UIButton()
    
    // 메뉴 배경
    private let menuView: UIView = UIView()
    
    init(frame: CGRect = .zero, menuIndex: Int) {
        super.init(frame: frame)
        setup(menuIndex: menuIndex)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(menuIndex: 0)
    }
    
    private func setup(menuIndex: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - 뒷배경
        
        background.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: ALPHA).cgColor
        background.isUserInteractionEnabled = true
        
        self.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        background.rx.tap
            .subscribe(onNext: {
                self.closeMenu()
            })
            .disposed(by: disposeBag)
        
        // MARK: - 메뉴 배경
        
        menuView.layer.backgroundColor = UIColor.rollpePrimary.cgColor
        
        menuView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        menuView.layer.cornerRadius = 16
        menuView.layer.masksToBounds = true
        
        self.addSubview(menuView)
        
        menuView.snp.makeConstraints { make in
            make.width.equalTo(MENU_VIEW_WIDTH)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // MARK: - 닫기
        let closeButton: UIButton = UIButton()
        
        let closeImageView: UIImageView = UIImageView()
        closeImageView.image = .iconX
        closeImageView.contentMode = .scaleAspectFit
        closeImageView.clipsToBounds = true
        closeImageView.tintColor = .rollpeSecondary
        closeImageView.isUserInteractionEnabled = false
        
        closeButton.addSubview(closeImageView)
        menuView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.trailing.equalToSuperview().inset(28)
        }
        
        closeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12)
        }
        
        closeButton.rx.tap
            .subscribe(onNext: {
                self.closeMenu()
            })
            .disposed(by: disposeBag)
        
        // MARK: - 메뉴 뷰
        
        let contentView: UIStackView = UIStackView()
        
        contentView.axis = .vertical
        contentView.spacing = 0
        contentView.distribution = .equalSpacing
        
        menuView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(24)
        }
        
        // 메뉴 텍스트 컴포넌트
        func menuText(menu: String, index: Int) -> UILabel {
            let label: UILabel = UILabel()
            label.textColor = menuIndex == index ? .rollpeMain : .rollpeSecondary
            label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 40)
            label.numberOfLines = 1
            label.text = menu
            
            return label
        }
        
        // 약관 텍스트 컴포넌트
        func policyText(text: String) -> UILabel {
            let label: UILabel = UILabel()
            label.textColor = .rollpeGray
            label.font = UIFont(name: "Pretendard-Regular", size: 12)
            label.numberOfLines = 1
            label.text = text
            
            return label
        }
        
        // 메뉴
        let menusView: UIStackView = UIStackView()
        menusView.translatesAutoresizingMaskIntoConstraints = false
        menusView.axis = .vertical
        menusView.spacing = 40
        
        contentView.addArrangedSubview(menusView)
        
        // 홈
        let home = menuText(menu: "홈", index: 0)
        menusView.addArrangedSubview(home)
        
        home.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if menuIndex != 0 {
                    self.closeMenu()
                    self.switchViewController(vc: MainAfterSignInViewController())
                }
            })
            .disposed(by: disposeBag)
        
        // 검색
        let search = menuText(menu: "검색", index: 1)
        menusView.addArrangedSubview(search)
        
        search.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if menuIndex != 1 {
                    self.closeMenu()
                    self.switchViewController(vc: SearchViewController())
                }
            })
            .disposed(by: disposeBag)
        
        // 공지사항
        let notice = menuText(menu: "공지사항", index: 2)
        menusView.addArrangedSubview(notice)
        
        // 1:1 문의
        let inquiry = menuText(menu: "1:1 문의", index: 3)
        menusView.addArrangedSubview(inquiry)
        
        inquiry.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://forms.gle/WGC7ibNBgTnomRgZ7") else {
                    return
                }
                
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        // 마이페이지
        let mypage = menuText(menu: "마이페이지", index: 4)
        menusView.addArrangedSubview(mypage)
        
        mypage.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                if menuIndex != 4 {
                    self.closeMenu()
                    self.switchViewController(vc: MyPageViewController())
                }
            })
            .disposed(by: disposeBag)
        
        
        // 약관
        let policiesView: UIStackView = UIStackView()
        policiesView.translatesAutoresizingMaskIntoConstraints = false
        policiesView.axis = .vertical
        policiesView.spacing = 8
        
        contentView.addArrangedSubview(policiesView)
        
        // 서비스 이용약관
        let termsOfService = policyText(text: "서비스 이용약관")
        policiesView.addArrangedSubview(termsOfService)
        
        termsOfService.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://haren-dev2.defcon.or.kr/terms-of-service") else {
                    return
                }
                
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        // 개인정보처리방침
        let privacyPolicy = policyText(text: "개인정보처리방침")
        policiesView.addArrangedSubview(privacyPolicy)
        
        privacyPolicy.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://haren-dev2.defcon.or.kr/privacy-policy") else {
                    return
                }
                
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 제스쳐
        let panGesture = UIPanGestureRecognizer()
        menuView.addGestureRecognizer(panGesture)
        
        panGesture.rx.event
            .subscribe(onNext: { gesture in
                // 제스처의 이동 거리
                let translation = gesture.translation(in: self)
                // 제스처의 속도
                let velocity = gesture.velocity(in: self)
                
                switch gesture.state {
                case .changed:
                    // 사용자가 오른쪽으로 드래그하면 메뉴를 이동
                    if translation.x > 0 {
                        self.menuView.transform = CGAffineTransform(translationX: translation.x, y: 0)
                    }
                case .ended:
                    let maximum = UIScreen.main.bounds.width * 0.4
                    
                    if translation.x > maximum || velocity.x > maximum {
                        // 드래그 거리나 속도가 기준 이상이면 메뉴 숨기기
                        self.closeMenu()
                    } else {
                        // 그렇지 않으면 위치 복원
                        UIView.animate(withDuration: self.ANIMATION_DURATION) {
                            self.menuView.transform = .identity
                        }
                    }
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 뷰 컨트롤러 전환
    
    private func switchViewController(vc: UIViewController) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = true
        navVC.hideKeyboardWhenTappedAround()
        
        sceneDelegate.window?.rootViewController = navVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - 메뉴 닫기
    
    func closeMenu() {
        UIView.animate(withDuration: ANIMATION_DURATION, animations: {
            self.background.alpha = 0
            
            // 메뉴 오른쪽으로 숨기기
            self.menuView.transform = CGAffineTransform(translationX: self.MENU_VIEW_WIDTH, y: 0)
        }, completion: { _ in
            // 애니메이션 종료 후 뷰 제거
            self.removeFromSuperview()
        })
    }
    
    // MARK: - 메뉴 펼치기
    
    func showMenu() {
        self.background.alpha = 0
        self.menuView.transform = CGAffineTransform(translationX: self.MENU_VIEW_WIDTH, y: 0)
        
        UIView.animate(withDuration: ANIMATION_DURATION) {
            self.background.alpha = self.ALPHA
            
            // 메뉴 원래 위치로 이동
            self.menuView.transform = .identity
        }
    }
}
