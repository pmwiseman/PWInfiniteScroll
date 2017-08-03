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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var colors = [UIColor.blue, UIColor.black, UIColor.yellow, UIColor.cyan, UIColor.red, UIColor.purple]
    var originalCount = 0
    var pageWidth = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalCount = colors.count
        pageControl.numberOfPages = originalCount
        createInfiniteColorPagingDataStructure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageWidth = view.frame.size.width
        let frame = CGRect(x: pageWidth, y: 0, width: pageWidth, height: 100)
        collectionView.scrollRectToVisible(frame, animated: false)
    }
    
    func createInfiniteColorPagingDataStructure() {
        let firstColor = colors.first
        let lastColor = colors.last
        if let _firstColor = firstColor, let _lastColor = lastColor {
            colors.append(_firstColor)
            colors.insert(_lastColor, at: 0)
        }
    }
    
    func setPageControl(withOffset offset: CGFloat) {
        let index = Int(floor(offset/pageWidth))
        if index == 0 {
            pageControl.currentPage = originalCount - 1
        } else if index == colors.count - 1 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = index - 1
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let color = colors[indexPath.row]
        cell.backgroundColor = color
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //left scroll
        if scrollView.contentOffset.x <= collectionView.frame.origin.x {
            let lastColorFrame = CGRect(x: pageWidth*CGFloat(originalCount), y: 0, width: pageWidth, height: 100)
            collectionView.scrollRectToVisible(lastColorFrame, animated: false)
        } else if scrollView.contentOffset.x >= (collectionView.contentSize.width - pageWidth) {
            let firstColorFrame = CGRect(x: pageWidth, y: 0, width: pageWidth, height: 100)
            collectionView.scrollRectToVisible(firstColorFrame, animated: false)
        }
        setPageControl(withOffset: scrollView.contentOffset.x)
    }
}
