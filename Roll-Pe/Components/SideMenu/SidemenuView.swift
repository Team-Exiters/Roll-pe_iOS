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
    private let disposeBag = DisposeBag()
    
    // 투명도
    private let ALPHA: CGFloat = 0.5
    
    // 애니메이션 시간
    private let ANIMATION_DURATION: CGFloat = 0.25
    
    // 메뉴 뷰 너비
    private let MENU_VIEW_WIDTH = UIScreen.main.bounds.width * 0.8
    
    // 뒷배경
    private lazy var background: UIButton = {
        let button = UIButton()
        button.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: ALPHA).cgColor
        button.isUserInteractionEnabled = true
        
        return button
    }()
    
    // 메뉴 배경
    private let menuView: UIView = {
        let view = UIView()
        view.layer.backgroundColor = UIColor.rollpePrimary.cgColor
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    // 닫기
    private let closeButton: UIButton = UIButton()
    
    private let closeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .iconX
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .rollpeSecondary
        iv.isUserInteractionEnabled = false
        
        return iv
    }()
    
    // 내부 뷰
    private let contentView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.distribution = .equalSpacing
        
        return sv
    }()
    
    // 메뉴
    private let menusView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 40
        
        return sv
    }()
    
    // 약관 텍스트 컴포넌트
    func policyText(text: String) -> UILabel {
        let label: UILabel = UILabel()
        label.textColor = .rollpeGray
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.numberOfLines = 1
        label.text = text
        
        return label
    }
    
    init(frame: CGRect = .zero, highlight: String) {
        super.init(frame: frame)
        
        setup(highlight: highlight)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup(highlight: "")
    }
    
    private func setup(highlight: String) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // MARK: - 뒷배경
        
        self.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        background.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.closeMenu()
            })
            .disposed(by: disposeBag)
        
        // 메뉴 배경
        self.addSubview(menuView)
        
        menuView.snp.makeConstraints { make in
            make.width.equalTo(MENU_VIEW_WIDTH)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 닫기
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
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.closeMenu()
            })
            .disposed(by: disposeBag)
        
        // 메뉴 뷰
        
        menuView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(120)
            make.horizontalEdges.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(24)
        }
        
        // 메뉴 텍스트 컴포넌트
        func menuText(text: String) -> UILabel {
            let label: UILabel = UILabel()
            label.textColor = text == highlight ? .rollpeMain : .rollpeSecondary
            label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 40)
            label.numberOfLines = 1
            label.text = text
            
            return label
        }
        
        // 메뉴 뷰
        contentView.addArrangedSubview(menusView)
        
        // 홈
        let home = menuText(text: "홈")
        menusView.addArrangedSubview(home)
        
        home.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                if highlight != "홈" {
                    self.closeMenu()
                    switchViewController(vc: MainAfterSignInViewController())
                }
            })
            .disposed(by: disposeBag)
        
        // 검색
        let search = menuText(text: "검색")
        menusView.addArrangedSubview(search)
        
        search.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                if highlight != "검색" {
                    self.closeMenu()
                    switchViewController(vc: SearchViewController())
                }
            })
            .disposed(by: disposeBag)
        
        // 공지사항
        /*
        let notice = menuText(menu: "공지사항", index: 2)
        menusView.addArrangedSubview(notice)
         */
        
        // 1:1 문의
        let inquiry = menuText(text: "1:1 문의")
        menusView.addArrangedSubview(inquiry)
        
        inquiry.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                guard let url = URL(string: "https://forms.gle/WGC7ibNBgTnomRgZ7") else {
                    return
                }
                
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        // 마이페이지
        let mypage = menuText(text: "마이페이지")
        menusView.addArrangedSubview(mypage)
        
        mypage.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                if highlight != "마이페이지" {
                    self.closeMenu()
                    switchViewController(vc: MyPageViewController())
                }
            })
            .disposed(by: disposeBag)
        
        
        // 약관
        let policiesView: UIStackView = UIStackView()
        policiesView.translatesAutoresizingMaskIntoConstraints = false
        policiesView.axis = .vertical
        policiesView.spacing = 8
        
        contentView.addArrangedSubview(policiesView)
        
        // MARK: - 제스쳐
        
        let panGesture = UIPanGestureRecognizer()
        menuView.addGestureRecognizer(panGesture)
        
        panGesture.rx.event
            .observe(on: MainScheduler.instance)
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
    
    // MARK: - 메뉴 닫기
    
    private func closeMenu() {
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
