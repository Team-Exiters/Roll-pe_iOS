//
//  RollpeHostViewModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/4/25.
//

import RxSwift
import UIKit


class RollpeHostViewModel {
    
    private var disposeBag = DisposeBag()
    var rollpeModel = BehaviorSubject<RollpeModel?>(value: nil)
    
    func fetchRollpeData() {
         let dataObservable = Observable<RollpeModel>.create { observer in
             // 나중에 API호출로 대체
             let dummyData = RollpeModel(
                 host: "몽실이",
                 title: "브라이언은 몽실몽실해해해해해해해해해해해 ",
                 writers: [UserDataModel(nickname: "브라이언",login: ["kakao"],userUID: "abc123",rollpeCount: 8, heartCount: 10),UserDataModel(nickname: "폴피닉스",login: ["kakao"],userUID: "abcasd123",rollpeCount: 8, heartCount: 10),
                           UserDataModel(nickname: "데빌진",login: ["kakao"],userUID: "abcas123",rollpeCount: 8, heartCount: 10),
                           UserDataModel(nickname: "아주세나",login: ["kakao"],userUID: "abxcc123",rollpeCount: 8, heartCount: 10),
                           UserDataModel(nickname: "노무현",login: ["kakao"],userUID: "abc12123",rollpeCount: 8, heartCount: 10)],
                 participants: [UserDataModel(nickname: "구대기1",login: ["kakao"],userUID: "ab12jc123",rollpeCount: 8, heartCount: 10),
                                UserDataModel(nickname: "김대중",login: ["kakao"],userUID: "abc1sc23",rollpeCount: 8, heartCount: 10),
                                UserDataModel(nickname: "사쿠라",login: ["kakao"],userUID: "abc1ewa23",rollpeCount: 8, heartCount: 10),
                                UserDataModel(nickname: "냥냥맨",login: ["kakao"],userUID: "abcgfn123",rollpeCount: 8, heartCount: 10)],
                 isPublic: false,
                 date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 10, hour: 14, minute: 20))!,
                 password: "1234"
             )
           
                 
                 observer.onNext(dummyData)
                 observer.onCompleted()
            
             return Disposables.create()
         }
         dataObservable
             .subscribe(onNext: { [weak self] model in
                 self?.rollpeModel.onNext(model)
             })
             .disposed(by: disposeBag)
     }
    
    func updateRollpeData(data: RollpeModel) {
        //롤페 수정사항 업데이트 로직
        //비동기로 db에 값업데이트한 후
        rollpeModel.onNext(data)
    }
    
    func deleteRollpeData() {
        //롤페 종료 로직
        print("롤페 종료로직")
    }
}
