//
//  EndedRollpeHostViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/10/25.
//
import UIKit
import SwiftUI
import SnapKit
import RxSwift
import MarqueeLabel

class EndedRollpeHostViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let rollpeHostViewModel = RollpeHostViewModel()
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let navigationBar : NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.showSideMenu = false
        return navigationBar
    }()
    
    private let titleLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 8.0, fadeLength: 10.0)
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
        label.type = .continuous
        return label
    }()
    
    private let presentImage : UIImageView = {
        let image = UIImageView()
        image.image = .imgPreviewWhiteHorizontal
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let explainationLabel : UILabel = {
        let label = UILabel()
        label.text = "롤페를 눌러 마음을 전달하세요!"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        return label
    }()
    
    private let writerLabel : UILabel = {
        let label = UILabel()
        label.text = "작성자(0/13)"
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
    
    private var writers : [UserDataModel] = []
    
    private let writerListStack : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let buttonVStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let saveButton = PrimaryButton(title: "이미지로 저장하기")
    
    private let sendButton = SecondaryButton(title: "마음이 담긴 롤페 전달하기")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rollpePrimary
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        bindViewModel()
        rollpeHostViewModel.fetchRollpeData()
        addWritersToList()
        setupScrollView()
        setupContentView()
        setupNavigationBar()
        setupTitle()
        setupPresentImage()
        setupExplainationLabel()
        setupWriterLabel()
        setupWriterList()
        setupButtonView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        contentView.addSubview(navigationBar)
        navigationBar.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.top.equalTo(navigationBar.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupPresentImage() {
        contentView.addSubview(presentImage)
        presentImage.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel).offset(52)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupExplainationLabel(){
        contentView.addSubview(explainationLabel)
        explainationLabel.snp.makeConstraints{make in
            make.top.equalTo(presentImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupWriterLabel(){
        contentView.addSubview(writerLabel)
        writerLabel.snp.makeConstraints{make in
            make.top.equalTo(explainationLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupWriterList(){
        contentView.addSubview(writerListStack)
        writerListStack.snp.makeConstraints{make in
            make.top.equalTo(writerLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func setupButtonView(){
        contentView.addSubview(buttonVStackView)
        buttonVStackView.addArrangedSubview(saveButton)
        buttonVStackView.addArrangedSubview(sendButton)
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        buttonVStackView.snp.makeConstraints{make in
            make.top.equalTo(writerListStack.snp.bottom).offset(44)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
    
    
    //MARK: 기능함수들
    private func addWritersToList(){
        for item in writers{
            let label = UILabel()
            label.text = item.nickname
            if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
                label.font = customFont
            } else {
                label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            }
            label.textColor = .rollpeSecondary
            label.textAlignment = .left
            writerListStack.addArrangedSubview(label)
        }
    }
    
    private func bindViewModel() {
        rollpeHostViewModel.rollpeModel
            .observe(on: MainScheduler.instance) // UI작업은 메인 스레드에서
             .compactMap { $0 }                // nil이 아닌 값만 처리
             .subscribe(onNext: { [weak self] model in
                 guard let self = self else { return }
                 self.titleLabel.text = model.title
                 self.writerLabel.text = "작성자(\(model.writers.count)/13)"
                 self.writers = model.writers
             })
             .disposed(by: disposeBag)
    }
    
    @objc private func saveButtonTapped(){
        
    }
    
    @objc private func sendButtonTapped(){
        
    }

}

struct EndedRollpeHostViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            EndedRollpeHostViewController()
        }
    }
}

