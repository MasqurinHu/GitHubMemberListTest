//
//  MainCoordinator.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

class MainCoordinator {
    
    var window: UIWindow?
    
    weak var navigationVc: UINavigationController?
    
    weak var mainVc: UIViewController?
    
    private var userInfoCoordinator: UserInfoCoordinator?
}

extension MainCoordinator {
    
    func startWithWindow() {
        
        let window = UIWindow()
        let vc = getMainVc()
        let nav = UINavigationController(rootViewController: vc)
        navigationVc = nav
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
    
    private func gopageListVc() {
        navigationVc?.pushViewController(getPagelistVc(), animated: true)
    }
    
    private func goUserInfoCoorDinator(with url: String?) {
        guard  let navigationVc = navigationVc else {
            return
        }
        let coordinator = getUserInfoCoordinator(with: url)
        userInfoCoordinator = coordinator
        coordinator.start(with: navigationVc, urlString: url)
    }
}

extension MainCoordinator: MainViewModelDelegate {
    
    func goPageList() {
        gopageListVc()
    }
    
    func getMainVc() -> UIViewController {
        
        let vc = MainVc()
        let viewModel = MainViewModel(with: self)
        vc.viewModel = viewModel
        
        return vc
    }
}

extension MainCoordinator: PageViewModelDelegate {
    
    func goUserInfoPage(with urlString: String?) {
        print("user info url = \(String(describing: urlString))")
        goUserInfoCoorDinator(with: urlString)
    }
    
    func getPagelistVc() -> UIViewController {
        
        let vc = PageVc()
        let viewModel = PageViewModel()
        viewModel.delegate = self
        vc.viewModel = viewModel
        return vc
    }
}

extension MainCoordinator: UserInfoCoordinatorDelegate {
    
    func closeUserInfoCoordinator() {
        print("close UserInfo")
        userInfoCoordinator = nil
    }
    
    func getUserInfoCoordinator(with url: String?) -> UserInfoCoordinator {
        let coordinator = UserInfoCoordinator()
        coordinator.delegate = self
        return coordinator
    }
}
