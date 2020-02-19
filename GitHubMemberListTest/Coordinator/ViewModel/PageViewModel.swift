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
    func getStatus() -> PageVc.Status {
        
        var ll:[UserProfileCVCellViewModel] = []
        for _ in 0 ..< 20 {
            ll.append(DummyData())
        }
        return .loadDone(PageVc.Vo(pageName: "999", haveLastPage: true, haveNextPage: true, userVoList: ll))
    }
}
