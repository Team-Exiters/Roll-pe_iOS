//
//  Spacer.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/9/25.
//

import UIKit

class Spacer: UIView {
    init(axis: NSLayoutConstraint.Axis, frame: CGRect = .zero) {
        super.init(frame: frame)
        setup(axis: axis)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(axis: .vertical)
    }
    
    private func setup(axis: NSLayoutConstraint.Axis) {
        self.setContentHuggingPriority(.defaultLow, for: axis)
    }
}
