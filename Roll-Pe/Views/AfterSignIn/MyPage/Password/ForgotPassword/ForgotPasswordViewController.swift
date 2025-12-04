//
//  ForgotPasswordViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/9/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ForgotPasswordViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = ForgotPasswordViewModel()
    
    // MARK: - 요소
    
    // 내부 뷰
    private let contentView: UIView = UIView()
    
    // 로고
    private lazy var logo: UIImageView = {
        let iv = UIImageView()
        iv.image = logoImage
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    // 로고 이미지
    private let logoImage = UIImage.imgLogo
    
    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        label.text = "비밀번호 찾기"
        
        return label
    }()
    
    // 이메일
    private let email: RoundedBorderTextField = {
        let textField = RoundedBorderTextField()
        textField.placeholder = "이메일"
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        
        return textField
    }()
    
    // 인증
    private let verifyButton = PrimaryButton(title: "이메일 인증")
    
    // 로딩 뷰
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        setUI()
        bind()
    }
    
    // MARK: - UI 구성
    
    // 전체 UI
    private func setUI() {
        view.backgroundColor = .rollpePrimary
        
        setupContentView()
        setupLogo()
        setupTitle()
        setupEmail()
        setupVerifyButton()
        
        addBack()
        addLoadingView()
    }
    
    // 뒤로가기
    private func addBack() {
        let back = BackButton()
        
        back.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(back)
        
        back.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(20)
        }
    }
    
    // 로딩 뷰
    private func addLoadingView() {
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 내부 뷰
    private func setupContentView() {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // 로고
    private func setupLogo() {
        contentView.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.width.equalToSuperview().multipliedBy(0.377884615)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage))
            make.centerX.equalToSuperview()
        }
    }
    
    // 제목
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // 이메일
    private func setupEmail() {
        contentView.addSubview(email)
        
        email.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 인증
    private func setupVerifyButton() {
        contentView.addSubview(verifyButton)
        
        verifyButton.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = ForgotPasswordViewModel.Input(
            email: email.rx.text,
            verifyButtonTapEvent: verifyButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.isVerifyEnabled
            .drive(onNext: { isEnabled in
                self.verifyButton.disabled = !isEnabled
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: { isLoading in
                self.loadingView.isHidden = !isLoading
            })
            .disposed(by: disposeBag)
        
        output.successAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "알림", message: message) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct ForgotPasswordViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ForgotPasswordViewController()
        }
    }
}
#endif
