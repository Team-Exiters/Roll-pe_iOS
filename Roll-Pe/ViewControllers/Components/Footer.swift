//
//  Footer.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/20/25.
//

import UIKit
import SnapKit

class Footer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.backgroundColor = UIColor.teamExiters.cgColor
        
        let contentView: UIStackView = UIStackView()
        
        contentView.axis = .vertical
        contentView.spacing = 0
        contentView.alignment = .center
        
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = UIEdgeInsets(top: 28, left: 0, bottom: 32, right: 0)
        
        self.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // MARK: - 팀 로고
        
        let logo: UIImageView = UIImageView()
        let image: UIImage! = UIImage(named: "TeamLogo")
        logo.image = image
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        
        contentView.addArrangedSubview(logo)
        
        logo.snp.makeConstraints { make in
            make.width.equalTo(192)
            make.height.equalTo(logo.snp.width).dividedBy(getImageRatio(image: image!))
        }
        
        contentView.setCustomSpacing(24, after: logo)
        
        // MARK: - 이메일
        
        let email: UILabel = UILabel()
        email.textColor = .rollpePrimary
        email.font = UIFont(name: "Pretendard-Regular", size: 10)
        email.numberOfLines = 1
        email.textAlignment = .center
        email.text = "team.exiters@gmail.com"
        
        contentView.addArrangedSubview(email)
        
        email.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        contentView.setCustomSpacing(2, after: email)
        
        // MARK: - 저작권
        
        let copyright: UILabel = UILabel()
        copyright.textColor = .rollpePrimary
        copyright.font = UIFont(name: "Pretendard-Regular", size: 10)
        copyright.numberOfLines = 1
        copyright.textAlignment = .center
        copyright.text = "Copyright 2025 Team Exiters. All rights reserved."
        
        contentView.addArrangedSubview(copyright)
        
        copyright.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(contentView.snp.height)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
