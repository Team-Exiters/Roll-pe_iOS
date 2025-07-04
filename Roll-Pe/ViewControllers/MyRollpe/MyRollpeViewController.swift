//
//  MyRollpeViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MyRollpeViewController: BaseRollpeV1ViewController, UITableViewDelegate {
    private let viewModel = GetRollpeViewModel()
    
    // MARK: - 요소
    
    private let scrollView = UIScrollView()
    
    private let contentView = UIView()
    
    // 네비게이션 바
    private let navigationBar: NavigationBar = {
        let navigationBar = NavigationBar()
        navigationBar.highlight = "마이페이지"
        navigationBar.showSideMenu = true
        
        return navigationBar
    }()
    
    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 롤페"
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
    
    // 롤페 개수 라벨
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        
        return label
    }()
    
    // 테이블 뷰
    private let rollpeTableView: UITableView = {
        let tv = AutoHeightTableView()
        
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 128
        tv.isScrollEnabled = false
        
        // 내용 여백
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        rollpeTableView.register(RollpeListTableViewCell.self, forCellReuseIdentifier: "RollpeListCell")
        
        // UI 설정
        setupScrollView()
        setupContentView()
        setupTitleLabel()
        setupAmountLabel()
        
        setupNavigationBar()
        
        // Bind
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getRollpes(type: "host")
    }
    
    // MARK: - UI 설정
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.width.equalToSuperview().offset(-40)
            make.height.greaterThanOrEqualToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        
        navigationBar.parentViewController = self
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(76)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupAmountLabel() {
        contentView.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview()
        }
    }
    
    // MARK: - Bind
    
    private func bind() {
        let output = viewModel.transform()
        
        output.showOKAlert
            .drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                if let message = message {
                    self.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        output.rollpeModels
            .map { rollpes in
                return (rollpes ?? []).enumerated().map {
                    ($0.element, rollpes?.count ?? 0)
                }
            }
            .drive(rollpeTableView.rx.items(cellIdentifier: "RollpeListCell", cellType: RollpeListTableViewCell.self)) { index, data, cell in
                let (model, length) = data
                cell.configure(model: model, isLast: index == length - 1)
            }
            .disposed(by: disposeBag)
        
        output.rollpeModels
            .drive(onNext: { [weak self] rollpeModels in
                guard let self = self,
                      let rollpeModels = rollpeModels
                else { return }
                
                self.amountLabel.text = "총 \(rollpeModels.count)개"
                
                self.contentView.addSubview(self.rollpeTableView)
                
                DispatchQueue.main.async {
                    self.rollpeTableView.snp.remakeConstraints { make in
                        make.top.equalTo(self.amountLabel.snp.bottom).offset(-4)
                        make.horizontalEdges.equalToSuperview()
                        make.height.equalTo(self.rollpeTableView.contentSize.height)
                        
                        if self.rollpeTableView.contentSize.height > UIScreen.main.bounds.height - (safeareaTop + safeareaBottom) {
                            make.bottom.equalToSuperview().inset(40)
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        rollpeTableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .withLatestFrom(output.rollpeModels) { indexPath, rollpeModels in
                return (indexPath, rollpeModels)
            }
            .subscribe(onNext: { indexPath, rollpeModels in
                guard let models = rollpeModels,
                      indexPath.row < models.count else { return }
                
                let selectedModel = models[indexPath.row]
                self.rollpeV1ViewModel.selectedRollpeDataModel = selectedModel
                self.rollpeV1ViewModel.getRollpeData(pCode: selectedModel.code)
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct MyRollpeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MyRollpeViewController()
        }
    }
}
#endif
