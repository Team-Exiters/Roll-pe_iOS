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
    private let disposeBag = DisposeBag()
    private let viewModel = SignUpViewModel()
    
    // MARK: - 컴포넌트
    
    // 약관확인 라벤
    private func confirmLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        label.text = text
        
        return label
    }
    
    // 링크 라벨
    private func linkLabel() -> UILabel {
        let label = UILabel()
        label.text = "보기"
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        label.textColor = .rollpeGray
        
        return label
    }
    
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
        label.text = "회원가입"
        
        return label
    }()
    
    // Spacer
    private let spacer: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return view
    }()
    
    // 이메일
    private let email: TextField = {
        let textField = TextField()
        textField.placeholder = "이메일"
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        
        return textField
    }()
    
    // 닉네임
    private let name: TextField = {
        let textField = TextField()
        textField.placeholder = "닉네임(2-6자)"
        textField.maxLength = 6
        
        return textField
    }()
    
    // 비밀번호
    private let password: TextField = {
        let textField = TextField()
        textField.placeholder = "비밀번호"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    // 비밀번호 확인
    private let passwordConfirm: TextField = {
        let textField = TextField()
        textField.placeholder = "비밀번호 확인"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    // 연령 확인
    private let confirmAgeView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        
        return sv
    }()
    
    private let checkboxConfirmAge: Checkbox = {
        let checkbox = Checkbox()
        
        return checkbox
    }()
    
    // 서비스 이용약관
    private let confirmTermsView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        
        return sv
    }()
    
    private let checkboxConfirmTerms: Checkbox = {
        let checkbox = Checkbox()
        
        return checkbox
    }()
    
    // 개인정보 수집 및 이용동의
    private let confirmPrivacyView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        
        return sv
    }()
    
    private let checkboxConfirmPrivacy: Checkbox = {
        let checkbox = Checkbox()
        
        return checkbox
    }()
    
    // 가입
    private let signUpButton = PrimaryButton(title: "가입")
    
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
        
        setupContentView()
        setupLogo()
        setupTitle()
        setupEmail()
        setupName()
        setupPassword()
        setupPasswordConfirm()
        setupConfirmAge()
        setupConfirmTerms()
        setupConfirmPrivacyPolicy()
        setupSignUpButton()
        
        addBack()
        addLoadingView()
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
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
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
    
    // 이름
    private func setupName() {
        contentView.addSubview(name)
        
        name.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 비밀번호
    private func setupPassword() {
        contentView.addSubview(password)
        
        password.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 비밀번호 확인
    private func setupPasswordConfirm() {
        contentView.addSubview(passwordConfirm)
        
        passwordConfirm.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(8)
            make.width.equalToSuperview()
        }
    }
    
    // 연령 확인
    private func setupConfirmAge() {
        contentView.addSubview(confirmAgeView)
        
        confirmAgeView.snp.makeConstraints { make in
            make.top.equalTo(passwordConfirm.snp.bottom).offset(40)
            make.leading.equalToSuperview()
        }
        
        confirmAgeView.addArrangedSubview(checkboxConfirmAge)
        
        let confirmAgeText = confirmLabel("저는 만 14세 이상입니다.")
        confirmAgeView.addArrangedSubview(confirmAgeText)
    }
    
    // 서비스 이용약관
    private func setupConfirmTerms() {
        contentView.addSubview(confirmTermsView)
        
        confirmTermsView.snp.makeConstraints { make in
            make.top.equalTo(confirmAgeView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        confirmTermsView.addArrangedSubview(checkboxConfirmTerms)
        
        let confirmTermsText = confirmLabel("서비스 이용약관에 동의합니다.")
        confirmTermsView.addArrangedSubview(confirmTermsText)
        
        confirmTermsView.addArrangedSubview(spacer)
        
        let linkToTerms = linkLabel()
        
        linkToTerms.rx.tap
            .subscribe(onNext: {
                let url = NSURL(string: "https://haren-dev2.defcon.or.kr/terms-of-service")
                let safariVc: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(safariVc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        confirmTermsView.addArrangedSubview(linkToTerms)
    }
    
    // 개인정보 수집 및 이용 동의
    private func setupConfirmPrivacyPolicy() {
        contentView.addSubview(confirmPrivacyView)
        
        confirmPrivacyView.snp.makeConstraints { make in
            make.top.equalTo(confirmTermsView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
        }
        
        confirmPrivacyView.addArrangedSubview(checkboxConfirmPrivacy)
        
        let confirmPrivacyText: UILabel = confirmLabel("개인정보 수집 및 이용에 동의합니다.")
        confirmPrivacyView.addArrangedSubview(confirmPrivacyText)
        
        confirmPrivacyView.addArrangedSubview(spacer)
        
        let linkToPrivacy: UILabel = linkLabel()
        
        linkToPrivacy.rx.tap
            .subscribe(onNext: {
                let url = NSURL(string: "https://haren-dev2.defcon.or.kr/privacy-policy")
                let safariVc: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(safariVc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        confirmPrivacyView.addArrangedSubview(linkToPrivacy)
    }
    
    // 가입
    private func setupSignUpButton() {
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
            .drive(onNext: { isEnabled in
                self.signUpButton.disabled = !isEnabled
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
                    self.showSuccessAlert(message: message)
                }
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
    
    private func showSuccessAlert(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
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
