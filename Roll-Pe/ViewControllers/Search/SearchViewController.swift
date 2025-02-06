//
//  SearchViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/26/25.
//

import UIKit
import SnapKit
import SwiftUI
import RxSwift
import RxCocoa

class SearchViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let dummyDatas: [RollpeSearchListItemModel] = [
        RollpeSearchListItemModel(id: 1, receiverDate: Date(), theme: "블랙", dDay: "D-102", title: "축하해", createdUser: "test", createdAt: Date()),
        RollpeSearchListItemModel(id: 2, receiverDate: Date(), theme: "생일", dDay: "D-365", title: "축하해", createdUser: "test", createdAt: Date()),
        RollpeSearchListItemModel(id: 3, receiverDate: Date(), theme: "생일", dDay: "D-365", title: "축하해", createdUser: "test", createdAt: Date()),
        RollpeSearchListItemModel(id: 4, receiverDate: Date(), theme: "생일", dDay: "D-365", title: "축하해", createdUser: "test", createdAt: Date()),
        RollpeSearchListItemModel(id: 5, receiverDate: Date(), theme: "생일", dDay: "D-365", title: "축하해", createdUser: "test", createdAt: Date()),
        RollpeSearchListItemModel(id: 6, receiverDate: Date(), theme: "생일", dDay: "D-365", title: "축하해", createdUser: "test", createdAt: Date()),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.changePositionWhenKeyboardUp()
        
        view.backgroundColor = .rollpePrimary
        
        // 스크롤 뷰
        let scrollView: UIScrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .rollpePrimary
        
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(safeareaTop)
            make.horizontalEdges.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 사이드 메뉴
        let sideMenuView = SidemenuView(menuIndex: 1)
        let buttonSideMenu: UIButton = ButtonSideMenu()
        
        view.addSubview(buttonSideMenu)
        
        buttonSideMenu.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(80)
            make.trailing.equalToSuperview().inset(20)
        }
        
        buttonSideMenu.rx.tap
            .subscribe(onNext: {
                self.view.addSubview(sideMenuView)
                sideMenuView.showMenu()
            })
            .disposed(by: disposeBag)
        
        // 스크롤 내부 뷰
        let contentView: UIView = UIView()
        contentView.backgroundColor = .rollpePrimary
        contentView.layoutMargins = UIEdgeInsets(top: 120, left: 0, bottom: 40, right: 0)
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(40)
            make.width.equalToSuperview().offset(-40)
        }
        
        // 제목
        let title: UILabel = UILabel()
        title.text = "진행 중인 롤페를 검색해요."
        title.textAlignment = .left
        title.numberOfLines = 0
        title.textColor = .rollpeSecondary
        title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24)
        
        contentView.addSubview(title)
        
        title.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.leading.equalToSuperview()
        }
        
        // 검색어 입력
        let textField = TextField()
        textField.placeholder = "검색어를 입력하세요."
        
        let searchButton: UIButton = {
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
        
        textField.rightViewMode = .always
        textField.rightView = searchButton
        textField.rightViewMode = .always
        textField.rightView = searchButton
        
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
        }
        
        // MARK: - 검색 결과
        
        // 검색 결과 개수
        let amountLabel: UILabel = UILabel()
        amountLabel.text = "총 \(dummyDatas.count)개의 검색 결과"
        amountLabel.textAlignment = .left
        amountLabel.numberOfLines = 0
        amountLabel.textColor = .rollpeSecondary
        amountLabel.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        
        contentView.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(76)
        }
        
        // 목록
        let listView: UIStackView = UIStackView()
        listView.axis = .vertical
        listView.spacing = 20
        listView.alignment = .leading
        
        contentView.addSubview(listView)
        
        listView.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        for (index, data) in dummyDatas.enumerated() {
            let itemView = RollpeSearchListItem(data)
            
            listView.addArrangedSubview(itemView)
            
            itemView.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview()
            }
            
            // 구분선
            if index != dummyDatas.count - 1 {
                let separatorView: UIView = UIView()
                separatorView.backgroundColor = .rollpeGray
                separatorView.layer.cornerRadius = 1
                separatorView.layer.masksToBounds = true
                
                listView.addArrangedSubview(separatorView)
                
                separatorView.snp.makeConstraints { make in
                    make.height.equalTo(2)
                    make.horizontalEdges.equalToSuperview()
                }
            } else {
                listView.setCustomSpacing(32, after: itemView)
            }
        }
        
        let getMoreButton = SecondaryButton(title: "더 불러오기")
        getMoreButton.layer.borderColor = UIColor.rollpeSecondary.cgColor
        getMoreButton.setTitleColor(.rollpeSecondary, for: .normal)
        
        listView.addArrangedSubview(getMoreButton)
        
        getMoreButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
    }
}

struct SearchViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            SearchViewController()
        }
    }
}
