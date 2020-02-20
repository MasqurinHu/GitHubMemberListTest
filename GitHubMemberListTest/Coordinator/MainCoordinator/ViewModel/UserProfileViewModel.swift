//
//  UserProfileViewModel.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

class UserProfileViewModel {
    
    init(with model: UserProfileModel) {
        self.model = model
    }
    
    private let model: UserProfileModel
    private var image: UIImage?
    private var task: URLSessionDataTask?
}

extension UserProfileViewModel: UserProfileCVCellViewModel {
    
    func getUserInfoUrlString() -> String? {
        model.url
    }
    
    
    func cancelTask() {
        task?.cancel()
        task = nil
    }
    
    func waitForRefresh(done: @escaping () -> ()) {
        image = nil
        task?.cancel()
        task = nil
        let session = URLSession(configuration: .default)
        guard let url = URL(string: model.avatarUrl) else {
            assertionFailure("urlError")
            done()
            return
        }
        let UrlRequest = URLRequest(url: url)
        task = session.dataTask(
            with: UrlRequest
        ) { [weak self] data, response, error in
            
            if let _ = error {
//                assertionFailure(error.localizedDescription)
                done()
                return
            }
            guard let data = data else {
                assertionFailure("data is nil")
                done()
                return
            }
            self?.image = UIImage(data: data)
            done()
        }
        task?.resume()
    }
    
    
    func getAvata() -> UIImage? {
        return image
    }
    
    func getLogInName() -> String {
        return model.login
    }
    
    func getHasBadge() -> Bool {
        return model.siteAdmin
    }
}
