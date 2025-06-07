//
//  ViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import SafariServices
import GoogleSignIn

class SignInViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = SignInViewModel()
    
    // MARK: - 컴포넌트
    
    // 메뉴 라벨
    private func menuText(_ text: String) -> UILabel {
        let label: UILabel = UILabel()
        label.textColor = .rollpeGray
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        label.text = text
        
        return label
    }
    
    // 약관 라벨
    private func policyText(_ text: String) -> UILabel {
        let label: UILabel = UILabel()
        label.textColor = .rollpeGray
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = text
        
        let tapGesture = UITapGestureRecognizer()
        label.addGestureRecognizer(tapGesture)
        
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
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.numberOfLines = 2
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineHeightMultiple = 0.98
        titleParagraphStyle.alignment = .center
        
        label.attributedText = NSMutableAttributedString(string: "다같이 한 마음으로\n사랑하는 사람에게 전달해보세요", attributes: [.paragraphStyle: titleParagraphStyle])
        
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
    
    // 비밀번호
    private let password: RoundedBorderTextField = {
        let textField = RoundedBorderTextField()
        textField.placeholder = "비밀번호"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    // 로그인 유지
    private let keepSignInView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        
        return sv
    }()
    
    private let keepSignIn: Checkbox = {
        let checkbox = Checkbox()
        checkbox.isChecked = true
        
        return checkbox
    }()
    
    // 로그인 버튼
    private let signInButton = PrimaryButton(title: "로그인")
    
    // 메뉴들
    private let menus: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        
        return sv
    }()
    
    // 소셜 로그인
    private let socialSignInView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 16
        sv.alignment = .center
        
        return sv
    }()
    
    // 소셜 로그인 - 카카오
    private let kakao: UIButton = {
        let view: UIButton = UIButton()
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.backgroundColor = .kakao
        
        view.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        let logo: UIImageView = UIImageView()
        let logoImage = UIImage(named: "icon_kakao")
        logo.image = logoImage
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        view.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage!))
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    // 소셜 로그인 - 구글
    private let google: UIButton = {
        let view: UIButton = UIButton()
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.backgroundColor = .rollpeWhite
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.realBlack.cgColor
        
        view.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        let logo: UIImageView = UIImageView()
        let logoImage = UIImage(named: "icon_google")
        logo.image = logoImage
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        view.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage!))
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    // 소셜 로그인 - 애플
    private let apple: UIButton = {
        let view: UIButton = UIButton()
        view.layer.cornerRadius = 24
        view.layer.masksToBounds = true
        view.backgroundColor = .realBlack
        
        view.snp.makeConstraints { make in
            make.size.equalTo(48)
        }
        
        let logo: UIImageView = UIImageView()
        let logoImage = UIImage(named: "icon_apple")
        logo.image = logoImage
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        view.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage!))
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    // 약관
    private let policiesView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 6
        sv.alignment = .center
        
        return sv
    }()
    
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
    
    // 전체 UI
    private func setUI() {
        view.backgroundColor = .rollpePrimary
        
        setupBackground()
        setupContentView()
        setupLogo()
        setupTitle()
        setupEmail()
        setupPassword()
        setupKeepSignIn()
        setupSignInButton()
        setupMenus()
        setupSocials()
        setupPolicies()
        
        addBack()
        addLoadingView()
    }
    
    // 배경
    private func setupBackground() {
        let background: UIImageView = UIImageView()
        background.image = .imgBackground
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        
        view.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
    }
    
    // 내부 뷰
    private func setupContentView() {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
    }
    
    // 로고
    private func setupLogo() {
        contentView.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.width.equalToSuperview().multipliedBy(0.427)
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
    
    // 비밀번호
    private func setupPassword() {
        contentView.addSubview(password)
        
        password.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 로그인 유지
    private func setupKeepSignIn() {
        contentView.addSubview(keepSignInView)
        
        keepSignInView.addArrangedSubview(keepSignIn)
        
        let keepSignInViewText: UILabel = UILabel()
        keepSignInViewText.textColor = .rollpeGray
        keepSignInViewText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        keepSignInViewText.text = "로그인 유지"
        
        keepSignInView.addArrangedSubview(keepSignInViewText)
        
        keepSignInView.snp.makeConstraints { make in
            make.top.equalTo(password.snp.bottom).offset(16)
            make.leading.equalToSuperview()
        }
    }
    
    // 로그인 버튼
    private func setupSignInButton() {
        contentView.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(keepSignInView.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 메뉴들
    private func setupMenus() {
        // let findAccountButton = menuText("계정 찾기")
        let findPasswordButton = menuText("비밀번호 찾기")
        let signUpButton = menuText("회원가입")
        
        findPasswordButton.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let vc = ForgotPasswordViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let vc = SignUpViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        /*
        menus.addArrangedSubview(findAccountButton)
        menus.addArrangedSubview(menuText("|"))
        menus.addArrangedSubview(findPasswordButton)
        menus.addArrangedSubview(menuText("|"))
        */
        menus.addArrangedSubview(signUpButton)
        
        contentView.addSubview(menus)
        
        menus.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // 소셜 로그인
    private func setupSocials() {
        socialSignInView.addArrangedSubview(kakao)
        socialSignInView.addArrangedSubview(google)
        socialSignInView.addArrangedSubview(apple)
        
        contentView.addSubview(socialSignInView)
        
        socialSignInView.snp.makeConstraints { make in
            make.top.equalTo(menus.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // 약관
    private func setupPolicies() {
        contentView.addSubview(policiesView)
        
        policiesView.snp.makeConstraints { make in
            make.top.equalTo(socialSignInView.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let termsOfServiceButton = policyText("서비스 이용약관")
        
        termsOfServiceButton.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let vc = PolicyViewController("terms")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        let privacyPolicy = policyText("개인정보처리방침")
        
        privacyPolicy.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let vc = PolicyViewController("privacy")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        policiesView.addArrangedSubview(termsOfServiceButton)
        policiesView.addArrangedSubview(policyText("|"))
        policiesView.addArrangedSubview(privacyPolicy)
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = SignInViewModel.Input(
            email: email.rx.text,
            password: password.rx.text,
            keepSignInChecked: keepSignIn.rx.isChecked,
            signInButtonTapEvent: signInButton.rx.tap,
            kakaoButtonTapEvent: kakao.rx.tap,
            appleButtonTapEvent: apple.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.isSignInEnabled
            .drive() { isEnabled in
                self.signInButton.disabled = !isEnabled
            }
            .disposed(by: disposeBag)
        
        output.response
            .drive(onNext: { success in
                if success {
                    let vc = MainAfterSignInViewController()
                    self.navigationController?.pushViewController(vc, animated: false)
                } else {
                    self.showOKAlert(title: "오류", message: "로그인에 실패하였습니다.")
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
                    self.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        
        // 구글 로그인
        google.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                GIDSignIn.sharedInstance.signIn(withPresenting: self, hint: nil, additionalScopes: ["email", "profile"]) { signInResult, error in
                    guard error == nil else { return }
                    guard let signInResult = signInResult else { return }
                    
                    signInResult.user.refreshTokensIfNeeded { user, error in
                        guard error == nil else { return }
                        guard let user = user else { return }
                        
                        guard let idToken = user.idToken?.tokenString else { return }
                        
                        self.viewModel.sendTokenToServer(token: idToken, social: "google")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct SignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SignInViewController()
        }
    }
}
#endif
