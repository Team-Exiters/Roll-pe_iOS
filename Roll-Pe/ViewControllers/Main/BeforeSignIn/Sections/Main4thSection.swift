//
//  Main4thSection.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/20/25.
//

import UIKit
import SnapKit

let MainBeforeSignIn4thSection: UIView = {
    let view: UIView = UIView()
    
    view.backgroundColor = .rollpePrimary
    
    let contentView: UIStackView = UIStackView()
    
    contentView.axis = .vertical
    contentView.spacing = 44
    contentView.alignment = .leading
    contentView.backgroundColor = .rollpePrimary
    
    contentView.isLayoutMarginsRelativeArrangement = true
    contentView.layoutMargins = UIEdgeInsets(top: 76, left: 0, bottom: 76, right: 0)
    
    view.addSubview(contentView)
    
    contentView.snp.makeConstraints { make in
        make.width.equalToSuperview()
        make.edges.equalToSuperview()
    }
    
    // 제목
    let titleContainer: UIView = UIView()
    
    contentView.addArrangedSubview(titleContainer)
    
    let title: UILabel = UILabel()
    title.textColor = .rollpeSecondary
    title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 28)
    title.numberOfLines = 2
    title.textAlignment = .left
    title.text = "뜨거운 감동을 나눴던\n롤페들"
    
    titleContainer.addSubview(title)
    
    title.snp.makeConstraints { make in
        make.leading.equalToSuperview().offset(40)
    }
    
    titleContainer.snp.makeConstraints { make in
        make.horizontalEdges.equalToSuperview()
        make.height.equalTo(title.snp.height)
    }
    
    // 롤페들
    let rollpeScrollView: UIScrollView = UIScrollView()
    rollpeScrollView.isPagingEnabled = true
    
    contentView.addArrangedSubview(rollpeScrollView)
    
    rollpeScrollView.snp.makeConstraints { make in
        make.horizontalEdges.equalToSuperview()
        make.width.equalToSuperview()
        make.height.equalTo(199)
    }
    
    let rollpes: UIStackView = UIStackView()
    rollpes.axis = .horizontal
    rollpes.spacing = 20
    rollpes.alignment = .center
    
    rollpeScrollView.addSubview(rollpes)
    
    rollpes.snp.makeConstraints { make in
        make.edges.equalToSuperview()
        make.height.equalToSuperview()
    }
    
    for _ in Array(repeating: 0, count: 5) {
        let rollpeBlock = RollpeBlock(image: "img_rollpe_sample1", titleText: "테스트의 생일을 축하합니다!")
        
        rollpes.addArrangedSubview(rollpeBlock)
    }
    
    view.snp.makeConstraints { make in
        make.height.equalTo(contentView.snp.height)
    }
    
    return view
}()
