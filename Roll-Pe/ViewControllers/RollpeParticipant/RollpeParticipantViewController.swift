//
//  RollpeParticipantViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/9/25.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import MarqueeLabel

class RollpeParticipantViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let rollpeParticipantViewModel = RollpeParticipantViewModel()
    
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
    
    private var buttonHStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let buttonVStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let shareButton = PrimaryButton(title: "공유하기")
    private let quitButton = SecondaryButton(title: "롤페 나가기")
    private var reportButton : SecondaryButton = {
        let button = SecondaryButton(title: "")
        if let image = UIImage(named: "icon_siren")?.withRenderingMode(.alwaysOriginal) {
              button.setImage(image, for: .normal)
          }
        button.setTitle(nil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rollpePrimary
        bindViewModel()
        rollpeParticipantViewModel.fetchRollpeData()
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
            buttonVStackView.addArrangedSubview(shareButton)
            buttonVStackView.addArrangedSubview(buttonHStackView)
            buttonHStackView.addArrangedSubview(quitButton)
            buttonHStackView.addArrangedSubview(reportButton)
            
            shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
            quitButton.addTarget(self, action: #selector(quitRollpeButtonTapped), for: .touchUpInside)
            reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        
        buttonVStackView.snp.makeConstraints{make in
            make.top.equalTo(writerListStack.snp.bottom).offset(44)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-40)
        }
        reportButton.snp.makeConstraints{make in
            make.width.height.equalTo(52)
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
        rollpeParticipantViewModel.rollpeModel
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
    
    @objc private func shareButtonTapped(){
        let urlToShare = "https://youtube.com/shorts/U-klwYEpc8k?si=eNVWZ8l5y5dZboPx"
        let items: [Any] = [urlToShare]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = shareButton
        }
        present(activityVC, animated: true)
    }
    @objc private func quitRollpeButtonTapped(){
        
    }
    @objc private func reportButtonTapped(){
        guard let url = URL(string: "https://forms.gle/yourGoogleFormURL") else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}


struct RollpeParticipantViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeParticipantViewController()
        }
    }
}
