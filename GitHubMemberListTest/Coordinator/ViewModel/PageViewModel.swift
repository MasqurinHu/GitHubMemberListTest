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
    private var task: URLSessionDataTask?
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
    
    func waitForRefresh(done: @escaping () -> ()) {
        
        let session = URLSession(configuration: .default)
        guard let url = URL(string: baseUrl) else {
            assertionFailure("urlError")
            viewStatus = .loadFail("urlError")
            done()
            return
        }
        let UrlRequest = URLRequest(url: url)
        let task = session.dataTask(
            with: UrlRequest
        ) { [weak self] data, response, error in
            
            guard let strongSelf = self else {
                assertionFailure("self error")
                self?.viewStatus = .loadFail("self error")
                return
            }
            if let error = error {
                assertionFailure(error.localizedDescription)
                strongSelf.viewStatus = .loadFail(error.localizedDescription)
                return
            }
            guard let data = data else {
                assertionFailure("data is nil")
                strongSelf.viewStatus = .loadFail("data is nil")
                return
            }
            let jsd = JSONDecoder()
            jsd.keyDecodingStrategy = .convertFromSnakeCase
            guard let jsonVoList = try? jsd.decode([UserProfileModel].self, from: data) else {
                assertionFailure("json decode error")
                self?.viewStatus = .loadFail("json decode error")
                return
            }
            var box: [UserProfileCVCellViewModel] = []
            for jsonVo in jsonVoList {
                let vo = UserProfileViewModel(with: jsonVo)
                box.append(vo)
            }
            strongSelf.viewStatus = .loadDone(
                PageVc.Vo(pageName: "\(strongSelf.nowPage)",
                    haveLastPage: false,
                    haveNextPage: true,
                    userVoList: box
                )
            )
            done()
        }
        task.resume()
    }
}

extension PageViewModel {
    func getStatus() -> PageVc.Status {viewStatus}
}

extension PageViewModel {
    
    
}
