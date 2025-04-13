//
//  GetRollpeViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 4/11/25.
//

import Foundation
import RxSwift
import RxCocoa

class GetRollpeViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    let rollpeModels = BehaviorRelay<[RollpeDataModel]?>(value: [])
    private let alertMessage = PublishSubject<String?>()
    
    struct Output {
        let rollpeModels: Driver<[RollpeDataModel]?>
        let showAlert: Driver<String?>
    }
    
    func transform() -> Output {
        return Output(
            rollpeModels: rollpeModels.asDriver(),
            showAlert: alertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 롤페 불러오기
    func getRollpes(type: String) {
        apiService.requestDecodable("/api/paper/mypage?type=\(type)", method: .get, decodeType: RollpeResponseListModel.self)
            .subscribe(onNext: { model in
                self.rollpeModels.accept(model.data)
            }, onError: { error in
                self.rollpeModels.accept([])
                print("롤페 불러오는 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
