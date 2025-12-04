//
//  Styles.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/22/25.
//

import UIKit

// 그림자 추가
func addShadow(
    to view: UIView,
    color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25),
    opacity: Float = 1,
    radius: CGFloat = 4,
    offset: CGSize = CGSize(width: 0, height: 4)
) {
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = opacity
    view.layer.shadowRadius = radius
    view.layer.shadowOffset = offset
    view.layer.masksToBounds = false
}
