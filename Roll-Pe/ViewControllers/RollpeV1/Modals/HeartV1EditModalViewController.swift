//
//  HeartV1EditModalViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class HeartV1EditModalViewController: UIViewController {
    let paperId: Int
    let heartId: Int
    let context: String
    let index: Int
    let isMono: Bool
    
    init(paperId: Int, heartId: Int, context: String, index: Int, isMono: Bool) {
        self.paperId = paperId
        self.heartId = heartId
        self.context = context
        self.index = index
        self.isMono = isMono
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = EditHeartViewModel()
    
    // MARK: - 요소
    
    // 닫기 버튼
    private let closeButton: UIButton = {
        let button = UIButton()
        let icon = UIImage.iconX
        
        button.setImage(.iconX, for: .normal)
        button.setImage(.iconX, for: .highlighted)
        button.tintColor = .rollpeWhite
        
        return button
    }()
    
    // 완료 버튼
    private let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.titleLabel?.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        button.setTitleColor(.rollpeWhite, for: .normal)
        button.setTitleColor(.rollpeWhite, for: .highlighted)
        
        return button
    }()
    
    // 내부 뷰
    private let contentView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .center
        sv.spacing = 40
        
        return sv
    }()
    
    // 메모 뷰
    private lazy var memoView: UIView = {
        let view = UIView()
        view.backgroundColor = .rollpeGray
        
        return view
    }()
    
    // 메모 내 text view
    private lazy var textView: HeartTextView = {
        let tv = HeartTextView()
        tv.backgroundColor = .clear
        tv.font = UIFont(name: "NanumPenOTF", size: 48)
        tv.textColor = .rollpeBlack
        tv.textAlignment = .center
        tv.maxLength = 40
        tv.placeholder = "내용을 입력해주세요.\n(최대 40자)"
        tv.placeholderColor = .rollpeBlack
        tv.text = context
        
        return tv
    }()
    
    // 색상 목록 뷰
    private let colorsView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.spacing = 12
        
        return sv
    }()
    
    // 색상 뷰
    private func colorView(_ model: QueryIndexDataModel) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(hex: model.name)
        view.layer.cornerRadius = 20
        
        view.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        
        view.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { _ in
                self.memoView.backgroundColor = UIColor(hex: model.name)
                self.viewModel.selectedColor.accept(model)
            })
            .disposed(by: disposeBag)
        
        return view
    }
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.hideKeyboardWhenTappedAround()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // UI 설정
        setupContentView()
        setupMemoView()
        setupTextView()
        setupColorsView()
        addCloseButton()
        addDoneButton()
        
        // bind
        bind()
    }
    
    // MARK: - UI 설정
    
    // 닫기
    private func addCloseButton() {
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(20)
        }
    }
    
    // 완료
    private func addDoneButton() {
        view.addSubview(doneButton)
        
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // 내부 뷰
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.center.equalToSuperview()
        }
    }
    
    // 메모지
    private func setupMemoView() {
        contentView.addArrangedSubview(memoView)
        
        memoView.snp.makeConstraints { make in
            let width = UIScreen.main.bounds.width - 40
            
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(width)
            make.height.equalTo(width * 1.14285714)
        }
    }
    
    // text view
    private func setupTextView() {
        memoView.addSubview(textView)
        
        textView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.trailing.bottom.equalToSuperview().offset(-16)
        }
    }
    
    // 색상 선택 뷰
    private func setupColorsView() {
        contentView.addArrangedSubview(colorsView)
    }
    
    // 색상 뷰
    private func addColorView(model: QueryIndexDataModel) {
        let view = colorView(model)
        
        colorsView.addArrangedSubview(view)
    }
    
    // MARK: - Bind
    
    private func bind() {
        // 색상 불러오기
        viewModel.getColors(isMono: isMono)
        
        let output = viewModel.transform()
        
        // 색상 선택 뷰 설정
        output.colors
            .drive(onNext: { models in
                for model in models {
                    self.addColorView(model: model)
                }
            })
            .disposed(by: disposeBag)
        
        let isTextValid = textView.rx.text.orEmpty.map { !$0.isEmpty }
        let isColorValid = viewModel.selectedColor.map { $0?.name != nil }
        
        // 닫기 버튼
        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 완료 버튼
        doneButton.rx.tap
            .observe(on: MainScheduler.instance)
            .flatMap {
                self.showConfirmAlert(title: "알림", message: "마음을 수정하시겠습니까?")
            }
            .withLatestFrom(Observable.combineLatest(isTextValid, isColorValid, textView.rx.text.orEmpty))
            .subscribe(onNext: { [weak self] isTextValid, isColorValid, text in
                guard let self = self else { return }
                
                if !isTextValid {
                    viewModel.errorAlertMessage.onNext("내용을 입력하세요.")
                } else if !isColorValid {
                    viewModel.errorAlertMessage.onNext("색상을 선택하세요.")
                } else {
                    viewModel.editHeart(heartPK: heartId, paperFK: paperId, color: viewModel.selectedColor.value?.name, context: text, location: index)
                }
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
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HEART_EDITED"), object: nil)
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
            self.dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HEART_EDITED"), object: nil)
        }))
        self.present(alertController, animated: true, completion: nil)
    }
}
