//
//  RollpeSizeBlock.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/1/25.
//

import UIKit
import SnapKit

class RollpeSizeBlock: UIButton {
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
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        sv.alignment = .center
        sv.isUserInteractionEnabled = false
        
        return sv
    }()
    
    let labelSize: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24)
        label.textAlignment = .center
        
        return label
    }()
    
    let labelMaximum: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 10)
        label.textAlignment = .center
        
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
        self.layer.cornerRadius = 40
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        
        stackView.addArrangedSubview(labelSize)
        stackView.addArrangedSubview(labelMaximum)
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
    }
    
    private func setSelected() {
        if isSelected {
            self.alpha = 1
            self.layer.borderColor = UIColor.rollpeSecondary.cgColor
            labelSize.textColor = .rollpeSecondary
            labelMaximum.textColor = .rollpeSecondary
        } else {
            self.alpha = 0.5
            self.layer.borderColor = UIColor.rollpeGray.cgColor
            labelSize.textColor = .rollpeGray
            labelMaximum.textColor = .rollpeGray
        }
    }
    
    private func configure() {
        if let model {
            switch model.name {
            case "A4": labelMaximum.text = "최대 \(13)명"
            default: break
            }
            
            labelSize.text = model.name
        }
    }
}
