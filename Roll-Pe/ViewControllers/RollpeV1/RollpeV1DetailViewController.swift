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
import RxGesture
import MarqueeLabel

class RollpeV1DetailViewController: UIViewController {
    let pCode: String
    
    init(pCode: String) {
        self.pCode = pCode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = RollpeV1ViewModel()
    
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
    
    // 제목
    private let titleLabel: MarqueeLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 8.0, fadeLength: 10.0)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .rollpeSecondary
        label.type = .continuous
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
        
        return label
    }()
    
    // 롤페 미리보기
    private var rollpeView: RollpeV1Types?
    
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
        label.text = "작성자(0/0)"
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
        setupButtonsVStackView()
        setupScrollView()
        setupContentView()
        setupTitle()
        
        // bind
        bind()
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
    
    // 하단 버튼 뷰
    private func setupButtonsVStackView() {
        self.view.addSubview(buttonsVStackView)
        
        buttonsVStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
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
    private func setupRollpeViewAndExplainationLabel() {
        guard let rollpeView = rollpeView else { return }
        
        rollpeView.addAction(UIAction { _ in
            self.navigationController?.pushViewController(RollpeV1ViewController(pCode: self.pCode), animated: false)
        }, for: .touchUpInside)
        
        contentView.addSubview(rollpeView)
        
        let size = rollpeView.frame.size
        let ratio = ((UIScreen.main.bounds.width - 40) / size.width)
        rollpeView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
        
        rollpeView.snp.remakeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(((size.height * ratio - size.height) / 2) + 52)
            make.centerX.equalToSuperview()
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }
        
        addShadow(to: rollpeView)
        
        contentView.addSubview(explainationLabel)
        
        explainationLabel.snp.makeConstraints { make in
            make.top.equalTo(rollpeView.snp.bottom).offset(((size.height * ratio - size.height) / 2) + 16)
            make.centerX.equalToSuperview()
        }
    }
    
    // 작성자 수
    private func setupWriterLabel() {
        contentView.addSubview(writerLabel)
        writerLabel.snp.makeConstraints { make in
            make.top.equalTo(explainationLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview()
        }
    }
    
    // 작성자 목록
    private func setupWriterList() {
        contentView.addSubview(writerListStack)
        writerListStack.snp.makeConstraints { make in
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
        participantListButton.rx
            .tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                let modalVC = ParticipantListModalViewController()
                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.modalTransitionStyle = .crossDissolve
                self?.present(modalVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        contentView.addSubview(participantListButton)
        
        participantListButton.snp.makeConstraints { make in
            make.top.equalTo(writerListStack.snp.bottom).offset(40)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupHostButtonsView() {
        buttonsVStackView.addArrangedSubview(buttonsHStackView)
        
        // 공유하기
        shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
        
        buttonsHStackView.addArrangedSubview(shareButton)
        
        // 수정하기
        editSecondaryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let modalVC = EditRollpeModalViewController()
                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.modalTransitionStyle = .crossDissolve
                self?.present(modalVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        buttonsHStackView.addArrangedSubview(editSecondaryButton)
    }
    
    // 방장 - 완료
    private func setupDoneButtonsView() {
        buttonsVStackView.addArrangedSubview(imageSaveButton)
    }
    
    // 참석자
    private func setupParticipantButtonsView() {
        buttonsVStackView.addArrangedSubview(shareButton)
        buttonsVStackView.addArrangedSubview(buttonsHStackView)
        
        buttonsHStackView.addArrangedSubview(quitButton)
        buttonsHStackView.addArrangedSubview(reportButton)
        
        reportButton.snp.makeConstraints { make in
            make.width.equalTo(reportButton.snp.height)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        viewModel.getRollpeData(pCode: pCode)
        
        let output = viewModel.transform()
        
        // 롤페 데이터 상호작용
        output.rollpe
            .drive(onNext: { model in
                guard let model = model else { return }
                
                let keychain = Keychain.shared
                guard let rawMyId = keychain.read(key: "USER_ID"),
                      let myId = Int(rawMyId) else { return }
                
                let date = Date()
                
                if self.rollpeView?.superview != nil {
                    self.rollpeView?.removeFromSuperview()
                }
                
                // 롤페 뷰 설정
                switch (model.ratio, model.theme, model.size) {
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
                default:
                    break
                }
                
                guard let rollpeView = self.rollpeView else { return }
                
                self.setupRollpeViewAndExplainationLabel()
                self.setupWriterLabel()
                self.setupWriterList()
                
                // 버튼 설정
                if convertYYYYMMddToDate(model.receive.receivingDate) > date {
                    if model.host.id == myId { // 방장
                        self.setupParticipantsButton()
                        self.setupHostButtonsView()
                    } else { // 참석자
                        self.setupParticipantButtonsView()
                    }
                } else { // 완료
                    if model.host.id == myId || model.receive.receiver.id == myId {
                        self.setupDoneButtonsView()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.criticalAlertMessage
            .drive(onNext: { message in
                if message != nil {
                    guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
                        return
                    }
                    
                    let navVC = UINavigationController(rootViewController: ErrorHandlerViewController())
                    navVC.navigationBar.isHidden = true
                    navVC.hideKeyboardWhenTappedAround()
                    
                    sceneDelegate.window?.rootViewController = navVC
                    sceneDelegate.window?.makeKeyAndVisible()
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct RollpeV1DetailViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeV1DetailViewController(pCode: "")
        }
    }
}
#endif
