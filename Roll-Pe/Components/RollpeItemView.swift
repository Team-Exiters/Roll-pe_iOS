//
//  RollpeItemView.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import Foundation
import UIKit
import SnapKit
import MarqueeLabel

class RollpeItemView: UIView {
    private let topSection = UIView()
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let badgeDDay = BadgeDDay()
    
    private let bottomSection = {
        let view = UIView()
        view.backgroundColor = .rollpePrimary
        
        return view
    }()
    
    private let titleLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 8.0, fadeLength: 10.0)
        
        if let font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
            label.font = font
        } else {
            label.font = UIFont.systemFont(ofSize: 16)
        }
        
        label.numberOfLines = 1
        label.textColor = .rollpeSecondary
        
        return label
    }()
    
    private let nameLabel = {
        let label = MarqueeLabel(frame: .zero, duration: 8.0, fadeLength: 10.0)
        
        if let font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 12) {
            label.font = font
        }
        else{
            label.font = UIFont.systemFont(ofSize: 12)
        }
        
        label.numberOfLines = 1
        label.textColor = .rollpeGray
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        
        // 윗 섹션
        addSubview(topSection)
        topSection.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(94)
        }
        
        topSection.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.48)
        }
        
        topSection.addSubview(badgeDDay)
        badgeDDay.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
        }
        
        // 아래 섹션
        addSubview(bottomSection)
        bottomSection.snp.makeConstraints { make in
            make.top.equalTo(topSection.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // 제목
        bottomSection.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        // 이름
        bottomSection.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configureTopSection(_ theme: String?) {
        switch theme {
        case "화이트":
            topSection.backgroundColor = .rollpeWhite
        case "블랙":
            topSection.backgroundColor = .rollpeBlack
        case "생일":
            topSection.backgroundColor = .rollpePink
            imageView.image = .iconBirthdayCake
        default:
            topSection.backgroundColor = .rollpeWhite
        }
    }
    
    func configure(model: RollpeItemModel) {
        configureTopSection(model.theme.name)
        badgeDDay.text = dateToDDay(convertYYYYMMddToDate(model.receivingDate))
        titleLabel.text = model.title
        nameLabel.text = model.hostName
    }
}
