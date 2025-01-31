//
//  ChangePasswordViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/31/25.
//

import UIKit
import SwiftUI
import RxSwift

class ChangePasswordViewController: UIViewController {
    
    var currentPassword : String? = nil
    
    private let backButton : UIButton = {
        let button = UIButton()
        let backImage = UIImage(named: "icon_chevron_left")
        button.setImage(backImage, for: .normal)
        button.tintColor = .rollpeSecondary
        return button
    }()
    
    private let logo : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "img_logo")
        return image
    }()
    
    private let sideMenuView = SidemenuView(menuIndex: 4)
    
    let sideMenuButton = UIButton.makeSideMenuButton()
    
    let disposeBag = DisposeBag()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "비밀번호 변경"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
        return label
    }()
    
    private let changePasswordTextField : TextField = {
        let textField = TextField()
        textField.placeholder = "비밀번호"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let confirmPasswordTextField : TextField = {
        let textField = TextField()
        textField.placeholder = "비밀번호 확인"
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let changeConfirmButton = PrimaryButton(title: "변경하기")

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .rollpePrimary
        setupTopNavigationBar()
        setupTitleLabel()
        setupChangePasswordTextField()
        setupConfirmPasswordTextField()
        setupChangeConfirmButton()
    }
    
    private func setupTopNavigationBar() {
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(130)
            make.leading.equalToSuperview().offset(20)
        }
        view.addSubview(logo)
        logo.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(130)
            make.width.equalTo(48)
            make.height.equalTo(24)
        }
        view.addSubview(sideMenuButton)
        sideMenuButton.snp.makeConstraints { make in
            make.centerY.equalTo(logo)
            make.trailing.equalToSuperview().inset(20)
        }
        sideMenuButton.rx.tap
            .subscribe(onNext: {
                self.view.addSubview(self.sideMenuView)
                self.sideMenuView.showMenu()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(28)
        }
    }
    
    private func setupChangePasswordTextField() {
        view.addSubview(changePasswordTextField)
        changePasswordTextField.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
        }
    }
    
    private func setupConfirmPasswordTextField() {
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(changePasswordTextField.snp.bottom).offset(8)
        }
    }
    
    private func setupChangeConfirmButton(){
        view.addSubview(changeConfirmButton)
        changeConfirmButton.addTarget(self, action: #selector(changeConfirmButtonTapped), for: .touchUpInside)
        changeConfirmButton.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(32)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func changeConfirmButtonTapped() {
        guard let currentPassword = currentPassword else {
            let alert = UIAlertController(title: "오류", message: "오류가 발생하였습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if let changePassword = changePasswordTextField.text {
            if (changePassword != ""){
                    if (changePassword != confirmPasswordTextField.text) {
                        let alert = UIAlertController(title: "오류", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        if (changePassword.contains(" ")) {
                            let alert = UIAlertController(title: "오류", message: "띄어쓰기는 포함될 수 없습니다", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        else{
                            if (currentPassword == changePassword) {
                                let alert = UIAlertController(title: "오류", message: "현재 비밀번호와 새 비밀번호가 동일합니다.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            else {
                                // 비밀번호 변경 로직 추가하기
                                let alert = UIAlertController(title: "성공", message: "비밀번호가 성공적으로 변경되었습니다.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
            }
            else{
                let alert = UIAlertController(title: "오류", message: "바꾸실 비밀번호를 입력해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "오류", message: "바꾸실 비밀번호를 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
     
    }

}

struct ChangePasswordViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ChangePasswordViewController()
        }
    }
}
