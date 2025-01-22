//
//  RollpeBlock.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/21/25.
//

import UIKit
import SnapKit

func RollpeBlock(image: String, titleText: String) -> UIView {
    let view: UIView = UIView()
    
    view.layer.cornerRadius = 16
    view.layer.borderWidth = 2
    view.layer.borderColor = UIColor.rollpeSecondary.cgColor
    
    view.snp.makeConstraints { make in
        make.width.equalTo(170)
        make.height.equalTo(199)
    }
    
    let contentView: UIStackView = UIStackView()
    
    contentView.translatesAutoresizingMaskIntoConstraints = false
    contentView.axis = .vertical
    contentView.spacing = 0
    contentView.alignment = .center
    contentView.distribution = .fill
    
    view.addSubview(contentView)
    
    contentView.snp.makeConstraints { make in
        make.top.equalToSuperview().inset(24)
        make.horizontalEdges.equalToSuperview()
        make.width.equalToSuperview()
        make.height.equalToSuperview()
    }
    
    // MARK: - 이미지
    let imageView: UIImageView = UIImageView()
    let image: UIImage! = UIImage(named: image)
    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    
    contentView.addArrangedSubview(imageView)
    
    // 가로형
    imageView.snp.makeConstraints { make in
        make.horizontalEdges.equalToSuperview().inset(16)
        make.width.greaterThanOrEqualTo(1)
        make.height.equalTo(imageView.snp.width).dividedBy(getImageRatio(image: image!))
    }
    
    // MARK: - 제목
    
    let title: UILabel = UILabel()
    title.textColor = .rollpeSecondary
    title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
    title.numberOfLines = 1
    title.textAlignment = .center
    title.lineBreakMode = .byTruncatingTail
    title.text = titleText
    
    contentView.addArrangedSubview(title)
    
    title.snp.makeConstraints { make in
        make.width.equalToSuperview().inset(16)
        make.top.greaterThanOrEqualTo(8)
        make.horizontalEdges.equalToSuperview().inset(16)
        make.centerX.equalToSuperview()
    }
    
    contentView.setCustomSpacing(24, after: title)
    
    return view
}
