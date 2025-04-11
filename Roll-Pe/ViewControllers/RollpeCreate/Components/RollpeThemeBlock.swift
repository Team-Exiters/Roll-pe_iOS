//
//  RollpeThemeBlock.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/1/25.
//

import UIKit
import SnapKit

class RollpeThemeBlock: UIButton {
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
    
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.alignment = .center
        sv.isUserInteractionEnabled = false
        
        return sv
    }()
    
    let preview: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16)
        label.textColor = .rollpeSecondary
        
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
        stackView.addArrangedSubview(preview)
        
        preview.snp.makeConstraints { make in
            make.size.equalTo(80)
        }
        
        stackView.addArrangedSubview(label)
        
        self.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setSelected() {
        if isSelected {
            self.alpha = 1
            label.textColor = .rollpeSecondary
        } else {
            self.alpha = 0.5
            label.textColor = .rollpeGray
        }
    }
    
    private func configure() {
        if let model {
            switch model.name {
            case "화이트":
                preview.backgroundColor = .rollpeWhite
                preview.layer.borderColor = UIColor.rollpeBlack.cgColor
                preview.layer.borderWidth = 2
            case "추모":
                preview.backgroundColor = .rollpeThemeMemorial
            case "축하":
                preview.backgroundColor = .rollpeThemeCongrats
                let congratsIcon: UIImageView = UIImageView()
                let congratsIconImage: UIImage = .iconBirthdayCake
                
                congratsIcon.image = congratsIconImage
                congratsIcon.contentMode = .scaleAspectFit
                preview.addSubview(congratsIcon)
                
                congratsIcon.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(0.575)
                    make.height.equalTo(congratsIcon.snp.width).dividedBy(getImageRatio(image: congratsIconImage))
                }
            default: break
            }
            
            label.text = model.name
        }
    }
}
