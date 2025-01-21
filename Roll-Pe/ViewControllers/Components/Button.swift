//
//  Button.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import UIKit
import SnapKit

class RollpeButtonPrimary: UIView {
    private let label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.layer.cornerRadius = 8
        self.backgroundColor = .rollpeMain
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(0)
        }
        
        // 터치 감지
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func buttonTapped() {
    }
    
    func setText(_ text: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont(name: "Pretendard-SemiBold", size: 16)!,
                .foregroundColor: UIColor.rollpePrimary,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        label.attributedText = attributedText
        
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.verticalEdges.equalToSuperview().inset(12)
        }
    }
}
