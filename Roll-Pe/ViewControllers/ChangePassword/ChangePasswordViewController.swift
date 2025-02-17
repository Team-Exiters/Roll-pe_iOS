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
    
    private var equalToCurrentPassword : Bool = false
    
    private let navigationBar : NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.menuIndex = 4
        navigationBar.showSideMenu = true
        return navigationBar
    }()
    
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
        setupNavigationBar()
        setupTitleLabel()
        setupChangePasswordTextField()
        setupConfirmPasswordTextField()
        setupChangeConfirmButton()
    }
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.parentViewController = self
            navigationBar.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(20)
                make.top.equalTo(safeareaTop + 40)
            }
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).offset(28)
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
       //서버에 changePasswordTextField.text값 보내서 현재 비밀번호와 비교시켜 같은지 아닌지 bool값으로 ViewModel함수로 반환시킨후 equalToCurrentPassword 변수에 저장시키는 로직
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
                            if (equalToCurrentPassword) {
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
