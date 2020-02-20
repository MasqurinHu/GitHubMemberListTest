//
//  UserinfoVc.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/20.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

protocol UserinfoVcDelegate: AnyObject {
    func waitForREfresh(done: @escaping (UserinfoVc.Status) -> ())
    func closeAction()
    func blogLinkAction()
}

protocol UserinfoVcDataSource: AnyObject {
    func getAvatar() -> UIImage?
    func getName() -> String?
    func getBio() -> String?
    func getLogIn() -> String?
    func haveBadge() -> Bool
    func getLocation() -> String?
    func getBlogUrl() -> String?
}

typealias UserinfoVcViewModel = UserinfoVcDelegate & UserinfoVcDataSource

class UserinfoVc: UIViewController {

    typealias Delegate = UserinfoVcDelegate
    typealias DataSource = UserinfoVcDataSource
    typealias ViewModel = UserinfoVcViewModel
    
    weak var delegate: Delegate?
    weak var dataSource: DataSource? {
        didSet {
            setDataSource(with: .loading)
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
        setVc()
        setDataSource(with: .loading)
        layoutVc()
        delegate?.waitForREfresh() { [weak self] status in
            DispatchQueue.main.async { [weak self] in
                self?.setDataSource(with: status)
            }
        }
    }
    
    private let crossBtn: UIButton = UIButton(type: .custom)
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let maskView: UIView = UIView()
    private let loadingView: AnimaView = AnimaFactory.getAnima(
        with: .loading
    )
    private let avatarLoading: AnimaView = AnimaFactory.getAnima(
        with: .avatar
    )
    private let avatarImage: UIImageView = UIImageView()
    private let nameLb: UILabel = UILabel()
    private let bioLb: UILabel = UILabel()
    private let hyphenView: UIView = UIView()
    private let bustView: AnimaView = AnimaFactory.getAnima(with: .bust)
    private let logInLb: UILabel = UILabel()
    private let badgeView: AnimaView = AnimaFactory.getAnima(
        with: .badge
    )
    private let locationIcon: AnimaView = AnimaFactory.getAnima(
        with: .location
    )
    private let locationLb: UILabel = UILabel()
    private let browerIcon: AnimaView = AnimaFactory.getAnima(
        with: .brower
    )
    private let linkBtn: UIButton = UIButton(type: .system)
    private let errorlb: UILabel = UILabel()
    
}

extension UserinfoVc {
    struct Vo {
        let avataImage: UIImage?
        let name: String?
        let bio: String?
        let login: String?
        let haveBadge: Bool
        let location: String?
        let blogUrl: String?
    }
    enum Status {
        case loading,
        loadDone(Vo),
        loadFail
    }
}

extension UserinfoVc {
    private func setDataSource(with status: Status) {
        guard let dataSource = dataSource else {
            assertionFailure("not have datasource")
            return
        }
        switch status {
        case .loading:
            loadingView.setLootMode(with: .loop)
            maskView.isHidden = false
            loadingView.isHidden = false
            errorlb.isHidden = true
            loadingView.play { isDone in
                
            }
            
        case .loadDone(_):
            loadingView.pause()
            maskView.isHidden = true
            
        case .loadFail:
            maskView.isHidden = false
            loadingView.isHidden = true
            errorlb.isHidden = false
            return
        }
        
        setAvatar(with: dataSource)
        setName(with: dataSource)
        setBio(with: dataSource)
        setLogIn(with: dataSource)
        setBadge(with: dataSource)
        setLocation(with: dataSource)
        setBlogUrl(with: dataSource)
    }
    private func setAvatar(with dataSource: DataSource) {
        avatarImage.image = dataSource.getAvatar()
        if dataSource.getAvatar() != nil {
            avatarLoading.isHidden = true
            avatarLoading.pause()
            return
        }
        avatarLoading.isHidden = false
        avatarLoading.setLootMode(with: .autoReverSe)
        avatarLoading.play { isDone in
            
        }
    }
    private func setName(with dataSource: DataSource) {
        nameLb.text = dataSource.getName()
    }
    private func setBio(with dataSource: DataSource) {
        bioLb.text = dataSource.getBio()
    }
    private func setLogIn(with dataSource: DataSource) {
        logInLb.text = dataSource.getLogIn()
    }
    private func setBadge(with dataSource: DataSource) {
        badgeView.isHidden = !dataSource.haveBadge()
    }
    private func setLocation(with dataSource: DataSource) {
        locationLb.text = dataSource.getLocation()
    }
    private func setBlogUrl(with dataSource: DataSource) {
        linkBtn.setTitle(dataSource.getBlogUrl(), for: .normal)
    }
}

extension UserinfoVc {
    @objc private func closeBtnAction(_: UIButton) {
        delegate?.closeAction()
    }
    @objc private func linkBtnAction(_: UIButton) {
        delegate?.blogLinkAction()
    }
}

extension UserinfoVc {
    private func setVc() {
        setCrossBtn()
        setMaskView()
        setErrorLb()
        setContentView()
        setNameLb()
        setBioLb()
        setHypen()
        setBustIcon()
        setBadge()
        setLocationIcon()
        setBrowerIcon()
        setLinkBtn()
    }
    private func setCrossBtn() {
        crossBtn.setTitle("X", for: .normal)
        crossBtn.titleLabel?.font = crossBtn.titleLabel?.font.withSize(40)
        crossBtn.addTarget(self, action: #selector(closeBtnAction(_:)), for: .touchUpInside)
    }
    private func setMaskView() {
        maskView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
    }
    
    private func setErrorLb() {
        errorlb.font = UIFont().withSize(20)
        errorlb.textAlignment = .center
        errorlb.textColor = .red
        errorlb.text = "Error please click X button!"
    }
    private func setContentView() {
        contentView.backgroundColor = .white
    }
    
    private func setNameLb() {
        nameLb.font = nameLb.font.withSize(20)
        nameLb.textAlignment = .center
    }
    private func setBioLb() {
        bioLb.textAlignment = .center
    }
    private func setHypen() {
        hyphenView.backgroundColor = .darkGray
    }
    private func setBustIcon() {
        bustView.setLootMode(with: .loop)
        bustView.play { isDone in
            
        }
    }
    private func setBadge() {
        badgeView.setLootMode(with: .loop)
        badgeView.play { isDone in
            
        }
    }
    private func setLocationIcon() {
        locationIcon.setLootMode(with: .loop)
        locationIcon.play { isDone in
            
        }
    }
    private func setBrowerIcon() {
        browerIcon.setLootMode(with: .loop)
        browerIcon.play { isDone in
            
        }
    }
    private func setLinkBtn() {
        linkBtn.addTarget(self, action: #selector(linkBtnAction(_:)), for: .touchUpInside)
    }
}

extension UserinfoVc {
    private var padding: CGFloat { 12 }
    private var gap: CGFloat { 8 }
    private var btnLength: CGFloat { 44 }
    private var iconLength: CGFloat { 30 }
    private var avatarLength: CGFloat { 200 }
    
}

extension UserinfoVc {
    
    private func layoutVc() {
        
        layoutCrossBtn()
        layoutScrollView()
        layoutContentView()
        layoutMaskView()
        layoutLoadingView()
        layoutErrorLb()
        layoutAvatarLoadingView()
        layoutAvatarImage()
        layoutNameLb()
        layoutBioLb()
        layoutHypenView()
        layoutBustIcon()
        layoutLogInLb()
        layoutBadge()
        layoutLocationView()
        layoutLocationLb()
        layoutBrower()
        layoutLinkBtn()
    }
    
    private func layoutCrossBtn() {
        
        setSameBaseLayout(with: crossBtn)
        NSLayoutConstraint.activate([
            crossBtn.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: padding
            ),
            crossBtn.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: padding
            ),
            crossBtn.widthAnchor.constraint(equalToConstant: btnLength),
            crossBtn.heightAnchor.constraint(equalToConstant: btnLength)
        ])
    }
    
