//
//  UserViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/18/25.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class UserViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    private let keychain = Keychain.shared
    
    // 현재 나의 롤페/마음 작성 횟수
    let myStatus = BehaviorRelay<MyStatusModel?>(value: nil)
    
    // 내 롤페 불러오기
    func getMyRollpes() {
        
    }
    
    // 초대받은 롤페 불러오기
    func getInvitedRollpes() {
        
    }
    
    // 내가 작성한 마음 불러오기
    func getMyStatus() {
        apiService.requestDecodable("/api/paper/mypage?type=main", method: .get, decodeType: MyStatusModel.self)
            .subscribe(onNext: { model in
                self.myStatus.accept(model)
            }, onError: { error in
                print("내 상태 불러오는 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    public func logout() {
        keychain.delete(key: "ACCESS_TOKEN")
        keychain.delete(key: "REFRESH_TOKEN")
        keychain.delete(key: "NAME")
        keychain.delete(key: "EMAIL")
        keychain.delete(key: "IDENTITY_CODE")
        
        DispatchQueue.main.async {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            if let rootVC = window?.rootViewController {
                let alertController = UIAlertController(title: "오류", message: "재로그인이 필요합니다", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LOGOUT"), object: nil)
                }))
                
                rootVC.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
