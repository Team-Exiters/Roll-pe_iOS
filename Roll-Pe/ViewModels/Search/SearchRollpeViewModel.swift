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
    
    let rollpeData = BehaviorRelay<RollpeResponsePagenationListModel?>(value: nil)
    let rollpeModels = BehaviorRelay<[RollpeListDataModel]?>(value: nil)
    private let alertMessage = PublishSubject<String?>()
    
    struct Input {
        let word: ControlProperty<String?>
        let keyboardTapEvent: ControlEvent<Void>
        let searchButtonTapEvent: ControlEvent<Void>
        let getMoreButtonTapEvent: ControlEvent<Void>
    }
    
    struct Output {
        let rollpeData: Driver<RollpeResponsePagenationListModel?>
        let rollpeModels: Driver<[RollpeListDataModel]?>
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
        
        input.getMoreButtonTapEvent
            .observe(on: MainScheduler.instance)
            .withLatestFrom(rollpeData)
            .subscribe(onNext: { [self] data in
                if let next = data?.data.next {
                    self.getMoreRollpes(next: next)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            rollpeData: rollpeData.asDriver(),
            rollpeModels: rollpeModels.asDriver(),
            showAlert: alertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 롤페 불러오기
    func getRollpes(name: String) {
        apiService.requestDecodable("/api/engine/serach?k=\(name)", method: .get, decodeType: RollpeResponsePagenationListModel.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { model in
                self.rollpeData.accept(model)
                self.rollpeModels.accept(model.data.results)
            }, onError: { error in
                self.rollpeModels.accept([])
            })
            .disposed(by: disposeBag)
    }
    
    // 롤페 더 불러오기
    func getMoreRollpes(next: String) {
        apiService.requestDecodable(next, method: .get, decodeType: RollpeResponsePagenationListModel.self, isDomainInclude: true)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { model in
                self.rollpeData.accept(model)
                
                let previous = self.rollpeModels.value
                let data = (previous ?? []) + model.data.results
                
                self.rollpeModels.accept(data)
            }, onError: { error in
                print("검색한 롤페 불러오는 중 오류 발생: \(error)")
                self.alertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}
