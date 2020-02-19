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
    
    weak var nowShowVc: UIViewController?
    
    weak var mainVc: UIViewController?
}

extension MainCoordinator {
    
    func startWithWindow() {
        
        let window = UIWindow()
        window.rootViewController = getMainVc()
        nowShowVc = window.rootViewController
        self.window = window
        window.makeKeyAndVisible()
    }
}

extension MainCoordinator: MainViewModelDelegate {
    
    func goPageList() {
        print("去第一頁")
    }
    
    func getMainVc() -> UIViewController {
        
        let vc = MainVc()
        let viewModel = MainViewModel(with: self)
        vc.viewModel = viewModel
        
        return vc
    }
    
    
}
