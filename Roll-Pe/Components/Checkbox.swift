//
//  Checkbox.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/24/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class Checkbox: UIButton {
    private let disposeBag = DisposeBag()
    
    let isCheckedSubject = BehaviorRelay<Bool>(value: false)
    
    var isChecked: Bool = false {
        didSet {
            updateCheckbox()
            isCheckedSubject.accept(isChecked)
        }
    }
    
    private let checkmarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .rollpeMain
        view.layer.cornerRadius = 1
        view.tag = 2
        view.isUserInteractionEnabled = false
        
        return view
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.rollpeGray.cgColor
        self.backgroundColor = .rollpePrimary
        
        self.snp.makeConstraints { make in
            make.size.equalTo(20)
        }
        
        self.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.isChecked.toggle()
            })
            .disposed(by: disposeBag)
        
        updateCheckbox()
    }
    
    private func updateCheckbox() {
        if isChecked {
            self.addSubview(checkmarkView)
            
            checkmarkView.snp.makeConstraints { make in
                make.size.equalTo(10)
                make.center.equalToSuperview()
            }
        } else {
            self.subviews.filter { $0.tag == 2 }.forEach { $0.removeFromSuperview() }
        }
    }
}

extension Reactive where Base: Checkbox {
    var isChecked: Observable<Bool> {
        return base.isCheckedSubject.asObservable()
    }
}
