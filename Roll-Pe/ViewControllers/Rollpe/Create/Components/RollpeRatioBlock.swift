//
//  RollpeRatioBlock.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/31/25.
//

import UIKit
import SnapKit

class RollpeRatioBlock: UIView {
    var image: String? {
        didSet {
            setup()
        }
    }
    
    var text: String? {
        didSet {
            setup()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            setSelected()
        }
    }
    
    let title: UILabel = UILabel()
    let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        
        self.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(140)
        }
        
        if let text, let image {
            // 이미지
            let image: UIImage! = UIImage(named: image)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            
            self.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(12).priority(.high)
                make.top.lessThanOrEqualToSuperview().inset(24).priority(.required)
                make.horizontalEdges.equalToSuperview().inset(20)
                make.size.lessThanOrEqualTo(80)
                make.bottom.greaterThanOrEqualToSuperview().inset(48)
            }
            
            // 내용
            title.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
            title.numberOfLines = 1
            title.textAlignment = .center
            title.lineBreakMode = .byTruncatingTail
            title.text = text
            
            self.addSubview(title)
            
            title.snp.makeConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(12)
                make.centerX.equalToSuperview()
            }
        }
    }
    
    private func setSelected() {
        if isSelected {
            self.alpha = 1
            self.layer.borderColor = UIColor.rollpeSecondary.cgColor
            title.textColor = .rollpeSecondary
        } else {
            self.alpha = 0.5
            self.layer.borderColor = UIColor.rollpeGray.cgColor
            title.textColor = .rollpeGray
        }
    }
}
