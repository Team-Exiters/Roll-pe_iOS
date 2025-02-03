//
//  RollpeDetailNotSignedInViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/2/25.
//

import UIKit
import SwiftUI

class RollpeDetailNotSignedInViewController: UIViewController {
    
    private let navigationBar : NavigationBar = {
        let navigationBar = NavigationBar()
        return navigationBar
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        if let logoImage = UIImage(named: "img_logo") {
            imageView.image = logoImage
        } else {
            print("로고 이미지를 불러오는 데 실패했습니다.")
        }
        imageView.contentMode = .scaleAspectFit //비율을 맞추기
        return imageView
    }()

    
    private let firstLabel : UILabel = {
        let label = UILabel()
        label.text = "아쉽게도 롤페는 초대되지 않은 상태면"
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
        label.text = "작성할 수 없어요"
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
    
    private let thirdLabel : UILabel = {
        let label = UILabel()
        label.text = "이미 초대 받으셨다면"
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
    
    private let forthLabel : UILabel = {
        let label = UILabel()
        label.text = "로그인 후 작성해주세요"
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

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .rollpePrimary
        setupNavigationBar()
        setupFirstLabel()
        setupLogo()
        setupSecondLabel()
        setupThirdLabel()
        setupForthLabel()
    }
    
    private func setupNavigationBar(){
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints{make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(100)
        }
    }
    
    private func setupLogo(){
        view.addSubview(logo)
        logo.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(firstLabel.snp.top).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(52)
        }
    }
    private func setupFirstLabel(){
        view.addSubview(firstLabel)
        firstLabel.snp.makeConstraints{make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    private func setupSecondLabel(){
        view.addSubview(secondLabel)
        secondLabel.snp.makeConstraints{make in
            make.top.equalTo(firstLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    private func setupThirdLabel(){
        view.addSubview(thirdLabel)
        thirdLabel.snp.makeConstraints{make in
            make.top.equalTo(secondLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    private func setupForthLabel(){
        view.addSubview(forthLabel)
        forthLabel.snp.makeConstraints{make in
            make.top.equalTo(thirdLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}


struct RollpeDetailNotSignedInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            RollpeDetailNotSignedInViewController()
        }
    }
}
