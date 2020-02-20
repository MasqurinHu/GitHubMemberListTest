//
//  MainViewModel.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import Foundation

protocol MainViewModelDelegate: AnyObject {
    func goPageList()
}

class MainViewModel: MainVcViewModel {
    
    typealias Delegate = MainViewModelDelegate
    
    weak var delegate: Delegate?
    
    init(with delegate: Delegate) {
        self.delegate = delegate
    }
    
}

extension MainViewModel {
    
    func getButton(with type: MainVc.ButtonType) -> String {
        
        switch type {
        case .first:
            return "打開列表"
        }
    }
}

extension MainViewModel {
    
    func buttonAction(with type: MainVc.ButtonType) {
        
        switch type {
        case .first:
            delegate?.goPageList()
        }
    }
}
