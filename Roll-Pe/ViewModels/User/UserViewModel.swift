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
    
    let successAlertMessage = PublishSubject<String?>()
    let errorAlertMessage = PublishSubject<String?>()
    
    struct Output {
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
    }
    
    func output() -> Output {
        return Output(
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 내가 작성한 마음 불러오기
    func getMyStatus() {
        apiService.requestDecodable("/api/paper/mypage?type=main", method: .get, decodeType: MyStatusModel.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { model in
                self.myStatus.accept(model)
            }, onError: { error in
                print("내 상태 불러오는 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // 로그아웃
    func logout() {
        keychain.delete(key: "ACCESS_TOKEN")
        keychain.delete(key: "REFRESH_TOKEN")
        keychain.delete(key: "NAME")
        keychain.delete(key: "EMAIL")
        keychain.delete(key: "IDENTITY_CODE")
        keychain.delete(key: "USER_ID")
        keychain.delete(key: "PROVIDER")
        
        UserDefaults.standard.removeObject(forKey: "KEEP_SIGN_IN")
        
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
    
    // 계정 삭제
    func deleteAccount() {
        apiService.request("/api/user/drop-user", method: .delete)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response, data in
                let decoder = JSONDecoder()
                
                do {
                    let model = try decoder.decode(ResponseNoDataModel.self, from: data)
                    
                    if (200..<300).contains(response.statusCode) {
                        self.successAlertMessage.onNext(model.message)
                    } else {
                        self.errorAlertMessage.onNext(model.message)
                    }
                } catch {
                    print("ResponseNoDataModel 변환 실패")
                    print(String(data: data, encoding: .utf8) ?? "")
                    
                    self.onError()
                }
            }, onError: { error in
                print("회원탈퇴 실패: \(error)")
                self.onError()
            })
            .disposed(by: disposeBag)
    }
    
    private func onError() {
        self.errorAlertMessage.onNext("오류가 발생하였습니다.")
    }
}

