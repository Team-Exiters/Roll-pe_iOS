//
//  RollpeCreateViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/19/25.
//

import Foundation
import RxSwift
import RxCocoa

class RollpeCreateViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    private let keychain = Keychain.shared
    
    private let isLoading = BehaviorSubject<Bool>(value: false)
    private let successAlertMessage = PublishSubject<String?>()
    private let errorAlertMessage = PublishSubject<String?>()
    private let criticalAlertMessage = PublishSubject<String?>()
    
    // 비율
    let ratios = BehaviorRelay<[QueryIndexDataModel]>(value: [])
    let selectedRatio = BehaviorRelay<QueryIndexDataModel?>(value: nil)
    
    // 테마
    let themes = BehaviorRelay<[QueryIndexDataModel]>(value: [])
    let selectedTheme = BehaviorRelay<QueryIndexDataModel?>(value: nil)
    
    // 크기
    let sizes = BehaviorRelay<[QueryIndexDataModel]>(value: [])
    let selectedSize = BehaviorRelay<QueryIndexDataModel?>(value: nil)
    
    // 선택한 유저
    let selectedUser = BehaviorRelay<SearchUserResultModel?>(value: nil)
    
    struct Input {
        let title: ControlProperty<String?>
        let privacyIndex: ControlProperty<Int>
        let password: ControlProperty<String?>
        let sendDate: ControlProperty<String?>
        let createButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let ratios: Driver<[QueryIndexDataModel]>
        let selectedRatio: Driver<QueryIndexDataModel?>
        let themes: Driver<[QueryIndexDataModel]>
        let selectedTheme: Driver<QueryIndexDataModel?>
        let sizes: Driver<[QueryIndexDataModel]>
        let selectedSize: Driver<QueryIndexDataModel?>
        let isPasswordVisible: Driver<Bool>
        let selectedUser: Driver<SearchUserResultModel?>
        let isCreateEnabled: Driver<Bool>
        let isLoading: Driver<Bool>
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
        let criticalAlertMessage: Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        // 비밀번호 표시 여부
        let isPasswordVisible = input.privacyIndex.map { $0 == 1 }
        
        // 검증
        let isTitleValid = input.title.orEmpty.map { !$0.isEmpty }
        let isRatioValid = selectedRatio.map { $0 != nil }
        let isThemeValid = selectedTheme.map { $0 != nil }
        let isSizeValid = selectedSize.map { $0 != nil }
        let isPasswordValid = Observable.combineLatest(
            isPasswordVisible,
            input.password.orEmpty
        ) { isVisible, password in
            return isVisible ? !password.isEmpty : true
        }
        
        let isDateValid = input.sendDate.orEmpty.map { !$0.isEmpty }
        let isUserValid = selectedUser.map { $0 != nil }
        
        let isCreateEnabled = Observable.combineLatest(
            isTitleValid,
            isRatioValid,
            isThemeValid,
            isSizeValid,
            isPasswordValid,
            isDateValid,
            isUserValid
        ) { $0 && $1 && $2 && $3 && $4 && $5 && $6
        }
            .asDriver(onErrorJustReturn: false)
        
        // combineLatest 그룹
        let validationGroup = Observable.combineLatest(
            isTitleValid,
            isRatioValid,
            isThemeValid,
            isSizeValid,
            isPasswordValid,
            isDateValid,
            isUserValid
        ) { (titleValid, ratioValid, themeValid, sizeValid, passwordValid, dateValid, userValid) in
            return (titleValid, ratioValid, themeValid, sizeValid, passwordValid, dateValid, userValid)
        }
        
        let inputGroup = Observable.combineLatest(
            input.title.orEmpty,
            input.privacyIndex,
            input.password.orEmpty,
            input.sendDate.orEmpty
        ) { (title, privacyIndex, password, sendDate) in
            return (title, privacyIndex, password, sendDate)
        }
        
        // 만들기 버튼 tap event
        input.createButtonTapEvent
            .observe(on: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(validationGroup, inputGroup))
            .subscribe(onNext: { [weak self] validation, inputs in
                guard let self = self else { return }
                let (titleValid, ratioValid, themeValid, sizeValid, passwordValid, dateValid, userValid) = validation
                let (title, privacyIndex, password, sendDate) = inputs
                
                if !titleValid {
                    errorAlertMessage.onNext("제목을 입력하세요.")
                } else if !ratioValid {
                    errorAlertMessage.onNext("비율을 선택하세요.")
                } else if !themeValid {
                    errorAlertMessage.onNext("테마를 선택하세요.")
                } else if !sizeValid {
                    errorAlertMessage.onNext("크기를 선택하세요.")
                } else if !passwordValid {
                    errorAlertMessage.onNext("비밀번호를 입력하세요.")
                } else if !dateValid {
                    errorAlertMessage.onNext("전달일을 설정하세요.")
                } else if !userValid {
                    errorAlertMessage.onNext("전달할 사람을을 선택해주세요.")
                } else {
                    self.createRollpe(
                        receiver: selectedUser.value,
                        receivingDate: sendDate,
                        title: title,
                        isPrivate: privacyIndex == 1,
                        password: password,
                        theme: selectedTheme.value,
                        size: selectedSize.value,
                        ratio: selectedRatio.value)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            ratios: ratios.asDriver(),
            selectedRatio: selectedRatio.asDriver(onErrorJustReturn: nil),
            themes: themes.asDriver(),
            selectedTheme: selectedTheme.asDriver(onErrorJustReturn: nil),
            sizes: sizes.asDriver(),
            selectedSize: selectedSize.asDriver(onErrorJustReturn: nil),
            isPasswordVisible: isPasswordVisible.asDriver(onErrorJustReturn: true),
            selectedUser: selectedUser.asDriver(),
            isCreateEnabled: isCreateEnabled,
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 서버로부터 비율, 테마, 크기 정보 가져오기
    func getIndexes() {
        apiService.requestDecodable("/api/index?type=all", method: .get, decodeType: QueryIndexResponseModel.self)
            .subscribe(onNext: { model in
                var themes: [QueryIndexDataModel] = []
                var sizes: [QueryIndexDataModel] = []
                var ratios: [QueryIndexDataModel] = []
                
                for data in model.data {
                    switch data.type {
                    case "THEME":
                        themes.append(data)
                    case "SIZE":
                        sizes.append(data)
                    case "RATIO":
                        ratios.append(data)
                    default: break
                    }
                }
                
                self.themes.accept(themes)
                self.sizes.accept(sizes)
                self.ratios.accept(ratios)
            }, onError: { error in
                print("index 가져오는 중 오류 발생: \(error)")
                self.onError()
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 만들기
    private func createRollpe(
        receiver: SearchUserResultModel?,
        receivingDate: String,
        title: String,
        isPrivate: Bool,
        password: String,
        theme: QueryIndexDataModel?,
        size: QueryIndexDataModel?,
        ratio: QueryIndexDataModel?) {
            guard let receiver = receiver,
                  let myId = keychain.read(key: "USER_ID"),
                  let myIdToInt = Int(myId),
                  let receivingDate = convertDateFormat(receivingDate),
                  !title.isEmpty,
                  let theme = theme,
                  let size = size,
                  let ratio = ratio else {
                onError()
                return
            }
            
            // 바디
            var body: [String: Any] = [
                "receiverFK": receiver.id,
                "hostFK": myIdToInt,
                "receivingDate": receivingDate,
                "title": title,
                "description": "",
                "themeFK": theme.id,
                "sizeFK": size.id,
                "ratioFK": ratio.id
            ]
            
            if isPrivate && !password.isEmpty {
                body.updateValue(password, forKey: "password")
            }
            
            apiService.request("/api/paper", method: .post, parameters: body)
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
                    print("롤페 만드는 중 오류 발생: \(error)")
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
