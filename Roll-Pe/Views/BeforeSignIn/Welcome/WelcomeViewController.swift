//
//  WelcomeViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 11/30/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WelcomeViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        view.backgroundColor = .rollpePrimary
        
        // 스크롤 뷰
        let scrollView: UIScrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .rollpePrimary
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 스크롤 내부 뷰
        let contentView: UIStackView = UIStackView()
        contentView.axis = .vertical
        contentView.spacing = 0
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(-safeareaTop)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(-safeareaBottom)
            make.width.equalToSuperview()
        }
        
        // MARK: - 첫번째 섹션
        
        let firstSection = Welcome1stSecionView()
        
        firstSection.button.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                let vc = SignInViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
        
        contentView.addArrangedSubview(firstSection)
        
        firstSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        // MARK: - 두번째 섹션
        
        let secondSection = Welcome2ndSection
        
        contentView.addArrangedSubview(secondSection)
        
        secondSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        // MARK: - 세번째 섹션
        
        let thirdSection = Welcome3rdSection
        
        contentView.addArrangedSubview(thirdSection)
        
        thirdSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        // MARK: - 메인 네번째 섹션
        
        /*
        let fourthSection = Welcome4thSection
        
        contentView.addArrangedSubview(fourthSection)
        
        fourthSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        */
        
        // MARK: - Footer
        
        let footer = Footer()
        
        contentView.addArrangedSubview(footer)
        
        footer.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}

#if DEBUG
import SwiftUI

struct WelcomeViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            WelcomeViewController()
        }
    }
}
#endif
