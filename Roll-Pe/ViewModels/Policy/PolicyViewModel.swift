//
//  PolicyViewModel.swift
//  Roll-Pe
//
//  Created by 김태은 on 6/5/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxRelay
import Alamofire
import RxAlamofire
import UIKit

class PolicyViewModel {
    private let disposeBag = DisposeBag()
    private let apiService = APIService.shared
    
    let htmlCode = BehaviorRelay<String>(value: "")
    private let criticalAlertMessage = PublishSubject<String?>()
    
    struct Output {
        let htmlCode: Driver<String>
        let criticalAlertMessage: Driver<String?>
    }
    
    func transform() -> Output {
        return Output(
            htmlCode: htmlCode.asDriver(),
            criticalAlertMessage: criticalAlertMessage.asDriver(onErrorJustReturn: nil)
        )
    }
    
    // 서버로부터 약관 가져오기
    func getHtml(_ policy: String) {
        RxAlamofire.requestDecodable(.get, "\(API_SERVER_URL)/api/user/docs?docs=\(policy)", encoding: JSONEncoding.default)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (response, model: ResponseStringModel) in
                self.htmlCode.accept(
                    """
                    <html>
                      <head>
                        <meta name="viewport" content="width=device-width, initial-scale=1.0">
                        <style>
                          body { color: \(UIColor.rollpeSecondary.toHex ?? "black"); background: \(UIColor.rollpePrimary.toHex ?? "black"); font-size: 14px; }
                        </style>
                      </head>
                      \(model.data)
                    </html>
                    """
                )
                
                print("\(String(describing: UIColor.rollpeSecondary.toHex))")
            }, onError: { error in
                print("index 가져오는 중 오류 발생: \(error)")
                self.onError()
            })
            .disposed(by: disposeBag)
    }
    
    private func onError() {
        self.criticalAlertMessage.onNext("오류가 발생하였습니다.")
    }
}
