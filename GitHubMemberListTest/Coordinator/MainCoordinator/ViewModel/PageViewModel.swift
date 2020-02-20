//
//  PageViewModel.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import Foundation

protocol PageViewModelDelegate: AnyObject {
    func goUserInfoPage(with urlString: String?)
}

class PageViewModel {
    
    typealias Delegate = PageViewModelDelegate
    weak var delegate: Delegate?
    
    private var viewStatus: PageVc.Status = .loading
    private var nowPage: Int = 1
    private var task: URLSessionDataTask?
    private var waitFor: (() -> ())?
    private var pageBox: [Int: Int] = [1: 0]
    private var retryType: RetryType = .last(since: .zero)
}

extension PageViewModel {
    
    private var pageSize: Int {20}
    private var lastSince: Int {
        guard let page = pageBox[nowPage] else {
            assertionFailure("get page error")
            return .zero
        }
        return page
    }
    private var nextSince: Int {
        guard let page = pageBox[nowPage] else {
            assertionFailure("get page error")
            return .zero
        }
        return page
    }
    
    private var baseUrl: String {"https://api.github.com/users?per_page=\(pageSize)"}
    
    enum RetryType {
        case last(since: Int),
        next(since: Int, nextPage: Int)
    }
}

extension PageViewModel: PageVcViewModel {
    
    func didSelectUser(with userInfoUrl: String?) {
        delegate?.goUserInfoPage(with: userInfoUrl)
    }
    
    func retryAction() {
        let useSince: Int
        switch retryType {
        case .last(let since),
             .next(let since, _):
            useSince = since
        }
        requestTask(with: useSince) { [weak self] count in
            self?.requestHandle(with: count)
        }
    }
    
    func lastButtonAction() {
        nowPage -= 1
        retryType = .last(since: lastSince)
        requestTask(with: lastSince) { [weak self] count in
            self?.requestHandle(with: count)
        }
    }
    
    func nextButtonAction() {
        nowPage += 1
        retryType = .next(since: nextSince, nextPage: nowPage + 1)
        requestTask(with: nextSince) { [weak self] count in
            self?.requestHandle(with: count)
        }
    }
    
    func waitForRefresh(done: @escaping () -> ()) {
        
        waitFor = {
            done()
        }
        retryType = .next(since: .zero, nextPage: nowPage + 1)
        requestTask(with: .zero) { [weak self] count in
            
            self?.requestHandle(with: count)
        }
    }
    
    private func requestHandle(with count: Int?) {
        
        switch retryType {
        case .last:
            break
        case .next(_, let nextPage):
            pageBox[nextPage] = count
        }
        waitFor?()
    }
    
}

extension PageViewModel {
    func getStatus() -> PageVc.Status {viewStatus}
}

extension PageViewModel {
    
    private func requestTask(with sincePage: Int,done: @escaping (Int?) -> ()) {
        
        viewStatus = .loading
        waitFor?()
        
        let session = URLSession(configuration: .default)
        guard let url = URL(string: baseUrl + "&since=\(sincePage)") else {
            assertionFailure("urlError")
            viewStatus = .loadFail("urlError")
            done(nil)
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
                strongSelf.viewStatus = .loadFail(error.localizedDescription)
                done(nil)
                return
            }
            guard let data = data else {
                assertionFailure("data is nil")
                strongSelf.viewStatus = .loadFail("data is nil")
                done(nil)
                return
            }
            let jsd = JSONDecoder()
            jsd.keyDecodingStrategy = .convertFromSnakeCase
            guard let jsonVoList = try? jsd.decode([UserProfileModel].self, from: data) else {
                assertionFailure("json decode error")
                self?.viewStatus = .loadFail("json decode error")
                done(nil)
                return
            }
            var box: [UserProfileCVCellViewModel] = []
            var count: Int = 0
            for jsonVo in jsonVoList {
                let vo = UserProfileViewModel(with: jsonVo)
                box.append(vo)
                count = jsonVo.id
            }
            strongSelf.viewStatus = .loadDone(
                PageVc.Vo(pageName: "\(strongSelf.nowPage)",
                    haveLastPage: strongSelf.nowPage > 1,
                    haveNextPage: true,
                    userVoList: box
                )
            )
            done(count)
        }
        task.resume()
    }
}
