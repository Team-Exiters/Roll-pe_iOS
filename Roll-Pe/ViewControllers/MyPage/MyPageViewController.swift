//
//  MyPageViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/27/25.
//

import UIKit
import SnapKit
import RxSwift
import RxGesture

class MyPageViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel = UserViewModel()
    private let keychain = Keychain.shared
    
    private lazy var provider = keychain.read(key: "PROVIDER")
    
    // MARK: - 요소
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        
        return sv
    }()
    
    private let contentView = UIView()
    
    // 사이드 메뉴
    private let buttonSideMenu = ButtonSideMenu()
    private let sideMenuView = SidemenuView(menuIndex: 4)
    
    // 제목
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "마이페이지"
        label.textAlignment = .center
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
        
        return label
    }()
    
    // 닉네임, 소셜로그인 뱃지 stack view
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        return stackView
    }()
    
    // 닉네임
    private let nicknameLabel: UILabel = {
        let label = UILabel()
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
    
    private let identifyCodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 14) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        }
        
        return label
    }()
    
    private let rollpeCountLabel: CountLabel = CountLabel(type: .rollpe)
    
    private let heartCountLabel: CountLabel = CountLabel(type: .heart)
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 배경 및 네비게이션 설정
        view.backgroundColor = .rollpePrimary
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        // UI 설정
        setupScrollView()
        setupContentView()
        setupTitleLabel()
        setupNicknameAndSocialBadge()
        setupIdentifyCodeLabel()
        setupRollpeCountLabel()
        setupHeartCountLabel()
        setupListSection()
        setupFooter()
        
        addSideMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Bind 설정
        bind()
    }
    
    // MARK: - UI 설정
    
    // 사이드 메뉴
    private func addSideMenuButton() {
        // 사이드 메뉴
        view.addSubview(buttonSideMenu)
        
        buttonSideMenu.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        buttonSideMenu.rx.tap
            .subscribe(onNext: {
                self.view.addSubview(self.sideMenuView)
                self.sideMenuView.showMenu()
            })
            .disposed(by: disposeBag)
    }
    
    // 스크롤 뷰
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    // 내부 뷰
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(-safeareaBottom)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview()
        }
    }
    
    // 제목
    private func setupTitleLabel(){
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(76)
            make.centerX.equalToSuperview()
        }
    }
    
    // 닉네임, 소셜뱃지
    private func setupNicknameAndSocialBadge() {
        let nickname = self.keychain.read(key: "NAME")
        
        nicknameLabel.text = "\(nickname ?? "")님"
        
        contentView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(nicknameLabel)
        
        if let provider = provider {
            horizontalStackView.addArrangedSubview(SocialBadgeView(provider: provider))
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(52)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // identify code 라벨
    private func setupIdentifyCodeLabel(){
        let identifyCode = self.keychain.read(key: "IDENTIFY_CODE")
        identifyCodeLabel.text = identifyCode ?? ""
        
        contentView.addSubview(identifyCodeLabel)
        
        identifyCodeLabel.snp.makeConstraints{make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // 롤페 작성 횟수
    private func setupRollpeCountLabel(){
        contentView.addSubview(rollpeCountLabel)
        rollpeCountLabel.snp.makeConstraints{ make in
            make.top.equalTo(identifyCodeLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // 마음 남긴 횟수
    private func setupHeartCountLabel(){
        contentView.addSubview(heartCountLabel)
        heartCountLabel.snp.makeConstraints{ make in
            make.top.equalTo(rollpeCountLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // 메뉴 목록
    private func setupListSection() {
        struct buttonStruct {
            let title: String
            let tap: () -> Void
        }
        
        contentView.addSubview(verticalStackView)
        
        let buttons: [buttonStruct] = [
            // VIP는 현재 제외
            buttonStruct(title: "비밀번호 변경", tap: changePasswordTapped),
            buttonStruct(title: "내 롤페", tap: myRollpeTapped),
            buttonStruct(title: "초대받은 롤페", tap: invitedRollpeTapped),
            buttonStruct(title: "로그아웃", tap: logoutTapped),
            buttonStruct(title: "회원탈퇴", tap: withdrawTapped)
        ]
        
        for button in buttons {
            if button.title == "비밀번호 변경" && provider != nil {
                continue
            }
            
            let label: UILabel = {
                let label = UILabel()
                label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
                label.textColor = .rollpeSecondary
                label.text = button.title
                
                return label
            }()
            
            label.rx.tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    button.tap()
                })
                .disposed(by: disposeBag)
            
            if button.title == "회원탈퇴" {
                label.textColor = .rollpeGray
            }
            
            verticalStackView.addArrangedSubview(label)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(heartCountLabel.snp.bottom).offset(48)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // VIP 구매
    private func vipPurchaseTapped() {
        
    }
    
    // 비밀번호 변경
    private func changePasswordTapped() {
        let vc = ChangePasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 내 롤페
    private func myRollpeTapped() {
        let vc = MyRollpeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 초대받은 롤페
    private func invitedRollpeTapped() {
        let vc = InvitedRollpeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 로그아웃
    private func logoutTapped() {
        let alert = UIAlertController(title: "경고", message: "로그아웃을 하시겠습니까?", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.viewModel.logout()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 회원탈퇴
    private func withdrawTapped() {
        let alert = UIAlertController(title: "경고", message: "정말 회원탈퇴를 진행하시겠습니까?", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .destructive) { _ in
            self.viewModel.deleteAccount()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // 푸터
    private func setupFooter(){
        let spacer = Spacer(axis: .vertical)
        
        contentView.addSubview(spacer)
        
        spacer.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        let footer = Footer()
        contentView.addSubview(footer)
        
        footer.snp.makeConstraints{ make in
            make.top.equalTo(spacer.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - bind
    
    private func bind() {
        viewModel.getMyStatus()
        
        // 내 상태
        viewModel.myStatus
            .map { model in
                return model?.data.host ?? 0
            }
            .bind(to: rollpeCountLabel.rx.count)
            .disposed(by: disposeBag)
        
        viewModel.myStatus
            .map { model in
                return model?.data.heart ?? 0
            }
            .bind(to: heartCountLabel.rx.count)
            .disposed(by: disposeBag)
        
        let output = viewModel.output()
        
        output.successAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showAlert(title: "알림", message: message)
                    self.viewModel.logout()
                }
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct MyPageViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MyPageViewController()
        }
    }
}
#endif

//여기서부터 MyPageViewController 전용 컴포넌트
class SocialBadgeView: UIView {
    private let imageView = UIImageView()
    
    init(provider: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
        configure(login: provider)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(8)
        }
    }
    
    private func configure(login: String) {
        switch login {
        case "kakao":
            imageView.image = UIImage(named: "icon_kakao")
            self.backgroundColor = .kakao
        case "google":
            imageView.image = UIImage(named: "icon_google")
            self.backgroundColor = .rollpeWhite
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.rollpeBlack.cgColor
        case "apple":
            imageView.image = UIImage(named: "icon_apple")
            self.backgroundColor = .rollpeBlack
        default:
            print("이미지 없음")
        }
    }
}
