//
//  CreateRollpeViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/30/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftUI

class CreateRollpeViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel = CreateRollpeViewModel()
    
    // MARK: - 요소
    
    private var ratioBlocks: [RollpeRatioBlock] = []
    private var themeBlocks: [RollpeThemeBlock] = []
    private var sizeBlocks: [RollpeSizeBlock] = []
    
    private let contentView: UIView = UIView()
    
    private let pageTitle = UILabel()
    
    private let textFieldTitle: RoundedBorderTextField = {
        let tf = RoundedBorderTextField()
        tf.placeholder = ""
        tf.maxLength = 20
        
        return tf
    }()
    
    private let scrollRatios: UIScrollView = UIScrollView()
    
    private let listRatios: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        
        return sv
    }()
    
    private let scrollThemes: UIScrollView = UIScrollView()
    
    private let listThemes: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        
        return sv
    }()
    
    private let scrollSizes: UIScrollView = UIScrollView()
    
    private let listSizes: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 20
        
        return sv
    }()
    
    private let controlPrivate = SegmentControl(items: ["공개", "비공개"])
    
    private let password = RoundedBorderTextField()
    
    private lazy var subjectSendDate: UILabel = LabelSubject()
    
    private let textFieldSendDate = RoundedBorderTextFieldPicker()
    
    private let pickerUser = RoundedBorderTextField()
    
    private let imageViewPreview = UIImageView()
    
    private let createButton = PrimaryButton(title: "만들기")
    
    // 컴포넌트
    // 주제 텍스트
    private func LabelSubject() -> UILabel {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        
        return label
    }
    
    // 설명 텍스트
    private func LabelDesc() -> UILabel {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 12)
        label.textColor = .rollpeSecondary
        
        return label
    }
    
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
        addNavigationBar()
        addLoadingView()
    }
    
    // MARK: - UI 구성
    
    private func setUI() {
        view.backgroundColor = .rollpePrimary
        
        setupContentView()
        setupPageTitle()
        setupTitle()
        setupRatio()
        setupThemes()
        setupSize()
        setupPrivate()
        setupSendDate()
        setupUser()
        setupPreview()
        setupCreateButton()
    }
    
    // 네비게이션 바
    private func addNavigationBar() {
        let navigationBar = NavigationBar()
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(safeareaTop)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // 로딩 뷰
    private func addLoadingView() {
        view.addSubview(loadingView)
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
            make.width.equalToSuperview()
        }
    }
    
    // 페이지 제목
    private func setupPageTitle() {
        pageTitle.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32)
        pageTitle.textColor = .rollpeSecondary
        pageTitle.text = "롤페 만들기"
        
        contentView.addSubview(pageTitle)
        
        pageTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(88)
            make.centerX.equalToSuperview()
        }
    }
    
    // 롤페 제목 입력
    private func setupTitle() {
        let subjectTitle: UILabel = LabelSubject()
        subjectTitle.text = "제목을 입력하세요"
        
        contentView.addSubview(subjectTitle)
        
        subjectTitle.snp.makeConstraints { make in
            make.top.equalTo(pageTitle.snp.bottom).offset(52)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(textFieldTitle)
        
        textFieldTitle.snp.makeConstraints { make in
            make.top.equalTo(subjectTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // 비율 선택
    private func setupRatio() {
        let subjectRatios: UILabel = LabelSubject()
        subjectRatios.text = "비율을 선택하세요"
        
        contentView.addSubview(subjectRatios)
        
        subjectRatios.snp.makeConstraints { make in
            make.top.equalTo(textFieldTitle.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(scrollRatios)
        
        scrollRatios.snp.makeConstraints { make in
            make.top.equalTo(subjectRatios.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        scrollRatios.addSubview(listRatios)
        
        listRatios.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalToSuperview()
        }
    }
    
    // 테마 선택
    private func setupThemes() {
        let subjectThemes: UILabel = LabelSubject()
        subjectThemes.text = "테마를 선택하세요"
        
        contentView.addSubview(subjectThemes)
        
        subjectThemes.snp.makeConstraints { make in
            make.top.equalTo(scrollRatios.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(scrollThemes)
        
        scrollThemes.snp.makeConstraints { make in
            make.top.equalTo(subjectThemes.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        scrollThemes.addSubview(listThemes)
        
        listThemes.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalToSuperview()
        }
    }
    
    // 크기 선택
    private func setupSize() {
        let subjectSizes: UILabel = LabelSubject()
        subjectSizes.text = "크기를 선택하세요"
        
        contentView.addSubview(subjectSizes)
        
        subjectSizes.snp.makeConstraints { make in
            make.top.equalTo(scrollThemes.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(scrollSizes)
        
        scrollSizes.snp.makeConstraints { make in
            make.top.equalTo(subjectSizes.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        scrollSizes.addSubview(listSizes)
        
        listSizes.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().offset(20)
            make.height.equalToSuperview()
        }
    }
    
    // 공개 여부 선택
    private func setupPrivate() {
        let subjectPrivate: UILabel = LabelSubject()
        subjectPrivate.text = "공개 설정 여부"
        
        contentView.addSubview(subjectPrivate)
        
        subjectPrivate.snp.makeConstraints { make in
            make.top.equalTo(scrollSizes.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        let descPrivate = LabelDesc()
        descPrivate.text = "링크를 가진 모든 분들이 볼 수 있어요."
        
        contentView.addSubview(descPrivate)
        
        descPrivate.snp.makeConstraints { make in
            make.top.equalTo(subjectPrivate.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        // 공개 설정
        controlPrivate.control.selectedSegmentIndex = 1
        
        contentView.addSubview(controlPrivate)
        
        controlPrivate.snp.makeConstraints { make in
            make.top.equalTo(descPrivate.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 비밀번호
        password.placeholder = "비밀번호"
        
        contentView.addSubview(password)
    }
    
    // 전달일 지정
    private func setupSendDate() {
        subjectSendDate.text = "전달일을 지정해주세요"
        
        contentView.addSubview(subjectSendDate)
        
        // 전달일 선택
        textFieldSendDate.text = "\(dateToYYYYMd(datePicker.minimumDate!)) 오전 10시"
        textFieldSendDate.inputView = datePicker
        
        contentView.addSubview(textFieldSendDate)
        
        textFieldSendDate.snp.makeConstraints { make in
            make.top.equalTo(subjectSendDate.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        datePicker.rx.date
            .subscribe(onNext: { date in
                self.textFieldSendDate.text = "\(dateToYYYYMd(date)) 오전 10시"
            })
            .disposed(by: disposeBag)
    }
    
    // 전달할 사람 지정
    private func setupUser() {
        let subjectUser: UILabel = LabelSubject()
        subjectUser.text = "전달할 사람을 지정해주세요"
        
        contentView.addSubview(subjectUser)
        
        subjectUser.snp.makeConstraints { make in
            make.top.equalTo(textFieldSendDate.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(pickerUser)
        
        pickerUser.snp.makeConstraints { make in
            make.top.equalTo(subjectUser.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        pickerUser.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let modalVC = SearchUserModalViewController()
                modalVC.onUserSelected = { user in
                    self?.viewModel.selectedUser.accept(user)
                }
                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.modalTransitionStyle = .crossDissolve
                self?.present(modalVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 미리보기
    private func setupPreview() {
        let subjectPreview: UILabel = LabelSubject()
        subjectPreview.text = "종료일을 지정해주세요"
        
        contentView.addSubview(subjectPreview)
        
        subjectPreview.snp.makeConstraints { make in
            make.top.equalTo(pickerUser.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        let descPreview = LabelDesc()
        descPreview.text = "최대 \(13)명까지 작성할 수 있어요."
        
        contentView.addSubview(descPreview)
        
        descPreview.snp.makeConstraints { make in
            make.top.equalTo(subjectPreview.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        let imagePreview: UIImage = .imgPreviewWhiteHorizontal
        imageViewPreview.image = imagePreview
        imageViewPreview.contentMode = .scaleAspectFit
        imageViewPreview.clipsToBounds = true
        
        contentView.addSubview(imageViewPreview)
        
        imageViewPreview.snp.makeConstraints { make in
            make.top.equalTo(descPreview.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(imageViewPreview.snp.width).dividedBy(getImageRatio(image: imagePreview))
        }
    }
    
    // 만들기
    private func setupCreateButton() {
        contentView.addSubview(createButton)
        
        createButton.snp.makeConstraints { make in
            make.top.equalTo(imageViewPreview.snp.bottom).offset(52)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.getIndexes()
        
        let input = CreateRollpeViewModel.Input(
            title: textFieldTitle.rx.text,
            privacyIndex: controlPrivate.control.rx.selectedSegmentIndex,
            password: password.rx.text,
            sendDate: textFieldSendDate.rx.text,
            createButtonTapEvent: createButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        // 비율
        output.ratios
            .drive(onNext: { [weak self] models in
                guard let self = self else { return }
                
                models.forEach { model in
                    let ratioBlock = RollpeRatioBlock()
                    ratioBlock.model = model
                    
                    // select tap event
                    ratioBlock.rx.tap
                        .subscribe(onNext: { [weak self] in
                            guard let self = self else { return }
                            
                            self.viewModel.selectedRatio.accept(model)
                        })
                        .disposed(by: self.disposeBag)
                    
                    self.listRatios.addArrangedSubview(ratioBlock)
                    self.ratioBlocks.append(ratioBlock)
                }
            })
            .disposed(by: disposeBag)
        
        output.selectedRatio
            .drive(onNext: { [weak self] model in
                guard let self = self else { return }
                
                self.ratioBlocks.forEach { block in
                    block.isSelected = (model == block.model)
                }
            })
            .disposed(by: disposeBag)
        
        // 테마
        output.themes
            .drive(onNext: { [weak self] models in
                guard let self = self else { return }
                
                models.forEach { model in
                    let themeBlock = RollpeThemeBlock()
                    themeBlock.model = model
                    
                    // select tap event
                    themeBlock.rx.tap
                        .subscribe(onNext: { [weak self] in
                            guard let self = self else { return }
                            
                            self.viewModel.selectedTheme.accept(model)
                        })
                        .disposed(by: self.disposeBag)
                    
                    self.listThemes.addArrangedSubview(themeBlock)
                    self.themeBlocks.append(themeBlock)
                }
            })
            .disposed(by: disposeBag)
        
        output.selectedTheme
            .drive(onNext: { [weak self] model in
                guard let self = self else { return }
                
                self.themeBlocks.forEach { block in
                    block.isSelected = (model == block.model)
                }
            })
            .disposed(by: disposeBag)
        
        // 크기
        output.sizes
            .drive(onNext: { [weak self] models in
                guard let self = self else { return }
                
                models.forEach { model in
                    let sizeBlock = RollpeSizeBlock()
                    sizeBlock.model = model
                    
                    // select tap event
                    sizeBlock.rx.tap
                        .subscribe(onNext: { [weak self] in
                            guard let self = self else { return }
                            
                            self.viewModel.selectedSize.accept(model)
                        })
                        .disposed(by: self.disposeBag)
                    
                    self.listSizes.addArrangedSubview(sizeBlock)
                    self.sizeBlocks.append(sizeBlock)
                }
            })
            .disposed(by: disposeBag)
        
        output.selectedSize
            .drive(onNext: { [weak self] model in
                guard let self = self else { return }
                
                self.sizeBlocks.forEach { block in
                    block.isSelected = (model == block.model)
                }
            })
            .disposed(by: disposeBag)
        
        output.isPasswordVisible
            .drive(onNext: { [weak self] visible in
                guard let self = self else { return }
                
                self.password.isHidden = !visible
                
                if visible {
                    self.password.snp.remakeConstraints { make in
                        make.top.equalTo(self.controlPrivate.snp.bottom).offset(12)
                        make.horizontalEdges.equalToSuperview().inset(20)
                    }
                    
                    self.subjectSendDate.snp.remakeConstraints { make in
                        make.top.equalTo(self.password.snp.bottom).offset(40)
                        make.horizontalEdges.equalToSuperview().inset(20)
                    }
                } else {
                    self.subjectSendDate.snp.remakeConstraints { make in
                        make.top.equalTo(self.controlPrivate.snp.bottom).offset(40)
                        make.horizontalEdges.equalToSuperview().inset(20)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.selectedUser
            .drive(onNext: { user in
                if let user {
                    self.pickerUser.text = "\(user.name)(\(user.identifyCode))"
                }
            })
            .disposed(by: disposeBag)
        
        output.isCreateEnabled
            .drive() { isEnabled in
                self.createButton.disabled = !isEnabled
            }
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
        
        output.criticalAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showCriticalErrorAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 완료 알림창
    private func showSuccessAlert(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 오류 알림창
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 심각한 오류 알림창
    private func showCriticalErrorAlert(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}

#if DEBUG
struct RollCreateViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            CreateRollpeViewController()
        }
    }
}
#endif
