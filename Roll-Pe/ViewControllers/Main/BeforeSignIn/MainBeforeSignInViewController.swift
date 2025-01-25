//
//  ViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 11/30/24.
//

import UIKit
import SnapKit
import SwiftUI

class MainBeforeSignInViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .rollpePrimary
        
        // 스크롤 뷰
        let scrollView: UIScrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.backgroundColor = .rollpePrimary
        scrollView.bounces = false
        
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
            make.top.equalToSuperview().inset(safeareaTop * -1)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(safeareaBottom * -1)
            make.width.equalToSuperview()
        }
        
        // MARK: - 메인 상단 섹션
        
        let mainTopSection = MainBeforeSignInTopSecionView()
        
        contentView.addArrangedSubview(mainTopSection)
        
        mainTopSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height)
        }
        
        // MARK: - 메인 두번째 섹션
        
        let main2ndSection = MainBeforeSignIn2ndSection()
        
        contentView.addArrangedSubview(main2ndSection)
        
        main2ndSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        // MARK: - 메인 세번째 섹션
        
        let main3rdSection = MainBeforeSignIn3rdSection()
        
        contentView.addArrangedSubview(main3rdSection)
        
        main3rdSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        // MARK: - 메인 네번째 섹션
        
        let main4thSection = MainBeforeSignIn4thSection()
        
        contentView.addArrangedSubview(main4thSection)
        
        main4thSection.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        // MARK: - Footer
        
        let footer = Footer()
        
        contentView.addArrangedSubview(footer)
        
        footer.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}

struct MainBeforeSignInViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            MainBeforeSignInViewController() // UIKit ViewController 연결
        }
    }
}
