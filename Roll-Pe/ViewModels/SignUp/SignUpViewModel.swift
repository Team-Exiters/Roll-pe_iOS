//
//  SignupViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/8/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire

final class SignUpViewModel {
    private let disposeBag = DisposeBag()
    
    private let isLoading = PublishSubject<Bool>()
    private let alertMessage = PublishSubject<String?>()
    private let response = PublishSubject<Bool>()
    
    struct Input {
        let email: ControlProperty<String?>
        let name: ControlProperty<String?>
        let password: ControlProperty<String?>
        let confirmPassword: ControlProperty<String?>
        let ageChecked: Observable<Bool>
        let termsChecked: Observable<Bool>
        let privacyChecked: Observable<Bool>
        let signUpButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let isSignUpEnabled: Driver<Bool>
        let isLoading: Driver<Bool>
        let showAlert: Driver<String?>
        let signUpResponse: Driver<Bool>
    }
    
    func transform(_ input: Input) -> Output {
        // 이메일 검증
        let isEmailValid = input.email.orEmpty
            .map { email in
                let regex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"
                return email.range(of: regex, options: .regularExpression) != nil
            }
        
        // 닉네임 검증
        let isNameValid = input.name.orEmpty
            .map { $0.count >= 2 && $0.count <= 6 }
        
        // 비밀번호 검증
        let isPasswordValid = input.password.orEmpty
            .map { password in
                let regex = "^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,}$"
                return password.range(of: regex, options: .regularExpression) != nil
            }
        
        // 비밀번호 확인 검증
        let isPasswordMatch = Observable
            .combineLatest(input.password.orEmpty, input.confirmPassword.orEmpty)
            .map { $0 == $1 && !$0.isEmpty }
        
        // 약관 모두 동의 검증
        let isAllChecked = Observable.combineLatest(
            input.ageChecked,
            input.termsChecked,
            input.privacyChecked
        ) { $0 && $1 && $2 }
        
        // 모두 검증이 될 때 가입 버튼 활성과
        let isSignUpEnabled = Observable.combineLatest(
            isEmailValid,
            isNameValid,
            isPasswordValid,
            isPasswordMatch,
            isAllChecked
        ) { $0 && $1 && $2 && $3 && $4 }
            .asDriver(onErrorJustReturn: false)
        
        // 버튼 tap event
        input.signUpButtonTapEvent
            .withLatestFrom(Observable.combineLatest(
                input.email.orEmpty,
                input.name.orEmpty,
                input.password.orEmpty,
                isEmailValid,
                isNameValid,
                isPasswordValid,
                isPasswordMatch,
                isAllChecked
            ))
            .subscribe(onNext: { [self] email, name, password, isEmailValid, isNameValid, isPasswordValid, isPasswordMatch, isAllChecked in
                if !isEmailValid {
                    alertMessage.onNext("이메일을 다시 확인하세요.")
                } else if !isNameValid {
                    alertMessage.onNext("닉네임은 2-6자로 적어주세요.")
                } else if !isPasswordValid {
                    alertMessage.onNext("비밀번호는 8자 이상, 대소문자, 숫자, 특수문자를 포함해야 합니다.")
                } else if !isPasswordMatch {
                    alertMessage.onNext("비밀번호가 일치하지 않습니다.")
                } else if !isAllChecked {
                    alertMessage.onNext("약관에 동의해주세요.")
                } else {
                    signUp(name: name, email: email, password: password)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            isSignUpEnabled: isSignUpEnabled,
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            showAlert: alertMessage.asDriver(onErrorJustReturn: nil),
            signUpResponse: response.asDriver(onErrorJustReturn: false)
        )
    }
    
    // 회원가입 API
    private func signUp(name: String, email: String, password: String) {
        let ip: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_IP") as! String
        
        // 헤더
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        // 바디
        let body: [String: Any] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        isLoading.onNext(true)
        
        RxAlamofire.requestData(.post, "\(ip)/api/user/signup", parameters: body, encoding: JSONEncoding.default, headers: headers)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { response, data in
                if (200..<300).contains(response.statusCode) {
                    self.response.onNext(true)
                } else if response.statusCode == 400 {
                    self.handleFailure(data)
                } else {
                    self.response.onNext(false)
                }
                
                self.isLoading.onNext(false)
            }, onError: { error in
                print("회원가입 오류: \(error)")
                self.response.onNext(false)
                self.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    // 회원가입 오류
    private func handleFailure(_ data: Data?) {
        guard let data = data else {
            response.onNext(false)
            return
        }
        
        do {
            let model = try JSONDecoder().decode(SignUpModel.self, from: data)
            self.alertMessage.onNext(model.message)
        } catch {
            response.onNext(false)
        }
    }
}
