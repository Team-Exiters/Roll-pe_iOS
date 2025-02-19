//
//  InvitedRollpeViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/29/25.
//

import UIKit
import SwiftUI
import RxSwift

class InvitedRollpeViewController: UIViewController {

    var rollpeListData: [RollpeListItemModel] = []
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    private let navigationBar : NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.menuIndex = 4
        navigationBar.showSideMenu = true
        return navigationBar
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "초대받은 롤페"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 32) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        }
        return label
    }()
    
    private let rollpeCountLabel :UILabel = {
        let label = UILabel()
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
    
    private let listStackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .leading
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .rollpePrimary
        setupScrollView()
        setupContentView()
        setupNavigationBar()
        setupTitleLabel()
        setupRollpeCountLabel()
        setupListStackView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.bounces = false
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top) // 상단 safeArea 유지
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        contentView.addSubview(navigationBar)
        navigationBar.parentViewController = self
            navigationBar.snp.makeConstraints { make in
                make.top.equalToSuperview()
                make.horizontalEdges.equalToSuperview().inset(20)
            }
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom).offset(28)
        }
    }
    
    private func setupRollpeCountLabel() {
        contentView.addSubview(rollpeCountLabel)
        rollpeCountLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
        }
    }
    
    //태은짱 코드 개날먹 ㅅㅅ
    private func setupListStackView() {
        contentView.addSubview(listStackView)
        listStackView.snp.makeConstraints { make in
            make.top.equalTo(rollpeCountLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        for (index, data) in rollpeListData.enumerated() {
            let itemView = RollpeListItem(data)
            
            listStackView.addArrangedSubview(itemView)
            
            itemView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(20)
            }
            
            // 구분선
            if index != rollpeListData.count - 1 {
                let separatorView: UIView = UIView()
                separatorView.backgroundColor = .rollpeGray
                separatorView.layer.cornerRadius = 1
                separatorView.layer.masksToBounds = true
                
                listStackView.addArrangedSubview(separatorView)
                
                separatorView.snp.makeConstraints { make in
                    make.height.equalTo(2)
                    make.leading.equalToSuperview().offset(20)
                    make.trailing.equalToSuperview().offset(-20)
                }
            } else {
                listStackView.setCustomSpacing(32, after: itemView)
            }
        }
    }
    

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rollpeCountLabel.text = "총 \(rollpeListData.count)개"
    }
}

struct InvitedRollpeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            InvitedRollpeViewController()
        }
    }
}
