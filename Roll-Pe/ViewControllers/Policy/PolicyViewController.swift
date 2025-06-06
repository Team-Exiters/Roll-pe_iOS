//
//  PolicyViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 6/4/25.
//

import UIKit
import SnapKit
import WebKit
import RxSwift

class PolicyViewController: UIViewController, WKNavigationDelegate {
    let policy: String
    let isModal: Bool
    
    init(_ policy: String, isModal: Bool = false) {
        self.policy = policy
        self.isModal = isModal
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let disposeBag = DisposeBag()
    private let viewModel = PolicyViewModel()
    var webViewHeightConstraint: Constraint?
    
    // MARK: - 요소
    
    // 내부 뷰
    private let contentView: UIView = UIView()
    
    // 로고
    private lazy var logo: UIImageView = {
        let iv = UIImageView()
        iv.image = logoImage
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    // 로고 이미지
    private let logoImage = UIImage.imgLogo
    
    // 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rollpeSecondary
        label.font = UIFont(name: "Pretendard-Regular", size: 20)
        
        return label
    }()
    
    // 웹뷰
    private let webView: WKWebView = {
        let wb = WKWebView()
        wb.scrollView.isScrollEnabled = false
        
        return wb
    }()

    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        view.backgroundColor = .rollpePrimary

        // UI 설정
        setupContentView()
        setupLogo()
        setupTitle()
        setupWebView()
        
        if !isModal {
            addBack()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Bind
        bind()
    }
    
    // MARK: - UI 구성
    
    // 뒤로가기
    private func addBack() {
        let back = BackButton()
        
        back.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        view.addSubview(back)
        
        back.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(20)
        }
    }
    
    // 내부 뷰
    private func setupContentView() {
        let scrollView: UIScrollView = UIScrollView()
        scrollView.bounces = false
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // 로고
    private func setupLogo() {
        contentView.addSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(80)
            make.width.equalTo(104)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: logoImage))
            make.centerX.equalToSuperview()
        }
    }
    
    // 제목
    private func setupTitle() {
        switch policy {
        case "terms": titleLabel.text = "서비스 이용약관"
        case "privacy": titleLabel.text = "개인정보처리방침"
        default: titleLabel.text = ""
        }
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    // 웹뷰
    private func setupWebView() {
        webView.navigationDelegate = self
        contentView.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            self.webViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }

    // MARK: - Bind
    
    private func bind() {
        viewModel.getHtml(policy)
        
        let output = viewModel.transform()
        
        output.htmlCode
            .drive(onNext: { html in
                self.webView.loadHTMLString(html, baseURL: nil)
            })
            .disposed(by: disposeBag)
        
        output.criticalAlertMessage
            .drive(onNext: { message in
                if let message = message {
                    self.showOKAlert(title: "오류", message: message) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Delegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // JavaScript로 webview 높이 측정
        webView.evaluateJavaScript("document.body.scrollHeight") { [weak self] (height, error) in
            guard let height = height as? CGFloat else { return }
            self?.webViewHeightConstraint?.update(offset: height)
        }
    }
}

#if DEBUG
import SwiftUI

struct PolicyViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            PolicyViewController("")
        }
    }
}
#endif
