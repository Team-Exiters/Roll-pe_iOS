//
//  MainAfterSignInViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift
import RxCocoa

class MainAfterSignInViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = MainAfterSignInViewModel()
    let userViewModel = UserViewModel()
    let keychain = Keychain.shared
    
    // MARK: - 요소
    
    private let contentView = UIView()
    
    private let hotContentView = UIView()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 24)
        }
        return label
    }()
    
    private let rollpesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
            print("커스텀 폰트를 로드하지 못했습니다.")
        }
        return label
    }()
    
    private let heartsLabel: UILabel = {
        let label = UILabel()
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
    
    private let primaryButton = PrimaryButton(title: "초대받은 롤페")
    
    private let secondaryButton = SecondaryButton(title: "롤페 만들기")
    
    private let hotLabel: UILabel = {
        let label = UILabel()
        label.text = "지금 뜨고있는 롤페"
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            label.font = UIFont.systemFont(ofSize: 24)
            print("커스텀 폰트를 로드하지 못했습니다.")
        }
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    var collectionViewHeightConstraint: Constraint?
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        setUI()
        bind()
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
            make.bottom.equalToSuperview().inset(safeareaBottom * -1)
            make.width.equalToSuperview()
        }
    }
    
    private func setupNickNameLabel() {
        let nickname = self.keychain.read(key: "NAME")
        nickNameLabel.text = "\(nickname ?? "")님은"
        
        contentView.addSubview(nickNameLabel)
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupRollpesLabel(){
        contentView.addSubview(rollpesLabel)
        
        rollpesLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupHeartsLabel(){
        contentView.addSubview(heartsLabel)
        
        heartsLabel.snp.makeConstraints { make in
            make.top.equalTo(rollpesLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupPrimaryButton(){
        contentView.addSubview(primaryButton)
        
        primaryButton.snp.makeConstraints { make in
            make.top.equalTo(heartsLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        primaryButton.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
    }
    
    private func setupSecondaryButton(){
        contentView.addSubview(secondaryButton)
        
        secondaryButton.snp.makeConstraints { make in
            make.top.equalTo(primaryButton.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        secondaryButton.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)
    }
    
    private func setupHotContentView(){
        contentView.addSubview(hotContentView)
        hotContentView.backgroundColor = .rollpeSectionBackground
        
        hotContentView.snp.makeConstraints { make in
            make.top.equalTo(secondaryButton.snp.bottom).offset(36)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setupHotLabel() {
        hotContentView.addSubview(hotLabel)
        
        hotLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupRollpeItems() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.register(MainAfterSignInGridCell.self, forCellWithReuseIdentifier: "GridCell")
        
        hotContentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(hotLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().inset(44)
            
            collectionViewHeightConstraint = make.height.equalTo(self.collectionView.contentSize.height).constraint
        }
    }
    
    private func setupFooter(){
        let footer = Footer()
        contentView.addSubview(footer)
        
        footer.snp.makeConstraints{make in
            make.top.equalTo(hotContentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func addSideMenuButton() {
        let sideMenuView = SidemenuView(menuIndex: 0)
        let buttonSideMenu: UIButton = ButtonSideMenu()
         
        view.addSubview(buttonSideMenu)
         
        buttonSideMenu.snp.makeConstraints { make in
             make.top.equalToSuperview().offset(80)
             make.trailing.equalToSuperview().inset(20)
         }
         
        buttonSideMenu.rx.tap
             .subscribe(onNext: {
                 self.view.addSubview(sideMenuView)
                 sideMenuView.showMenu()
             })
             .disposed(by: disposeBag)
    }
    
    // MARK: - Bind
    
    private func bind() {
        userViewModel.getMyStatus()
        
        // 내 상태
        userViewModel.myStatus
            .map { model in
                return "\(model?.data.host ?? 0)번의 롤페를 만드셨어요."
            }
            .bind(to: rollpesLabel.rx.text)
            .disposed(by: disposeBag)
        
        userViewModel.myStatus
            .map { model in
                return "\(model?.data.heart ?? 0)번의 마음을 작성하셨어요."
            }
            .bind(to: heartsLabel.rx.text)
            .disposed(by: disposeBag)
        
        // 지금 뜨는 롤페
        viewModel.hotRollpeList
            .map { model in
                return model?.data ?? []
            }
            .bind(to: collectionView.rx.items(cellIdentifier: "GridCell", cellType: MainAfterSignInGridCell.self)) { index, model, cell in
                cell.configure(model: model)
            }
            .disposed(by: disposeBag)
    }
    
}

extension MainAfterSignInViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 12) / 2
        
        // collectionView의 높이 설정
        DispatchQueue.main.async {
            self.collectionViewHeightConstraint?.update(offset: self.collectionView.contentSize.height)
        }
        
        return CGSize(width: width, height: 148)
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

    func configure(model: RollpeItemModel) {
        rollpeItemView.configure(model: model)
    }
}

#if DEBUG
struct MainAfterSignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MainAfterSignInViewController()
        }
    }
}
#endif
