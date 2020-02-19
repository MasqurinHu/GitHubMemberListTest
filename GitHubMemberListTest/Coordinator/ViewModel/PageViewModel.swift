//
//  PageViewModel.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import Foundation

protocol PageViewModelDelegate: AnyObject {
    func goUserInfoPage(with urlString: String)
}

class PageViewModel {
    
    typealias Delegate = PageViewModelDelegate
    weak var delegate: Delegate?
    
    private var viewStatus: PageVc.Status = .loading
    private var nowPage: Int = .zero
}

extension PageViewModel {
    
    private var pageSize: Int {20}
    
    private var baseUrl: String {"https://api.github.com/users?page=100&per_page=20&since=7"}
}

extension PageViewModel: PageVcViewModel {
    func retryAction() {
        
    }
    
    func lastButtonAction() {
        
    }
    
    func nextButtonAction() {
        
    }
    
    func waitForRefresh(_: () -> ()) {
        
    }
}

extension PageViewModel {
    func getStatus() -> PageVc.Status {viewStatus}
}
