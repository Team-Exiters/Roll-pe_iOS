//
//  MainAfterSignInViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainAfterSignInViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let keychain = Keychain.shared
    
    private let mainViewModel = MainAfterSignInViewModel()
    private let userViewModel = UserViewModel()
    private let rollpeV1ViewModel = RollpeV1ViewModel()
    
    // MARK: - 요소
    
    private let contentView = UIView()
    
    private let hotContentView = UIView()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24) {
            label.font = customFont
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 24)
        }
        return label
    }()
    
    private let rollpeCountLabel: CountLabel = CountLabel(type: .rollpe)
    
    private let heartCountLabel: CountLabel = CountLabel(type: .heart)
    
    private let primaryButton = PrimaryButton(title: "초대받은 롤페")
    
    private let secondaryButton = SecondaryButton(title: "롤페 만들기")
    
    private let hotLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 뜨고있는 롤페"
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 24)
            print("커스텀 폰트를 로드하지 못했습니다.")
        }
        
        return label
    }()
    
    private let rollpeCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // UI 설정
        setUI()
        
        // Bind
        bindRollpeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rollpeCollectionView.dataSource = nil
        
        userViewModel.getMyStatus()
        
        // bind
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rollpeV1ViewModel.isPushed = false
    }
    
    // MARK: - UI 구성
    
    private func setUI() {
        view.backgroundColor = .rollpePrimary
        
        setupContentView()
        setupNickNameLabel()
        setupRollpesLabel()
        setupHeartsLabel()
        setupPrimaryButton()
        setupSecondaryButton()
        setupHotContentView()
        setupHotLabel()
        setupRollpeItems()
        setupFooter()
        addSideMenuButton()
    }
    
    // 사이드 메뉴
    private func addSideMenuButton() {
        // 사이드 메뉴
        let sideMenuView = SidemenuView(highlight: "홈")
        let buttonSideMenu: UIButton = ButtonSideMenu()
        
        view.addSubview(buttonSideMenu)
        
        buttonSideMenu.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        buttonSideMenu.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.view.addSubview(sideMenuView)
                sideMenuView.showMenu()
            })
            .disposed(by: disposeBag)
    }
    
    // 내부 뷰
    private func setupContentView() {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(-safeareaBottom)
            make.width.equalToSuperview()
        }
    }
    
    // 닉네임
    private func setupNickNameLabel() {
        let nickname = self.keychain.read(key: "NAME")
        nickNameLabel.text = "\(nickname ?? "")님은"
        
        contentView.addSubview(nickNameLabel)
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // 내가 만든 롤페 횟수
    private func setupRollpesLabel(){
        contentView.addSubview(rollpeCountLabel)
        
        rollpeCountLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // 내가 작성한 롤페 횟수
    private func setupHeartsLabel(){
        contentView.addSubview(heartCountLabel)
        
        heartCountLabel.snp.makeConstraints { make in
            make.top.equalTo(rollpeCountLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // 초대받는 롤페 버튼
    private func setupPrimaryButton(){
        contentView.addSubview(primaryButton)
        
        primaryButton.snp.makeConstraints { make in
            make.top.equalTo(heartCountLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        primaryButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.pushViewController(InvitedRollpeViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 만들기 버튼
    private func setupSecondaryButton(){
        contentView.addSubview(secondaryButton)
        
        secondaryButton.snp.makeConstraints { make in
            make.top.equalTo(primaryButton.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        secondaryButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.pushViewController(CreateRollpeViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 지금 뜨고있는 롤페 구역
    private func setupHotContentView(){
        contentView.addSubview(hotContentView)
        hotContentView.backgroundColor = .rollpeSectionBackground
        
        hotContentView.snp.makeConstraints { make in
            make.top.equalTo(secondaryButton.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview()
            make.height.greaterThanOrEqualTo(UIScreen.main.bounds.height - (safeareaTop + 292))
        }
    }
    
    // 지금 뜨고있는 롤페 라벨
    private func setupHotLabel() {
        hotContentView.addSubview(hotLabel)
        
        hotLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // 지금 뜨고있는 롤페
    private func setupRollpeItems() {
        rollpeCollectionView.backgroundColor = .clear
        rollpeCollectionView.delegate = self
        
        rollpeCollectionView.register(MainAfterSignInGridCell.self, forCellWithReuseIdentifier: "GridCell")
        
        hotContentView.addSubview(rollpeCollectionView)
        
        rollpeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(hotLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(44).priority(.low)
            make.height.equalTo(0)
        }
    }
    
    // 푸터
    private func setupFooter(){
        let footer = Footer()
        contentView.addSubview(footer)
        
        footer.snp.makeConstraints{make in
            make.top.equalTo(hotContentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        // 내 상태
        userViewModel.myStatus
            .map { model in
                return model?.data.host ?? 0
            }
            .bind(to: rollpeCountLabel.rx.count)
            .disposed(by: disposeBag)
        
        userViewModel.myStatus
            .map { model in
                return model?.data.heart ?? 0
            }
            .bind(to: heartCountLabel.rx.count)
            .disposed(by: disposeBag)
        
        // 지금 뜨는 롤페
        mainViewModel.hotRollpeList
            .bind(to: rollpeCollectionView.rx.items(cellIdentifier: "GridCell", cellType: MainAfterSignInGridCell.self)) { index, model, cell in
                cell.configure(model: model)
            }
            .disposed(by: disposeBag)
        
        rollpeCollectionView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(mainViewModel.hotRollpeList) { indexPath, rollpeModels in
                return (indexPath, rollpeModels)
            }
            .subscribe(onNext: { indexPath, rollpeModels in
                guard indexPath.row < rollpeModels.count else { return }
                
                let selectedModel = rollpeModels[indexPath.row]
                self.rollpeV1ViewModel.selectedRollpeDataModel = selectedModel
                
                self.rollpeV1ViewModel.getRollpeData(pCode: selectedModel.code)
            })
            .disposed(by: disposeBag)
    }
}

extension MainAfterSignInViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 12) / 2
        
        // collectionView의 높이 설정
        DispatchQueue.main.async {
            self.rollpeCollectionView.snp.updateConstraints { make in
                make.height.equalTo(self.rollpeCollectionView.contentSize.height)
            }
        }
        
        return CGSize(width: width, height: 148)
    }
}

extension MainAfterSignInViewController {
    // bind
    private func bindRollpeViewModel() {
        let output = rollpeV1ViewModel.transform()
        
        output.needEnter
            .emit(onNext: { needEnter in
                if let needEnter = needEnter,
                   let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel,
                   !self.rollpeV1ViewModel.isPushed {
                    if needEnter {
                        if rollpeDataModel.viewStat { // 공개
                            self.confirmEnterRollpe()
                        } else { // 비공개
                            self.showPasswordTextFieldAlert()
                        }
                    } else {
                        self.navigationController?.pushViewController(RollpeV1DetailViewController(pCode: rollpeDataModel.code), animated: true)
                        self.rollpeV1ViewModel.isPushed = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.isEnterSuccess
            .emit(onNext: { isEnterSuccess in
                if let isEnterSuccess = isEnterSuccess,
                   let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel,
                   !self.rollpeV1ViewModel.isPushed {
                    if isEnterSuccess {
                        self.navigationController?.pushViewController(RollpeV1DetailViewController(pCode: rollpeDataModel.code), animated: true)
                        self.rollpeV1ViewModel.isPushed = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 입장 확인
    private func confirmEnterRollpe() {
        guard let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel else {
            return
        }
        
        self.showConfirmAlert(title: "알림", message: "\(rollpeDataModel.title) 롤페에 입장하시겠습니까?")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.rollpeV1ViewModel.enterRollpe(pCode: rollpeDataModel.code)
            })
            .disposed(by: disposeBag)
    }
    
    // 비밀번호를 통한 입장
    private func showPasswordTextFieldAlert() {
        let alertController = UIAlertController(title: "롤페 입장하기", message: "비밀번호를 입력하세요", preferredStyle: .alert)
        
        alertController.addTextField { field in
            
        }
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            if let textField = alertController.textFields?.first,
               let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel {
                self.rollpeV1ViewModel.enterRollpe(pCode: rollpeDataModel.code, password: textField.text)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// Grid Cell
class MainAfterSignInGridCell: UICollectionViewCell {
    private let rollpeItemView = RollpeItemView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(rollpeItemView)
        
        rollpeItemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func configure(model: RollpeListDataModel) {
        rollpeItemView.configure(model: model)
    }
}

#if DEBUG
import SwiftUI

struct MainAfterSignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MainAfterSignInViewController()
        }
    }
}
#endif
