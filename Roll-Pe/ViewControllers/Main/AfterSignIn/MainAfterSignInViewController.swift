//
//  MainAfterSignInViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import UIKit
import SwiftUI
import SnapKit


//절대 손대지말것 , 필요시 의논후 부탁
class MainAfterSignInViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let grayContentView = UIView()
    private let nickNameLabel : UILabel = {
        let label = UILabel()
        label.text = "몽실이는몽몽님은"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "rollpe_secondary")
        return label
    }()
    private let firstLabel : UILabel = {
        let label = UILabel()
        label.text = "15개의 롤페를 만드셨어요"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "rollpe_secondary")
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        return label
    }()
    private let secondLabel : UILabel = {
        let label = UILabel()
        label.text = "15번의 마음을 작성하셨어요"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        return label
    }()
    private let primaryButton = PrimaryButton(title: "초대받은 롤페")
    private let secondaryButton = SecondaryButton(title: "롤페 만들기")
    private let thirdLabel : UILabel = {
        let label = UILabel()
        label.text = "지금 뜨고있는 롤페"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "rollpe_secondary")
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }
        return label
    }()
    
    private var rollpeItems : [RollpeItemModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        view.backgroundColor = .white
        setupScrollView()
        setupNickNameLabel()
        setupFirstLabel()
        setupSecondLabel()
        setupPrimaryButton()
        setupSecondaryButton()
        setupGrayContentView()
        setupThirdLabel()
        setupRollpeItems()
        setupFooter()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = false
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    
    private func setupGrayContentView(){
        contentView.addSubview(grayContentView)
        grayContentView.translatesAutoresizingMaskIntoConstraints = false
        grayContentView.backgroundColor = UIColor(named: "rollpe_section_background")
        NSLayoutConstraint.activate([
            grayContentView.topAnchor.constraint(equalTo: secondaryButton.bottomAnchor,constant: 35),
            grayContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            grayContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            grayContentView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            grayContentView.heightAnchor.constraint(equalToConstant: 626)
        ])
    }
    

    private func setupNickNameLabel() {
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24) {
            nickNameLabel.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            nickNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        }

        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nickNameLabel)

        NSLayoutConstraint.activate([
            nickNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 100),
            nickNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        ])
    }

    private func setupFirstLabel(){
        contentView.addSubview(firstLabel)
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor,constant: 8),
            firstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20)
        ])
    }

    private func setupSecondLabel(){
        contentView.addSubview(secondLabel)
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor,constant: 4),
            secondLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20)
        ])
    }

    private func setupPrimaryButton(){
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(primaryButton)
        NSLayoutConstraint.activate([
            primaryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            primaryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            primaryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            primaryButton.topAnchor.constraint(equalTo: secondLabel.bottomAnchor,constant: 40)
        ])
        primaryButton.addTarget(self, action: #selector(primaryButtonTapped), for: .touchUpInside)
    }
    
    private func setupSecondaryButton(){
        secondaryButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(secondaryButton)
        NSLayoutConstraint.activate([
            secondaryButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            secondaryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            secondaryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            secondaryButton.topAnchor.constraint(equalTo: primaryButton.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupThirdLabel() {
        grayContentView.addSubview(thirdLabel)
        thirdLabel.snp.makeConstraints{ make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(44)
        }
    }
    
    private func setupRollpeItems() {
        let columns = 2
        let spacing: CGFloat = 20 //아이템간의 거리
        let rowSpacing: CGFloat = 12
        let itemWidth: CGFloat = (UIScreen.main.bounds.width - (CGFloat(columns + 1) * spacing)) / CGFloat(columns)
        let itemHeight: CGFloat = 147 //뷰 높이
        
        for (index, model) in rollpeItems.enumerated() {
            let row = index / columns
            let column = index % columns
            
            let rollpeItemView = RollpeItemView(frame: .zero)
            rollpeItemView.configure(
                theme: model.theme ?? "",
                dDay: model.dDay ?? "",
                title: model.title ?? "",
                subtitle: model.subtitle ?? ""
            )
            
            grayContentView.addSubview(rollpeItemView)
            
            rollpeItemView.snp.makeConstraints { make in
                make.width.equalTo(itemWidth)
                make.height.equalTo(itemHeight)
                
                if column == 0 {
                    make.leading.equalToSuperview().offset(spacing)
                } else {
                    make.leading.equalTo(grayContentView.snp.leading).offset(spacing * CGFloat(column + 1) + itemWidth * CGFloat(column))
                }
                
                if row == 0 {
                    make.top.equalTo(thirdLabel.snp.bottom).offset(40)
                } else {
                    make.top.equalTo(thirdLabel.snp.bottom).offset(40 + (itemHeight * CGFloat(row)) + (rowSpacing * CGFloat(row)))
                }
            }
        }
    }
    
    private func setupFooter(){
        let footer = Footer()
        contentView.addSubview(footer)
        footer.snp.makeConstraints{make in
            make.top.equalTo(grayContentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func getData(){
        //여기서 데이터값 뷰모델로 받아오기, 밑에꺼는 임시용
        rollpeItems = [
            RollpeItemModel(theme: "블랙", dDay: "D-5", title: "1타이틀", subtitle: "첫번째입니둥"),
            RollpeItemModel(theme: "화이트", dDay: "D-15", title: "2타이틀", subtitle: "두번째입니둥"),
            RollpeItemModel(theme: "생일", dDay: "D-30", title: "3타이틀", subtitle: "세번째입니둥"),
            RollpeItemModel(theme: "블랙", dDay: "D-7", title: "4타이틀", subtitle: "네번째입니둥"),
            RollpeItemModel(theme: "화이트", dDay: "D-10", title: "5타이틀", subtitle: "다섯번째입니둥"),
            RollpeItemModel(theme: "생일", dDay: "D-20", title: "6타이틀", subtitle: "여섯번째입니둥")
        ]
    }
    
    @objc private func primaryButtonTapped() {
         print("primaryButton 탭")
    }
    @objc private func secondaryButtonTapped() {
        print("secondaryButton 탭")
    }
}


struct MainAfterSignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
                    MainAfterSignInViewController()
                }
    }
}
