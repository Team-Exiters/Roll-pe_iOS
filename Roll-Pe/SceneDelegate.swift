//
//  SceneDelegate.swift
//  Roll-Pe
//
//  Created by 김태은 on 11/30/24.
//

import Foundation
import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let keychain = Keychain.shared
        
        window = UIWindow(windowScene: windowScene)
        
        let navVC: UINavigationController
        
        if let keepSignIn = UserDefaults.standard.object(forKey: "KEEP_SIGN_IN") as? Bool {
            if keepSignIn, keychain.read(key: "REFRESH_TOKEN") != nil {
                let vc = MainAfterSignInViewController()
                navVC = UINavigationController(rootViewController: vc)
            } else {
                let userViewModel = UserViewModel()
                userViewModel.logout()
                
                let vc = MainBeforeSignInViewController()
                navVC = UINavigationController(rootViewController: vc)
            }
        } else {
            let vc = MainBeforeSignInViewController()
            navVC = UINavigationController(rootViewController: vc)
        }
        
        navVC.navigationBar.isHidden = true
        navVC.hideKeyboardWhenTappedAround()
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        
        // 토큰 만료시
        NotificationCenter.default.addObserver(self, selector: #selector(moveToMainBeforeSignInView), name: Notification.Name(rawValue: "LOGOUT"), object: nil)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // 카카오 로그인
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            } else {
                let _ = GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    // 로그인 전 메인 뷰로 이동
    @objc private func moveToMainBeforeSignInView() {
        let vc = MainBeforeSignInViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = true
        navVC.hideKeyboardWhenTappedAround()
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