    private func layoutScrollView() {
        setSameBaseLayout(with: scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: crossBtn.bottomAnchor
            ),
            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    
    private func layoutContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(
                equalTo: scrollView.topAnchor
            ),
            contentView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor,
                constant: padding
            ),
            contentView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor,
                constant: padding
            ),
            contentView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor,
                constant: -padding
            ),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func layoutMaskView() {
        setSameBaseLayout(with: maskView)
        NSLayoutConstraint.activate([
            maskView.topAnchor.constraint(
                equalTo: crossBtn.bottomAnchor
            ),
            maskView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            maskView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
            maskView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }
    
    private func layoutLoadingView() {
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        maskView.addSubview(loadingView)
        let length = UIScreen.main.bounds.width * 0.7
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(
                equalTo: maskView.centerXAnchor
            ),
            loadingView.centerYAnchor.constraint(
                equalTo: maskView.centerYAnchor
            ),
            loadingView.widthAnchor.constraint(equalToConstant: length),
            loadingView.heightAnchor.constraint(equalToConstant: length)
        ])
    }
    
    private func layoutErrorLb() {
        
        errorlb.translatesAutoresizingMaskIntoConstraints = false
        maskView.addSubview(errorlb)
        NSLayoutConstraint.activate([
            errorlb.trailingAnchor.constraint(
                equalTo: maskView.trailingAnchor
            ),
            errorlb.centerYAnchor.constraint(
                equalTo: maskView.centerYAnchor
            ),
            errorlb.leadingAnchor.constraint(equalTo: maskView.leadingAnchor)
        ])
    }
    
    private func layoutAvatarLoadingView() {
        
        setSameAvatarLayout(with: avatarLoading)
    }
    
    private func layoutAvatarImage() {
        setSameAvatarLayout(with: avatarImage)
    }
    
    private func setSameAvatarLayout(with avatar: UIView) {
    
        setSameLayoutInContentView(with: avatar)
        NSLayoutConstraint.activate([
            avatar.widthAnchor.constraint(
                equalToConstant: avatarLength
            ),
            avatar.heightAnchor.constraint(
                equalToConstant: avatarLength
            ),
            avatar.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            avatar.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            )
        ])

    }
    
    private func layoutNameLb() {
        setSameLayoutInContentView(with: nameLb)
        NSLayoutConstraint.activate([
            nameLb.topAnchor.constraint(
                equalTo: avatarImage.bottomAnchor,
                constant: gap
            ),
            nameLb.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            nameLb.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            )
        ])
    }
    
    private func layoutBioLb() {
        setSameLayoutInContentView(with: bioLb)
        NSLayoutConstraint.activate([
            bioLb.topAnchor.constraint(
                equalTo: nameLb.bottomAnchor,
                constant: gap
            ),
            bioLb.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            bioLb.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            )
        ])
    }
    
    private func layoutHypenView() {
        setSameLayoutInContentView(with: hyphenView)
        NSLayoutConstraint.activate([
            hyphenView.topAnchor.constraint(
                equalTo: bioLb.bottomAnchor,
                constant: padding
            ),
            hyphenView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            hyphenView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            hyphenView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func layoutBustIcon() {
        setSameLayoutInContentView(with: bustView)
        NSLayoutConstraint.activate([
            bustView.topAnchor.constraint(
                equalTo: hyphenView.bottomAnchor,
                constant: padding
            ),
            bustView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            bustView.widthAnchor.constraint(equalToConstant: iconLength),
            bustView.heightAnchor.constraint(equalToConstant: iconLength)
        ])
    }
    
    private func layoutLogInLb() {
        setSameLeadingGapLayout(with: logInLb)
        NSLayoutConstraint.activate([
            logInLb.topAnchor.constraint(equalTo: bustView.topAnchor),
            logInLb.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: padding
            )
        ])
    }
    
    private func layoutBadge() {
        setSameLeadingGapLayout(with: badgeView)
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(
                equalTo: logInLb.bottomAnchor,
                constant: gap
            ),
            badgeView.widthAnchor.constraint(
                equalToConstant: iconLength
            ),
            badgeView.heightAnchor.constraint(
                equalToConstant: iconLength
            )
        ])
    }
    
    private func layoutLocationView() {
        setSameLayoutInContentView(with: locationIcon)
        NSLayoutConstraint.activate([
            locationIcon.topAnchor.constraint(
                equalTo: bustView.bottomAnchor,
                constant: padding
            ),
            locationIcon.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            locationIcon.widthAnchor.constraint(
                equalToConstant: iconLength
            ),
            locationIcon.heightAnchor.constraint(
                equalToConstant: iconLength
            )
        ])
    }
    
    private func layoutLocationLb() {
        setSameLeadingGapLayout(with: locationLb)
        NSLayoutConstraint.activate([
            locationLb.centerYAnchor.constraint(
                equalTo: locationIcon.centerYAnchor
            ),
            locationLb.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: padding
            )
        ])
    }
    
    private func layoutBrower() {
        setSameLayoutInContentView(with: browerIcon)
        NSLayoutConstraint.activate([
            browerIcon.topAnchor.constraint(
                equalTo: locationIcon.bottomAnchor,
                constant: padding
            ),
            browerIcon.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            browerIcon.widthAnchor.constraint(
                equalToConstant: iconLength
            ),
            browerIcon.heightAnchor.constraint(
                equalToConstant: iconLength
            ),
            browerIcon.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }
    
    private func layoutLinkBtn() {
        setSameLeadingGapLayout(with: linkBtn)
        NSLayoutConstraint.activate([
            linkBtn.centerYAnchor.constraint(
                equalTo: browerIcon.centerYAnchor
            ),
            linkBtn.trailingAnchor.constraint(
                lessThanOrEqualTo: contentView.trailingAnchor,
                constant: padding
            )
        ])
    }
    
    private func setSameBaseLayout(with newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newView)
    }
    
    private func setSameLayoutInContentView(with newView: UIView) {
        newView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newView)
    }
    
    private func setSameLeadingGapLayout(with newView: UIView) {
        
        setSameLayoutInContentView(with: newView)
        NSLayoutConstraint.activate([
            newView.leadingAnchor.constraint(
                equalTo: bustView.trailingAnchor,
                constant: padding
            )
        ])
    }
}

