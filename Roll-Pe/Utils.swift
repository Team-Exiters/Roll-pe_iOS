//
//  Utils.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import Foundation
import UIKit

// safearea
let scenes = UIApplication.shared.connectedScenes
let windowScene = scenes.first as? UIWindowScene
let window = windowScene?.windows.first
let safeareaTop = window?.safeAreaInsets.top ?? 0
let safeareaBottom = window?.safeAreaInsets.bottom ?? 0

// 이미지 비율 계산
func getImageRatio(image: UIImage) -> CGFloat {
    return image.size.width / image.size.height
}
