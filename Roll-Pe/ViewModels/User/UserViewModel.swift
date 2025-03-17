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
import Alamofire

class UserViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    private let keychain = Keychain.shared
    
   
    let myStatus = BehaviorRelay<MyStatusModel?>(value: nil)
    let myRollpe = BehaviorRelay<[RollpeListItemModel]?>(value: nil)
    let invitedRollpe = BehaviorRelay<[RollpeListItemModel]?>(value: nil)
    let equalToCurrentPassword = BehaviorRelay<Bool?>(value: nil)
    let serverResponse = BehaviorRelay<String?>(value: nil)
    let navigationPop = BehaviorRelay<Bool?>(value: nil)
    
    
    // 내 롤페 불러오기
    func getMyRollpes() {
        apiService.requestDecodable("/api/paper/mypage?type=my", method: .get, decodeType: [RollpeListItemModel]?.self)
            .subscribe(onNext: { model in
                self.myRollpe.accept(model)
            }, onError: { error in
                print("내 롤페 불러오는 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // 초대받은 롤페 불러오기
    func getInvitedRollpes() {
        apiService.requestDecodable("/api/paper/mypage?type=inviting", method: .get, decodeType: [RollpeListItemModel]?.self)
            .subscribe(onNext: { model in
                self.invitedRollpe.accept(model)
            }, onError: { error in
                print("초대받은 롤페 불러오는 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
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
    
    // 기존 비밀번호와 동일한지 확인하기
    func checkPassword(password:String) {
        let parameters: [String: Any] = ["password": password]
        apiService.requestDecodable("/api/user/password-check", method: .post,parameters: parameters ,decodeType: Bool.self)
            .subscribe(onNext: { model in
                self.equalToCurrentPassword.accept(model)
                print("요청값:\(model)")
            }, onError: { error in
                print("비밀번호 일치 확인 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // 비밀번호 변경확정 하기
    func changePassword(password: String) {
        let parameters: [String: Any] = ["password": password]
        return apiService.requestDecodable("/api/user/change-password",
                                           method: .patch,
                                           parameters: parameters,
                                           decodeType: String.self)
        .subscribe(onNext: { model in
            self.serverResponse.accept(model)
            self.navigationPop.accept(true)
        }, onError: { error in
            print("changePassword함수 에러:\(error)")
            self.serverResponse.accept("오류가 발생하였습니다")
        })
        .disposed(by: disposeBag)
    }

    
    
    func logout() {
        keychain.delete(key: "ACCESS_TOKEN")
        keychain.delete(key: "REFRESH_TOKEN")
        keychain.delete(key: "NAME")
        keychain.delete(key: "EMAIL")
        keychain.delete(key: "IDENTITY_CODE")
        keychain.delete(key: "PROVIDER")
        
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
    
    func deleteAccount() {
        apiService.requestDecodable("/api/user/drop-user",
                                    method: .delete,decodeType: String.self)
            .subscribe(onNext: { model in
                self.serverResponse.accept(model)
                self.logout()
            }, onError: { error in
                print("회원탈퇴 실패: \(error)")
                self.serverResponse.accept("오류가 발생하였습니다")
            })
            .disposed(by: disposeBag)
    }
    
    func isValidPassword(_ password: String) -> Bool {
         let pattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
         return predicate.evaluate(with: password)
     }
}

