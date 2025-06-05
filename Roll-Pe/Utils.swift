//
//  Utils.swift
//  Roll-Pe
//
//  Created by 김태은 on 1/19/25.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Photos

// API 서버 주소
let API_SERVER_URL: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_IP") as! String

// 웹사이트 주소
let WEBSITE_URL: String = "https://haren-dev2.defcon.or.kr"

// safearea
let scenes = UIApplication.shared.connectedScenes
let windowScene = scenes.first as? UIWindowScene
let window = windowScene?.windows.first

let safeareaTop = window?.safeAreaInsets.top ?? 0
let safeareaBottom = window?.safeAreaInsets.bottom ?? 0

// 이메일 정규식
let emailRegex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"

// 비밀번호 정규식(8자 이상, 대소문자, 숫자, 특수문자를 포함)
let passwordRegex = "^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,}$"

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
        return "마감"
    }
}

// YYYY.M.D 계산
func dateToYYYYMD(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.M.d"
    return dateFormatter.string(from: date)
}

// YYYY년 MM월 DD일 계산
func dateToYYYYMd(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "yyyy년 M월 d일"
    return dateFormatter.string(from: date)
}

// YYYY-MM-dd date로 변환
func convertYYYYMMddToDate(_ string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "ko_KR")
    
    return dateFormatter.date(from: string)!
}

// 한글 날짜에서 yyyy-MM-dd 형식으로 변환
func convertDateFormat(_ input: String) -> String? {
    // 입력 형식 정의
    let inputFormatter = DateFormatter()
    inputFormatter.locale = Locale(identifier: "ko_KR")
    inputFormatter.dateFormat = "yyyy년 M월 d일 a h시"
    inputFormatter.amSymbol = "오전"
    inputFormatter.pmSymbol = "오후"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy-MM-dd"
    
    guard let date = inputFormatter.date(from: input) else {
        print("날짜 변환 실패: \(input)")
        return nil
    }
    
    return outputFormatter.string(from: date)
}

// 뷰 컨트롤러 전환
func switchViewController(vc: UIViewController) {
    DispatchQueue.main.async {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = true
        navVC.hideKeyboardWhenTappedAround()
        
        sceneDelegate.window?.rootViewController = navVC
        sceneDelegate.window?.makeKeyAndVisible()
    }
}

// 사진 권한 확인
func checkNotHavaPhotoPermission() -> Bool {
    var status: PHAuthorizationStatus = .notDetermined
    status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
    
    return status == .denied
}

extension UIViewController {
    // 키보드 숨기기
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // RxSwift + 확인 알림창
    func showConfirmAlert(title: String?, message: String?) -> Observable<Void> {
        let result = PublishSubject<Void>()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: { _ in
            result.onNext(())
            result.onCompleted()
        })
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            result.onCompleted()
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
        return result
    }
    
    // Alert 표시
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 뒤로 돌아가는 Alert 표시
    func showAlertAndPop(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension UIStackView {
    // 스택 하위 뷰 제거
    func clear() {
        arrangedSubviews.forEach {
            removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
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

// hex에서 UIColor로 변환
extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let r = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let g = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    var toHex: String? {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            guard self.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
            let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            return String(format: "#%06x", rgb)
        }
}

// UILabel에 line-height 설정
extension UILabel {
    func setTextWithLineHeight(text: String?, lineHeight: CGFloat) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = lineHeight
            style.minimumLineHeight = lineHeight
            
            let attributes: [NSAttributedString.Key: Any] = [
                .paragraphStyle: style,
                .baselineOffset: (lineHeight - font.lineHeight) / 4
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
}

// 미리보기
#if DEBUG
import SwiftUI

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
#endif
