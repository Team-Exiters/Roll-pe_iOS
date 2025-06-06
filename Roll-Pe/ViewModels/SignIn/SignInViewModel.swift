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
import KakaoSDKUser
import RxKakaoSDKUser
import AuthenticationServices

class SignInViewModel: NSObject, ObservableObject, ASAuthorizationControllerDelegate {
    private let disposeBag = DisposeBag()
    private let keychain = Keychain.shared
    
    private let isLoading = BehaviorSubject<Bool>(value: false)
    private let response = PublishSubject<Bool>()
    private let errorAlertMessage = PublishSubject<String?>()
    
    struct Input {
        let email: ControlProperty<String?>
        let password: ControlProperty<String?>
        let keepSignInChecked: Observable<Bool>
        let signInButtonTapEvent: ControlEvent<Void>
        let kakaoButtonTapEvent: ControlEvent<Void>
        let appleButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let isSignInEnabled: Driver<Bool>
        let isLoading: Driver<Bool>
        let errorAlertMessage: Driver<String?>
        let response: Driver<Bool>
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
                input.email,
                input.password,
                input.keepSignInChecked,
                isEmailValid,
                isPasswordValid
            ))
            .subscribe(onNext: { [weak self] email, password, keepSignIn, emailValid, passwordValid in
                guard let self = self else { return }
                
                if !emailValid {
                    errorAlertMessage.onNext("이메일을 입력하세요.")
                } else if !passwordValid {
                    errorAlertMessage.onNext("비밀번호를 입력하세요.")
                } else {
                    signIn(email: email!, password: password!, keepSignIn: keepSignIn)
                }
            })
            .disposed(by: disposeBag)
        
        // 카카오 로그인 tap event
        input.kakaoButtonTapEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.signInWithKakao()
            })
            .disposed(by: disposeBag)
        
        // 애플 로그인 tap event
        input.appleButtonTapEvent
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.signInWithApple()
            })
            .disposed(by: disposeBag)
        
        return Output(
            isSignInEnabled: isSignInEnabled,
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil),
            response: response.asDriver(onErrorJustReturn: false)
        )
    }
    
    // MARK: - 이메일 로그인
    
    // 이메일 로그인
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
        
        RxAlamofire.requestData(.post, "\(API_SERVER_URL)/api/user/signin", parameters: body, encoding: JSONEncoding.default, headers: headers)
            .observe(on: MainScheduler.instance)
            .do(onSubscribe: {
                self.isLoading.onNext(true)
            })
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
            }, onError: { error in
                print("로그인 중 오류: \(error)")
                self.response.onNext(false)
            }, onDisposed: {
                self.isLoading.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    // 로그인 성공
    private func handleSuccess(_ model: SignInModel, _ keepSignIn: Bool = true) {
        let isSuccess = model.code == "SUCCESS"
        
        // 정보 저장
        if isSuccess, let data = model.data, let userData = model.data?.user {
            keychain.create(key: "ACCESS_TOKEN", value: data.access)
            keychain.create(key: "REFRESH_TOKEN", value: data.refresh)
            
            keychain.create(key: "NAME", value: userData.name)
            keychain.create(key: "EMAIL", value: userData.email)
            keychain.create(key: "IDENTIFY_CODE", value: userData.identifyCode)
            keychain.create(key: "USER_ID", value: "\(userData.id)")
            UserDefaults.standard.set(keepSignIn, forKey: "KEEP_SIGN_IN")
            
            if let provider = userData.provider {
                keychain.create(key: "PROVIDER", value: provider)
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
                self.errorAlertMessage.onNext("이메일 인증되지 않은 계정입니다.\n인증 후 로그인해주세요.")
                self.resendEmailAuthentication(email: email)
            } else {
                self.errorAlertMessage.onNext(model.message)
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
        
        RxAlamofire.request(.post, "\(API_SERVER_URL)/api/user/verify-email", parameters: body, encoding: JSONEncoding.default, headers: headers)
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
    
    // MARK: - 소셜 로그인
    
    // 소셜에서 발급받은 토큰 전송
    func sendTokenToServer(token: String, social: String, name: String? = nil) {
        // 헤더
        let headers: HTTPHeaders = [
            .contentType("application/json")
        ]
        
        // 바디
        var body: [String: Any] = [
            "accessToken": token
        ]
        
        if let name {
            body.updateValue(name, forKey: "name")
        }
        
        
        RxAlamofire.requestData(.post, "\(API_SERVER_URL)/api/user/social/login/\(social)", parameters: body, encoding: JSONEncoding.default, headers: headers)
            .observe(on: MainScheduler.instance)
            .do(onSubscribe: { [weak self] in
                guard let self = self else { return }
                
                isLoading.onNext(true)
            })
            .subscribe(onNext: { response, data in
                if (200..<300).contains(response.statusCode) {
                    do {
                        let model = try JSONDecoder().decode(SignInModel.self, from: data)
                        self.handleSuccess(model)
                    } catch {
                        print("SignInModel JSON 디코딩 오류: \(error)")
                        self.response.onNext(false)
                    }
                } else {
                    do {
                        let model = try JSONDecoder().decode(ResponseNoDataModel.self, from: data)
                        self.errorAlertMessage.onNext(model.message)
                    } catch {
                        self.response.onNext(false)
                    }
                }
                
            }, onError: { error in
                print("로그인 중 오류: \(error)")
                self.response.onNext(false)
            }, onDisposed: {
                self.isLoading.onNext(false)
            })
            
            .disposed(by: disposeBag)
    }
    
    // 카카오 로그인
    private func signInWithKakao() {
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoTalk() success.")
                    
                    let token = oauthToken.accessToken
                    self.sendTokenToServer(token: token, social: "kakao")
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoAccount() success.")
                    
                    let token = oauthToken.accessToken
                    self.sendTokenToServer(token: token, social: "kakao")
                }, onError: {error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
    }
    
    // 애플 로그인
    private func signInWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                self.response.onNext(false)
                self.isLoading.onNext(false)
                return
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                self.response.onNext(false)
                self.isLoading.onNext(false)
                
                return
            }
            
            if let familyName = appleIDCredential.fullName?.familyName,
               let givenName = appleIDCredential.fullName?.givenName {
                sendTokenToServer(token: idTokenString, social: "apple", name: "\(familyName)\(givenName)")
            } else {
                sendTokenToServer(token: idTokenString, social: "apple")
            }
            
        }
    }
}
