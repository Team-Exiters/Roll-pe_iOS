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
    
    let rollpeData = BehaviorRelay<RollpeResponsePagenationListModel?>(value: nil)
    let rollpeModels = BehaviorRelay<[RollpeListDataModel]?>(value: [])
    private let alertMessage = PublishSubject<String?>()
    
    struct Output {
        let rollpeData: Driver<RollpeResponsePagenationListModel?>
        let rollpeModels: Driver<[RollpeListDataModel]?>
        let showOKAlert: Driver<String?>
    }
    
    func transform() -> Output {
        return Output(
            rollpeData: rollpeData.asDriver(),
            rollpeModels: rollpeModels.asDriver(),
            showOKAlert: alertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 내 롤페 불러오기
    func getMyRollpes() {
        apiService.requestDecodable("/api/paper/mypage?type=host", method: .get, decodeType: RollpeResponseListModel.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { model in
                self.rollpeModels.accept(model.data)
            }, onError: { error in
                self.rollpeModels.accept([])
                print("롤페 불러오는 중 오류 발생: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    // 초대받은 롤페 불러오기
    func getInvitedRollpes() {
        apiService.requestDecodable("/api/paper/user?type=inviting", method: .get, decodeType: RollpeResponsePagenationListModel.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { data in
                self.rollpeData.accept(data)
                self.rollpeModels.accept(data.data.results)
            }, onError: { error in
                self.rollpeModels.accept([])
                print("롤페 불러오는 중 오류 발생: \(error)")
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
                print("롤페 페이지네이션 중 오류 발생: \(error)")
                self.alertMessage.onNext("오류가 발생하였습니다.")
            })
            .disposed(by: disposeBag)
    }
}
