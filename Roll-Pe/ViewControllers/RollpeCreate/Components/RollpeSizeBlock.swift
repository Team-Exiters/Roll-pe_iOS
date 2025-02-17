//
//  RollpeSizeBlock.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/1/25.
//

import UIKit
import SnapKit

class RollpeSizeBlock: UIView {
    var size: String? {
        didSet {
            setup()
        }
    }
    
    var maximum: Int? {
        didSet {
            setup()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            setSelected()
        }
    }
    
    let labelSize: UILabel = UILabel()
    let labelMaximum: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setSelected()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.layer.cornerRadius = 40
        self.layer.masksToBounds = true
        self.layer.borderWidth = 2
        
        self.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        
        if let size, let maximum {
            let stackView: UIStackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 0
            stackView.alignment = .center
            
            labelSize.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 24)
            labelSize.textAlignment = .center
            labelSize.text = size
            
            labelMaximum.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 10)
            labelMaximum.textAlignment = .center
            labelMaximum.text = "최대 \(maximum)명"
            
            stackView.addArrangedSubview(labelSize)
            stackView.addArrangedSubview(labelMaximum)
            
            self.addSubview(stackView)
            
            stackView.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
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
}
