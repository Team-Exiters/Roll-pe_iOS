//
//  RollpeParticipantViewModel.swift
//  Roll-Pe
//
//  Created by DongHyeokHwang on 2/9/25.
//


import Foundation
import RxSwift

class RollpeParticipantViewModel {
    
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
                           UserDataModel(nickname: "끠잉잉",login: ["kakao"],userUID: "abc12123",rollpeCount: 8, heartCount: 10)],
                 participants: [UserDataModel(nickname: "구대기1",login: ["kakao"],userUID: "ab12jc123",rollpeCount: 8, heartCount: 10),
                                UserDataModel(nickname: "뿡ㅇ뿌룽",login: ["kakao"],userUID: "abc1sc23",rollpeCount: 8, heartCount: 10),
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
    
}
