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
    
    func gopageListVc() {
        navigationVc?.pushViewController(getPagelistVc(), animated: true)
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
    
    func goUserInfoPage(with urlString: String) {
        print("user info url = \(urlString)")
    }
    
    func getPagelistVc() -> UIViewController {
        
        let vc = PageVc()
        let viewModel = PageViewModel()
        vc.viewModel = viewModel
        return vc
    }
}
