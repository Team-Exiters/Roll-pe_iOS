//
//  ViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/24/25.
//

import UIKit
import SnapKit
import SwiftUI

class SignInViewController: UIViewController {
    // MARK: - Form
    
    private func Form() -> UIStackView {
        let form: UIStackView = UIStackView()
        form.axis = .vertical
        form.spacing = 0
        form.alignment = .center
        
        // MARK: - 이메일
        
        let email = TextField()
        email.placeholder = "이메일"
        email.textContentType = .emailAddress
        email.keyboardType = .emailAddress
        
        form.addArrangedSubview(email)
        
        email.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        form.setCustomSpacing(12, after: email)
        
        // MARK: - 비밀번호
        
        let password = TextField()
        password.placeholder = "비밀번호"
        password.textContentType = .password
        password.isSecureTextEntry = true
        
        form.addArrangedSubview(password)
        
        password.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        form.setCustomSpacing(16, after: password)
        
        // MARK: - 로그인 유지
        
        let keepSignInView: UIStackView = UIStackView()
        keepSignInView.axis = .horizontal
        keepSignInView.spacing = 8
        keepSignInView.alignment = .center
        
        form.addArrangedSubview(keepSignInView)
        
        let checkbox = Checkbox()
        checkbox.isChecked = true
        
        keepSignInView.addArrangedSubview(checkbox)
        
        let keepSignInViewText: UILabel = UILabel()
        keepSignInViewText.textColor = .rollpeGray
        keepSignInViewText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        keepSignInViewText.text = "로그인 유지"
        
        keepSignInView.addArrangedSubview(keepSignInViewText)
        
        keepSignInView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        form.setCustomSpacing(28, after: keepSignInView)
        
        // MARK: - 로그인 버튼
        
        let signInButton = PrimaryButton(title: "로그인")
        
        form.addArrangedSubview(signInButton)
        
        signInButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        return form
    }
    
    // MARK: - 메뉴들
    
    private func Menus() -> UIStackView {
        let text: (String) -> UILabel = {
            let label: UILabel = UILabel()
            label.textColor = .rollpeGray
            label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
            label.text = $0
            
            return label
        }
        
        let view: UIStackView = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.alignment = .center
        
        view.addArrangedSubview(text("계정 찾기"))
        view.addArrangedSubview(text("|"))
        view.addArrangedSubview(text("비밀번호 찾기"))
        view.addArrangedSubview(text("|"))
        view.addArrangedSubview(text("회원가입"))
        
        return view
    }
    
    // MARK: - 소셜 로그인
    
    private func SocialSignIn() -> UIStackView {
        let socialBlock: (String) -> UIView = {
            let SIZE: CGFloat = 48
            
            let view: UIView = UIView()
            view.layer.cornerRadius = SIZE / 2
            view.layer.masksToBounds = true
            
            view.snp.makeConstraints { make in
                make.size.equalTo(SIZE)
            }
            
            let logo: UIImageView = UIImageView()
            let logoImage = UIImage(named: $0)
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
        }
        
        let view: UIStackView = UIStackView()
        view.axis = .horizontal
        view.spacing = 16
        view.alignment = .center
        
        let kakao = socialBlock("icon_kakao")
        kakao.backgroundColor = .kakao
        
        view.addArrangedSubview(kakao)
        
        let google = socialBlock("icon_google")
        google.backgroundColor = .rollpeWhite
        google.layer.borderWidth = 1
        google.layer.borderColor = UIColor.realBlack.cgColor
        
        view.addArrangedSubview(google)
        
        let apple = socialBlock("icon_apple")
        apple.backgroundColor = .realBlack
        
        view.addArrangedSubview(apple)
        
        return view
    }
    
    // MARK: - 약관들
    
    private func Policies() -> UIStackView {
        let text: (String) -> UILabel = {
            let label: UILabel = UILabel()
            label.textColor = .rollpeGray
            label.font = UIFont(name: "Pretendard-Regular", size: 12)
            label.text = $0
            
            return label
        }
        
        let view: UIStackView = UIStackView()
        view.axis = .horizontal
        view.spacing = 6
        view.alignment = .center
        
        view.addArrangedSubview(text("서비스 이용약관"))
        view.addArrangedSubview(text("|"))
        view.addArrangedSubview(text("개인정보처리방침"))
        
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .rollpePrimary
        
        // MARK: - 배경 이미지
        
        let background: UIImageView = UIImageView()
        background.image = UIImage.imgBackground
        background.contentMode = .scaleAspectFill
        background.clipsToBounds = true
        background.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(safeareaTop * -1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(safeareaBottom * -1)
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        // MARK: - 뒤로가기
        
        let back: UIImageView = UIImageView()
        let backImage: UIImage = UIImage.iconChevronLeft
        back.image = backImage
        back.contentMode = .scaleAspectFit
        back.clipsToBounds = true
        back.tintColor = .rollpeSecondary
        
        view.addSubview(back)
        
        back.snp.makeConstraints { make in
            make.top.equalTo(safeareaTop + 20)
            make.leading.equalTo(20)
            make.width.equalTo(12)
            make.height.equalTo(back.snp.width).dividedBy(getImageRatio(image: backImage))
        }
        
        // MARK: - 내부 뷰
        
        let scrollView: UIScrollView = UIScrollView()
        scrollView.bounces = false
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(safeareaTop)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        let contentView: UIStackView = UIStackView()
        contentView.axis = .vertical
        contentView.spacing = 0
        contentView.alignment = .center
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        // 로고
        let logo: UIImageView = UIImageView()
        let logoImage = UIImage.imgLogo
        logo.image = logoImage
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        contentView.addArrangedSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.427)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage))
        }
        
        contentView.setCustomSpacing(20, after: logo)
        
        // 제목
        let title: UILabel = UILabel()
        title.textColor = .rollpeSecondary
        title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        title.numberOfLines = 2
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.lineHeightMultiple = 0.98
        titleParagraphStyle.alignment = .center
        title.attributedText = NSMutableAttributedString(string: "다같이 한 마음으로\n사랑하는 사람에게 전달해보세요", attributes: [.paragraphStyle: titleParagraphStyle])
        
        contentView.addArrangedSubview(title)
        
        contentView.setCustomSpacing(60, after: title)
        
        // Form
        let form = Form()
        
        contentView.addArrangedSubview(form)
        
        form.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        contentView.setCustomSpacing(28, after: form)
        
        // 메뉴들
        let menus = Menus()
        
        contentView.addArrangedSubview(menus)
        contentView.setCustomSpacing(20, after: menus)
        
        // 소셜 로그인
        let socialSignIn = SocialSignIn()
        
        contentView.addArrangedSubview(socialSignIn)
        contentView.setCustomSpacing(64, after: socialSignIn)
        
        // 약관들
        let polices = Policies()
        
        contentView.addArrangedSubview(polices)
    }
}

struct SignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SignInViewController() // UIKit ViewController 연결
        }
    }
}
