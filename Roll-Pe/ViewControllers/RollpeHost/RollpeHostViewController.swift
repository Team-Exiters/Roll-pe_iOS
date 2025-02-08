//
//  RollpeHostViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/4/25.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift

class RollpeHostViewController: UIViewController {
    
    private let rollpeHostViewModel = RollpeHostViewModel()
    
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let navigationBar : NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.showSideMenu = false
        return navigationBar
    }()
    
    private let lockImage : UIImageView = {
        let image = UIImageView()
        image.image = .iconLock
        image.tintColor = .rollpeSecondary
        return image
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
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
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
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
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
        return label
    }()
    
    private let participantLabel : UILabel = {
        let label = UILabel()
        label.text = "참여자(0/100)"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
        return label
    }()
    
    private let buttonStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let shareButton = PrimaryButton(title: "공유하기")
    
    private let editButton = SecondaryButton(title: "수정하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rollpePrimary
        bindViewModel()                      //뷰 불러올때 뷰모델에서 불러올 값 이렇게 먼저 바인딩 시키고
        rollpeHostViewModel.fetchRollpeData() //그 다음에 이렇게 데이터 불러올것 (패턴이니까 그냥 외워서 사용할것)
        setupScrollView()
        setupContentView()
        setupNavigationBar()
        setupTitle()
        setupPresentImage()
        setupExplainationLabel()
        setupWriterLabel()
        setupParticipantLabel()
        setupButtonStackView()
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
        contentView.addSubview(lockImage)
        titleLabel.snp.makeConstraints{make in
            make.top.equalTo(navigationBar.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
        lockImage.snp.makeConstraints{make in
            make.trailing.equalTo(titleLabel.snp.leading).offset(-12)
            make.centerY.equalTo(titleLabel)
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
    
    private func setupParticipantLabel(){
        contentView.addSubview(participantLabel)
        participantLabel.snp.makeConstraints{make in
            make.top.equalTo(writerLabel.snp.bottom).offset(120)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupButtonStackView(){
        contentView.addSubview(buttonStackView)
        buttonStackView.addArrangedSubview(shareButton)
        buttonStackView.addArrangedSubview(editButton)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        buttonStackView.snp.makeConstraints{make in
            make.top.equalTo(participantLabel.snp.bottom).offset(180)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview()
        }
    }
    
    //뷰모델의 rollpeModel값 바인딩시키는 함수임
    private func bindViewModel() {
        rollpeHostViewModel.rollpeHostModel
            .observe(on: MainScheduler.instance) // UI 작업은 메인 스레드에서
             .compactMap { $0 }                // nil이 아닌 값만 처리
             .subscribe(onNext: { [weak self] model in //뷰컨트롤러 꺼져도 메모리에 데이터 남아있어도 되는구조인지 몰라서 일단 안전하게 약한참조 시킴
                 guard let self = self else { return }
                 self.titleLabel.text = "\(model.host)님의 롤페"
                 self.writerLabel.text = "작성자(\(model.writers.count)/13)"
                 self.participantLabel.text = "참여자(\(model.participants.count)/100)"
             })
             .disposed(by: disposeBag)
    }
    
    @objc private func shareButtonTapped() {
        let urlToShare = URL(string: "여기에 공유 url추가하면 됩니둥")!
        let items: [Any] = [urlToShare]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = shareButton
        }
        present(activityVC, animated: true)
    }
    
    @objc private func editButtonTapped() {
        print("수정")
        let rollpeEditVC = RollpeEditViewController(rollpeHostViewModel: rollpeHostViewModel)
        navigationController?.pushViewController(rollpeEditVC, animated: true)
    }
}


struct RollpeHostViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeHostViewController()
        }
    }
}
