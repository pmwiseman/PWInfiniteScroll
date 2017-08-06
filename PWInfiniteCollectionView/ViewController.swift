//
//  ViewController.swift
//  PWInfiniteCollectionView
//
//  Created by Patrick Wiseman on 8/2/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: PWInfiniteCollectionView!
    
    var colors = [UIColor.blue, UIColor.black, UIColor.yellow, UIColor.cyan, UIColor.red, UIColor.purple]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageControl.numberOfPages = colors.count
        collectionView.infiniteDataSource = self
        collectionView.infiniteDelegate = self
    }
}

extension ViewController: PWInfiniteCollectionViewDataSource {
    func numberOfItems(collectionView: UICollectionView) -> Int {
        return colors.count
    }
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath, dataIndexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let color = colors[dataIndexPath.row]
        cell.backgroundColor = color
        return cell
    }
}

extension ViewController: PWInfiniteCollectionViewDelegate {
    func currentPageIndexDidChange(with pageIndex: Int) {
        pageControl.currentPage = pageIndex
    }
}
