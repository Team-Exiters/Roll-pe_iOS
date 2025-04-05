//
//  MemoV1.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/20/25.
//

import UIKit
import SnapKit

class MemoV1: UIView {
    var model: HeartModel? {
        didSet {
            if let model = model {
                setMemo(model: model)
            }
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .rollpeBlack
        label.font = UIFont(name: "NanumPenOTF", size: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        
        return label
    }()
    
    private let dashedBorder: CAShapeLayer = {
        let border = CAShapeLayer()
        border.strokeColor = UIColor.rollpeBlack.cgColor
        border.lineDashPattern = [2, 2]
        border.lineWidth = 1
        border.lineJoin = .round
        border.fillColor = nil
        
        return border
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    // 기본 설정
    private func setup() {
        self.backgroundColor = .rollpeGray.withAlphaComponent(0.5)
        
        // 점선 효과 추가
        self.layer.addSublayer(dashedBorder)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(140)
            make.height.equalTo(160)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if label.text == nil || label.text!.isEmpty {
            dashedBorder.frame = self.bounds
            dashedBorder.path = UIBezierPath(rect: self.bounds).cgPath
        } else {
            dashedBorder.removeFromSuperlayer()
        }
    }
    
    private func setMemo(model: HeartModel) {
        
        setBackground(color: model.color)
        setText(content: model.content, author: model.author.name)
    }
    
    // 배경 설정
    private func setBackground(color: String) {
        self.backgroundColor = UIColor(hex: color)
    }
    
    // 라벨 설정
    private func setText(content: String, author: String) {
        label.text = "\(content)\n- \(author)"
        
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
            make.center.equalToSuperview()
        }
    }
}

// 메모 회전 후 위치 재계산 함수
func calculateMemoV1RotatedPoint(originalX: CGFloat, originalY: CGFloat, frameSize: CGSize) -> CGPoint {
    let width: CGFloat = 140
    let height: CGFloat = 160
    
    let newX = originalX + ((frameSize.width - width) / 2)
    let newY = originalY + ((frameSize.height - height) / 2)
    
    let newPosition = CGPoint(x: newX, y: newY)
    
    return newPosition
}
