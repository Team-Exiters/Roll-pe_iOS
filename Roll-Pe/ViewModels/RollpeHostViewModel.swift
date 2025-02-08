//
//  RollpeHostViewModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/4/25.
//

import Foundation
import RxSwift


class RollpeHostViewModel {
    
    private var disposeBag = DisposeBag()
    var rollpeHostModel = BehaviorSubject<RollpeHostModel?>(value: nil)
    
    func fetchRollpeData() {
         let dataObservable = Observable<RollpeHostModel>.create { observer in
             // 나중에 API호출로 대체
             let dummyData = RollpeHostModel(
                 host: "몽실이",
                 writers: ["작성자1", "작성자2"],
                 participants: ["참가자1", "참가자2", "참가자3"],
                 isPublic: false
             )
        
                 observer.onNext(dummyData)
                 observer.onCompleted()
            
             return Disposables.create()
         }
         dataObservable
             .subscribe(onNext: { [weak self] model in
                 self?.rollpeHostModel.onNext(model)
             })
             .disposed(by: disposeBag)
     }
}
