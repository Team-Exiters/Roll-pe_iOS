//
//  SearchViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchViewController: BaseRollpeV1ViewController, UITableViewDelegate {
    private let viewModel = SearchRollpeViewModel()
    
    // MARK: - 요소
    
    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "진행 중인 롤페를 검색해요."
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24)
        
        return label
    }()
    
    // 검색 바
    private lazy var searchBar: RoundedBorderTextField = {
        let textField = RoundedBorderTextField()
        textField.placeholder = "검색어를 입력하세요."
        textField.rightViewMode = .always
        textField.rightView = searchButton
        textField.returnKeyType = .search
        
        return textField
    }()
    
    // 검색 아이콘 버튼
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
        let tv = UITableView()
        tv.backgroundColor = .rollpePrimary
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 88
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    // 더 불러오기 버튼
    private let getMoreButton: SecondaryButton = {
        let button = SecondaryButton(title: "더 불러오기", isColorMain: false)
        button.layer.borderColor = UIColor.rollpeSecondary.cgColor
        
        return button
    }()
    
    // 노 데이터 뷰
    private let noDataView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 40
        sv.alignment = .center
        
        let icon = UIImageView()
        icon.image = .iconX
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .rollpeGray
        icon.snp.makeConstraints { make in
            make.size.equalTo(64)
        }
        sv.addArrangedSubview(icon)
        
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .rollpeGray
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.text = "검색 결과가 없습니다."
        sv.addArrangedSubview(label)
        
        return sv
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        rollpeTableView.register(SearchRollpeTableViewCell.self, forCellReuseIdentifier: "SearchRollpeCell")
        
        setupUI()
        bind()
    }
    
    // MARK: - UI 구성
    
    private func setupUI() {
        amountLabel.isHidden = true
        getMoreButton.isHidden = true
        
        setupTableView()
        setupTableHeader()
        addSideMenuButton()
    }
    
    // TableView 설정
    private func setupTableView() {
        view.addSubview(rollpeTableView)
        
        rollpeTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    // TableView Header 설정
    private func setupTableHeader() {
        let headerView = UIView()
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(searchBar)
        headerView.addSubview(amountLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.horizontalEdges.equalToSuperview()
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(76)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // Header 높이 계산
        let headerHeight: CGFloat = 40 + titleLabel.intrinsicContentSize.height + 20 + searchBar.intrinsicContentSize.height + 76 + amountLabel.intrinsicContentSize.height
        headerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 40, height: headerHeight)
        
        if rollpeTableView.backgroundView != nil {
            noDataView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset((headerHeight - 76 - amountLabel.intrinsicContentSize.height) / 2)
            }
        }
        
        rollpeTableView.tableHeaderView = headerView
    }
    
    // TableView Footer 설정
    private func setupTableFooter(hasMore: Bool) {
        getMoreButton.isHidden = !hasMore
        
        if hasMore {
            let footerView = UIView()
            footerView.addSubview(getMoreButton)
            
            getMoreButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(32)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().inset(4)
                make.height.equalTo(48)
            }
            
            // Footer 높이 계산
            let footerHeight: CGFloat = 32 + 48 + 4
            footerView.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 40, height: footerHeight)
            
            rollpeTableView.tableFooterView = footerView
        } else {
            rollpeTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 40))
        }
    }
    
    // 검색 결과 UI 업데이트
    private func updateTableView(rollpeModels: [RollpeListDataModel], hasMore: Bool) {
        if rollpeModels.isEmpty {
            rollpeTableView.isScrollEnabled = false
            rollpeTableView.backgroundView = noDataView
            amountLabel.isHidden = true
            setupTableFooter(hasMore: false)
        } else {
            rollpeTableView.isScrollEnabled = true
            rollpeTableView.backgroundView = nil
            amountLabel.isHidden = false
            setupTableFooter(hasMore: hasMore)
        }
        
        setupTableHeader()
    }
    
    // 사이드 메뉴
    private func addSideMenuButton() {
        let sideMenuView = SidemenuView(highlight: "검색")
        sideMenuView.parentViewController = self
        
        let buttonSideMenu = ButtonSideMenu()
        
        view.addSubview(buttonSideMenu)
        
        buttonSideMenu.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        buttonSideMenu.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.view.addSubview(sideMenuView)
                sideMenuView.showMenu()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Bind
    
    private func bind() {
        let input = SearchRollpeViewModel.Input(
            word: searchBar.rx.text,
            keyboardTapEvent: searchBar.rx.controlEvent(.editingDidEndOnExit),
            searchButtonTapEvent: searchButton.rx.tap,
            getMoreButtonTapEvent: getMoreButton.rx.tap
        )
        
        let output = viewModel.transform(input)
        
        output.showOKAlert
            .drive(onNext: { [weak self] message in
                if let message = message {
                    self?.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
        
        output.rollpeData
            .drive(onNext: { [weak self] data in
                guard let self = self, let data = data else { return }
                
                amountLabel.text = "총 \(data.data.count)개의 검색 결과"
            })
            .disposed(by: disposeBag)
        
        // TableView 데이터 바인딩
        output.rollpeModels
            .map { rollpes in
                let rollpes = rollpes ?? []
                return (rollpes).enumerated().map {
                    ($0.element, rollpes.count)
                }
            }
            .drive(rollpeTableView.rx.items(
                cellIdentifier: "SearchRollpeCell",
                cellType: SearchRollpeTableViewCell.self
            )) { index, data, cell in
                let (model, length) = data
                cell.configure(model: model, isLast: index == length - 1)
            }
            .disposed(by: disposeBag)
        
        // UI 업데이트
        Driver.combineLatest(output.rollpeModels, output.rollpeData)
            .drive(onNext: { [weak self] rollpeModels, rollpeData in
                guard let self = self, let models = rollpeModels else { return }
                
                let hasMore = rollpeData?.data.next != nil
                updateTableView(rollpeModels: models, hasMore: hasMore)
            })
            .disposed(by: disposeBag)
        
        // 셀 선택
        rollpeTableView.rx.modelSelected((RollpeListDataModel, Int).self)
            .subscribe(onNext: { [weak self] (model, length) in
                guard let self = self else { return }
                
                rollpeV1ViewModel.selectedRollpeDataModel = model
                rollpeV1ViewModel.getRollpeData(pCode: model.code)
            })
            .disposed(by: disposeBag)
    }
}

// table view cell
class SearchRollpeTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let rollpeListItem = RollpeSearchListItem()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .rollpeGray
        view.layer.cornerRadius = 1
        
        return view
    }()
    
    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(rollpeListItem)
        contentView.addSubview(separatorView)
    }
    
    func configure(model: RollpeListDataModel, isLast: Bool) {
        rollpeListItem.configure(model: model)
        
        rollpeListItem.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        separatorView.snp.remakeConstraints { make in
            make.top.equalTo(rollpeListItem.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(isLast ? 0 : 2)
        }
    }
}

#if DEBUG
import SwiftUI

struct SearchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SearchViewController()
        }
    }
}
#endif
