//
//  SignInViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/7/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

class SignInViewModel {
    private let ip: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_IP") as! String
    private let keychain = Keychain()
    
    private let disposeBag = DisposeBag()
    private let isLoading = PublishSubject<Bool>()
    private let response = PublishSubject<Bool>()
    private let alertMessage = PublishSubject<String?>()
    
    struct Input {
        let email: ControlProperty<String?>
        let password: ControlProperty<String?>
        let keepSignInChecked: Observable<Bool>
        let signInButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let isSignInEnabled: Driver<Bool>
        let isLoading: Driver<Bool>
        let showAlert: Driver<String?>
        let signInResponse: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        // 이메일 검증
        let isEmailValid = input.email.orEmpty.map { !$0.isEmpty }
        
        // 비밀번호 검증
        let isPasswordValid = input.password.orEmpty.map { !$0.isEmpty }
        
        // 모두 검증이 될 때 로그인 버튼 활성화
        let isSignInEnabled = Observable.combineLatest(
            isEmailValid,
            isPasswordValid
        ) { $0 && $1 }
            .asDriver(onErrorJustReturn: false)
        
        // 버튼 tap event
        input.signInButtonTapEvent
            .observe(on: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(
                input.email.orEmpty,
                input.password.orEmpty,
                input.keepSignInChecked,
                isEmailValid,
                isPasswordValid
            ))
            .subscribe(onNext: { [self] email, password, keepSignIn, emailValid, passwordValid in
                if !emailValid {
                    alertMessage.onNext("이메일을 입력하세요.")
                } else if !passwordValid {
                    alertMessage.onNext("비밀번호를 입력하세요.")
                } else {
                    signIn(email: email, password: password, keepSignIn: keepSignIn)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            isSignInEnabled: isSignInEnabled,
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            showAlert: alertMessage.asDriver(onErrorJustReturn: nil),
            signInResponse: response.asDriver(onErrorJustReturn: false)
        )
    }
    
    // 로그인 API
    private func signIn(email: String, password: String, keepSignIn: Bool) {
        // 헤더
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        // 바디
        let body: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        isLoading.onNext(true)
        
        RxAlamofire.requestData(.post, "\(ip)/api/user/signin", parameters: body, encoding: JSONEncoding.default, headers: headers)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response, data in
                if (200..<300).contains(response.statusCode) {
                    do {
                        let model = try JSONDecoder().decode(SignInModel.self, from: data)
                        self.handleSuccess(model, keepSignIn)
                    } catch {
                        print("SignInModel JSON 디코딩 오류: \(error)")
                        self.response.onNext(false)
                    }
                } else if response.statusCode == 400 {
                    self.handleAuthError(email, data)
                } else {
                    self.response.onNext(false)
                }
                
                self.isLoading.onNext(false)
            }, onError: { error in
                print("로그인 중 오류: \(error)")
                self.response.onNext(false)
                self.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    // 로그인 성공
    private func handleSuccess(_ model: SignInModel, _ keepSignIn: Bool) {
        let isSuccess = model.code == "SUCCESS"
        
        // 토큰 저장
        if isSuccess, let data = model.data {
            keychain.create(key: "ACCESS_TOKEN", value: data.access)
            
            if keepSignIn {
                keychain.create(key: "REFRESH_TOKEN", value: data.refresh)
            }
        }
        
        response.onNext(isSuccess)
    }
    
    // 인증 오류
    private func handleAuthError(_ email: String, _ data: Data?) {
        guard let data = data else {
            response.onNext(false)
            return
        }
        
        do {
            let model = try JSONDecoder().decode(SignInModel.self, from: data)
            
            if model.code == "NOT CERIFIED" {
                self.alertMessage.onNext("이메일 인증되지 않은 계정입니다.\n인증 후 로그인해주세요.")
                self.resendEmailAuthentication(email: email)
            } else {
                self.alertMessage.onNext(model.message)
            }
        } catch {
            response.onNext(false)
        }
    }
    
    // 이메일 인증 재전송 API
    private func resendEmailAuthentication(email: String) {
        // 헤더
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        // 바디
        let body: [String: Any] = [
            "email": email,
            "pathCode": "email"
        ]
        
        RxAlamofire.request(.post, "\(ip)/api/user/verify-email", parameters: body, encoding: JSONEncoding.default, headers: headers)
            .observe(on: MainScheduler.instance)
            .validate(statusCode: 200..<300)
            .responseData()
            .subscribe(onNext: { response, data in
                print("이메일 인증 재전송 완료")
            }, onError: { error in
                print("이메일 인증 재전송 중 오류: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
