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
import RxGesture

class CreateRollpeViewController: UIViewController {
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel = CreateRollpeViewModel()
    
    // MARK: - 샘플 Model
    
    private lazy var sampleRollpeV1Model = RollpeV1DataModel(
        id: -1,
        code: "",
        title: "제목을 입력하세요.",
        host: RollpeUserModel(
            id: -1,
            identifyCode: "",
            name: ""
        ),
        receive: RollpeReceiveDataModel(
            receiver: RollpeUserModel(
                id: -1,
                identifyCode: "",
                name: ""
            ),
            receivingDate: "",
            receivingStat: -1
        ),
        viewStat: true,
        theme: "",
        size: "",
        ratio: "",
        maxHeartLength: -1,
        hearts: HeartResponseModel(
            count: -1,
            data: [
                HeartModel(
                    id: -1,
                    code: "",
                    index: 0,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트1"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F228D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 1,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트2"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F2EB28",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 2,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트3"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F2EB28",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 3,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트4"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#28E8F2",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 4,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트5"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F2EB28",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 5,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트6"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#28E8F2",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 6,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트7"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F228D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 7,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트8"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F2EB28",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 8,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트9"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#28E8F2",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 9,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트10"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F228D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 10,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트11"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#F228D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 11,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트12"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#28E8F2",
                    version: ""
                )
            ]
        ),
        invitingUser: [],
        createdAt: ""
    )
    
    private lazy var sampleRollpeV1MonoModel = RollpeV1DataModel(
        id: -1,
        code: "",
        title: "제목을 입력하세요.",
        host: RollpeUserModel(
            id: -1,
            identifyCode: "",
            name: ""
        ),
        receive: RollpeReceiveDataModel(
            receiver: RollpeUserModel(
                id: -1,
                identifyCode: "",
                name: ""
            ),
            receivingDate: "",
            receivingStat: -1
        ),
        viewStat: true,
        theme: "",
        size: "",
        ratio: "",
        maxHeartLength: -1,
        hearts: HeartResponseModel(
            count: -1,
            data: [
                HeartModel(
                    id: -1,
                    code: "",
                    index: 0,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트1"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 1,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트2"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#D3D3D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 2,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트3"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 3,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트4"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 4,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트5"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 5,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트6"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 6,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트7"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#D3D3D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 7,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트8"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 8,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트9"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#D3D3D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 9,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트10"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 10,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트11"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#D3D3D3",
                    version: ""
                ),
                HeartModel(
                    id: -1,
                    code: "",
                    index: 11,
                    author: RollpeUserModel(
                        id: -1,
                        identifyCode: "",
                        name: "테스트12"
                    ),
                    content: "가나다라마바사",
                    createdAt: "",
                    color: "#999999",
                    version: ""
                )
            ]
        ),
        invitingUser: [],
        createdAt: ""
    )
    
    // MARK: - 요소
    
    // 비율, 테마, 크기 목록
    private var ratioBlocks: [RollpeRatioBlock] = []
    private var themeBlocks: [RollpeThemeBlock] = []
    private var sizeBlocks: [RollpeSizeBlock] = []
    
    // 내부 뷰
    private let contentView: UIView = UIView()
    
