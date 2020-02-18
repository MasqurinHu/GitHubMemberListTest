//
//  ViewController.swift
//  GitHubMemberListTest
//
//  Created by 五加一 on 2020/2/18.
//  Copyright © 2020 五加一. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
    }


}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let originalCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath
        )
        guard let cell = originalCell as? UserProfileCVCell else {
            return originalCell
        }
        cell.viewModel = DummyData()
        return cell
    }
}

extension ViewController {
    private var cellId: String {"profileCell"}
    
    private func setCollectionView() {
        collectionView.register(UserProfileCVCell.self, forCellWithReuseIdentifier: cellId)
    }
}

class DummyData: UserProfileCVCellViewModel {
    func getAvata() -> UIImage {
        return UIImage(data: try! Data(contentsOf: URL(string: "https://img2.woyaogexing.com/2020/02/18/1571faf051584a8eae1c1f03ab2cfea3!400x400.jpeg")!))!
    }
    
    func getLogInName() -> String {
        return "testName"
    }
    
    func getHasBadge() -> Bool {
        return Int.random(in: 0 ... 1) == 0
    }
}
