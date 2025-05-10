//
//  WhiteHorizontalRollpeV1.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class WhiteHorizontalRollpeV1: UIControl {
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
    
    // 롤페 제목
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .rollpeBlack
        label.font = UIFont(name: "JalnanGothic", size: 52)
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
        self.backgroundColor = .rollpeWhite
        
        self.snp.makeConstraints { make in
            make.width.equalTo(842)
            make.height.equalTo(595)
        }
        
        // 메모 각도
        let degrees: [CGFloat] = [
            -2.72, // 0
             0, // 1
             5.39, // 2
             0.22, // 3
             -1.6, // 4
             2.78, // 5
             3.1, // 6
             -1.98, // 7
             4.03, // 8
             -1.98, // 9
             -0.5, // 10
             -2.83 // 11
        ]
        
        // 메모 좌표
        let positions: [CGPoint] = [
            CGPoint(x: 16.5, y: 26), // 0
            CGPoint(x: 187.5, y: 24), // 1
            CGPoint(x: 344.5, y: 24), // 2
            CGPoint(x: 512.5, y: 21), // 3
            CGPoint(x: 678.5, y: 13), // 4
            CGPoint(x: 34.5, y: 217), // 5
            CGPoint(x: 665.5, y: 210), // 6
            CGPoint(x: 23.5, y: 403), // 7
            CGPoint(x: 188.5, y: 408), // 8
            CGPoint(x: 347.5, y: 393), // 9
            CGPoint(x: 514.5, y: 408), // 10
            CGPoint(x: 673.5, y: 398) // 11
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
        titleLabel.setTextWithLineHeight(text: model.title, lineHeight: 64)
        titleLabel.textAlignment = .center
        
        self.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(416)
            make.center.equalToSuperview()
        }
        
        // 메모를 눌렀을 때 부모에 model 전송
        for (index, memoView) in memoViews.enumerated() {
            memoView.rx
                .tapGesture()
                .when(.recognized)
                .subscribe(onNext: { _ in
                    self.onMemoSelected?(
                        index, model.hearts.data?.first { $0.index == index }
                    )
                })
                .disposed(by: disposeBag)
        }
        
        // response에 따라 메모에 데이터 입력
        for heart in model.hearts.data ?? [] {
            memoViews[heart.index].model = heart
        }
    }
}
