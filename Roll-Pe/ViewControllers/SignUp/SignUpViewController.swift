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

class SignUpViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .rollpePrimary
        
        // Spacer
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // 링크 버튼 폰트
        let linkButtonFont: UIFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        // MARK: - 내부 뷰
        
        let scrollView: UIScrollView = UIScrollView()
        
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
            make.top.equalToSuperview().inset(80)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        
        // MARK: - 로고
        
        let logo: UIImageView = UIImageView()
        let logoImage = UIImage.imgLogo
        logo.image = logoImage
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        contentView.addArrangedSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.377884615)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage))
        }
        
        contentView.setCustomSpacing(20, after: logo)
        
        // MARK: - 제목
        
        let title: UILabel = UILabel()
        title.textColor = .rollpeSecondary
        title.font = UIFont(name: "Pretendard-Regular", size: 20)
        title.text = "회원가입"
        
        contentView.addArrangedSubview(title)
        
        contentView.setCustomSpacing(60, after: title)
        
        // MARK: - 이메일
        
        // 이메일
        let email = TextField()
        email.placeholder = "이메일"
        email.textContentType = .emailAddress
        email.keyboardType = .emailAddress
        
        contentView.addArrangedSubview(email)
        
        email.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        contentView.setCustomSpacing(8, after: email)
        
        // 인증번호 발송
        let buttonSendVerificationCode = SecondaryButton(title: "인증번호 발송")
        
        contentView.addArrangedSubview(buttonSendVerificationCode)
        
        buttonSendVerificationCode.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        contentView.setCustomSpacing(8, after: buttonSendVerificationCode)
        
        // MARK: - 인증번호
        
        let verificationCode = TextField()
        verificationCode.placeholder = "인증번호"
        verificationCode.textContentType = .oneTimeCode
        verificationCode.keyboardType = .numberPad
        
        contentView.addArrangedSubview(verificationCode)
        
        verificationCode.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        contentView.setCustomSpacing(8, after: verificationCode)
        
        let buttonCheckSendVerificationCode = SecondaryButton(title: "인증번호 확인")
        
        contentView.addArrangedSubview(buttonCheckSendVerificationCode)
        
        buttonCheckSendVerificationCode.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        contentView.setCustomSpacing(8, after: buttonCheckSendVerificationCode)
        
        // MARK: - 비밀번호
        
        let password = TextField()
        password.placeholder = "비밀번호"
        password.textContentType = .password
        password.isSecureTextEntry = true
        
        contentView.addArrangedSubview(password)
        
        password.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        contentView.setCustomSpacing(8, after: password)
        
        let passwordConfirm = TextField()
        passwordConfirm.placeholder = "비밀번호 확인"
        passwordConfirm.textContentType = .password
        passwordConfirm.isSecureTextEntry = true
        
        contentView.addArrangedSubview(passwordConfirm)
        
        passwordConfirm.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        contentView.setCustomSpacing(40, after: passwordConfirm)
        
        // MARK: - 연령 확인
        
        let confirmAgeView: UIStackView = UIStackView()
        confirmAgeView.axis = .horizontal
        confirmAgeView.spacing = 8
        confirmAgeView.alignment = .center
        
        contentView.addArrangedSubview(confirmAgeView)
        
        let checkboxConfirmAge = Checkbox()
        
        confirmAgeView.addArrangedSubview(checkboxConfirmAge)
        
        let confirmAgeText: UILabel = UILabel()
        confirmAgeText.textColor = .rollpeSecondary
        confirmAgeText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        confirmAgeText.text = "저는 만 14세 이상입니다."
        
        confirmAgeView.addArrangedSubview(confirmAgeText)
        
        confirmAgeView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        contentView.setCustomSpacing(8, after: confirmAgeView)
        
        // MARK: - 서비스 이용약관
        
        let confirmTermsView: UIStackView = UIStackView()
        confirmTermsView.axis = .horizontal
        confirmTermsView.spacing = 8
        confirmTermsView.alignment = .center
        
        contentView.addArrangedSubview(confirmTermsView)
        
        let checkboxConfirmTerms = Checkbox()
        
        confirmTermsView.addArrangedSubview(checkboxConfirmTerms)
        
        let confirmTermsText: UILabel = UILabel()
        confirmTermsText.textColor = .rollpeSecondary
        confirmTermsText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        confirmTermsText.text = "서비스 이용약관에 동의합니다."
        
        confirmTermsView.addArrangedSubview(confirmTermsText)
        
        confirmTermsView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        confirmTermsView.addArrangedSubview(spacer)
        
        let buttonLinkToTerms: UIButton = UIButton()
        buttonLinkToTerms.setTitle("보기", for: .normal)
        buttonLinkToTerms.setTitleColor(.rollpeGray, for: .normal)
        buttonLinkToTerms.removeConfigurationPadding()
        buttonLinkToTerms.setFont(linkButtonFont)
        
        confirmTermsView.addArrangedSubview(buttonLinkToTerms)
        
        contentView.setCustomSpacing(8, after: confirmTermsView)
        
        // MARK: - 개인정보 수집 및 이용 동의
        
        let confirmPrivacyView: UIStackView = UIStackView()
        confirmPrivacyView.axis = .horizontal
        confirmPrivacyView.spacing = 8
        confirmPrivacyView.alignment = .center
        
        contentView.addArrangedSubview(confirmPrivacyView)
        
        let checkboxConfirmPrivacy = Checkbox()
        
        confirmPrivacyView.addArrangedSubview(checkboxConfirmPrivacy)
        
        let confirmPrivacyText: UILabel = UILabel()
        confirmPrivacyText.textColor = .rollpeSecondary
        confirmPrivacyText.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14)
        confirmPrivacyText.text = "개인정보 수집 및 이용에 동의합니다."
        
        confirmPrivacyView.addArrangedSubview(confirmPrivacyText)
        
        confirmPrivacyView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
        }
        
        confirmPrivacyView.addArrangedSubview(spacer)
        
        let buttonLinkToPrivacy: UIButton = UIButton()
        buttonLinkToPrivacy.setTitle("보기", for: .normal)
        buttonLinkToPrivacy.setTitleColor(.rollpeGray, for: .normal)
        buttonLinkToPrivacy.removeConfigurationPadding()
        buttonLinkToPrivacy.setFont(linkButtonFont)
        
        confirmPrivacyView.addArrangedSubview(buttonLinkToPrivacy)
        
        contentView.setCustomSpacing(20, after: confirmPrivacyView)
        
        // MARK: - 가입
        
        let buttonSignUp: UIButton = PrimaryButton(title: "가입")
        contentView.addArrangedSubview(buttonSignUp)
        
        buttonSignUp.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
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
    }
}

struct SignUpViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SignUpViewController()
        }
    }
}
