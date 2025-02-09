//
//  WriterListViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/7/25.
//

import UIKit
import SwiftUI
import RxSwift


class ParticipantListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var rollpeHostViewModel : RollpeHostViewModel
    
    private lazy var listView = ListView(rollpeHostViewModel: rollpeHostViewModel)
    
    init(rollpeHostViewModel: RollpeHostViewModel) {
        self.rollpeHostViewModel = rollpeHostViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:)에러")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .rollpeGray
        navigationItem.hidesBackButton = true
        setupListView()
    }
    
    private func setupListView(){
        view.addSubview(listView)
        listView.layer.cornerRadius = 16
        listView.layer.masksToBounds = true
        listView.snp.makeConstraints{make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.62)
        }
    }
}

class ListView : UIView , UITableViewDataSource , UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return participants.count
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
         cell.textLabel?.text = participants[indexPath.row].nickname
      
         let blockButton = UIButton(type: .system)
         if let originalImage = UIImage(named: "icon_deny"),
            let resizedImage = originalImage.resizedImage(to: CGSize(width: 20, height: 20)) {
             blockButton.setImage(resizedImage, for: .normal)
         }
         blockButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
         blockButton.tintColor = .rollpeStatusDanger
         blockButton.addTarget(self, action: #selector(blockButtonTapped), for: .touchUpInside)
         
        let reportButton = UIButton(type: .system)
         if let originalImage = UIImage(named: "icon_siren")?.withRenderingMode(.alwaysOriginal),
            let resizedImage = originalImage.resizedImage(to: CGSize(width: 22, height: 22))?.withRenderingMode(.alwaysOriginal) {
             reportButton.setImage(resizedImage, for: .normal)
         }
         reportButton.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
         reportButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 2, right: 0)
         reportButton.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
         
         let stackView = UIStackView(arrangedSubviews: [blockButton, reportButton])
         stackView.axis = .horizontal
         stackView.spacing = 12
         stackView.alignment = .center
          stackView.distribution = .fill
         stackView.frame = CGRect(x: 0, y: 0, width: 54, height: 94)
         cell.accessoryView = stackView
         
         if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20) {
             cell.textLabel?.font = customFont
         } else {
             cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
         }
         if indexPath.row == participants.count - 1 {
                 cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: CGFloat.greatestFiniteMagnitude)
             } else {
                 cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
             }
         cell.selectionStyle = .none
         return cell
     }
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tv.layer.borderWidth = 2.0
        tv.layer.borderColor = UIColor.rollpeSecondary.cgColor
        tv.layer.cornerRadius = 16.0
        tv.layer.masksToBounds = true
        tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        tv.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tv.separatorColor = .rollpeGray
        return tv
    }()
    
    private var participants : [UserDataModel] = [UserDataModel(nickname: "ㅏㅏㅑ",login: ["kakao"],userUID: "ab12jc123",rollpeCount: 8, heartCount: 10),
                                                  UserDataModel(nickname: "ㄴㅇㅇㄴ",login: ["kakao"],userUID: "abc1sc23",rollpeCount: 8, heartCount: 10),
                                                  UserDataModel(nickname: "ㄴㅇㄴㅇ",login: ["kakao"],userUID: "abc1ewa23",rollpeCount: 8, heartCount: 10),
                                                  UserDataModel(nickname: "ㄴㅇㄴㄴ",login: ["kakao"],userUID: "abcgfn123",rollpeCount: 8, heartCount: 10)]
    
    private let disposeBag = DisposeBag()
    
    var rollpeHostViewModel : RollpeHostViewModel
    
    init(rollpeHostViewModel : RollpeHostViewModel) {
        self.rollpeHostViewModel = rollpeHostViewModel
        super.init(frame: .zero)
        bindViewModel()
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:)에러")
    }
    
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
        label.text = "참여자 목록"
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
    
    private func setupUI(){
        backgroundColor = .rollpePrimary
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        
        backButton.snp.makeConstraints{make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(20)
        }
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(24)
        }
    }
    private func bindViewModel() {
        rollpeHostViewModel.rollpeModel
            .observe(on: MainScheduler.instance)
             .compactMap { $0 }
             .subscribe(onNext: { [weak self] model in
                 guard let self = self else { return }
                 participants = model.participants
             })
             .disposed(by: disposeBag)
    }
    
    @objc private func backButtonTapped() {
        print("백버튼")
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @objc private func blockButtonTapped() {
        print("차단탭")
    }
    
    @objc private func reportButtonTapped() {
        print("신고탭")
    }
    
}


struct ParticipantListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ParticipantListViewController(rollpeHostViewModel: RollpeHostViewModel())
        }
    }
}

extension UIImage {
    func resizedImage(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
