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

class UserinfoViewModel {
    
    init(with urlString: String?) {
        self.urlString = urlString
    }
    
    typealias Delegate = UserinfoViewModelDelegate
    weak var delegate: Delegate?
    
    private var waitFor: (() -> ())?
    private var viewStatus: UserinfoVc.Status = .loading
    private let urlString: String?
    private var model: UserInfoModel?
    private var image: UIImage?
}

extension UserinfoViewModel: UserinfoVcViewModel {
    func waitForREfresh(done: @escaping (UserinfoVc.Status) -> ()) {
        waitFor = { [weak self] in
            guard let self = self else {
                assertionFailure("get self error")
                done(.loadFail)
                return
            }
            done(self.viewStatus)
        }
        requestTask { [weak self] in
            self?.waitFor?()
            self?.requestImage { [weak self] in
                self?.waitFor?()
            }
        }
    }
    
    func closeAction() {
        delegate?.closeAction()
    }
    
    func blogLinkAction() {
        delegate?.blogLinkAction(with: nil)
    }
    
    func getAvatar() -> UIImage? {
        image
    }
    
    func getName() -> String? {
        model?.name
    }
    
    func getBio() -> String? {
        model?.bio
    }
    
    func getLogIn() -> String? {
        model?.login
    }
    
    func haveBadge() -> Bool {
        model?.siteAdmin ?? false
    }
    
    func getLocation() -> String? {
        model?.location
    }
    
    func getBlogUrl() -> String? {
        model?.blog
    }
}

extension UserinfoViewModel {
    
    private func requestImage(done: @escaping () -> ()) {
        
        guard let urlString = model?.avatarUrl,
        let url = URL(string: urlString) else {
            done()
            return
        }
        let session = URLSession(configuration: .default)
        let UrlRequest = URLRequest(url: url)
        let task = session.dataTask(
            with: UrlRequest
        ) { [weak self] data, response, error in
            
            guard let strongSelf = self else {
                assertionFailure("self error")
                return
            }
            if let _ = error {
                done()
                return
            }
            guard let data = data else {
                done()
                return
            }
            strongSelf.image = UIImage(data: data)
            done()
        }
        task.resume()
    }
    
    private func requestTask(done: @escaping () -> ()) {
        
        viewStatus = .loading
        waitFor?()
        
        let session = URLSession(configuration: .default)
        guard let urlString = urlString,
            let url = URL(string: urlString) else {
            assertionFailure("urlError")
                viewStatus = .loadFail
            done()
            return
        }
        let UrlRequest = URLRequest(url: url)
        let task = session.dataTask(
            with: UrlRequest
        ) { [weak self] data, response, error in
            
            guard let strongSelf = self else {
                assertionFailure("self error")
                self?.viewStatus = .loadFail
                return
            }
            if let _ = error {
                strongSelf.viewStatus = .loadFail
                done()
                return
            }
            guard let data = data else {
                assertionFailure("data is nil")
                strongSelf.viewStatus = .loadFail
                done()
                return
            }
            let jsd = JSONDecoder()
            jsd.keyDecodingStrategy = .convertFromSnakeCase
            guard let jsonVo = try? jsd.decode(UserInfoModel.self, from: data) else {
                assertionFailure("json decode error")
                self?.viewStatus = .loadFail
                done()
                return
            }
            strongSelf.model = jsonVo
            let vo = UserinfoVc.Vo(
                avataImage: nil,
                name: jsonVo.name,
                bio: jsonVo.bio,
                login: jsonVo.login,
                haveBadge: jsonVo.siteAdmin,
                location: jsonVo.location,
                blogUrl: jsonVo.blog
            )
            strongSelf.viewStatus = .loadDone(vo)
            done()
        }
        task.resume()
    }
}

