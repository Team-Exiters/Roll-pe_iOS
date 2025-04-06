//
//  RollpeV1ViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 3/28/25.
//

import Foundation
import RxSwift
import RxCocoa

class RollpeV1ViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    private let rollpe = BehaviorRelay<RollpeV1DataModel?>(value: nil)
    
    private let criticalAlertMessage = PublishSubject<String?>()
    
    struct Output {
        let rollpe: Driver<RollpeV1DataModel?>
        let criticalAlertMessage: Driver<String?>
    }
    
    func transform() -> Output {
        return Output(
            rollpe: rollpe.asDriver(onErrorJustReturn: nil),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 롤페 불러오기
    func getRollpeData(pCode: String) {
        apiService.requestDecodable("/api/paper?pcode=\(pCode)", method: .get, decodeType: RollpeV1ResponseModel.self)
            .subscribe(onNext: { model in
                self.rollpe.accept(model.data)
            }, onError: { error in
                print("롤페 정보 가져오는 중 오류 발생: \(error)")
                self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}
