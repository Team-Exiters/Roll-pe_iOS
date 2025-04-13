//
//  CountLabel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 3/18/25.
//

import UIKit

class CountLabel: UILabel {
    enum CountType {
        case rollpe
        case heart
    }
    
    var type: CountType
    
    var count: Int = 0 {
        didSet {
            setupLabel()
        }
    }
    
    init(type: CountType, frame: CGRect = .zero) {
        self.type = type
        super.init(frame: frame)
        setup()
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        self.type = .rollpe
        super.init(coder: coder)
        setup()
        setupLabel()
    }
    
    private func setup() {
        self.textAlignment = .center
        self.textColor = .rollpeSecondary
        
        if let customFont = UIFont(name: "HakgyoansimDunggeunmisoOTF-R", size: 16) {
            self.font = customFont
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        
        self.numberOfLines = 1
    }
    
    private func setupLabel() {
        switch type {
        case .rollpe:
            self.text = "\(count)개의 롤페를 만드셨어요."
        case .heart:
            self.text = "\(count)번의 마음을 작성하셨어요."
        }
    }
}

