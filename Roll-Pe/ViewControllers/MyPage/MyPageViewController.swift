//
//  MyPageViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/27/25.
//

import UIKit
import SwiftUI
import SnapKit
import RxSwift


//절대 절대 절대  손대지말것  modify자체를 하면 안댐 띄어쓰기도 금지, 필요시 말해서 동혁이가 직접 수정하도록 유도
class MyPageViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    let userViewModel = UserViewModel()
    
    let keychain = Keychain.shared
    
    private var myStatus : MyStatusModel? = nil
    
    private var userData : UserDataModel? = nil
    
    private var myRollpeListData : [RollpeListItemModel]? = nil
    
    private var invitedRollpeListData : [RollpeListItemModel]? = nil
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let sideMenuView = SidemenuView(menuIndex: 4)
    
    private let buttonSideMenu = ButtonSideMenu()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "rollpe_secondary")
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
        return label
    }()
    private let horizontalStackView: UIStackView = {
         let stackView = UIStackView()
         stackView.axis = .horizontal
         stackView.spacing = 8
         stackView.alignment = .center
         stackView.distribution = .fill
         return stackView
     }()
    
    private let nicknameLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
        return label
    }()
    
    private let userUIDLabel : UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "rollpe_secondary")
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        return label
    }()
    
    private lazy var rollpeCountLabel: CountLabel = {
        let count = myStatus?.data.host ?? 0
        return CountLabel(count: count,type: .rollpe)
    }()

    private lazy var heartCountLabel : CountLabel = {
        let count = myStatus?.data.heart ?? 0
        return CountLabel(count: count, type: .heart)
    }()
    
    private let verticalStackView: UIStackView = {
         let stackView = UIStackView()
        stackView.axis = .vertical
         stackView.spacing = 16
        stackView.alignment = .leading
         stackView.distribution = .fill
         return stackView
     }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경 및 네비게이션 설정
        view.backgroundColor = .rollpePrimary
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // Bind 설정
        bind()
        
        // UI 설정
        setupScrollView()
        setupContentView()
        setupSideMenu()
        setupTitleLabel()
        setupNicknameAndLoginBadge()
        setupUserID()
        setupRollpeCountLabel()
        setupHeartCountLabel()
        setupListSection()
        setupFooter()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }

    
    private func setupSideMenu() {
        contentView.addSubview(buttonSideMenu)
        buttonSideMenu.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.trailing.equalToSuperview().inset(20)
        }
        buttonSideMenu.rx.tap
            .subscribe(onNext: {
                self.view.addSubview(self.sideMenuView)
                self.sideMenuView.showMenu()
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTitleLabel(){
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(buttonSideMenu).offset(28)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupNicknameAndLoginBadge() {
        let nickname = self.keychain.read(key: "NAME")
        let provider = self.keychain.read(key: "PROVIDER")
        
        nicknameLabel.text = "\(nickname ?? "")님"
        
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(nicknameLabel)

        if let provider = provider {
            horizontalStackView.addArrangedSubview(LoginBadgeView(provider:provider))
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupUserID(){
        let userID = self.keychain.read(key: "USER_ID")
        userUIDLabel.text = userID ?? ""
        contentView.addSubview(userUIDLabel)
        userUIDLabel.snp.makeConstraints{make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupRollpeCountLabel(){
        contentView.addSubview(rollpeCountLabel)
        rollpeCountLabel.snp.makeConstraints{make in
            make.top.equalTo(userUIDLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupHeartCountLabel(){
        contentView.addSubview(heartCountLabel)
        heartCountLabel.snp.makeConstraints{ make in
            make.top.equalTo(rollpeCountLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    private func setupListSection() {
        contentView.addSubview(verticalStackView)
        let buttonTitles = [
            "VIP 구매",
            "비밀번호 변경",
            "내 롤페",
            "초대받은 롤페",
            "로그아웃",
            "회원탈퇴"
        ]
        for (index, title) in buttonTitles.enumerated() {
            let button = ListSectionButton(text: title)
            button.tag = index
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            if title == "회원탈퇴" {
                button.setTitleColor(UIColor(named: "rollpe_gray"), for: .normal)
                  }
            verticalStackView.addArrangedSubview(button)
        }
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(heartCountLabel.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            vipPurchaseTapped()
        case 1:
            changePasswordTapped()
        case 2:
            myRollpeTapped()
        case 3:
            invitedRollpeTapped()
        case 4:
            logoutTapped()
        case 5:
            withdrawTapped()
        default:
            break
        }
    }

    private func vipPurchaseTapped() {

    }
    private func changePasswordTapped() {
        let changePasswordVC = ChangePasswordViewController()
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    private func myRollpeTapped() {
        let vc = MyRollpeViewController()
        userViewModel.getMyRollpes()
        vc.rollpeListData = myRollpeListData ?? []
        navigationController?.pushViewController(vc, animated: true)
    }
    private func invitedRollpeTapped() {
        let vc = InvitedRollpeViewController()
        userViewModel.getInvitedRollpes()
        vc.rollpeListData = invitedRollpeListData ?? []
        navigationController?.pushViewController(vc, animated: true)
    }
    private func logoutTapped() {
        userViewModel.logout()
    }
    private func withdrawTapped() {
        let alert = UIAlertController(title: "회원 탈퇴", message: "정말 회원 탈퇴를 진행하시겠습니까?", preferredStyle: .alert)
           let confirmAction = UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
               self?.userViewModel.deleteAccount()
           }
           let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
           alert.addAction(confirmAction)
           alert.addAction(cancelAction)
           self.present(alert, animated: true, completion: nil)
    }
    
    private func setupFooter() {
        let footer = Footer()
        contentView.addSubview(footer)
        footer.snp.makeConstraints{make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(164)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        userViewModel.getMyStatus()
        
        userViewModel.myStatus
            .subscribe(onNext: { [weak self] model in
                self?.myStatus = model
            })
            .disposed(by: disposeBag)
        
        userViewModel.myRollpe
            .subscribe(onNext:{[weak self] model in
                self?.myRollpeListData = model
            })
            .disposed(by: disposeBag)
        
        userViewModel.invitedRollpe
            .subscribe(onNext:{ [weak self] model in
                self?.invitedRollpeListData = model
            })
            .disposed(by: disposeBag)
    }
    
}

struct MyPageViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MyPageViewController()
        }
    }
}

//여기서부터 MyPageViewController 전용 컴포넌트
class LoginBadgeView: UIView {
    private let imageView = UIImageView()
    init(provider: String) {
        super.init(frame: .zero)
        setupView()
        configureImage(for: provider)
        configureBackground(for: provider)
        configureBorder(for: provider)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.snp.makeConstraints { make in
              make.width.height.equalTo(20)
          }
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(8)
        }
    }
    
    private func configureImage(for login: String) {
        switch login.lowercased() {
        case "kakao":
            imageView.image = UIImage(named: "icon_kakao")
        case "google":
            imageView.image = UIImage(named: "icon_google")
        case "apple":
            imageView.image = UIImage(named: "icon_apple")
        default:
            print("이미지 없음")
        }
    }
    
    private func configureBackground(for login: String) {
        switch login.lowercased() {
        case "kakao":
            self.backgroundColor = .kakao
        case "google":
            self.backgroundColor = .rollpePrimary
        case "apple":
            self.backgroundColor = .rollpeSecondary
        default:
           print("로그인데이터 없음")
        }
    }
    
    private func configureBorder(for login: String) {
          if login.lowercased() == "google" {
              self.layer.borderWidth = 1
              self.layer.borderColor = UIColor(named: "rollpe_secondary")?.cgColor
          } else {
              self.layer.borderWidth = 0
              self.layer.borderColor = nil
          }
      }
}

class ListSectionButton: UIButton {
    
    init(text: String) {
        super.init(frame: .zero)
        setupButton()
        self.setTitle(text, for: .normal) // 버튼 타이틀 설정
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        self.setTitleColor(UIColor(named: "rollpe_secondary"), for: .normal)
        self.titleLabel?.numberOfLines = 1
        self.contentHorizontalAlignment = .left
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) {
            self.titleLabel?.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        }
    }
}

extension UIViewController {
    func setupDefaultAppearance() {
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .rollpePrimary
    }
}

