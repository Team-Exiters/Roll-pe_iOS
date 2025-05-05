//
//  ForgotPasswordViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/15/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class ForgotPasswordViewModel {
    private let disposeBag = DisposeBag()
    
    private let isLoading = BehaviorSubject<Bool>(value: false)
    private let successAlertMessage = PublishSubject<String?>()
    private let errorAlertMessage = PublishSubject<String?>()
    
    struct Input {
        let email: ControlProperty<String?>
        let verifyButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let isVerifyEnabled: Driver<Bool>
        let isLoading: Driver<Bool>
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        // 이메일 검증
        let isEmailValid = input.email.orEmpty
            .map { email in
                return email.range(of: emailRegex, options: .regularExpression) != nil
            }
        
        let isVerifyEnabled = isEmailValid
            .asDriver(onErrorJustReturn: false)
        
        input.verifyButtonTapEvent
            .withLatestFrom(
                Observable.combineLatest(
                    input.email.orEmpty,
                    isEmailValid
                )
            )
            .subscribe(onNext: { [weak self] email, isEmailValid in
                guard let self = self else { return }
                
                if !isEmailValid {
                    self.errorAlertMessage.onNext("이메일을 다시 확인하세요.")
                } else {
                    sendEmail(email: email)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            isVerifyEnabled: isVerifyEnabled,
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 이메일 전송 API
    private func sendEmail(email: String) {
        // 헤더
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        // 바디
        let body: [String: Any] = [
            "email": email
        ]
        
        RxAlamofire.requestData(.post, "\(API_SERVER_URL)/api/user/forgot-password", parameters: body, encoding: JSONEncoding.default, headers: headers)
            .observe(on: MainScheduler.instance)
            .do(onSubscribe: {
                self.isLoading.onNext(true)
            })
            .subscribe(onNext: { response, data in
                if (200..<300).contains(response.statusCode) {
                    do {
                        let model = try JSONDecoder().decode(ResponseNoDataModel.self, from: data)
                        self.successAlertMessage.onNext(model.message)
                    } catch {
                        self.errorAlertMessage.onNext("오류가 발생하였습니다.")
                    }
                } else {
                    do {
                        let model = try JSONDecoder().decode(ResponseNoDataModel.self, from: data)
                        self.errorAlertMessage.onNext(model.message)
                    } catch {
                        self.errorAlertMessage.onNext("오류가 발생하였습니다.")
                    }
                }
            }, onError: { error in
                print("비밀번호 찾기 오류: \(error)")
                self.errorAlertMessage.onNext("오류가 발생하였습니다.")
            }, onDisposed: {
                self.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
}
