//
//  Utils.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import Foundation
import UIKit
import SwiftUI

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

// D-day 계산
func dateToDDay(_ endDate: Date) -> String {
    let today = Date()
    let calendar = Calendar.current
    
    guard let daysDifference = calendar.dateComponents([.day], from: today, to: endDate).day else {
        return "Error calculating D-Day"
    }
    
    if daysDifference == 0 {
        return "D-Day"
    } else if daysDifference > 0 {
        return "D-\(daysDifference)"
    } else {
        return "D+\(abs(daysDifference))"
    }
}

// YYYY.M.D 계산
func dateToYYYYMD(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.M.d"
    return dateFormatter.string(from: date)
}

// YYYY년 MM월 DD일 A HH:mm
func dateToYYYYMdahhmm(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy년 M월 d일 a hh:mm"
    return dateFormatter.string(from: date)
}

// 키보드 숨기기
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// textfield 키보드 위치에 따른 뷰 높이 변화
extension UIViewController {
    func changePositionWhenKeyboardUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboard(notification:Notification) {
        guard let keyboardReact = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            self.view.frame.origin.y = -keyboardReact.height
        } else{
            self.view.frame.origin.y = 0
        }
    }
}

// 미리보기
struct UIViewControllerPreview: UIViewControllerRepresentable {
    let viewController: () -> UIViewController
    
    init(_ viewController: @escaping () -> UIViewController) {
        self.viewController = viewController
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        return viewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

// 버튼 여백 수정
extension UIButton {
    func removeConfigurationPadding() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        self.configuration = config
    }
    
    // removeConfigurationPadding를 사용하는 경우 font 적용
    func setFont(_ font: UIFont) {
        self.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            return outgoing
        }
    }
}
