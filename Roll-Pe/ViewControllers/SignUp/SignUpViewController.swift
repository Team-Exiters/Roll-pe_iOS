//
//  SignUpViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftUI
import SafariServices

class SignUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    // 뷰모델
    private let viewModel = SignUpViewModel()
    
    // MARK: - 속성
    
    // Spacer
    let spacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return view
    }()
    
    // 이메일
    let email: TextField = {
        let textField = TextField()
        textField.placeholder = "이메일"
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        
        return textField
    }()
    
    // 닉네임
    let name: TextField = {
        let textField = TextField()
        textField.placeholder = "닉네임(2-6자)"
        textField.maxLength = 6
        
        return textField
    }()
    
    /*
     // 인증번호 발송
     let buttonSendVerificationCode = SecondaryButton(title: "인증번호 발송")
     
     // 인증번호
     let verificationCode: TextField = {
     let textField = TextField()
     textField.placeholder = "인증번호"
     textField.textContentType = .oneTimeCode
     textField.keyboardType = .numberPad
     
     return textField
     }()
     
     // 인증번호 확인
     let buttonCheckSendVerificationCode = SecondaryButton(title: "인증번호 확인")
     */
    
    // 비밀번호
    let password: TextField = {
        let textField = TextField()
        textField.placeholder = "비밀번호"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    // 비밀번호 확인
    let passwordConfirm: TextField = {
        let textField = TextField()
        textField.placeholder = "비밀번호 확인"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    // 연령 확인
    let checkboxConfirmAge: Checkbox = {
        let checkbox = Checkbox()
        
        return checkbox
    }()
    
    // 서비스 이용약관
    let checkboxConfirmTerms: Checkbox = {
        let checkbox = Checkbox()
        
        return checkbox
    }()
    
    // 개인정보 수집 및 이용동의
    let checkboxConfirmPrivacy: Checkbox = {
        let checkbox = Checkbox()
        
        return checkbox
    }()
    
    // 가입
    let signUpButton = PrimaryButton(title: "가입")
    
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
        addBack()
        addLoadingView()
    }
    
    // MARK: - UI 구성
    
    // 뒤로가기
    private func addBack() {
        let back = BackButton()
        
        back.rx.tap
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
    
    // 전체 UI
    private func setUI() {
        view.backgroundColor = .rollpePrimary
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        let contentView: UIView = UIView()
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        // 로고
        let logo: UIImageView = UIImageView()
        let logoImage = UIImage.imgLogo
        logo.image = logoImage
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        contentView.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.width.equalToSuperview().multipliedBy(0.377884615)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage))
            make.centerX.equalToSuperview()
        }
        
        // 제목
        let title: UILabel = UILabel()
        title.textColor = .rollpeSecondary
        title.font = UIFont(name: "Pretendard-Regular", size: 20)
        title.text = "회원가입"
        
        contentView.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 이메일
        contentView.addSubview(email)
        
        email.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 닉네임
        contentView.addSubview(name)
        
        name.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        /*
         // 인증번호 발송
         contentView.addArrangedSubview(buttonSendVerificationCode)
         
         buttonSendVerificationCode.snp.makeConstraints { make in
         make.horizontalEdges.equalToSuperview()
         }
         
         contentView.setCustomSpacing(8, after: buttonSendVerificationCode)
         */
        
        // 인증번호
        /*
         contentView.addArrangedSubview(verificationCode)
         
         verificationCode.snp.makeConstraints { make in
         make.width.equalToSuperview()
         }
         
         contentView.setCustomSpacing(8, after: verificationCode)
         */
        
        // 인증번호 확인
        /*
         contentView.addArrangedSubview(buttonCheckSendVerificationCode)
         
         buttonCheckSendVerificationCode.snp.makeConstraints { make in
         make.horizontalEdges.equalToSuperview()
         }
         
         contentView.setCustomSpacing(8, after: buttonCheckSendVerificationCode)
         */
        
        
        
        // 비밀번호
        contentView.addSubview(password)
        
        password.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 비밀번호 확인
        contentView.addSubview(passwordConfirm)
        
        passwordConfirm.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(8)
            make.width.equalToSuperview()
        }
        
        // 연령 확인
        let confirmAgeView: UIStackView = UIStackView()
        confirmAgeView.axis = .horizontal
        confirmAgeView.spacing = 8
        confirmAgeView.alignment = .center
        
        contentView.addSubview(confirmAgeView)
        
        confirmAgeView.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirm.snp.bottom).offset(40)
            make.leading.equalToSuperview()
        }
        
        confirmAgeView.addArrangedSubview(checkboxConfirmAge)
        
        let confirmAgeText: UILabel = UILabel()
        confirmAgeText.textColor = .rollpeSecondary
        confirmAgeText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        confirmAgeText.text = "저는 만 14세 이상입니다."
        
        confirmAgeView.addArrangedSubview(confirmAgeText)
        
        // 서비스 이용약관
        let confirmTermsView: UIStackView = UIStackView()
        confirmTermsView.axis = .horizontal
        confirmTermsView.spacing = 8
        confirmTermsView.alignment = .center
        
        contentView.addSubview(confirmTermsView)
        
        confirmTermsView.snp.makeConstraints { make in
            make.top.equalTo(confirmAgeView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        confirmTermsView.addArrangedSubview(checkboxConfirmTerms)
        
        let confirmTermsText: UILabel = UILabel()
        confirmTermsText.textColor = .rollpeSecondary
        confirmTermsText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        confirmTermsText.text = "서비스 이용약관에 동의합니다."
        
        confirmTermsView.addArrangedSubview(confirmTermsText)
        
        confirmTermsView.addArrangedSubview(spacer)
        
        let linkToTerms: UILabel = UILabel()
        linkToTerms.text = "보기"
        linkToTerms.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        linkToTerms.textColor = .rollpeGray
        
        linkToTerms.rx.tap
            .subscribe(onNext: {
                let url = NSURL(string: "https://haren-dev2.defcon.or.kr/terms-of-service")
                let safariVc: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(safariVc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        confirmTermsView.addArrangedSubview(linkToTerms)
        
        // 개인정보 수집 및 이용 동의
        let confirmPrivacyView: UIStackView = UIStackView()
        confirmPrivacyView.axis = .horizontal
        confirmPrivacyView.spacing = 8
        confirmPrivacyView.alignment = .center
        
        contentView.addSubview(confirmPrivacyView)
        
        confirmPrivacyView.snp.makeConstraints { make in
            make.top.equalTo(confirmTermsView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        confirmPrivacyView.addArrangedSubview(checkboxConfirmPrivacy)
        
        let confirmPrivacyText: UILabel = UILabel()
        confirmPrivacyText.textColor = .rollpeSecondary
        confirmPrivacyText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        confirmPrivacyText.text = "개인정보 수집 및 이용에 동의합니다."
        
        confirmPrivacyView.addArrangedSubview(confirmPrivacyText)
        
        confirmPrivacyView.addArrangedSubview(spacer)
        
        let linkToPrivacy: UILabel = UILabel()
        linkToPrivacy.text = "보기"
        linkToPrivacy.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        linkToPrivacy.textColor = .rollpeGray
        
        linkToPrivacy.rx.tap
            .subscribe(onNext: {
                let url = NSURL(string: "https://haren-dev2.defcon.or.kr/privacy-policy")
                let safariVc: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(safariVc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        confirmPrivacyView.addArrangedSubview(linkToPrivacy)
        
        // 가입
        contentView.addSubview(signUpButton)
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPrivacyView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = SignUpViewModel.Input(
            email: email.rx.text,
            name: name.rx.text,
            password: password.rx.text,
            confirmPassword: passwordConfirm.rx.text,
            ageChecked: checkboxConfirmAge.rx.isChecked,
            termsChecked: checkboxConfirmTerms.rx.isChecked,
            privacyChecked: checkboxConfirmPrivacy.rx.isChecked,
            signUpButtonTapEvent: signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.isSignUpEnabled
            .drive() { isEnabled in
                self.signUpButton.disabled = !isEnabled
            }
            .disposed(by: disposeBag)
        
        output.response
            .drive(onNext: { success in
                if success {
                    self.showDoneAlert()
                } else {
                    self.showErrorAlert(message: "오류가 발생하였습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: { isLoading in
                self.loadingView.isHidden = !isLoading
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showErrorAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showDoneAlert() {
        let alertController = UIAlertController(title: "알림", message: "회원가입이 정상적으로 완료되었습니다.\n이메일 인증 후 로그인해주세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

#if DEBUG
struct SignUpViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SignUpViewController()
        }
    }
}
#endif
