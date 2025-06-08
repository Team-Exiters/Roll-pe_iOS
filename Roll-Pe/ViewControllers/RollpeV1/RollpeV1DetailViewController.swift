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
import Photos

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
    private let keychain = Keychain.shared
    
    // MARK: - 요소
    
    // 네비게이션 바
    private let navigationBar: NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.showSideMenu = false
        
        return navigationBar
    }()
    
    // 로딩 뷰
    private let loadingView: LoadingView = {
        let view = LoadingView()
        view.isHidden = true
        
        return view
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
        label.numberOfLines = 1
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
    
    // 공유하기
    private let shareButton = PrimaryButton(title: "공유하기")
    
    // 방장
    private let participantListButton: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.setTextWithLineHeight(text: "참여자 목록 >", lineHeight: 20)
        
        return label
    }()
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
        setupContentsView()
        setupTitle()
        
        addLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 롤페 데이터 불러오기
        viewModel.getRollpeData(pCode: pCode)
        
        // UI 설정
        resetButtonsView()
        
        // Bind
        bind()
    }
    
    // MARK: - UI 설정
    
    // 네비게이션 바
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
    
    // 컨텐츠 뷰
    private func setupContentsView() {
        // 하단 버튼 뷰
        view.addSubview(buttonsVStackView)
        
        buttonsVStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        // 스크롤 뷰
        view.addSubview(scrollView)
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(buttonsVStackView.snp.top).offset(-40)
        }
        
        // 내부 뷰
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
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // 미리보기와 설명
    private func setupRollpeViewAndExplainationLabel() {
        // 롤페 미리보기 뷰
        guard let rollpeView = rollpeView else { return }
        
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
        
        // 설명 라벨
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
            make.bottom.equalToSuperview() // 참여자 목록 기능 추가하면 바꿔야함
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
    }
    
    // 방장
    private func setupParticipantsButton() {
        contentView.addSubview(participantListButton)
        
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
        
        
        participantListButton.snp.makeConstraints { make in
            make.top.equalTo(writerListStack.snp.bottom).offset(40)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupHostButtonsView() {
        buttonsVStackView.addArrangedSubview(buttonsHStackView)
        buttonsHStackView.addArrangedSubview(shareButton)
        
        /*
        // 수정하기
        buttonsHStackView.addArrangedSubview(editSecondaryButton)
        
        editSecondaryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let modalVC = EditRollpeModalViewController()
                modalVC.modalPresentationStyle = .overFullScreen
                modalVC.modalTransitionStyle = .crossDissolve
                self?.present(modalVC, animated: true)
            })
            .disposed(by: disposeBag)
        */
    }
    
    // 방장 - 완료
    private func setupDoneButtonsView() {
        buttonsVStackView.addArrangedSubview(imageSaveButton)
        
        // 이미지 저장 버튼
        imageSaveButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.saveImage()
            })
            .disposed(by: disposeBag)
    }
    
    // 참석자
    private func setupParticipantButtonsView() {
        buttonsVStackView.addArrangedSubview(shareButton)
        buttonsVStackView.addArrangedSubview(buttonsHStackView)
        
        // 신고하기
        buttonsHStackView.addArrangedSubview(reportButton)
        
        reportButton.snp.makeConstraints { make in
            make.width.equalTo(reportButton.snp.height)
        }
        
        reportButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let userCode = keychain.read(key: "IDENTIFY_CODE"),
                      let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSfBv17bitAz4mSeiPg0hgXU9FktXujQCEIYe3_m1L-y8bIWyQ/viewform?usp=pp_url&entry.44205633=부적절한+롤페&entry.2107714088=\(userCode)&entry.1553361014=\(pCode)&entry.1614951501=해당+없음") else { return }
                
                UIApplication.shared.open(url)
            })
            .disposed(by: disposeBag)
        
        /*
        // 롤페 나가기 버튼
        buttonsHStackView.addArrangedSubview(quitButton)
        
        quitButton.rx.tap
            .subscribe(onNext: { [weak self] in
                
            })
            .disposed(by: disposeBag)
        */
    }
    
    // 공유하기 버튼 설정
    private func setupShareButton(host: RollpeUserModel) {
        shareButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let message: String = "\(host.name)님의 롤페를 마음을 작성해 완성해 보아요!\n\n\(WEBSITE_URL)/rollpe/\(self.pCode)"
                
                let activityItems: [String] = [message]
                
                let activityViewController = UIActivityViewController(
                    activityItems: activityItems,
                    applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                
                self.present(activityViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bind
    
    private func bind() {
        let output = viewModel.transform()
        
        // 롤페 데이터 상호작용
        output.rollpe
            .drive(onNext: { [weak self] model in
                guard let self = self,
                      let model = model else { return }
                
                let keychain = Keychain.shared
                guard let rawMyId = keychain.read(key: "USER_ID"),
                      let myId = Int(rawMyId) else { return }
                
                titleLabel.text = model.title
                
                writerLabel.text = "작성자(\(model.hearts.count)/\(model.maxHeartLength))"
                
                writerLabel.rx
                    .tapGesture()
                    .when(.recognized)
                    .subscribe(onNext: { _ in
                        print("dd")
                    })
                    .disposed(by: disposeBag)
                
                writerListStack.clear()
                
                model.hearts.data?.forEach { heart in
                    let label = UILabel()
                    label.numberOfLines = 1
                    label.textColor = .rollpeSecondary
                    label.text = "\(heart.author.name)(\(heart.author.identifyCode))"
                    if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) {
                        label.font = customFont
                    } else {
                        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
                    }
                    
                    self.writerListStack.addArrangedSubview(label)
                }
                
                if rollpeView?.superview != nil {
                    rollpeView?.removeFromSuperview()
                }
                
                // 롤페 뷰 설정
                switch (model.ratio, model.theme, model.size) {
                case ("가로", "화이트", "A4"):
                    rollpeView = WhiteHorizontalRollpeV1()
                case ("가로", "추모", "A4"):
                    rollpeView = MemorialHorizontalRollpeV1()
                case ("가로", "축하", "A4"):
                    rollpeView = CongratsHorizontalRollpeV1()
                case ("세로", "화이트", "A4"):
                    rollpeView = WhiteVerticalRollpeV1()
                case ("세로", "추모", "A4"):
                    rollpeView = MemorialVerticalRollpeV1()
                case ("세로", "축하", "A4"):
                    rollpeView = CongratsVerticalRollpeV1()
                default:
                    break
                }
                
                guard rollpeView != nil else { return }
                
                rollpeView!.model = model
                
                setupRollpeViewAndExplainationLabel()
                setupWriterLabel()
                setupWriterList()
                
                // rollpeView interaction 추가
                rollpeView!.isMemoInteractionEnabled = false
                
                // 버튼 설정
                if stringToDate(
                    string: "\(model.receive.receivingDate) \(ROLLPE_END_TIME)",
                    format: "yyyy-MM-dd a h시") > Date() {
                    (rollpeView! as UIView).rx
                        .tapGesture()
                        .when(.recognized)
                        .subscribe(onNext: { _ in
                            self.navigationController?.pushViewController(RollpeV1ViewController(pCode: self.pCode), animated: false)
                        })
                        .disposed(by: disposeBag)
                    
                    if model.host.id == myId { // 방장
                        // self.setupParticipantsButton()
                        setupHostButtonsView()
                    } else { // 참석자
                        setupParticipantButtonsView()
                    }
                } else { // 완료
                    (rollpeView! as UIView).rx
                        .tapGesture()
                        .when(.recognized)
                        .subscribe(onNext: { _ in
                            self.showOKAlert(title: "알림", message: "더 이상 마음을 작성할 수 없습니다.")
                        })
                        .disposed(by: disposeBag)
                    
                    if model.receive.receiver.id == myId {
                        setupDoneButtonsView()
                    } else {
                        switchViewController(vc: RollpeErrorViewController())
                    }
                }
                
                setupShareButton(host: model.host)
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        output.criticalAlertMessage
            .drive(onNext: { message in
                if message != nil {
                    switchViewController(vc: RollpeErrorViewController())
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 기능
    
    // 롤페 이미지 저장
    private func saveImage() {
        guard let rollpeView = rollpeView else { return }
        
        loadingView.isHidden = false
        
        let tempRollpeView: RollpeV1Types = rollpeView
        
        // 그림자 제거
        tempRollpeView.layer.shadowColor = nil
        tempRollpeView.layer.shadowOpacity = 0
        tempRollpeView.layer.shadowRadius = 0
        tempRollpeView.layer.shadowOffset = .zero
        
        // 크기 조정
        let scaleFactor: CGFloat = 1.0
        let scaledSize = CGSize(width: tempRollpeView.bounds.size.width * scaleFactor, height: tempRollpeView.bounds.size.height * scaleFactor)
        
        // 크기 반영
        let renderer = UIGraphicsImageRenderer(size: scaledSize, format: .init(for: tempRollpeView.traitCollection))
        
        let image = renderer.image { context in
            context.cgContext.scaleBy(x: scaleFactor, y: scaleFactor)
            tempRollpeView.layer.render(in: context.cgContext)
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 롤페 이미지 저장 handler
    @objc func imageSaved(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        loadingView.isHidden = true
        
        if let error = error {
            print("이미지 저장 실패: \(error.localizedDescription)")
            if checkNotHavaPhotoPermission() {
                showOKAlert(title: "오류", message: "사진 접근 권한이 없어 저장할 수 없습니다.")
            } else {
                showOKAlert(title: "오류", message: "롤페 이미지 저장 중 오류가 발생하였습니다.")
            }
        } else {
            showOKAlert(title: "알림", message: "롤페 이미지를 저장하였습니다.")
        }
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
