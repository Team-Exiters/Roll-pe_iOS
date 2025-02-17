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
    var searchedUsers = BehaviorSubject<[UserDataModel]?>(value: nil)
    
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
    
    func searchUser(nickname:String){
        //nickname파라미터를 가진 유저들을 불러오기
        //api호출로 비동기작업, 이하는 임의
        let dataObservable = Observable<[UserDataModel]>.create { observer in
            let dummyData = [UserDataModel(nickname: "김제법1",login: ["google"],userUID: "a124",rollpeCount: 5,heartCount: 6),
                             UserDataModel(nickname: "김제법2",login: ["google"],userUID: "b14",rollpeCount: 5,heartCount: 6),
                             UserDataModel(nickname: "김제법3",login: ["google"],userUID: "asugeuf124",rollpeCount: 5,heartCount: 6),
                             UserDataModel(nickname: "김제법4",login: ["google"],userUID: "kreyuigfi124",rollpeCount: 5,heartCount: 6),
                             UserDataModel(nickname: "김제법5",login: ["google"],userUID: "oweuyfbc124",rollpeCount: 5,heartCount: 6),
                             UserDataModel(nickname: "김제법6",login: ["google"],userUID: "gudqe124",rollpeCount: 5,heartCount: 6),
                             UserDataModel(nickname: "김제법7",login: ["google"],userUID: "vnksoqw124",rollpeCount: 5,heartCount: 6),
                             UserDataModel(nickname: "김제법8",login: ["google"],userUID: "ouqwegdvgj24",rollpeCount: 5,heartCount: 6)]
            observer.onNext(dummyData)
            observer.onCompleted()
       
        return Disposables.create()
        }
        dataObservable
            .subscribe(onNext: { [weak self] model in
                self?.searchedUsers.onNext(model)
            })
            .disposed(by: disposeBag)
    }
    
    func sendRollpe(selectedUser:UserDataModel){
        
    }
}
