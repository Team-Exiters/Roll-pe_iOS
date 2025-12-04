//
//  ChangePassword.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/10/25.
//

import Foundation
import RxSwift
import RxCocoa

class ChangePasswordViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    private let keychain = Keychain.shared
    
    private let isLoading = BehaviorSubject<Bool>(value: false)
    private let successAlertMessage = PublishSubject<String?>()
    private let errorAlertMessage = PublishSubject<String?>()
    private let criticalAlertMessage = PublishSubject<String?>()
    
    struct Input {
        let password: ControlProperty<String?>
        let confirmPassword: ControlProperty<String?>
        let buttonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let isButtonEnabled: Driver<Bool>
        let isLoading: Driver<Bool>
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
        let criticalAlertMessage: Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        // 비밀번호 검증
        let isPasswordValid = input.password.orEmpty
            .map { password in
                return password.range(of: passwordRegex, options: .regularExpression) != nil
            }
        
        // 비밀번호 확인 검증
        let isPasswordMatch = Observable
            .combineLatest(input.password.orEmpty, input.confirmPassword.orEmpty)
            .map { $0 == $1 && !$0.isEmpty }
        
        let isButtonEnabled = isPasswordMatch
            .asDriver(onErrorJustReturn: false)
        
        input.buttonTapEvent
            .observe(on: MainScheduler.instance)
            .withLatestFrom(
                Observable.combineLatest(
                    input.password.orEmpty,
                    isPasswordValid,
                    isPasswordMatch
                )
            )
            .subscribe(onNext: { [weak self] password, isPasswordValid, isPasswordMatch in
                guard let self = self else { return }
                
                if !isPasswordValid {
                    self.errorAlertMessage.onNext("비밀번호는 8자 이상, 대소문자, 숫자, 특수문자를 포함해야 합니다.")
                } else if !isPasswordMatch {
                    self.errorAlertMessage.onNext("비밀번호가 일치하지 않습니다.")
                } else {
                    
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            isButtonEnabled: isButtonEnabled,
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 비밀번호 변경 API
    private func changePassword(password: String) {
        guard let refresh = keychain.read(key: "REFRESH_TOKEN") else {
            onError()
            return
        }
        
        let body: [String: Any] = [
            "refresh": refresh,
            "password": password
        ]
        
        apiService.request("/api/user/change-password", method: .patch, parameters: body)
            .observe(on: MainScheduler.instance)
            .do(onSubscribe: {
                self.isLoading.onNext(true)
            })
            .subscribe(onNext: { response, data in
                let decoder = JSONDecoder()
                
                do {
                    let model = try decoder.decode(ResponseNoDataModel.self, from: data)
                    
                    if (200..<300).contains(response.statusCode) {
                        self.successAlertMessage.onNext(model.message)
                    } else {
                        self.criticalAlertMessage.onNext(model.message)
                    }
                } catch {
                    print("ResponseNoDataModel 변환 실패")
                    print(String(data: data, encoding: .utf8) ?? "")
                    
                    self.onError()
                }
            }, onError: { error in
                print("비밀번호 변경 중 오류 발생: \(error)")
                self.onError()
            }, onDisposed: {
                self.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func onError() {
        self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
    }
}
