//
//  EditRollpeViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/23/25.
//

import Foundation
import RxSwift
import RxCocoa

class EditRollpeViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    private let isLoading = BehaviorSubject<Bool>(value: false)
    private let successAlertMessage = PublishSubject<String?>()
    private let errorAlertMessage = PublishSubject<String?>()
    
    struct Input {
        let privacyIndex: ControlProperty<Int>
        let password: ControlProperty<String?>
        let sendDate: ControlProperty<String?>
        let endButtonTapEvent: ControlEvent<Void>
        let saveButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let isPasswordVisible: Driver<Bool>
        let isLoading: Driver<Bool>
        let successAlertMessage: Driver<String?>
        let errorAlertMessage: Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        // 비밀번호 표시 여부
        let isPasswordVisible = input.privacyIndex.map { $0 == 1 }
        
        let isPasswordValid = Observable.combineLatest(
            isPasswordVisible,
            input.password.orEmpty
        ) { isVisible, password in
            return isVisible ? !password.isEmpty : true
        }
        
        // 만들기 버튼 tap event
        input.saveButtonTapEvent
            .observe(on: MainScheduler.instance)
            .withLatestFrom(isPasswordValid)
            .subscribe(onNext: { [weak self] passwordValid in
                guard let self = self else { return }
                
                if !passwordValid {
                    errorAlertMessage.onNext("비밀번호를 입력하세요.")
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            isPasswordVisible: isPasswordVisible.asDriver(onErrorJustReturn: true),
            isLoading: isLoading.asDriver(onErrorJustReturn: false),
            successAlertMessage: successAlertMessage.asDriver(onErrorJustReturn: nil),
            errorAlertMessage: errorAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
}