    // 뷰 제목
    private let viewTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32)
        label.textColor = .rollpeSecondary
        label.text = "롤페 만들기"
        
        return label
    }()
    
    // 롤페 제목
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
    
    private let controlPrivate = {
        let sc = SegmentControl(items: ["공개", "비공개"])
        sc.control.selectedSegmentIndex = 1
        
        return sc
    }()
    
    private let password = {
        let tf = RoundedBorderTextField()
        tf.placeholder = "비밀번호"
        
        return tf
    }()
    
    private lazy var titleSendDate: UILabel = {
        let label = titleLabel()
        label.text = "전달일을 지정해주세요"
        
        return label
    }()
    
    private let textFieldSendDate = RoundedBorderTextFieldPicker()
    
    private let pickerUser = RoundedBorderTextField()
    
    private lazy var descPreview = descLabel()
    
    private var rollpeView: RollpeV1Types?
    
    private let createButton = PrimaryButton(title: "만들기")
    
    // 컴포넌트
    // 주제 텍스트
    private func titleLabel() -> UILabel {
        let label: UILabel = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        
        return label
    }
    
    // 설명 텍스트
    private func descLabel() -> UILabel {
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
        setupPreviewAndCreateButton()
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
    
    // 뷰 제목
    private func setupPageTitle() {
        contentView.addSubview(viewTitle)
        
        viewTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(88)
            make.centerX.equalToSuperview()
        }
    }
    
    // 롤페 제목 입력
    private func setupTitle() {
        let titleRollpeTitle: UILabel = titleLabel()
        titleRollpeTitle.text = "제목을 입력하세요"
        
        contentView.addSubview(titleRollpeTitle)
        
        titleRollpeTitle.snp.makeConstraints { make in
            make.top.equalTo(viewTitle.snp.bottom).offset(52)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(textFieldTitle)
        
        textFieldTitle.snp.makeConstraints { make in
            make.top.equalTo(titleRollpeTitle.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // 비율 선택
    private func setupRatio() {
        let titleRatios: UILabel = titleLabel()
        titleRatios.text = "비율을 선택하세요"
        
        contentView.addSubview(titleRatios)
        
        titleRatios.snp.makeConstraints { make in
            make.top.equalTo(textFieldTitle.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(scrollRatios)
        
        scrollRatios.snp.makeConstraints { make in
            make.top.equalTo(titleRatios.snp.bottom).offset(20)
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
        let titleThemes: UILabel = titleLabel()
        titleThemes.text = "테마를 선택하세요"
        
        contentView.addSubview(titleThemes)
        
        titleThemes.snp.makeConstraints { make in
            make.top.equalTo(scrollRatios.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(scrollThemes)
        
        scrollThemes.snp.makeConstraints { make in
            make.top.equalTo(titleThemes.snp.bottom).offset(20)
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
        let titleSizes: UILabel = titleLabel()
        titleSizes.text = "크기를 선택하세요"
        
        contentView.addSubview(titleSizes)
        
        titleSizes.snp.makeConstraints { make in
            make.top.equalTo(scrollThemes.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(scrollSizes)
        
        scrollSizes.snp.makeConstraints { make in
            make.top.equalTo(titleSizes.snp.bottom).offset(20)
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
        let titlePrivate: UILabel = titleLabel()
        titlePrivate.text = "공개 설정 여부"
        
        contentView.addSubview(titlePrivate)
        
        titlePrivate.snp.makeConstraints { make in
            make.top.equalTo(scrollSizes.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        let descPrivate = descLabel()
        descPrivate.text = "링크를 가진 모든 분들이 볼 수 있어요."
        
        contentView.addSubview(descPrivate)
        
        descPrivate.snp.makeConstraints { make in
            make.top.equalTo(titlePrivate.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        // 공개 설정
        contentView.addSubview(controlPrivate)
        
        controlPrivate.snp.makeConstraints { make in
            make.top.equalTo(descPrivate.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 비밀번호
        contentView.addSubview(password)
    }
    
    // 전달일 지정
    private func setupSendDate() {
        contentView.addSubview(titleSendDate)
        
        // 전달일 선택
        textFieldSendDate.text = "\(dateToString(date: datePicker.minimumDate!, format: "yyyy년 M월 d일")) 오전 10시"
        textFieldSendDate.inputView = datePicker
        
        contentView.addSubview(textFieldSendDate)
        
        textFieldSendDate.snp.makeConstraints { make in
            make.top.equalTo(titleSendDate.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        datePicker.rx.date
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { date in
                self.textFieldSendDate.text = "\(dateToString(date: date, format: "yyyy년 M월 d일")) 오전 10시"
            })
            .disposed(by: disposeBag)
    }
    
    // 전달할 사람 지정
    private func setupUser() {
        let titleUser: UILabel = titleLabel()
        titleUser.text = "전달할 사람을 지정해주세요"
        
        contentView.addSubview(titleUser)
        
        titleUser.snp.makeConstraints { make in
            make.top.equalTo(textFieldSendDate.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(pickerUser)
        
        pickerUser.snp.makeConstraints { make in
            make.top.equalTo(titleUser.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        pickerUser.rx
            .tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
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
    
    // 미리보기, 만들기 커튼
    private func setupPreviewAndCreateButton() {
        // 미리보기 제목
        let titlePreview: UILabel = titleLabel()
        titlePreview.text = "미리보기"
        
        contentView.addSubview(titlePreview)
        
        titlePreview.snp.makeConstraints { make in
            make.top.equalTo(pickerUser.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        // 미리보기 설명
        contentView.addSubview(descPreview)
        
        descPreview.snp.makeConstraints { make in
            make.top.equalTo(titlePreview.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(createButton)
        
        if let rollpeView = rollpeView {
            // 롤페 미리보기
            rollpeView.isUserInteractionEnabled = false
            view.addSubview(rollpeView)
            
            let size = rollpeView.frame.size
            let ratio = ((UIScreen.main.bounds.width - 40) / size.width)
            rollpeView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            
            rollpeView.snp.remakeConstraints { make in
                make.top.equalTo(self.descPreview.snp.bottom).offset(((size.height * ratio - size.height) / 2) + 20)
                make.centerX.equalToSuperview()
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
            
            addShadow(to: rollpeView)
            
            // 버튼 설정
            createButton.snp.remakeConstraints { make in
                make.top.equalTo(rollpeView.snp.bottom).offset(((size.height * ratio - size.height) / 2) + 52)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.bottom.equalToSuperview()
            }
        } else {
            // 버튼 설정
            createButton.snp.remakeConstraints { make in
                make.top.equalTo(descPreview.snp.bottom).offset(52)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.bottom.equalToSuperview()
            }
        }
        
        view.bringSubviewToFront(loadingView)
    }
    
    // MARK: - Bind
    
    private func bind() {
        // 비율, 테마 크기 목록 불러오기
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
                        .observe(on: MainScheduler.instance)
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
        
        // 선택한 비윯
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
                        .observe(on: MainScheduler.instance)
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
        
        // 선택한 테마
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
                        .observe(on: MainScheduler.instance)
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
        
        // 선택한 크기
        output.selectedSize
            .drive(onNext: { [weak self] model in
                guard let self = self,
                let model = model else { return }
                
                self.sizeBlocks.forEach { block in
                    block.isSelected = (model == block.model)
                }
                
                descPreview.text = "최대 \(model.query.max!)명까지 작성할 수 있어요."
            })
            .disposed(by: disposeBag)
        
        // 비밀번호 입력 표시 여부
        output.isPasswordVisible
            .drive(onNext: { [weak self] visible in
                guard let self = self else { return }
                
                self.password.isHidden = !visible
                
                if visible {
                    self.password.snp.remakeConstraints { make in
                        make.top.equalTo(self.controlPrivate.snp.bottom).offset(12)
                        make.horizontalEdges.equalToSuperview().inset(20)
                    }
                    
                    self.titleSendDate.snp.remakeConstraints { make in
                        make.top.equalTo(self.password.snp.bottom).offset(40)
                        make.horizontalEdges.equalToSuperview().inset(20)
                    }
                } else {
                    self.titleSendDate.snp.remakeConstraints { make in
                        make.top.equalTo(self.controlPrivate.snp.bottom).offset(40)
                        make.horizontalEdges.equalToSuperview().inset(20)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        // 선택한 유저
        output.selectedUser
            .drive(onNext: { user in
                if let user {
                    self.pickerUser.text = "\(user.name)(\(user.identifyCode))"
                }
            })
            .disposed(by: disposeBag)
        
        // 만들기 버튼 활성화 여부
        output.isCreateEnabled
            .drive(onNext: { isEnabled in
                self.createButton.disabled = !isEnabled
            })
            .disposed(by: disposeBag)
        
        // 로딩 창 표시 여부
        output.isLoading
            .drive(onNext: { isLoading in
                self.loadingView.isHidden = !isLoading
            })
            .disposed(by: disposeBag)
        
        // 성공 메시지 handle
        output.successAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showAlertAndPop(title: "알림", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        // 오류 메시지 handle
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        // 심각한 오류 메시지 handle
        output.criticalAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showAlertAndPop(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        // 롤페 미리보기
        Driver.combineLatest(output.selectedRatio, output.selectedTheme, output.selectedSize)
            .drive(onNext: { ratio, theme, size in
                guard let ratio = ratio,
                      let theme = theme,
                      let size = size else { return }
                
                if self.rollpeView?.superview != nil {
                    self.rollpeView?.removeFromSuperview()
                }
                
                switch (ratio.name, theme.name, size.name) {
                case ("가로", "화이트", "A4"):
                    self.rollpeView = WhiteHorizontalRollpeV1()
                case ("가로", "추모", "A4"):
                    self.rollpeView = MemorialHorizontalRollpeV1()
                case ("가로", "축하", "A4"):
                    self.rollpeView = CongratsHorizontalRollpeV1()
                case ("세로", "화이트", "A4"):
                    self.rollpeView = WhiteVerticalRollpeV1()
                case ("세로", "추모", "A4"):
                    self.rollpeView = MemorialVerticalRollpeV1()
                case ("세로", "축하", "A4"):
                    self.rollpeView = CongratsVerticalRollpeV1()
                default: break
                }
                
                self.setupPreviewAndCreateButton()
                
                guard let rollpeView = self.rollpeView else { return }
                
                if ["추모"].contains(theme.name) {
                    rollpeView.model = self.sampleRollpeV1MonoModel
                } else {
                    rollpeView.model = self.sampleRollpeV1Model
                }
            })
            .disposed(by: disposeBag)
        
        // 롤페 미리보기 제목 처리
        Driver.combineLatest(
            output.selectedTheme, textFieldTitle.rx.text.orEmpty.asDriver().distinctUntilChanged())
            .drive(onNext: { theme, text in
                guard let theme = theme,
                      let rollpeView = self.rollpeView else { return }
                
                self.sampleRollpeV1Model.title = text.isEmpty ? "제목을 입력하세요." : text
                self.sampleRollpeV1MonoModel.title = text.isEmpty ? "제목을 입력하세요." : text
                
                if ["추모"].contains(theme.name) {
                    rollpeView.model = self.sampleRollpeV1MonoModel
                } else {
                    rollpeView.model = self.sampleRollpeV1Model
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct RollCreateViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            CreateRollpeViewController()
        }
    }
}
#endif
