//
//  RollpeItemView.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 1/25/25.
//

import Foundation
import UIKit
import SnapKit

class RollpeItemView: UIView {
    
    private let upperBackgroundView = UIView()
    private let lowerBackgroundView = UIView()
    private let dDayLabel = BadgeDDay()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private var theme: String?
    
    override init(frame: CGRect = .zero) {
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
        
        addSubview(dDayLabel)
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        addSubview(imageView)
        
        titleLabel.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        titleLabel.textColor = .rollpeSecondary
        addSubview(titleLabel)
        
        
        subtitleLabel.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 12)
        subtitleLabel.textColor = .rollpeGray
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
            make.width.equalTo(42)
            make.height.equalTo(20)
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


