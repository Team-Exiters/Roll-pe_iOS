//
//  Button.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PrimaryButton: UIButton {
    var disabled: Bool = false {
        didSet {
            disableAnimation()
            disabledSubject.accept(disabled)
        }
    }
    
    init(frame: CGRect = .zero, title: String) {
        super.init(frame: frame)
        setup(title: title)
        disableAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(title: "")
        disableAnimation()
    }
    
    private func setup(title: String) {
        self.layer.cornerRadius = 8
        self.backgroundColor = .rollpeMain
        
        // 여백 수정
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let font = UIFont(name: "Pretendard-SemiBold", size: 16) ?? .systemFont(ofSize: 16)
        
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: font,
                .foregroundColor: UIColor.rollpePrimary
            ])
        )
        
        self.configuration = config
    }
    
    private func disableAnimation() {
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = self.disabled ? .rollpeMain.withAlphaComponent(0.5) : .rollpeMain
        }
    }
    
    let disabledSubject = BehaviorRelay<Bool>(value: false)
}

extension Reactive where Base: PrimaryButton {
    var disabled: Observable<Bool> {
        return base.disabledSubject.asObservable()
    }
}

class SecondaryButton: UIButton {
    var config = UIButton.Configuration.plain()
    
    init(frame: CGRect = .zero, title: String, isColorMain: Bool = true) {
        super.init(frame: frame)
        setup(title: title, isColorMain: isColorMain)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(title: "", isColorMain: true)
    }
    
    private func setup(title: String, isColorMain: Bool) {
        self.layer.cornerRadius = 8
        self.backgroundColor = .rollpePrimary
        
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.rollpeMain.cgColor
        
        config.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let font = UIFont(name: "Pretendard-SemiBold", size: 16) ?? .systemFont(ofSize: 16)
        
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer([
                .font: font,
                .foregroundColor: isColorMain ? UIColor.rollpeMain : UIColor.rollpeSecondary
            ])
        )
        
        self.configuration = config
    }
}

class BackButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let image: UIImage = .iconChevronLeft
        self.tintColor = .rollpeSecondary
        self.setImage(image, for: .normal)
        
        self.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(self.snp.width).dividedBy(getImageRatio(image: image))
        }
    }
}
