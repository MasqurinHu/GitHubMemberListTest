//
//  UserInfoCoordinator.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/20.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

protocol UserInfoCoordinatorDelegate: AnyObject {
    func closeUserInfoCoordinator()
}

class UserInfoCoordinator {
    
    typealias Delegate = UserInfoCoordinatorDelegate
    weak var delegate: Delegate?
    
    private weak var baseVc: UIViewController?
}
extension UserInfoCoordinator {
    
    func start(with sourceVc: UIViewController, urlString: String?) {
        let vc = getUserInfoVc(with: urlString)
        baseVc = vc
        vc.modalPresentationStyle = .fullScreen
        sourceVc.present(vc, animated: true, completion: nil)
    }
}

extension UserInfoCoordinator: UserinfoViewModelDelegate {
    
    func closeAction() {
        delegate?.closeUserInfoCoordinator()
        baseVc?.dismiss(animated: true, completion: nil)
    }
    
    func blogLinkAction(with urlString: String?) {
        print("click link to \(String(describing: urlString))")
    }
    
    private func getUserInfoVc(with urlString: String?) -> UIViewController {
        let viewmodel: UserinfoViewModel = UserinfoViewModel(with: urlString)
        let vc: UserinfoVc = UserinfoVc()
        vc.viewModel = viewmodel
        viewmodel.delegate = self
        return vc
    }
}
