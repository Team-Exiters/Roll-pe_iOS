//
//  MemorialVerticalRollpeV1.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MemorialVerticalRollpeV1: UIControl {
    private let disposeBag = DisposeBag()
    
    var onMemoSelected: ((Int, HeartModel?) -> Void)?
    
    var model: RollpeV1DataModel? {
        didSet {
            if let model = model {
                setInfo(model: model)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // 이미지
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = .imgChrysanthemum
        iv.contentMode = .scaleAspectFill
        iv.layer.opacity = 0.5
        
        return iv
    }()
    
    // 롤페 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rollpeWhite
        label.font = UIFont(name: "NanumMyeongjo", size: 40)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        
        return label
    }()
    
    // 메모지
    private lazy var memoViews = [
        MemoV1(), // 0
        MemoV1(), // 1
        MemoV1(), // 2
        MemoV1(), // 3
        MemoV1(), // 4
        MemoV1(), // 5
        MemoV1(), // 6
        MemoV1(), // 7
        MemoV1(), // 8
        MemoV1(), // 9
        MemoV1(), // 10
        MemoV1() // 11
    ]
    
    private func setup() {
        self.backgroundColor = .rollpeThemeMemorial
        
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(44)
            make.width.equalTo(307)
            make.height.equalTo(125)
            make.centerX.equalToSuperview()
        }
        
        self.snp.makeConstraints { make in
            make.width.equalTo(595)
            make.height.equalTo(842)
        }
        
        // 메모 각도
        let degrees: [CGFloat] = [
            0.86, // 0
            -0.26, // 1
            0.15, // 2
            0.42, // 3
            0.07, // 4
            0.86, // 5
            -0.74, // 6
            0.76, // 7
            1.45, // 8
            -0.11, // 9
            1.23, // 10
            -0.66 // 11
        ]
        
        // 메모 좌표
        let positions: [CGPoint] = [
            CGPoint(x: 13.41, y: 204.5), // 0
            CGPoint(x: 158.34, y: 218.05), // 1
            CGPoint(x: 304.6, y: 207.98), // 2
            CGPoint(x: 448.17, y: 219.5), // 3
            CGPoint(x: 9.82, y: 417.79), // 4
            CGPoint(x: 156.41, y: 424.5), // 5
            CGPoint(x: 301.12, y: 420.01), // 6
            CGPoint(x: 449.77, y: 425.38), // 7
            CGPoint(x: 12.11, y: 631.15), // 8
            CGPoint(x: 157.24, y: 626.64), // 9
            CGPoint(x: 304.44, y: 635.43), // 10
            CGPoint(x: 447.45, y: 629.23) // 11
        ]
        
        // 메모 위치 보정 후 배치
        for (index, memoView) in memoViews.enumerated() {
            let degree = degrees[index]
            let position = positions[index]
            
            self.addSubview(memoView)
            memoView.transform = CGAffineTransform(rotationAngle: degree * .pi / 180)
            
            self.layoutIfNeeded()
            
            let newPosition = calculateMemoV1RotatedPoint(originalX: position.x, originalY: position.y, frameSize: memoView.frame.size)
            
            memoView.snp.makeConstraints { make in
                make.leading.equalTo(newPosition.x)
                make.top.equalTo(newPosition.y)
            }
            
            addShadow(to: memoView)
        }
    }
    
    private func setInfo(model: RollpeV1DataModel) {
        titleLabel.text = model.title
        titleLabel.textAlignment = .center
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(381)
        }
        
        // 메모를 눌렀을 때 부모에 model 전송
        for (index, memoView) in memoViews.enumerated() {
            memoView.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    self.onMemoSelected?(
                        index, model.hearts.data.first { $0.index == index }
                    )
                })
                .disposed(by: disposeBag)
        }
        
        // response에 따라 메모에 데이터 입력
        for heart in model.hearts.data {
            memoViews[heart.index].model = heart
        }
    }
}
