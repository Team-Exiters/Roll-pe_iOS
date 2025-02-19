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
import SwiftUI
import SafariServices

class SignInViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    // 뷰모델
    private let viewModel = SignInViewModel()
    
    // MARK: - 속성
    
    // 이메일
    private let email: TextField = {
        let textField = TextField()
        textField.placeholder = "이메일"
        textField.textContentType = .emailAddress
        textField.keyboardType = .emailAddress
        
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
    
    // 로그인 유지
    private let keepSignIn: Checkbox = {
        let checkbox = Checkbox()
        checkbox.isChecked = true
        
        return checkbox
    }()
    
    // 로그인 버튼
    private let signInButton = PrimaryButton(title: "로그인")
    
    // 메뉴들
    private func menuText(_ text: String) -> UILabel {
        let label: UILabel = UILabel()
        label.textColor = .rollpeGray
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        label.text = text
        
        return label
    }
        
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
    
    // 약관들
    private func policyText(_ text: String) -> UILabel {
        let label: UILabel = UILabel()
        label.textColor = .rollpeGray
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.text = text
        
        let tapGesture = UITapGestureRecognizer()
        label.addGestureRecognizer(tapGesture)
        
        return label
    }
    
    // 로딩 뷰
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        
        return view
    }()
    
    // MARK: - viewDidLoad
    
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
        
        // 배경 이미지
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
        
        // 내부 뷰
        let scrollView: UIScrollView = UIScrollView()
        scrollView.bounces = false
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
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().inset(40)
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
            make.top.equalToSuperview().inset(100)
            make.width.equalToSuperview().multipliedBy(0.427)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage))
            make.centerX.equalToSuperview()
        }
        
        // 제목
        let title: UILabel = UILabel()
        title.textColor = .rollpeSecondary
        title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        title.numberOfLines = 2
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineHeightMultiple = 0.98
        titleParagraphStyle.alignment = .center
        title.attributedText = NSMutableAttributedString(string: "다같이 한 마음으로\n사랑하는 사람에게 전달해보세요", attributes: [.paragraphStyle: titleParagraphStyle])
        
        contentView.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // Form
        // 이메일
        contentView.addSubview(email)
        
        email.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(60)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 비밀번호
        contentView.addSubview(password)
        
        password.snp.makeConstraints { make in
            make.top.equalTo(email.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 로그인 유지
        let keepSignInView: UIStackView = UIStackView()
        keepSignInView.axis = .horizontal
        keepSignInView.spacing = 8
        keepSignInView.alignment = .center
        
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
        
        // 로그인 버튼
        contentView.addSubview(signInButton)
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(keepSignInView.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview()
        }
        
        // 메뉴들
        let menus: UIStackView = UIStackView()
        menus.axis = .horizontal
        menus.spacing = 8
        menus.alignment = .center
        
        let findAccountButton = menuText("계정 찾기")
        let findPasswordButton = menuText("비밀번호 찾기")
        let signUpButton = menuText("회원가입")
        
        signUpButton.rx.tap
            .subscribe(onNext: {
                let vc = SignUpViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        menus.addArrangedSubview(findAccountButton)
        menus.addArrangedSubview(menuText("|"))
        menus.addArrangedSubview(findPasswordButton)
        menus.addArrangedSubview(menuText("|"))
        menus.addArrangedSubview(signUpButton)
        
        contentView.addSubview(menus)
        
        menus.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 소셜 로그인
        let socialSignInView: UIStackView = UIStackView()
        socialSignInView.axis = .horizontal
        socialSignInView.spacing = 16
        socialSignInView.alignment = .center
        
        socialSignInView.addArrangedSubview(kakao)
        socialSignInView.addArrangedSubview(google)
        socialSignInView.addArrangedSubview(apple)
        
        contentView.addSubview(socialSignInView)
        
        socialSignInView.snp.makeConstraints { make in
            make.top.equalTo(menus.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        // 약관들
        let policies: UIStackView = UIStackView()
        policies.axis = .horizontal
        policies.spacing = 6
        policies.alignment = .center
        
        contentView.addSubview(policies)
        
        policies.snp.makeConstraints { make in
            make.top.equalTo(socialSignInView.snp.bottom).offset(64)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        let termsOfServiceButton = policyText("서비스 이용약관")
        
        termsOfServiceButton.rx.tap
            .subscribe(onNext: {
                let url = NSURL(string: "https://haren-dev2.defcon.or.kr/terms-of-service")
                let safariVc: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(safariVc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        let privacyPolicy = policyText("개인정보처리방침")
        
        privacyPolicy.rx.tap
            .subscribe(onNext: {
                let url = NSURL(string: "https://haren-dev2.defcon.or.kr/privacy-policy")
                let safariVc: SFSafariViewController = SFSafariViewController(url: url! as URL)
                self.present(safariVc, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        policies.addArrangedSubview(termsOfServiceButton)
        policies.addArrangedSubview(policyText("|"))
        policies.addArrangedSubview(privacyPolicy)
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = SignInViewModel.Input(
            email: email.rx.text,
            password: password.rx.text,
            keepSignInChecked: keepSignIn.rx.isChecked,
            signInButtonTapEvent: signInButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.isSignInEnabled
            .drive() { isEnabled in
                self.signInButton.disabled = !isEnabled
            }
            .disposed(by: disposeBag)
        
        output.signInResponse
            .drive(onNext: { success in
                if success {
                    let vc = MainAfterSignInViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showErrorAlert(message: "로그인에 실패하였습니다.")
                }
            })
            .disposed(by: disposeBag)
        
        output.isLoading
            .drive(onNext: { isLoading in
                self.loadingView.isHidden = !isLoading
            })
            .disposed(by: disposeBag)
        
        output.showAlert
            .drive(onNext: { message in
                if let message = message {
                    self.showErrorAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

#if DEBUG
struct SignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SignInViewController()
        }
    }
}
#endif
