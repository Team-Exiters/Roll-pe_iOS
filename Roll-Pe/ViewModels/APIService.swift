//
//  APIService.swift
//  Roll-Pe
//
//  Created by 김태은 on 2/15/25.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

class APIService {
    static let shared = APIService()
    
    private let disposeBag = DisposeBag()
    private let ip: String = Bundle.main.object(forInfoDictionaryKey: "SERVER_IP") as! String
    private let keychain = Keychain()
    
    // 요청
    private func request(
        _ url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = JSONEncoding.default
    ) -> Observable<Data> {
        guard let accessToken = keychain.read(key: "ACCESS_TOKEN") else {
            return Observable.error(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "액세스 토큰이 없음"]))
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: accessToken)
        ]
        
        return RxAlamofire.request(
            method,
            "\(ip)\(url)",
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .observe(on: MainScheduler.instance)
        .validate(statusCode: 200..<300)
        .responseData()
        .flatMap { response, data in
            // 액세스 토큰 만료일 때
            if response.statusCode == 401 {
                guard let refreshToken = self.keychain.read(key: "REFRESH_TOKEN") else {
                    return Observable.error(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "리프레시 토큰이 없음"])) as Observable<Data>
                }
                
                return self.refreshAccessToken(refreshToken)
                    .flatMap { at in
                        self.keychain.create(key: "ACCESS_TOKEN", value: at)
                        return self.request(url, method: method, parameters: parameters, encoding: encoding)
                    }
            } else {
                return Observable.just(data)
            }
        }
    }
    
    // 요청과 Decode처리
    private func requestDecodable<T: Decodable>(
        _ url: String,
        method: HTTPMethod,
        parameters: [String: Any]? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        decodeType: T.Type
    ) -> Observable<T> {
        guard let accessToken = keychain.read(key: "ACCESS_TOKEN") else {
            return Observable.error(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "액세스 토큰이 없음"]))
        }
        
        let headers: HTTPHeaders = [
            .authorization(bearerToken: accessToken)
        ]
        
        return RxAlamofire.request(
            method,
            "\(ip)\(url)",
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .observe(on: MainScheduler.instance)
        .validate(statusCode: 200..<300)
        .responseData()
        .flatMap { response, data in
            // 액세스 토큰 만료일 때
            if response.statusCode == 401 {
                guard let refreshToken = self.keychain.read(key: "REFRESH_TOKEN") else {
                    return Observable.error(NSError(domain: "APIService", code: 401, userInfo: [NSLocalizedDescriptionKey: "리프레시 토큰이 없음"])) as Observable<T>
                }
                
                return self.refreshAccessToken(refreshToken)
                    .flatMap { at in
                        self.keychain.create(key: "ACCESS_TOKEN", value: at)
                        return self.requestDecodable(url, method: method, parameters: parameters, encoding: encoding, decodeType: decodeType)
                    }
            } else {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(decodeType, from: data)
                    return Observable.just(decodedData)
                } catch {
                    return Observable.error(error)
                }
            }
        }
    }
    
    // 리프레시 토큰 재발급
    private func refreshAccessToken(_ refreshToken: String) -> Observable<String> {
        return Observable.create { observer in
            let parameters: [String: Any] = ["refresh": refreshToken]
            
            let request = RxAlamofire.request(.post, "\(self.ip)/api/user/token/refresh", parameters: parameters)
                .validate(statusCode: 200..<300)
                .responseData()
                .subscribe(onNext: { response, data in
                    do {
                        let json = try JSONDecoder().decode(RefreshModel.self, from: data)
                        observer.onNext(json.access)
                        observer.onCompleted()
                    } catch {
                        // 리프레시 토큰이 만료일 때
                        observer.onError(NSError(domain: "APIService", code: 400, userInfo: [NSLocalizedDescriptionKey: "리프레시 토큰이 없음"]))
                        self.handleLogout()
                    }
                }, onError: { error in
                    // 리프레시 토큰이 만료일 때
                    observer.onError(error)
                    self.handleLogout()
                })
            
            return Disposables.create {
                request.dispose()
            }
        }
    }
    
    // 로그아웃 처리
    private func handleLogout() {
        keychain.delete(key: "ACCESS_TOKEN")
        keychain.delete(key: "REFRESH_TOKEN")
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TOKEN_EXPIRED"), object: nil)
        }
    }
}
