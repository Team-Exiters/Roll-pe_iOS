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

class SearchViewController: UIViewController, UITableViewDelegate {
    private let disposeBag = DisposeBag()
    private let viewModel = SearchRollpeViewModel()
    private let rollpeV1ViewModel = RollpeV1ViewModel()
    
    // MARK: - 요소
    
    // 내부 뷰
    private let contentView: UIView = UIView()
    
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
        let tv = AutoHeightTableView()
        
        tv.backgroundColor = .rollpePrimary
        tv.separatorStyle = .none
        tv.estimatedRowHeight = 90
        tv.isScrollEnabled = false
        
        // 내용 여백
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return tv
    }()
    
    // 더 불러오기 버튼
    private let getMoreButton = {
        let button = SecondaryButton(title: "더 불러오기", isColorMain: false)
        button.layer.borderColor = UIColor.rollpeSecondary.cgColor
        
        return button
    }()
    
    // 노 데이터 뷰
    private let noDataView: UIView = {
        let view = UIView()
        
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
        
        view.addSubview(sv)
        
        sv.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return view
    }()
    
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        rollpeTableView.delegate = self
        rollpeTableView.register(SearchRollpeTableViewCell.self, forCellReuseIdentifier: "SearchRollpeCell")
        
        // UI 설정
        setUI()
        
        // Bind
        bindRollpeViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        rollpeTableView.dataSource = nil
        
        // Bind
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        rollpeV1ViewModel.isPushed = false
    }
    
    // MARK: - UI 구성
    
    private func setUI() {
        view.backgroundColor = .rollpePrimary
        
        setupContentView()
        setupTitle()
        setupSearchBar()
        addSideMenuButton()
    }
    
    // 사이드 메뉴
    private func addSideMenuButton() {
        let sideMenuView = SidemenuView(highlight: "검색")
        let buttonSideMenu: UIButton = ButtonSideMenu()
        
        view.addSubview(buttonSideMenu)
        
        buttonSideMenu.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.trailing.equalToSuperview().inset(20)
        }
        
        buttonSideMenu.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.view.addSubview(sideMenuView)
                sideMenuView.showMenu()
            })
            .disposed(by: disposeBag)
    }
    
    // 내부 뷰
    private func setupContentView() {
        // 스크롤 뷰
        let scrollView: UIScrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.greaterThanOrEqualTo(UIScreen.main.bounds.height - (safeareaTop + safeareaBottom))
        }
    }
    
    // 제목
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview()
        }
    }
    
    // 검색란
    private func setupSearchBar() {
        contentView.addSubview(searchBar)
        
        searchBar.snp.remakeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    // 검색 결과 UI 초기화
    private func resetResult() {
        amountLabel.removeFromSuperview()
        rollpeTableView.removeFromSuperview()
        getMoreButton.removeFromSuperview()
        noDataView.removeFromSuperview()
    }
    
    // 검색 결과 개수
    private func setupAmountLabel() {
        contentView.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(76)
        }
    }
    
    // 더 불러오기 버튼
    private func setupGetMoreButton() {
        contentView.addSubview(getMoreButton)
        
        getMoreButton.snp.makeConstraints { make in
            make.top.equalTo(rollpeTableView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }
    
    // 검색 결과 없음
    private func setupNoDataView() {
        contentView.addSubview(noDataView)
        
        noDataView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(76)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
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
            .drive(rollpeTableView.rx.items(cellIdentifier: "SearchRollpeCell", cellType: SearchRollpeTableViewCell.self)) { index, data, cell in
                let (model, length) = data
                cell.configure(model: model, isLast: index == length - 1)
            }
            .disposed(by: disposeBag)
        
        Driver.combineLatest(output.rollpeModels, output.rollpeData)
            .drive(onNext: { [weak self] rollpeModels, rollpeData in
                guard let self = self,
                      let rollpeModels = rollpeModels,
                      let rollpeData = rollpeData else { return }
                
                DispatchQueue.main.async {
                    self.resetResult()
                    
                    if rollpeModels.isEmpty {
                        self.setupNoDataView()
                    } else {
                        self.amountLabel.text = "총 \(rollpeModels.count)개의 검색 결과"
                        
                        self.setupAmountLabel()
                        self.contentView.addSubview(self.rollpeTableView)
                        
                        self.rollpeTableView.snp.remakeConstraints { make in
                            make.top.equalTo(self.amountLabel.snp.bottom)
                            make.horizontalEdges.equalToSuperview()
                            make.height.equalTo(self.rollpeTableView.contentSize.height)
                            
                            if rollpeData.data.next == nil && self.rollpeTableView.contentSize.height > UIScreen.main.bounds.height - (safeareaTop + safeareaBottom) {
                                make.bottom.equalToSuperview().inset(40)
                            }
                        }
                        
                        if rollpeData.data.next != nil {
                            self.setupGetMoreButton()
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

extension SearchViewController {
    // bind
    private func bindRollpeViewModel() {
        let output = rollpeV1ViewModel.transform()
        
        output.needEnter
            .emit(onNext: { needEnter in
                if let needEnter = needEnter,
                   let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel,
                   !self.rollpeV1ViewModel.isPushed {
                    if needEnter {
                        if rollpeDataModel.viewStat { // 공개
                            self.confirmEnterRollpe()
                        } else { // 비공개
                            self.showPasswordTextFieldAlert()
                        }
                    } else {
                        self.navigationController?.pushViewController(RollpeV1DetailViewController(pCode: rollpeDataModel.code), animated: true)
                        self.rollpeV1ViewModel.isPushed = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.isEnterSuccess
            .emit(onNext: { isEnterSuccess in
                if let isEnterSuccess = isEnterSuccess,
                   let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel,
                   !self.rollpeV1ViewModel.isPushed {
                    if isEnterSuccess {
                        self.navigationController?.pushViewController(RollpeV1DetailViewController(pCode: rollpeDataModel.code), animated: true)
                        self.rollpeV1ViewModel.isPushed = true
                    }
                }
            })
            .disposed(by: disposeBag)
        
        output.errorAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 입장 확인
    private func confirmEnterRollpe() {
        guard let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel else {
            return
        }
        
        self.showConfirmAlert(title: "알림", message: "\(rollpeDataModel.title) 롤페에 입장하시겠습니까?")
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.rollpeV1ViewModel.enterRollpe(pCode: rollpeDataModel.code)
            })
            .disposed(by: disposeBag)
    }
    
    // 비밀번호를 통한 입장
    private func showPasswordTextFieldAlert() {
        let alertController = UIAlertController(title: "롤페 입장하기", message: "비밀번호를 입력하세요", preferredStyle: .alert)
        
        alertController.addTextField { field in
            
        }
        
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            if let textField = alertController.textFields?.first,
               let rollpeDataModel = self.rollpeV1ViewModel.selectedRollpeDataModel {
                self.rollpeV1ViewModel.enterRollpe(pCode: rollpeDataModel.code, password: textField.text)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        self.present(alertController, animated: true, completion: nil)
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
    }
    
    func configure(model: RollpeListDataModel, isLast: Bool) {
        rollpeListItem.configure(model: model)
        separatorView.removeFromSuperview()
        
        if isLast {
            rollpeListItem.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().inset(20)
            }
            
        } else {
            rollpeListItem.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(20)
                make.horizontalEdges.equalToSuperview()
            }
            
            contentView.addSubview(separatorView)
            
            separatorView.snp.remakeConstraints { make in
                make.top.equalTo(rollpeListItem.snp.bottom).offset(20)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().priority(.low)
                make.height.equalTo(2)
            }
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
