//
//  HeartV1MineModalViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class HeartV1MineModalViewController: UIViewController {
    let paperId: Int
    let model: HeartModel
    let isMono: Bool
    
    init(paperId: Int, model: HeartModel, isMono: Bool) {
        self.paperId = paperId
        self.model = model
        self.isMono = isMono
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = DeleteHeartViewModel()
    
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
    
    // 메모 뷰
    private lazy var memoView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: model.color)
        
        return view
    }()
    
    // 스크롤 뷰
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    // 메모 텍스트
    private lazy var memoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rollpeBlack
        label.font = UIFont(name: "NanumPenOTF", size: 48)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        label.text = "\(model.content)\n- \(model.author.name)"
        
        return label
    }()
    
    // 수정 버튼
    private let editButton: UIButton = {
        let button = UIButton()
        button.setTitle("수정", for: .normal)
        button.titleLabel?.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        button.setTitleColor(.rollpeBlack, for: .normal)
        button.setTitleColor(.rollpeBlack, for: .highlighted)
        
        return button
    }()
    
    // 삭제 버튼
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.titleLabel?.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        button.setTitleColor(.rollpeBlack, for: .normal)
        button.setTitleColor(.rollpeBlack, for: .highlighted)
        
        return button
    }()
    
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.hideKeyboardWhenTappedAround()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // UI 설정
        setupMemoView()
        setupScrollView()
        setupMemoLabel()
        setupEditButton()
        setupDeleteButton()
        addCloseButton()
        
        // bind
        bind()
    }
    
    // MARK: - UI 설정
    
    // 닫기 버튼
    private func addCloseButton() {
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(20)
        }
    }
    
    // 메모지
    private func setupMemoView() {
        view.addSubview(memoView)
        
        memoView.snp.makeConstraints { make in
            let width = UIScreen.main.bounds.width - 40
            
            make.width.equalTo(width)
            make.height.equalTo(width * 1.14285714)
            make.center.equalToSuperview()
        }
    }
    
    // 스크롤 뷰
    private func setupScrollView() {
        memoView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // 메모지 라벨
    private func setupMemoLabel() {
        scrollView.addSubview(memoLabel)
        
        memoLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
            make.width.equalToSuperview().inset(16)
        }
        
        DispatchQueue.main.async {
            let lineHeight = UIFont(name: "NanumPenOTF", size: 48)?.lineHeight ?? 52.8
            
            if self.memoLabel.frame.height + lineHeight <= self.scrollView.frame.height {
                self.memoLabel.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(16)
                    make.width.equalToSuperview().inset(16)
                    make.centerY.equalToSuperview()
                }
            }
        }
    }
    
    // 수정 버튼
    private func setupEditButton() {
        memoView.addSubview(editButton)
        
        editButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // 삭제 버튼
    private func setupDeleteButton() {
        memoView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        let output = viewModel.transform()
        
        // 닫기 버튼
        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 수정 버튼
        editButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                self.navigationController?.pushViewController(
                    HeartV1EditModalViewController(
                        paperId: paperId,
                        heartId: model.id,
                        context: model.content,
                        index: model.index,
                        isMono: isMono
                    ), animated: false)
            })
            .disposed(by: disposeBag)
        
        // 완료 버튼
        deleteButton.rx.tap
            .observe(on: MainScheduler.instance)
            .flatMap {
                self.showConfirmAlert(title: "알림", message: "마음을 삭제하시겠습니까?")
            }
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                
                viewModel.deleteHeart(hCode: model.code)
            })
            .disposed(by: disposeBag)
        
        output.successAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showSuccessAlert(message: message)
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
