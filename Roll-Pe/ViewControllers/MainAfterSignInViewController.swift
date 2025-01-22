//
//  MainAfterSignInViewController.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/22/25.
//

import UIKit
import SwiftUI

class MainAfterSignInViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let nickNameLabel : UILabel = {
        let label = UILabel()
        label.text = "몽실이는몽몽님은"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private let rollpeFirstLabel : UILabel = {
        let label = UILabel()
        label.text = "15개의 롤페를 만드셨어요"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        if let customFont = UIFont(name: "Hakgyoansim-Dunggeunmiso-R", size: 16) {
            label.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        return label
    }()
    
    private let rollpeSecondLabel : UILabel = {
        let label = UILabel()
        label.text = "15번의 마음을 작성하셨어요"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        if let customFont = UIFont(name: "Hakgyoansim-Dunggeunmiso-R", size: 16) {
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
        view.backgroundColor = .white
        setupScrollView()
        setupNickNameLabel()
        setupRollpeFirstLabel()
        setupRollpeSecondLabel()
        setupInvitedRollpeButton()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }
    
    private func setupNickNameLabel() {
        if let customFont = UIFont(name: "Hakgyoansim-Dunggeunmiso-R", size: 24) {
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
    
    private func setupRollpeFirstLabel(){
        contentView.addSubview(rollpeFirstLabel)
        rollpeFirstLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rollpeFirstLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor,constant: 8),
            rollpeFirstLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20)
        ])
    }
    
    private func setupRollpeSecondLabel(){
        contentView.addSubview(rollpeSecondLabel)
        rollpeSecondLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rollpeSecondLabel.topAnchor.constraint(equalTo: rollpeFirstLabel.bottomAnchor,constant: 4),
            rollpeSecondLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor , constant: 20)
        ])
    }
    
    private func setupInvitedRollpeButton(){
        let rollpeButton = RollpeButtonPrimary(title: "초대받은 롤페")
        rollpeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rollpeButton)
        
        NSLayoutConstraint.activate([
            rollpeButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rollpeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rollpeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rollpeButton.topAnchor.constraint(equalTo: rollpeSecondLabel.bottomAnchor,constant: 40)
        ])
        
        // 버튼 액션 추가
        rollpeButton.addTarget(self, action: #selector(rollpeButtonTapped), for: .touchUpInside)
    }
    
    @objc private func rollpeButtonTapped() {
        
    }
}




// 프리뷰니까 이거 보고하셈 ,IOS 16 개병신같다 ㄹㅇ
struct MyViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MainAfterSignInViewController() // UIKit ViewController 연결
        }
    }
}

struct UIViewControllerPreview: UIViewControllerRepresentable {
    let viewController: () -> UIViewController
    
    init(_ viewController: @escaping () -> UIViewController) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
