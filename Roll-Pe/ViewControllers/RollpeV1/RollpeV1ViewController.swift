//
//  RollpeV1ViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

let monoThemes: [String] = ["추모"]

class RollpeV1ViewController: UIViewController {
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
    
    // 닫기 버튼
    private let closeButton : UIButton = {
        let button = UIButton()
        let icon = UIImage.iconX
        
        button.setImage(.iconX, for: .normal)
        button.setImage(.iconX, for: .highlighted)
        button.tintColor = .rollpeSecondary
        
        return button
    }()
    
    // 롤페 뷰
    private var rollpeView: RollpeV1Types?
    
    // 변형 관련
    private var scale: CGFloat = 1.0
    private var lastTranslation: CGPoint = .zero
    
    private let maxRotation: CGFloat = .pi / 2
    private let minRotation: CGFloat = -.pi / 2
    private var rotation: CGFloat = 0.0
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        view.backgroundColor = .rollpePrimary
        
        // 홈에서 앱으로 복귀 시 롤페 뷰 초기화
        NotificationCenter.default.rx.notification(UIApplication.didBecomeActiveNotification)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.getData()
            })
            .disposed(by: disposeBag)
        
        // 마음이 변경되었을 경우 롤페 뷰 초기화
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: "HEART_EDITED"))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                self.getData()
            })
            .disposed(by: disposeBag)
        
        // UI 설정
        addCloseButton()
        
        // bind
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI 설정
    
    // 닫기 뷰 추가
    private func addCloseButton() {
        view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(20)
        }
        
        closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 뷰 설정
    private func setupRollpeView(model: RollpeV1DataModel) {
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
        
        guard let rollpeView = rollpeView else { return }
        
        rollpeView.model = model
        
        // 롤페 뷰 디바이스 너비와 높이에 따라 비율 조정
        let size = rollpeView.frame.size
        let ratio = UIScreen.main.bounds.height / size.height
        
        view.addSubview(rollpeView)
        
        rollpeView.transform = CGAffineTransform(scaleX: ratio, y: ratio)
        
        rollpeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .offset((size.height * ratio - size.height) / 2)
            make.leading.equalToSuperview()
                .offset((size.width * ratio - size.width) / 2)
        }
        
        addShadow(to: rollpeView)
    }
    
    // 롤페 뷰 초기화
    private func resetRollpeView() {
        if rollpeView?.superview != nil {
            rollpeView?.removeFromSuperview()
        }
        
        scale = 1.0
        lastTranslation = .zero
        rotation = 0.0
    }
    
    // MARK: - Bind
    
    private func getData() {
        viewModel.getRollpeData(pCode: pCode)
    }
    
    private func bindData() {
        closeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.transform()
        
        // 롤페 데이터 상호작용
        output.rollpe
            .drive(onNext: { model in
                guard let model = model else { return }
                
                self.resetRollpeView()
                self.setupRollpeView(model: model)
                self.bindMemoTap(dataModel: model)
                self.bindGestures()
                
                self.addCloseButton()
            })
            .disposed(by: disposeBag)
        
        output.criticalAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 뷰 제스쳐 설정
    private func bindGestures() {
        guard let rollpeView = rollpeView else { return }
        
        (rollpeView as UIView).rx.pinchGesture()
            .when(.changed)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { gesture in
                guard let view = gesture.view else { return }
                
                self.scale *= gesture.scale
                view.transform = CGAffineTransform(scaleX: self.scale, y: self.scale)
                
                gesture.scale = 1.0
            })
            .disposed(by: disposeBag)
        
        (rollpeView as UIView).rx.panGesture()
            .when(.began)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { gesture in
                guard let view = gesture.view else { return }
                
                self.lastTranslation = view.center
            })
            .disposed(by: disposeBag)
        
        (rollpeView as UIView).rx.panGesture()
            .when(.changed)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { gesture in
                guard let view = gesture.view else { return }
                
                let translation = gesture.translation(in: self.view)
                let center = CGPoint(x: self.lastTranslation.x + translation.x, y: self.lastTranslation.y + translation.y)
                view.center = center
            })
            .disposed(by: disposeBag)
        
        (rollpeView as UIView).rx.panGesture()
            .when(.ended)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { gesture in
                guard let view = gesture.view else { return }
                
                self.lastTranslation = view.center
            })
            .disposed(by: disposeBag)
        
        (rollpeView as UIView).rx.rotationGesture()
            .when(.changed)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { gesture in
                guard let view = gesture.view else { return }
                
                self.rotation += gesture.rotation
                
                self.rotation = min(max(self.rotation, self.minRotation), self.maxRotation)
                
                let transform = CGAffineTransform.identity
                    .scaledBy(x: self.scale, y: self.scale)
                    .rotated(by: self.rotation)
                
                view.transform = transform
                
                gesture.rotation = 0
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 메모 상호작용 설정
    private func bindMemoTap(dataModel: RollpeV1DataModel) {
        guard let rollpeView = rollpeView else { return }
        
        let isMono: Bool = monoThemes.contains(dataModel.theme)
        
        rollpeView.onMemoSelected = { (index, model) in
            guard self.presentedViewController == nil else { return }
            
            var navVC: UINavigationController
            
            if model != nil {
                // 내 마음
                if model!.author.id == Int(self.keychain.read(key: "USER_ID") ?? "-1") {
                    navVC = UINavigationController(rootViewController: HeartV1MineModalViewController(
                        paperId: dataModel.id,
                        model: model!,
                        isMono: isMono))
                } else if dataModel.host.id == Int(self.keychain.read(key: "USER_ID") ?? "-1") { // 방장
                    navVC = UINavigationController(rootViewController: HeartV1HostModalViewController(
                        paperId: dataModel.id,
                        pCode: self.pCode,
                        model: model!))
                } else { // 타인의 마음
                    navVC = UINavigationController(rootViewController: HeartV1ViewModalViewController(pCode: self.pCode, model: model!))
                }
            } else {
                // 빈 마음
                navVC = UINavigationController(rootViewController: HeartV1WriteModalViewController(
                    paperId: dataModel.id,
                    index: index,
                    isMono: isMono))
            }
            
            navVC.modalPresentationStyle = .overFullScreen
            navVC.modalTransitionStyle = .crossDissolve
            navVC.navigationBar.isHidden = true
            
            self.present(navVC, animated: false, completion: nil)
        }
    }
}

// rollpeView 타입 관련
protocol RollpeV1Types: UIControl {
    var onMemoSelected: ((Int, HeartModel?) -> Void)? { get set }
    var model: RollpeV1DataModel? { get set }
    var isMemoInteractionEnabled: Bool { get set }
}

extension WhiteHorizontalRollpeV1: RollpeV1Types {}
extension WhiteVerticalRollpeV1: RollpeV1Types {}
extension MemorialHorizontalRollpeV1: RollpeV1Types {}
extension MemorialVerticalRollpeV1: RollpeV1Types {}
extension CongratsHorizontalRollpeV1: RollpeV1Types {}
extension CongratsVerticalRollpeV1: RollpeV1Types {}

#if DEBUG
import SwiftUI

struct RollpeV1ViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeV1ViewController(pCode: "")
        }
    }
}
#endif
