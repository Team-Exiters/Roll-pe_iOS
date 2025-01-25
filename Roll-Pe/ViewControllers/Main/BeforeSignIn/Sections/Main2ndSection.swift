//
//  Main2ndSection.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/20/25.
//

import UIKit
import SnapKit

func MainBeforeSignIn2ndSection() -> UIView {
    let view: UIView = UIView()
    
    view.backgroundColor = .rollpePrimary
    
    let contentView: UIStackView = UIStackView()
    
    contentView.axis = .vertical
    contentView.spacing = 44
    contentView.alignment = .leading
    contentView.backgroundColor = .rollpePrimary
    
    contentView.layoutMargins = UIEdgeInsets(top: 44, left: 0, bottom: 52, right: 0)
    
    view.addSubview(contentView)
    
    contentView.snp.makeConstraints { make in
        make.top.equalToSuperview()
        make.horizontalEdges.equalToSuperview().inset(40)
        make.bottom.equalToSuperview()
    }
    
    // 제목
    let title: UILabel = UILabel()
    title.textColor = .rollpeSecondary
    title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 28)
    title.numberOfLines = 2
    title.textAlignment = .left
    title.text = "쉽게 만드는\n우리만의 롤페"
    
    contentView.addArrangedSubview(title)
    
    // 이미지
    let imageView: UIImageView = UIImageView()
    let image: UIImage = .imgMain2NdSection
    imageView.image = image
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    
    contentView.addArrangedSubview(imageView)
    
    imageView.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.height.equalTo(imageView.snp.width).dividedBy(getImageRatio(image: image))
    }
    
    view.snp.makeConstraints { make in
        make.height.equalTo(contentView.snp.height)
    }
    
    return view
}
