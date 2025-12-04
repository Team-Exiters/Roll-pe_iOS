//
//  InvitedRollpeViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/29/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class InvitedRollpeViewController: BaseRollpeV1ViewController, UITableViewDelegate {
    private let viewModel = GetRollpeViewModel()
    
    // MARK: - 요소
    // 테이블 뷰
    private let rollpeTableView: UITableView = {
        let tv = UITableView()
        
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 128
        
        // 내용 여백
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    // 네비게이션 바
    private let navigationBar: NavigationBar = {
        let navigationBar = NavigationBar(highlight: "마이페이지")
        navigationBar.showSideMenu = true
        
        return navigationBar
    }()
    
    // 제목
    private let titleLabel: UILabel = {
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
    
    // 롤페 개수 라벨
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.text = "총 0개"
        
        return label
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        rollpeTableView.register(RollpeListTableViewCell.self, forCellReuseIdentifier: "RollpeListCell")
        
        // UI 설정
        setupNavigationBar()
        setupTableView()
        
        // Bind
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getInvitedRollpes()
    }
    
    // MARK: - UI 설정
    
    private func setupNavigationBar() {
        view.addSubview(navigationBar)
        
        navigationBar.parentViewController = self
        
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    private func setupTableView() {
        view.addSubview(rollpeTableView)
        
        rollpeTableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalTo(navigationBar.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        let headerView = UIView()
        
        // 제목
        [titleLabel, amountLabel].forEach {
            headerView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
        }
        
        // 개수
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.leading.bottom.equalToSuperview()
        }
        
        // 헤더 뷰
        let headerHeight: CGFloat = 8 + titleLabel.intrinsicContentSize.height + 32 + amountLabel.intrinsicContentSize.height
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 40, height: headerHeight)
        rollpeTableView.tableHeaderView = headerView
        
        // 푸터 뷰
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width - 40, height: 40))
        rollpeTableView.tableFooterView = footerView
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
        
        output.rollpeData
            .drive(onNext: { [weak self] data in
                guard let self = self,
                      let data = data
                else { return }
                
                self.amountLabel.text = "총 \(data.data.count)개"
            })
            .disposed(by: disposeBag)
        
        output.rollpeModels
            .map { rollpes in
                return rollpes ?? []
            }
            .drive(rollpeTableView.rx.items(cellIdentifier: "RollpeListCell", cellType: RollpeListTableViewCell.self)) { index, model, cell in
                let length = self.rollpeTableView.numberOfRows(inSection: 0)
                cell.configure(model: model, isLast: index == length - 1)
            }
            .disposed(by: disposeBag)
        
        // 셀 선택
        rollpeTableView.rx.modelSelected(RollpeListDataModel.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                
                rollpeV1ViewModel.selectedRollpeDataModel = model
                rollpeV1ViewModel.getRollpeData(pCode: model.code)
            })
            .disposed(by: disposeBag)
        
        // 페이지네이션
        Observable.combineLatest(rollpeTableView.rx.willDisplayCell, output.rollpeData.asObservable())
            .map { [weak self] cellInfo, data -> (Bool, RollpeResponsePagenationListModel?) in
                guard let self = self else { return (false, nil) }
                
                let (_, indexPath) = cellInfo
                let totalCount = rollpeTableView.numberOfRows(inSection: 0)
                let triggerCount = 3
                
                return (totalCount > triggerCount && indexPath.row >= totalCount - triggerCount, data)
            }
            .distinctUntilChanged { prev, current in
                prev.0 == current.0
            }
            .filter { $0 && $1 != nil }
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _, data in
                guard let self = self, let next = data?.data.next else { return }
                
                viewModel.getMoreRollpes(next: next)
            })
            .disposed(by: disposeBag)
    }
}

#if DEBUG
import SwiftUI

struct InvitedRollpeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            InvitedRollpeViewController()
        }
    }
}
#endif
