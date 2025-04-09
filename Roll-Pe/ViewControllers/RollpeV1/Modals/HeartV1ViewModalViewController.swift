//
//  HeartV1ViewModalViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class HeartV1ViewModalViewController: UIViewController {
    let model: HeartModel
    
    init(model: HeartModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    
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
    private func setupReportLabel() {
        memoView.addSubview(reportLabel)
        
        reportLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        // 닫기 버튼
        closeButton.rx.tap
            .subscribe(onNext: {
                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        // 신고 버튼
        reportLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
            })
            .disposed(by: disposeBag)
    }
}
