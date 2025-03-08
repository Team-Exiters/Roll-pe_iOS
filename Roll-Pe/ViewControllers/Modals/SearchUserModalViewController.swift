//
//  SearchUserModalViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/25/25.
//

import UIKit
import SnapKit
import SwiftUI
import RxSwift

class SearchUserModalViewController: UIViewController, UITableViewDelegate {
    private let disposeBag = DisposeBag()
    private let viewModel = SearchUserViewModel()
    
    // 선택한 유저 부모 뷰로 전달
    var onUserSelected: ((SearchUserResultModel) -> Void)?
    
    // MARK: - 요소
    
    private let contentView = {
        let view = UIView()
        view.backgroundColor = .rollpePrimary
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let closeButton : UIButton = {
        let button = UIButton()
        let icon = UIImage.iconX
        icon.withTintColor(.rollpeSecondary)
        
        button.setImage(.iconX, for: .normal)
        button.setImage(.iconX, for: .highlighted)
        button.tintColor = .rollpeSecondary
        
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "전달하기"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 28) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 28)
        }
        
        return label
    }()
    
    private lazy var searchBar : TextField = {
        let textField = TextField()
        textField.placeholder = "검색어를 입력하세요."
        textField.rightViewMode = .always
        textField.rightView = searchButton
        textField.returnKeyType = .search
        
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button: UIButton = UIButton()
        let iconView: UIImageView = UIImageView()
        let iconImage: UIImage = UIImage.iconMagnifyingGlass
        iconView.image = iconImage
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .rollpeSecondary
        button.addSubview(iconView)
        
        iconView.snp.makeConstraints { make in
            make.width.equalTo(22)
            make.height.equalTo(iconView.snp.width).dividedBy(getImageRatio(image: iconImage))
            make.trailing.equalToSuperview().inset(16)
        }
        
        button.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
        
        return button
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(SearchUserModalTableViewCell.self, forCellReuseIdentifier: "SearchUserCell")
        
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 46
        
        tv.backgroundColor = .rollpePrimary
        tv.layer.borderWidth = 2.0
        tv.layer.borderColor = UIColor.rollpeSecondary.cgColor
        tv.layer.cornerRadius = 16.0
        tv.layer.masksToBounds = true
        tv.separatorStyle = .none
        
        // 내용 여백
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        return tv
    }()
    
    private let sendButton = PrimaryButton(title: "선택하기")
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.hideKeyboardWhenTappedAround()
        
        setUI()
        bind()
    }
    
    // MARK: - UI 구성
    
    private func setUI() {
        setupContentView()
        setupCloseButton()
        setupTitle()
        setupSearchBar()
        setupTableView()
        setupSendButton()
    }
    
    // 내부 뷰
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.center.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.62)
        }
    }
    
    // 닫기 버튼
    private func setupCloseButton() {
        contentView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(20)
        }
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 제목
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton)
        }
    }
    
    // 검색 바
    private func setupSearchBar() {
        contentView.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // 테이블 뷰
    private func setupTableView() {
        tableView.delegate = self
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // 전송 버튼
    private func setupSendButton() {
        contentView.addSubview(sendButton)
        
        sendButton.snp.makeConstraints{ make in
            make.top.equalTo(tableView.snp.bottom).offset(28)
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = SearchUserViewModel.Input(
            word: searchBar.rx.text,
            keyboardTapEvent: searchBar.rx.controlEvent(.editingDidEndOnExit),
            searchButtonTapEvent: searchButton.rx.tap,
            selectUser: tableView.rx.itemSelected
        )
        
        let output = viewModel.transform(input)
        
        output.showAlert
            .drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                if let message = message {
                    self.showErrorAlert(message: message)
                }
            })
            .disposed(by: disposeBag)
        
        output.users
            .map { users in users.enumerated().map { ($0.element, users.count) } }
            .drive(tableView.rx.items(cellIdentifier: "SearchUserCell", cellType: SearchUserModalTableViewCell.self)) { index, data, cell in
                let (model, length) = data
                cell.configure(model: model, isLast: index == length - 1)
            }
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .withLatestFrom(output.users) { _, users in
                users.first(where: { $0.isSelected! })
            }
            .subscribe(onNext: { [weak self] selectedUser in
                guard let self = self else { return }
                
                if let user = selectedUser {
                    self.onUserSelected?(user)
                    self.dismiss(animated: true)
                } else {
                    self.showErrorAlert(message: "유저를 선택해주세요.")
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// table view cell
class SearchUserModalTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let iconCheck: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .iconCheck
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .rollpeMain
        imageView.isHidden = true
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .rollpeGray
        view.layer.cornerRadius = 1
        
        return view
    }()
    
    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(iconCheck)
        
        iconCheck.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(10)
        }
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(separatorView)
    }
    
    func configure(model: SearchUserResultModel, isLast: Bool) {
        titleLabel.text = "\(model.name)(\(model.identifyCode))"
        iconCheck.isHidden = !(model.isSelected ?? false)
        
        iconCheck.snp.updateConstraints { make in
            make.size.equalTo((model.isSelected ?? false) ? 10 : 0)
        }
        
        separatorView.removeFromSuperview()
        
        if isLast {
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalTo(iconCheck.snp.trailing).offset((model.isSelected ?? false) ? 8 : 0)
                make.trailing.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().inset(12)
            }
        } else {
            contentView.addSubview(separatorView)
            
            titleLabel.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(12)
                make.leading.equalTo(iconCheck.snp.trailing).offset((model.isSelected ?? false) ? 8 : 0)
                make.trailing.equalToSuperview().offset(-16)
            }
            
            separatorView.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(12)
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().offset(-16)
                make.bottom.equalToSuperview().priority(.low)
                make.height.equalTo(2)
            }
        }
    }
}

#if DEBUG
struct PreviewSearchUserModalViewController: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SendRollpeViewController()
        }
    }
}
#endif
