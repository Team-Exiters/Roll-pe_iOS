//
//  RollpeEditViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/4/25.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class RollpeEditViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var rollpeHostViewModel : RollpeHostViewModel
    
    init(rollpeHostViewModel: RollpeHostViewModel) {
        self.rollpeHostViewModel = rollpeHostViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)에러")
    }
    
    private lazy var editView = EditView(rollpeHostViewModel: rollpeHostViewModel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rollpeGray
        navigationItem.hidesBackButton = true
        setupEditView()
        bindEditViewData()
        hideKeyboardWhenTappedAround()
    }
    
    private func setupEditView(){
        view.addSubview(editView)
        editView.layer.cornerRadius = 16
        editView.layer.masksToBounds = true
        editView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    private func bindEditViewData(){
        editView.isEndAlertActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self , isActive else {return}
                let alert = UIAlertController(title: "롤페 마무리", message: "롤페를 마무리하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
                    self.rollpeHostViewModel.deleteRollpeData()
                }))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by:disposeBag)
        editView.isSaveAlertActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self , isActive else {return}
                let alert = UIAlertController(title: "변경사항 저장", message: "저장하시겠습니까?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { _ in
                    if var rollpeData = self.editView.currentRollpeData {
                        if rollpeData.isPublic == true {
                            rollpeData.password = nil
                        }
                        self.rollpeHostViewModel.updateRollpeData(data: rollpeData)
                        if let navigationController = self.navigationController {
                            navigationController.popViewController(animated: true)
                        }
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by:disposeBag)
        editView.isPasswordEmptyAlertActive
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isActive in
                guard let self = self , isActive else {return}
                let alert = UIAlertController(title: "비밀번호", message: "비밀번호를 반드시 입력해주세요", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by:disposeBag)
    }
}

struct RollpeEditViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeEditViewController(rollpeHostViewModel: RollpeHostViewModel())
        }
    }
}

class EditView : UIView {
    
    private let disposeBag = DisposeBag()
    
    var rollpeHostViewModel : RollpeHostViewModel
    
    private var rollpeData : RollpeModel? = nil
    
    var currentRollpeData : RollpeModel? {
        return rollpeData
    }
    
    var isPasswordEmptyAlertActive = PublishRelay<Bool>()
    
    var isEndAlertActive = PublishRelay<Bool>()
    
    var isSaveAlertActive = PublishRelay<Bool>()
    
    init(rollpeHostViewModel: RollpeHostViewModel) {
        self.rollpeHostViewModel = rollpeHostViewModel
        super.init(frame: .zero)
        bindViewModel()
        setUIData()
        updateSegmentData()
        updatePasswordData()
        setupUI()
        setupDatePicker()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:)에러")
    }
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        if let originalImage = UIImage(named: "icon_x") {
            let resizedImage = originalImage.resized(to: CGSize(width: 20, height: 20))
            button.setImage(resizedImage, for: .normal)
        }
        button.tintColor = .rollpeSecondary
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "수정하기"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 28) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        }
        return label
    }()
    
    private let publicSettingLabel : UILabel = {
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
    
    private let segmentControl = SegmentControl(items: ["공개","비공개"])
    
    private let passwordTextField : TextField = {
        let textField = TextField()
        textField.placeholder = "비밀번호"
        textField.textContentType = .password
        return textField
    }()
    
    private let dateLabel : UILabel = {
        let label = UILabel()
        label.text = "종료 일자"
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
    
    private let dateTextField : TextField = {
        let textField = TextField()
        textField.placeholder = ""
        textField.textContentType = .password
        return textField
    }()
    
    private let rollpeEndButton = SecondaryButton(title: "롤페 마무리하기")
    
    private let rollpeSaveButton = PrimaryButton(title: "변경사항 저장")
    
    private func setupUI(){
        backgroundColor = .rollpePrimary
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(publicSettingLabel)
        addSubview(segmentControl)
        addSubview(passwordTextField)
        addSubview(dateLabel)
        addSubview(dateTextField)
        addSubview(rollpeEndButton)
        addSubview(rollpeSaveButton)
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        rollpeEndButton.addTarget(self, action: #selector(rollpeEndButtonTapped), for: .touchUpInside)
        rollpeSaveButton.addTarget(self, action: #selector(rollpeSaveButtonTapped), for:  .touchUpInside)
        
        backButton.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        publicSettingLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(backButton.snp.bottom).offset(32)
        }
        segmentControl.snp.makeConstraints{ make in
            make.top.equalTo(publicSettingLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        passwordTextField.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(segmentControl.snp.bottom).offset(12)
        }
        dateLabel.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(segmentControl.snp.bottom).offset(104)
        }
        dateTextField.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(dateLabel.snp.bottom).offset(20)
        }
        rollpeEndButton.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(dateTextField.snp.bottom).offset(40)
        }
        rollpeSaveButton.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(rollpeEndButton.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func bindViewModel() {
        rollpeHostViewModel.rollpeModel
            .compactMap { $0 } // nil 값 제거
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                self.rollpeData = model
            })
            .disposed(by: disposeBag)
    }
    
    //뷰열리면 처음 값들 세팅하는함수임
    private func setUIData(){
        segmentControl.control.selectedSegmentIndex = self.rollpeData?.isPublic ?? false ? 0 : 1
        passwordTextField.text = self.rollpeData?.password
        passwordTextField.isHidden = self.rollpeData?.isPublic ?? false
        if let date = self.rollpeData?.date {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy년 M월 d일 a h시 mm분"
            dateTextField.placeholder = formatter.string(from: date)
        }
    }
    
    //Segment값 변화할때 실시간으로 rollpeData값 업데이트 하는 함수
    private func updateSegmentData() {
          segmentControl.control.rx.selectedSegmentIndex
              .subscribe(onNext: { [weak self] index in
                  guard let self = self else { return }
                  // index가 0이면 공개(true) , 1이면 비공개(false)로 설정
                  self.rollpeData?.isPublic = (index == 0)
                  self.passwordTextField.isHidden = self.rollpeData?.isPublic ?? false
              })
              .disposed(by: disposeBag)
      }
    
    private func updatePasswordData(){
        passwordTextField.rx.text
                .orEmpty // 옵셔널 방지 (nil이면 빈 문자열로 변환)
                .distinctUntilChanged() // 같은 값이면 중복 호출 방지
                .subscribe(onNext: { [weak self] newPassword in
                    self?.rollpeData?.password = newPassword
                })
                .disposed(by: disposeBag)
    }
    
    private func setupDatePicker() {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.locale = Locale(identifier: "ko_KR")
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
   
        self.dateTextField.inputView = datePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        self.dateTextField.inputAccessoryView = toolbar
    }

    @objc private func donePressed() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker {
            self.dateTextField.placeholder = dateToYYYYMD(datePicker.date)
            self.rollpeData?.date = datePicker.date
        }
        self.dateTextField.resignFirstResponder()
    }
    
    @objc private func backButtonTapped() {
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @objc private func rollpeEndButtonTapped(){
        isEndAlertActive.accept(true)
    }
    
    @objc private func rollpeSaveButtonTapped(){
        if (rollpeData?.isPublic == false && passwordTextField.text?.isEmpty == true){
            isPasswordEmptyAlertActive.accept(true)
        }
        else{
            isSaveAlertActive.accept(true)
        }
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

