//
//  UserinfoViewModel.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/20.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

protocol UserinfoViewModelDelegate: AnyObject {
    func closeAction()
    func blogLinkAction(with urlString: String?)
}

class UserinfoViewModel: UserinfoVcViewModel {
    
    typealias Delegate = UserinfoViewModelDelegate
    weak var delegate: Delegate?
    
    func waitForREfresh(done: @escaping (UserinfoVc.Status) -> ()) {
        done(.loading)
    }
    
    func closeAction() {
        delegate?.closeAction()
    }
    
    func blogLinkAction() {
        delegate?.blogLinkAction(with: nil)
    }
    
    func getAvatar() -> UIImage? {
        nil
    }
    
    func getName() -> String? {
        "HK"
    }
    
    func getBio() -> String? {
        "jji"
    }
    
    func getLogIn() -> String? {
        "hkjkhjk"
    }
    
    func haveBadge() -> Bool {
        false
    }
    
    func getLocation() -> String? {
        "jlk"
    }
    
    func getBlogUrl() -> String? {
        "jljkl"
    }
}
