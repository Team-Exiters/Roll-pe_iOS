//
//  Button.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import UIKit
import SnapKit

// 태은꺼
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


//여기서부터 동혁이코드
class PrimaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "")
    }
    private func setupButton(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = 8
        self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        self.backgroundColor = UIColor(named: "rollpe_main")
        self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
}

class SecondaryButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        setupButton(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton(title: "")
    }
    
    private func setupButton(title: String) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor(named: "rollpe_main"), for: .normal)
        self.layer.cornerRadius = 8
        self.contentEdgeInsets = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
        self.backgroundColor = UIColor(named: "rollpe_primary")
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(named: "rollpe_main")?.cgColor
        self.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
}
