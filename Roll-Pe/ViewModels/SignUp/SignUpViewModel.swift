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
        let isEmailValid = input.email.orEmpty
            .map { email in
                let regex = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"
                return email.range(of: regex, options: .regularExpression) != nil
            }
        
        let isNameValid = input.name.orEmpty
            .map { $0.count >= 2 && $0.count <= 6 }
        
        let isPasswordValid = input.password.orEmpty
            .map { password in
                let regex = "^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,}$"
                return password.range(of: regex, options: .regularExpression) != nil
            }
        
        let isPasswordMatch = Observable
            .combineLatest(input.password.orEmpty, input.confirmPassword.orEmpty)
            .map { $0 == $1 && !$0.isEmpty }
        
        let isAllChecked = Observable.combineLatest(
            input.ageChecked,
            input.termsChecked,
            input.privacyChecked
        ) { $0 && $1 && $2 }
        
        let isSignUpEnabled = Observable.combineLatest(
            isEmailValid,
            isNameValid,
            isPasswordValid,
            isPasswordMatch,
            isAllChecked
        ) { $0 && $1 && $2 && $3 && $4 }
            .asDriver(onErrorJustReturn: false)
        
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
        
        print(body)
        
        isLoading.onNext(true)
        
        AF.request("\(ip)/api/user/signup", method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData { response in
                switch response.result {
                case .success(_):
                    print("회원가입 성공")
                    self.response.onNext(true)
                case .failure(let error):
                    print("Error: \(error)")
                    self.response.onNext(false)
                }
                
                self.isLoading.onNext(false)
            }
    }
}
