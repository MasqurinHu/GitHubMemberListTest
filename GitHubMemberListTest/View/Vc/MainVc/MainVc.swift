//
//  MainVc.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

protocol MainVcDelegate: AnyObject {
    func buttonAction(with type: MainVc.ButtonType)
}

protocol MainVcDataSource: AnyObject {
    func getButton(with type: MainVc.ButtonType) -> String
}

typealias MainVcViewModel = MainVcDelegate & MainVcDataSource

class MainVc: UIViewController {
    
    typealias Delegate = MainVcDelegate
    typealias DataSource = MainVcDataSource
    typealias ViewModel = MainVcViewModel
    
    private let firstBtn: UIButton = UIButton()
    
    weak var delegate: Delegate?
    weak var dataSource: DataSource? {
        didSet {
            setDataSource()
        }
    }
    
    var viewModel: ViewModel? {
        didSet {
            delegate = viewModel
            dataSource = viewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        layoutVc()
        setVc()
    }
}

extension MainVc {
    enum ButtonType {
        case first
    }
}

extension MainVc {
    
    private func setVc() {
        
        setFirstButton()
    }
    
    private func setFirstButton() {
        
        firstBtn.addTarget(self, action: #selector(btnAction(with:)), for: .touchUpInside)
    }
}

extension MainVc {
    private func setDataSource() {
        
        firstBtn.setTitle(dataSource?.getButton(with: .first), for: .normal)
    }
}

extension MainVc {
    @objc private func btnAction(with btn: UIButton) {
        
        switch btn {
        case firstBtn:
            delegate?.buttonAction(with: .first)
        default:
            break
        }
    }
}

extension MainVc {
    
    private func layoutVc() {
        
        layoutFirstButton()
    }
    
    private func layoutFirstButton() {
        
        setSameLayout(with: firstBtn)
        NSLayoutConstraint.activate([
            firstBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            firstBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setSameLayout(with newView: UIView) {
        view.addSubview(newView)
        newView.translatesAutoresizingMaskIntoConstraints = false
    }
}
