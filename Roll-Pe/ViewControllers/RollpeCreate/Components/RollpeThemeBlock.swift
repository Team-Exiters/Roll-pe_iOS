//
//  RollpeThemeBlock.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/1/25.
//

import UIKit

class RollpeThemeBlock: UIStackView {
    var view: UIView? {
        didSet {
            update()
        }
    }
    
    var label: UILabel? {
        didSet {
            update()
        }
    }
    
    var isSelected: Bool = false {
        didSet {
            setSelect()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setSelect()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.axis = .vertical
        self.spacing = 16
        self.alignment = .center
    }
    
    private func update() {
        if let view, let label {
            self.addArrangedSubview(view)
            self.addArrangedSubview(label)
        }
    }
    
    private func setSelect() {
        if isSelected {
            self.alpha = 1
            if let label {
                label.textColor = .rollpeSecondary
            }
        } else {
            self.alpha = 0.5
            if let label {
                label.textColor = .rollpeGray
            }
        }
    }
}
