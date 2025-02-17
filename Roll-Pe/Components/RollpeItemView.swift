//
//  RollpeItemView.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import Foundation
import UIKit
import SnapKit


//절대 손대지말것 , 필요시 의논후 부탁
class RollpeItemView: UIView {
    
    private let upperBackgroundView = UIView()
    private let lowerBackgroundView = UIView()
    private let dDayLabel = PaddedLabel()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var theme: String?
    
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
        
        addSubview(upperBackgroundView)
        
        lowerBackgroundView.backgroundColor = .rollpePrimary
        addSubview(lowerBackgroundView)
        
        if let font = UIFont(name: "Hakgyoansim-Dunggeunmiso-R", size: 12){
            dDayLabel.font = font
        }
        else{
            dDayLabel.font = UIFont.systemFont(ofSize: 12)
        }
        dDayLabel.textColor = .white
        dDayLabel.textAlignment = .center
        dDayLabel.backgroundColor = UIColor(named: "rollpe_main")
        dDayLabel.layer.cornerRadius = 10
        dDayLabel.layer.masksToBounds = true
        addSubview(dDayLabel)
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .rollpeSecondary
        addSubview(imageView)
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor(named: "rollpe_secondary")
        addSubview(titleLabel)
        
        
        if let font = UIFont(name: "Hakgyoansim-Dunggeunmiso-R", size: 12){
            subtitleLabel.font = font
        }
        else{
            subtitleLabel.font = UIFont.systemFont(ofSize: 12)
        }
        subtitleLabel.textColor = .gray
        addSubview(subtitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        upperBackgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(94)
        }
        
        lowerBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(upperBackgroundView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(53)
        }
        
        dDayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(upperBackgroundView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(lowerBackgroundView.snp.top).inset(12)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().inset(10)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalTo(lowerBackgroundView.snp.bottom).inset(12)
        }
    }
    
    func configureImageView(for theme: String) {
        switch theme {
        case "블랙":
            imageView.image = UIImage(systemName: "pencil")
            upperBackgroundView.backgroundColor = .red
        case "화이트":
            imageView.image = UIImage(systemName: "person")
            upperBackgroundView.backgroundColor = .blue
        case "생일":
            imageView.image = UIImage(systemName: "birthday.cake")
            upperBackgroundView.backgroundColor = .green
        default:
            imageView.image = nil
        }
    }
    
    func configure(theme: String, dDay: String, title: String, subtitle: String) {
        dDayLabel.text = dDay
        titleLabel.text = title
        subtitleLabel.text = subtitle
        self.theme = theme
  
        configureImageView(for: theme)
    }
}

class PaddedLabel: UILabel {
    private let padding = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

    override func drawText(in rect: CGRect) {
        let insets = padding
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}


