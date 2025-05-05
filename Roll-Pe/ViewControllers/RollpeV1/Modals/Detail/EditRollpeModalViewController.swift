//
//  EditRollpeModalViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/14/25.
//

import UIKit
import SnapKit
import RxSwift

class EditRollpeModalViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = EditRollpeViewModel()
    
    // MARK: - 요소
    
    // 컨테이너 뷰
    private let containerView = {
        let view = UIView()
        view.backgroundColor = .rollpePrimary
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    // 스크롤 뷰
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        
        return sv
    }()
    
    // 내부 뷰
    private let contentView = UIView()
    
    // 닫기 버튼
    private let closeButton: UIButton = {
        let button = UIButton()
        let icon = UIImage.iconX
        icon.withTintColor(.rollpeSecondary)
        
        button.setImage(.iconX, for: .normal)
        button.setImage(.iconX, for: .highlighted)
        button.tintColor = .rollpeSecondary
        
        return button
    }()
    
    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "수정하기"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 28) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 28)
        }
        
        return label
    }()
    
    // 공개 설정 제목
    private let publicSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "공개 설정"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
        
        return label
    }()
    
    // 공개 설정 segment
    private let controlPrivate = SegmentControl(items: ["공개", "비공개"])
    
    // 비밀번호 text field
    private let password: RoundedBorderTextField = {
        let textField = RoundedBorderTextField()
        textField.placeholder = "비밀번호"
        
        return textField
    }()
    
    // 전달일 제목
    private let sendDateLabel: UILabel = {
        let label = UILabel()
        label.text = "전달일"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
        
        return label
    }()
    
    // 날짜 선택
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale(identifier: "ko-KR")
        
        var components = DateComponents()
        // 최소일
        components.day = 1
        let minDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        // 최대일
        components.day = 30
        let maxDate = Calendar.autoupdatingCurrent.date(byAdding: components, to: Date())
        
        picker.maximumDate = maxDate
        picker.minimumDate = minDate
        
        return picker
    }()
    
    // 전달일 picker
    private let textFieldSendDate = RoundedBorderTextFieldPicker()
    
    // 롤페 종료
    private let endRollpeButton = SecondaryButton(title: "롤페 종료하기")
    
    // 변경사항 저장
    private let saveButton = PrimaryButton(title: "변경사항 저장")
    
    let testButton = PrimaryButton(title: "test")
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.hideKeyboardWhenTappedAround()
        
        // UI 설정
        setupContentView()
        setupCloseButton()
        setupTitle()
        setupPublicSetting()
        setupSendDate()
        setupEndRollpeButton()
        setupSaveButton()
        
        // bind
        bind()
    }
    
    
    // MARK: - UI 설정
    
    // 내부 뷰
    private func setupContentView() {
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.center.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.62)
        }
        
        containerView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview().inset(20)
        }
    }
    
    // 닫기 버튼
    private func setupCloseButton() {
        contentView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview()
            make.size.equalTo(20)
        }
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 제목
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton)
        }
    }
    
    // 공개 설정
    private func setupPublicSetting() {
        contentView.addSubview(publicSettingLabel)
        
        publicSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview()
        }
        
        contentView.addSubview(controlPrivate)
        
        controlPrivate.snp.makeConstraints { make in
            make.top.equalTo(publicSettingLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        contentView.addSubview(password)
    }
    
    // 전달일 지정
    private func setupSendDate() {
        contentView.addSubview(sendDateLabel)
        
        // 전달일 선택
        textFieldSendDate.text = "\(dateToYYYYMd(datePicker.minimumDate!)) 오전 10시"
        textFieldSendDate.inputView = datePicker
        
        contentView.addSubview(textFieldSendDate)
        
        textFieldSendDate.snp.makeConstraints { make in
            make.top.equalTo(sendDateLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        datePicker.rx.date
            .subscribe(onNext: { date in
                self.textFieldSendDate.text = "\(dateToYYYYMd(date)) 오전 10시"
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 종료하기
    private func setupEndRollpeButton() {
        contentView.addSubview(endRollpeButton)
        
        endRollpeButton.snp.makeConstraints { make in
            make.top.equalTo(textFieldSendDate.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 변경사항 저장
    private func setupSaveButton() {
        contentView.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(endRollpeButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = EditRollpeViewModel.Input(
            privacyIndex: controlPrivate.control.rx.selectedSegmentIndex,
            password: password.rx.text,
            sendDate: textFieldSendDate.rx.text,
            endButtonTapEvent: endRollpeButton.rx.tap,
            saveButtonTapEvent: saveButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.isPasswordVisible
            .drive(onNext: { [weak self] visible in
                guard let self = self else { return }
                
                self.password.isHidden = !visible
                
                if visible {
                    self.password.snp.remakeConstraints { make in
                        make.top.equalTo(self.controlPrivate.snp.bottom).offset(12)
                        make.horizontalEdges.equalToSuperview()
                    }
                    
                    self.sendDateLabel.snp.remakeConstraints { make in
                        make.top.equalTo(self.password.snp.bottom).offset(40)
                        make.leading.equalToSuperview()
                    }
                } else {
                    self.sendDateLabel.snp.remakeConstraints { make in
                        make.top.equalTo(self.controlPrivate.snp.bottom).offset(40)
                        make.leading.equalToSuperview()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.successAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showAlertAndPop(title: "알림", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct EditRollpeModalViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            EditRollpeModalViewController()
        }
    }
}
#endif
