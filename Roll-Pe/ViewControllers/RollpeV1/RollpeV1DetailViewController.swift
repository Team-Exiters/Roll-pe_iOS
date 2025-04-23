//
//  RollpeV1DetailViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/12/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MarqueeLabel
import SwiftUI

class RollpeV1DetailViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    // MARK: - 요소
    
    // 네비게이션 바
    private let navigationBar: NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.showSideMenu = false
        
        return navigationBar
    }()
    
    // 내부 스크롤 뷰
    private let scrollView = UIScrollView()
    
    // 내부 뷰
    private let contentView = UIView()
    
    // 미리보기
    private let presentImage: UIImageView = {
        let image = UIImageView()
        image.image = .imgPreviewWhiteHorizontal
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    // 제목
    private let titleLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 8.0, fadeLength: 10.0)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .rollpeSecondary
        label.type = .continuous
        label.text = "dd"
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
        
        return label
    }()
    
    // 롤페 미리보기 설명
    private let explainationLabel: UILabel = {
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
    
    // 작성자
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
    
    // 작성자 목록
    private let writerListStack : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    
    // 하단 버튼 stack view
    private let buttonsVStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 8
        sv.distribution = .fillEqually
        
        return sv
    }()
    
    private var buttonsHStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        
        return sv
    }()
    
    // 방장
    private let participantListButton: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.setTextWithLineHeight(text: "참여자 목록 >", lineHeight: 20)
        
        return label
    }()
    
    private let shareButton = PrimaryButton(title: "공유하기")
    private let editSecondaryButton = SecondaryButton(title: "수정하기")
    
    // 방장 - 완료
    private let sendHeartButton = SecondaryButton(title: "마음 전달하기")
    private let imageSaveButton = PrimaryButton(title: "이미지로 저장하기")
    
    // 참석자
    private let quitButton = SecondaryButton(title: "롤페 나가기")
    
    private let reportButton : SecondaryButton = {
        let button = SecondaryButton(title: "")
        button.setImage(.iconSiren.withRenderingMode(.alwaysOriginal), for: .normal)
        button.setTitle(nil, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .rollpePrimary
        
        // UI 설정
        setupNavigationBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // UI 설정
        resetButtonsView()
        
        setupHostButtonsView()
        
        setupScrollView()
        setupContentView()
        setupTitle()
        setupPresentImage()
        setupExplainationLabel()
        setupWriterLabel()
        setupWriterList()
        
        // 방장 전용
        setupParticipantsButton()
    }
    
    // MARK: - UI 설정
    
    // 네비게이션 바
    private func setupNavigationBar() {
        self.view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // 스크롤 뷰
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(88)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(buttonsVStackView.snp.top).offset(-40)
        }
    }
    
    // 스크롤 내부 뷰
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    // 제목
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    // 미리보기
    private func setupPresentImage() {
        contentView.addSubview(presentImage)
        
        presentImage.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel).offset(52)
            make.centerX.equalToSuperview()
        }
    }
    
    // 롤페 미리보기 설명
    private func setupExplainationLabel() {
        contentView.addSubview(explainationLabel)
        
        explainationLabel.snp.makeConstraints{make in
            make.top.equalTo(presentImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
    // 작성자 수
    private func setupWriterLabel() {
        contentView.addSubview(writerLabel)
        writerLabel.snp.makeConstraints{make in
            make.top.equalTo(explainationLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview()
        }
    }
    
    // 작성자 목록
    private func setupWriterList() {
        contentView.addSubview(writerListStack)
        writerListStack.snp.makeConstraints{make in
            make.top.equalTo(writerLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview()
        }
    }
    
    // 하단 버튼 뷰 초기화
    private func resetButtonsView() {
        shareButton.removeFromSuperview()
        editSecondaryButton.removeFromSuperview()
        sendHeartButton.removeFromSuperview()
        imageSaveButton.removeFromSuperview()
        quitButton.removeFromSuperview()
        reportButton.removeFromSuperview()
        buttonsHStackView.removeFromSuperview()
        buttonsVStackView.removeFromSuperview()
    }
    
    // 방장
    private func setupParticipantsButton() {
        contentView.addSubview(participantListButton)
        
        participantListButton.snp.makeConstraints { make in
            make.top.equalTo(writerListStack.snp.bottom).offset(40)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupHostButtonsView() {
        self.view.addSubview(buttonsVStackView)
        
        buttonsVStackView.addArrangedSubview(buttonsHStackView)
        
        buttonsHStackView.addArrangedSubview(shareButton)
        buttonsHStackView.addArrangedSubview(editSecondaryButton)
        
        buttonsVStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    // 방장 - 완료
    private func setupHostDoneButtonsView() {
        self.view.addSubview(buttonsVStackView)
        
        buttonsVStackView.addArrangedSubview(imageSaveButton)
        
        buttonsVStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    // 참석자
    private func setupParticipantButtonsView() {
        self.view.addSubview(buttonsVStackView)
        
        buttonsVStackView.addArrangedSubview(shareButton)
        buttonsVStackView.addArrangedSubview(buttonsHStackView)
        
        buttonsHStackView.addArrangedSubview(quitButton)
        buttonsHStackView.addArrangedSubview(reportButton)
        
        buttonsVStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        reportButton.snp.makeConstraints { make in
            make.width.equalTo(reportButton.snp.height)
        }
    }
}

struct RollpeV1DetailViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeV1DetailViewController()
        }
    }
}
