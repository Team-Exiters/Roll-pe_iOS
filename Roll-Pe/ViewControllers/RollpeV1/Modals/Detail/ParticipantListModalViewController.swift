//
//  ParticipantListModalViewController.swift
//  Roll-Pe
//
//  Created by 김태은 on 14/4/25.
//

import UIKit
import SnapKit
import RxSwift

class ParticipantListModalViewController: UIViewController, UITableViewDelegate {
    private let disposeBag = DisposeBag()
    
    // MARK: - 요소
    
    private let contentView = {
        let view = UIView()
        view.backgroundColor = .rollpePrimary
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let closeButton : UIButton = {
        let button = UIButton()
        let icon = UIImage.iconX
        icon.withTintColor(.rollpeSecondary)
        
        button.setImage(.iconX, for: .normal)
        button.setImage(.iconX, for: .highlighted)
        button.tintColor = .rollpeSecondary
        
        return button
    }()
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "참여자 목록"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 28) {
            label.font = customFont
        } else {
            label.font = UIFont.systemFont(ofSize: 28)
        }
        
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(ParticipantListModalTableViewCell.self, forCellReuseIdentifier: "ParticipantCell")
        
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 46
        
        tv.backgroundColor = .rollpePrimary
        tv.layer.borderWidth = 2.0
        tv.layer.borderColor = UIColor.rollpeSecondary.cgColor
        tv.layer.cornerRadius = 16.0
        tv.layer.masksToBounds = true
        tv.separatorStyle = .none
        
        // 내용 여백
        tv.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        
        return tv
    }()
    
    // MARK: - 생명주기
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.hideKeyboardWhenTappedAround()
        
        setUI()
    }
    
    // MARK: - UI 구성
    
    private func setUI() {
        setupContentView()
        setupCloseButton()
        setupTitle()
        setupTableView()
    }
    
    // 내부 뷰
    private func setupContentView() {
        view.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.center.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height * 0.62)
        }
    }
    
    // 닫기 버튼
    private func setupCloseButton() {
        contentView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(20)
        }
        
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    // 제목
    private func setupTitle() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton)
        }
    }
    
    // 테이블 뷰
    private func setupTableView() {
        tableView.delegate = self
        
        contentView.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-24)
        }
    }
}

// table view cell
class ParticipantListModalTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 20)
        label.textColor = .rollpeSecondary
        
        return label
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .rollpeGray
        view.layer.cornerRadius = 1
        
        return view
    }()
    
    private let kickImageView: UIImageView = {
        let iv = UIImageView()
        let image: UIImage = .iconDeny
        iv.image = image
        iv.tintColor = .rollpeStatusDanger
        
        return iv
    }()
    
    private let reportImageView: UIImageView = {
        let iv = UIImageView()
        let image: UIImage = .iconSiren.withRenderingMode(.alwaysOriginal)
        iv.image = image
        
        return iv
    }()
    
    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        contentView.addSubview(label)
        contentView.addSubview(kickImageView)
        contentView.addSubview(reportImageView)
    }
    
    func configure(model: SearchUserResultModel, isLast: Bool) {
        label.text = "\(model.name)(\(model.identifyCode))"
        
        separatorView.removeFromSuperview()
        
        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            if isLast {
                make.bottom.equalToSuperview().inset(12)
            }
        }
        
        reportImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-16)
            make.size.equalTo(20)
            if isLast {
                make.bottom.equalToSuperview().inset(12)
            }
        }
        
        kickImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalTo(reportImageView.snp.leading).offset(-12)
            make.size.equalTo(20)
            if isLast {
                make.bottom.equalToSuperview().inset(12)
            }
        }
        
        if !isLast {
            contentView.addSubview(separatorView)
            
            separatorView.snp.makeConstraints { make in
                make.top.equalTo(label.snp.bottom).offset(12)
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().priority(.low)
                make.height.equalTo(2)
            }
        }
        
    }
}

#if DEBUG
import SwiftUI

struct ParticipantListViewControllerPreview: PreviewProvider {
    static var previews: some View {
        UIViewControllerPreview {
            ParticipantListModalViewController()
        }
    }
}
#endif
