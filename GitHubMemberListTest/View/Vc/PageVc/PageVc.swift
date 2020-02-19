//
//  PageVc.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/19.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

protocol PageVcDelegate: AnyObject {
    func retryAction()
    func lastButtonAction()
    func nextButtonAction()
    func waitForRefresh(_:() -> ())
}

protocol PageVcDataSource: AnyObject {
    
    func getStatus() -> PageVc.Status
}

typealias PageVcViewModel = PageVcDelegate & PageVcDataSource

class PageVc: UIViewController {

    typealias Delegate = PageVcDelegate
    typealias DataSource = PageVcDataSource
    typealias ViewModel = PageVcViewModel
    
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
        delegate?.waitForRefresh { [weak self] in
            self?.setDataSource()
        }
    }
    
    private let pageNameLb: UILabel = UILabel()
    private let lastBtn: UIButton = UIButton(type: .system)
    private let nextBtn: UIButton = UIButton(type: .system)
    private let retryBtn: UIButton = UIButton(type: .system)
    private let loadingView: UIView = UIView()
    private let retryView: UIView = UIView()
    private lazy var collectionView: UICollectionView = getCollectionView()
}

extension PageVc {
    
    private func getCollectionView() -> UICollectionView {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 84)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .vertical
        
        return UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    }
    
    private func setVc() {
        setLastBtn()
        setNextBtn()
        setCollectionBtn()
        setLoadingView()
        setRetrytBtn()
        setRetryView()
    }
    
    private func setLastBtn() {
        lastBtn.setTitle("lastPage", for: .normal)
        lastBtn.addTarget(self, action: #selector(lastBtnAction(_:)), for: .touchUpInside)
    }
    private func setNextBtn() {
        nextBtn.setTitle("nextPage", for: .normal)
        nextBtn.addTarget(self, action: #selector(nextBtnAction(_:)), for: .touchUpInside)
    }
    private func setRetrytBtn() {
        retryBtn.setTitle("retry", for: .normal)
        retryBtn.addTarget(self, action: #selector(retryBtnAction), for: .touchUpInside)
    }
    private func setCollectionBtn() {
        collectionView.register(UserProfileCVCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func setLoadingView() {
        loadingView.backgroundColor = maskColor
    }
    
    private func setRetryView() {
        retryView.backgroundColor = maskColor
    }
    
    @objc private func lastBtnAction(_: UIButton) {
        delegate?.lastButtonAction()
    }
    @objc private func nextBtnAction(_: UIButton) {
        delegate?.nextButtonAction()
    }
    @objc private func retryBtnAction(_: UIButton) {
        delegate?.retryAction()
    }
    private var cellId: String {"userProfileCell"}
    private var maskColor: UIColor {.init(red: 0, green: 0, blue: 0, alpha: 0.7)}
}

extension PageVc {
    
    private func layoutVc() {
        
        layoutNameLb()
        layoutLastBtn()
        layoutNextBtn()
        layoutCollectionView()
        layoutLoadingView()
        layoutRetryView()
    }
    
    private func layoutNameLb() {
        
        setSameLayout(with: pageNameLb)
        NSLayoutConstraint.activate([
            pageNameLb.heightAnchor.constraint(equalToConstant: 20),
            pageNameLb.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageNameLb.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: 0
            )
        ])
        pageNameLb.sizeToFit()
    }
    
    private func layoutLastBtn() {
        
        setSameLayout(with: lastBtn)
        NSLayoutConstraint.activate([
            lastBtn.trailingAnchor.constraint(equalTo: pageNameLb.leadingAnchor, constant: -8),
            lastBtn.bottomAnchor.constraint(equalTo: pageNameLb.bottomAnchor),
            lastBtn.leadingAnchor.constraint(
                greaterThanOrEqualTo: view.leadingAnchor,
                constant: 8
            )
        ])
    }
    
    private func layoutNextBtn() {
        
        setSameLayout(with: nextBtn)
        NSLayoutConstraint.activate([
            nextBtn.leadingAnchor.constraint(equalTo: pageNameLb.trailingAnchor, constant: 8),
            nextBtn.bottomAnchor.constraint(equalTo: pageNameLb.bottomAnchor),
            nextBtn.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func layoutCollectionView() {
        
        setSameLayout(with: collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: pageNameLb.topAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func layoutLoadingView() {
        
        setSameMaskLayout(with: loadingView)
        let length: CGFloat = UIScreen.main.bounds.width * 0.8
        let animaView = AnimaFactory.getAnima(with: .loading)
        animaView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(animaView)
        NSLayoutConstraint.activate([
            animaView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animaView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animaView.widthAnchor.constraint(equalToConstant: length),
            animaView.heightAnchor.constraint(equalToConstant: length)
        ])
        animaView.setLootMode(with: .loop)
        animaView.play { isDone in
            
        }
    }
    
    private func layoutRetryView() {
        setSameMaskLayout(with: retryView)
        retryBtn.translatesAutoresizingMaskIntoConstraints = false
        retryView.addSubview(retryBtn)
        NSLayoutConstraint.activate([
            retryBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            retryBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        retryBtn.sizeToFit()
    }
    
    private func setSameLayout(with newView: UIView) {
        
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
    }
    
    private func setSameMaskLayout(with newView: UIView) {
        
        setSameLayout(with: newView)
        
        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newView.topAnchor.constraint(equalTo: view.topAnchor),
            newView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }
}

extension PageVc {
    
    private func setDataSource() {
        
        guard let dataSource = dataSource else {
            assertionFailure("not have dataSource")
            return
        }
        switch dataSource.getStatus() {
        case .loading:
            retryView.isHidden = true
            loadingView.isHidden = false
        case .loadDone(let vo):
            retryView.isHidden = true
            loadingView.isHidden = true
            setLastBtn(with: vo)
            setNextBtn(with: vo)
            setName(with: vo)
        case .loadFail(_):
            retryView.isHidden = false
            loadingView.isHidden = true
        }
        collectionView.reloadData()
    }
    private func setLastBtn(with vo: Vo) {
        lastBtn.isHidden = !vo.haveLastPage
    }
    private func setNextBtn(with vo: Vo) {
        nextBtn.isHidden = !vo.haveNextPage
    }
    private func setName(with vo: Vo) {
        pageNameLb.text = vo.pageName
    }
    
}

extension PageVc: UICollectionViewDelegate {
    
}

extension PageVc: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        switch dataSource.getStatus() {
        case .loading,
             .loadFail(_):
            return 0
        case .loadDone(let vo):
            return vo.userVoList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let originalCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        guard let dataSource = dataSource else {
            assertionFailure("not have dataSource")
            return originalCell
        }
        let voBox: Vo
        switch dataSource.getStatus() {
        case .loading,
             .loadFail(_):
            assertionFailure("this status count need zero")
            return originalCell
        case .loadDone(let vo):
            voBox = vo
            pageNameLb.text = vo.pageName
        }
        guard let cell = originalCell as? UserProfileCVCell else {
            assertionFailure("cellId not mappimg cell class")
            return originalCell
        }
        guard voBox.userVoList.count > indexPath.item else {
            assertionFailure("vo count error")
            return originalCell
        }
        cell.viewModel = voBox.userVoList[indexPath.item]
        return cell
    }
}

extension PageVc {
    
}

extension PageVc {
    
}

extension PageVc {
    
    enum Status {
        case loading,
        loadDone(Vo),
        loadFail(String)
    }
    
    struct Vo {
        let pageName: String
        let haveLastPage: Bool
        let haveNextPage: Bool
        let userVoList: [UserProfileCVCellViewModel]
    }
}


