//
//  ErrorHandlerViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ErrorHandlerViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    // MARK: - 요소
    
    // 내부 뷰
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        
        return sv
    }()
    
    // 로고
    private let logo: UIImageView = {
        let iv = UIImageView()
        iv.image = .imgLogo
        iv.contentMode = .scaleAspectFit
        
        return iv
    }()
    
    // 내용
    private let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.textAlignment = .center
        label.text = "초대되지 않은 상태거나,\n로그인이 필요합니다."
        
        return label
    }()
    
    // 돌아가기 버튼
    private let backButton = PrimaryButton(title: "돌아가기")
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UI 설정
        setupStackView()
        setupLogo()
        setupDesc()
        setupBackButton()
        
        // bind
        
        
    }
    
    // MARK: - UI 설정
    
    // 내부 뷰 설정
    private func setupStackView() {
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
    }

    // 로고
    private func setupLogo() {
        stackView.addArrangedSubview(logo)
        stackView.setCustomSpacing(20, after: logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(104)
            make.height.equalTo(52)
        }
    }
    
    // 설명
    private func setupDesc() {
        stackView.addArrangedSubview(descLabel)
        stackView.setCustomSpacing(40, after: descLabel)
    }
    
    // 돌아가기 버튼
    private func setupBackButton() {
        stackView.addArrangedSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        backButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                    return
                }
                
                let navVC = UINavigationController(rootViewController: MainAfterSignInViewController())
                navVC.navigationBar.isHidden = true
                navVC.hideKeyboardWhenTappedAround()
                
                sceneDelegate.window?.rootViewController = navVC
                sceneDelegate.window?.makeKeyAndVisible()
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct ErrorHandlerViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ErrorHandlerViewController()
        }
    }
}
#endif
