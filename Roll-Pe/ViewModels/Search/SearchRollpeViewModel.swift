//
//  SearchRollpeViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/2/25.
//

import Foundation
import RxSwift
import RxCocoa

class SearchRollpeViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    let rollpeData = BehaviorRelay<RollpeResponseListModel?>(value: nil)
    private let alertMessage = PublishSubject<String?>()
    
    struct Input {
        let word: ControlProperty<String?>
        let keyboardTapEvent: ControlEvent<Void>
        let searchButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let rollpeData: Driver<RollpeResponseListModel?>
        let showAlert: Driver<String?>
    }
    
    func transform(_ input: Input) -> Output {
        let searchTrigger = Observable.merge(
            input.keyboardTapEvent.asObservable(),
            input.searchButtonTapEvent.asObservable()
        )
        
        searchTrigger
            .observe(on: MainScheduler.instance)
            .withLatestFrom(input.word)
            .subscribe(onNext: { [self] word in
                if let word {
                    self.getRollpes(name: word)
                } else {
                    self.alertMessage.onNext("제목을 입력하세요")
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            rollpeData: rollpeData.asDriver(),
            showAlert: alertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 롤페 불러오기
    func getRollpes(name: String) {
        apiService.requestDecodable("/api/engine/serach?k=\(name)", method: .get, decodeType: RollpeResponseListModel.self)
            .subscribe(onNext: { model in
                self.rollpeData.accept(model)
            }, onError: { error in
                print("검색한 롤페 불러오는 중 오류 발생: \(error)")
                self.alertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}
