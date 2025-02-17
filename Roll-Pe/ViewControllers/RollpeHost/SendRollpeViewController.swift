//
//  SendRollpeViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/10/25.
//

import UIKit
import SnapKit
import SwiftUI
import RxSwift

class SendRollpeViewController: UIViewController {
    
    private let sendView = SendView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rollpeGray
        navigationItem.hidesBackButton = true
        setupSendView()
    }
    
    private func setupSendView(){
        view.addSubview(sendView)
        sendView.layer.cornerRadius = 16
        sendView.layer.masksToBounds = true
        sendView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.62)
        }
    }
    

}


class SendView : UIView , UITableViewDataSource , UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "UserCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = searchedUsers[indexPath.row].nickname
        if indexPath.row == searchedUsers.count - 1 {
               cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: cell.bounds.size.width)
           }
        if let selected = selectedUser, selected.userUID == searchedUsers[indexPath.row].userUID {
            if let checkmarkImage = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate) {
                cell.imageView?.image = checkmarkImage
                cell.imageView?.tintColor = .rollpeMain
            }
        } else {
            cell.imageView?.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedUser = searchedUsers[indexPath.row]
        tableView.reloadData()
        print(selectedUser?.nickname ?? "없음")
    }

    init(){
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
    }
    required init?(coder:NSCoder){
        fatalError("init(coder:)에러")
    }
    
    private let disposeBag = DisposeBag()
    
    let rollpeHostViewModel = RollpeHostViewModel()
    
    private var searchedUsers : [UserDataModel] = []
    
    private var selectedUser : UserDataModel? = nil
    
    private let backButton : UIButton = {
        let button = UIButton(type: .system)
        if let originalImage = UIImage(named: "icon_x") {
            let resizedImage = originalImage.resized(to: CGSize(width: 20, height: 20))
            button.setImage(resizedImage, for: .normal)
        }
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
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        }
        return label
    }()
    
    private lazy var searchBar : TextField = {
        let textField = TextField()
        textField.placeholder = "검색어를 입력하세요."
        textField.rightViewMode = .always
        textField.rightView = searchButton
        textField.rightViewMode = .always
        textField.rightView = searchButton
        return textField
    }()
 
    private let searchButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage.iconMagnifyingGlass.withRenderingMode(.alwaysOriginal)
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16)
        let button = UIButton(configuration: config, primaryAction: nil)
        return button
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.layer.borderWidth = 2.0
        tv.layer.borderColor = UIColor.rollpeSecondary.cgColor
        tv.layer.cornerRadius = 16.0
        tv.layer.masksToBounds = true
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.separatorColor = .rollpeGray
        return tv
    }()
    
    private let sendButton = PrimaryButton(title: "소유권 이전하기")

    //MARK: 함수선언
    private func setupUI(){
        backgroundColor = .rollpePrimary
        
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(sendButton)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if let selectedUser = selectedUser {
                    rollpeHostViewModel.sendRollpe(selectedUser: selectedUser)
                }
                else{
                    //유저를 골라달라는 alert
                }
            })
            .disposed(by: disposeBag)
        searchButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                selectedUser = nil
                rollpeHostViewModel.searchUser(nickname: searchBar.text ?? "")
            })
            .disposed(by: disposeBag)
        
        backButton.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        sendButton.snp.makeConstraints{ make in
            make.top.equalTo(tableView.snp.bottom).offset(28)
            make.bottom.equalToSuperview().inset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
    }
    
    private func bindViewModel(){
        rollpeHostViewModel.searchedUsers
            .observe(on: MainScheduler.instance)
             .compactMap { $0 }
             .subscribe(onNext: { [weak self] model in
                 guard let self = self else { return }
                 searchedUsers = model
                 tableView.reloadData()
             })
             .disposed(by: disposeBag)
    }
}


struct SendRollpeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SendRollpeViewController()
        }
    }
}
