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

class SignInViewModel {
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
    
    // API
    private func signIn(email: String, password: String, keepSignIn: Bool) {
        let ip: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_IP") as! String
        let keychain = Keychain()
        
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
        
        AF.request("\(ip)/api/user/signin", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: SignInModel.self) { response in
                if let data = response.data, let dataString = String(data: data, encoding: .utf8) {
                    print(dataString)
                }
                
                switch response.result {
                case .success(let model):
                    let isSuccess = model.code == "SUCCESS"
                    
                    // SUCCESS일 때 토큰 keychain에 저장
                    if isSuccess, let data = model.data {
                        keychain.create(key: "ACCESS_TOKEN", value: data.access)
                        
                        // 로그인 유지 시
                        if keepSignIn {
                            keychain.create(key: "REFRESH_TOKEN", value: data.refresh)
                        }
                    }
                    
                    self.response.onNext(isSuccess)
                case .failure(let error):
                    print("로그인 중 오류: \(error)")
                    self.response.onNext(false)
                }
                
                self.isLoading.onNext(false)
            }
    }
}
