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
    private let errorAlertMessage = PublishSubject<String?>()
    private let response = PublishSubject<Bool>()
    
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
        let errorAlertMessage: Driver<String?>
        let response: Driver<Bool>
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
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil),
            response: response.asDriver(onErrorJustReturn: false)
        )
    }
    
    func getRatioIndexes() {
        apiService.requestDecodable("/api/index?type=ratio", method: .get, decodeType: QueryIndexModel.self)
            .subscribe(onNext: { model in
                self.ratios.accept(model.data)
            }, onError: { error in
                print("비율 index 가져오는 중 오류 발생: \(error)")
                self.response.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func getThemeIndexes() {
        apiService.requestDecodable("/api/index?type=theme", method: .get, decodeType: QueryIndexModel.self)
            .subscribe(onNext: { model in
                self.themes.accept(model.data)
            }, onError: { error in
                print("테마 index 가져오는 중 오류 발생: \(error)")
                self.response.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
    func getSizeIndexes() {
        apiService.requestDecodable("/api/index?type=size", method: .get, decodeType: QueryIndexModel.self)
            .subscribe(onNext: { model in
                self.sizes.accept(model.data)
            }, onError: { error in
                print("크기 index 가져오는 중 오류 발생: \(error)")
                self.response.onNext(false)
            })
            .disposed(by: disposeBag)
    }
    
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
                  let myIdentifyCode = keychain.read(key: "USER_ID"),
                  let receivingDate = convertDateFormat(receivingDate),
                  !title.isEmpty,
                  let theme = theme,
                  let size = size,
                  let ratio = ratio else {
                self.response.onNext(false)
                return
            }
            
            // 바디
            var body: [String: Any] = [
                "receiverFK": receiver.identifyCode,
                "hostFK": myIdentifyCode,
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
            
            print(body)
            
            self.isLoading.onNext(true)
            
            apiService.request("/api/paper", method: .post, parameters: body)
                .subscribe(onNext: { data in
                    print(String(data: data, encoding: .utf8))
                    self.response.onNext(true)
                    self.isLoading.onNext(false)
                }, onError: { error in
                    print("롤페 만드는 중 오류 발생: \(error)")
                    self.response.onNext(false)
                    self.isLoading.onNext(false)
                })
                .disposed(by: disposeBag)
        }
    
    private func convertDateFormat(_ input: String) -> String? {
        // 입력 형식 정의
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.dateFormat = "yyyy년 M월 d일 a h시"
        inputFormatter.amSymbol = "오전"
        inputFormatter.pmSymbol = "오후"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = inputFormatter.date(from: input) else {
            print("날짜 변환 실패: \(input)")
            return nil
        }
        
        return outputFormatter.string(from: date)
    }
}
