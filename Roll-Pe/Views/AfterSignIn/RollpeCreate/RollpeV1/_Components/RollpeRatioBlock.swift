//
//  RollpeRatioBlock.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/31/25.
//

import UIKit
import SnapKit

class RollpeRatioBlock: UIButton {
    override var isSelected: Bool {
        didSet {
            setSelected()
        }
    }
    
    var model: QueryIndexDataModel? {
        didSet {
            configure()
        }
    }
    
    let icon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        
        return iv
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setSelected()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setSelected()
    }
    
    private func setup() {
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 2
        
        self.addSubview(icon)
        
        icon.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12).priority(.high)
            make.top.lessThanOrEqualToSuperview().inset(24).priority(.required)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.size.lessThanOrEqualTo(80)
            make.bottom.greaterThanOrEqualToSuperview().inset(48)
        }
        
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(140)
        }
    }
    
    private func setSelected() {
        if isSelected {
            self.alpha = 1
            self.layer.borderColor = UIColor.rollpeSecondary.cgColor
            label.textColor = .rollpeSecondary
        } else {
            self.alpha = 0.5
            self.layer.borderColor = UIColor.rollpeGray.cgColor
            label.textColor = .rollpeGray
        }
    }
    
    private func configure() {
        if let model {
            switch model.name {
            case "가로": icon.image = .imgPaperHorizontal
            case "세로": icon.image = .imgPaperVertical
            default: break
            }
            
            label.text = model.name
        }
    }
}
