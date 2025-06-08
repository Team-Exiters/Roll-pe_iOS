//
//  HeartV1HostModalViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class HeartV1HostModalViewController: UIViewController {
    let paperId: Int
    let pCode: String
    let model: HeartModel
    
    init(paperId: Int, pCode: String, model: HeartModel) {
        self.paperId = paperId
        self.pCode = pCode
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = DeleteHeartViewModel()
    private let keychain = Keychain.shared
    
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
    
    // 신고 버튼
    private let reportLabel: UILabel = {
        let label = UILabel()
        label.text = "신고"
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeBlack
        
        return label
    }()
    
    // 삭제 버튼
    private let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "삭제"
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeStatusDanger
        
        return label
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
        setupReportLabel()
        setupDeleteLabel()
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
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().offset(-48)
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
    private func setupReportLabel() {
        memoView.addSubview(reportLabel)
        
        reportLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // 삭제 버튼
    private func setupDeleteLabel() {
        memoView.addSubview(deleteLabel)
        
        deleteLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        let output = viewModel.transform()
        
        // 닫기 버튼
        closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 신고 버튼
        reportLabel.rx.tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self,
                      let userCode = keychain.read(key: "IDENTIFY_CODE"),
                      let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfBv17bitAz4mSeiPg0hgXU9FktXujQCEIYe3_m1L-y8bIWyQ/viewform?usp=pp_url&entry.44205633=부적절한+마음&entry.2107714088=\(userCode)&entry.1553361014=\(pCode)&entry.1614951501=\(model.code)") else { return }
                
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        // 삭제 버튼
        deleteLabel.rx.tapGesture()
            .when(.recognized)
            .observe(on: MainScheduler.instance)
            .flatMap { _ in
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
                    self.showOKAlert(title: "알림", message: message) {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HEART_EDITED"), object: nil)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.criticalAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message) {
                        self.dismiss(animated: true) {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HEART_EDITED"), object: nil)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
