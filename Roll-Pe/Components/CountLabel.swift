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
    
    init(count: Int, type: CountType) {
        super.init(frame: .zero)
        setupLabel()
        switch type {
        case .rollpe:
            self.text = "\(count)개의 롤페를 만드셨어요"
        case .heart:
            self.text = "\(count)번의 마음을 작성하셨어요"
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabel()
    }
    
    private func setupLabel() {
        self.textAlignment = .center
        self.textColor = UIColor(named: "rollpe_secondary")
        if let customFont = UIFont(name: "Hakgyoansim-Dunggeunmiso-R", size: 16) {
            self.font = customFont
            print("폰트로드완료")
        } else {
            print("커스텀 폰트를 로드하지 못했습니다.")
            self.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        }
        self.numberOfLines = 1
    }
}

