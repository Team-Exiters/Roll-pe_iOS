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
    
    private let combinedView = CombinedView()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .rollpePrimary
        setupNavigationBar()
        setupCombinedView()
    }
    
    private func setupNavigationBar(){
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints{make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(100)
        }
    }
    
    private func setupCombinedView(){
        view.addSubview(combinedView)
        combinedView.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
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

class CombinedView : UIView {
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         setupContent()
     }
     
     required init?(coder: NSCoder) {
         super.init(coder: coder)
         setupContent()
     }
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        if let logoImage = UIImage(named: "img_logo") {
            imageView.image = logoImage
        } else {
            print("로고 이미지를 불러오는 데 실패했습니다.")
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    
    private let combinedLabel: UILabel = {
        let label = UILabel()
        label.text = """
        아쉽게도 롤페는 초대되지 않은 상태면
               작성할 수 없어요
        
              이미 초대 받으셨다면
             로그인 후 작성해주세요.
        """
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "rollpe_secondary")
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        
        return label
    }()
    private func setupContent() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(logo)
        stackView.addArrangedSubview(combinedLabel)
        stackView.snp.makeConstraints{make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        logo.snp.makeConstraints { make in
                   make.width.equalTo(100)
                   make.height.equalTo(52)
               }
    }
}
