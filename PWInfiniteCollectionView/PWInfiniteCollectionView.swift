//
//  PWInfiniteCollectionView.swift
//  PWInfiniteCollectionView
//
//  Created by Patrick Wiseman on 8/5/17.
//  Copyright © 2017 Patrick Wiseman. All rights reserved.
//

import UIKit

protocol PWInfiniteCollectionViewDataSource {
    func numberOfItems(collectionView: UICollectionView) -> Int
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath, dataIndexPath: IndexPath) -> UICollectionViewCell
}

protocol PWInfiniteCollectionViewDelegate {
    func currentPageIndexDidChange(with pageIndex: Int)
}

class PWInfiniteCollectionView: UICollectionView {
    var infiniteDataSource: PWInfiniteCollectionViewDataSource?
    var infiniteDelegate: PWInfiniteCollectionViewDelegate?
    
    fileprivate var pageCount = 0
    fileprivate let extraPageCount = 2
    fileprivate var pageHeight = CGFloat(0)
    fileprivate var pageWidth = CGFloat(0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //paging settings
        isPagingEnabled = true
        pageHeight = frame.height
        pageWidth = frame.width
        
        //scroll settings
        showsHorizontalScrollIndicator = false
        let layout = collectionViewLayout as? UICollectionViewFlowLayout
        layout?.scrollDirection = .horizontal
        
        dataSource = self
        delegate = self
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        //offset to first page
        let firstPageOffsetPoint = CGPoint(x: pageWidth, y: 0)
        setContentOffset(firstPageOffsetPoint, animated: false)
    }
    
    fileprivate var numberOfPages: Int {
        return pageCount + extraPageCount
    }
}

// MARK: - Data Source

extension PWInfiniteCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageCount = infiniteDataSource?.numberOfItems(collectionView: self) ?? 0
        return pageCount + extraPageCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let infiniteDataSource = infiniteDataSource else {
            fatalError()
        }
        return infiniteDataSource.cellForItemAt(collectionView: self, indexPath: indexPath, dataIndexPath: calculateNewIndexPath(with: indexPath))
    }
    
    func calculateNewIndexPath(with indexPath: IndexPath) -> IndexPath {
        if indexPath.row == 0 {
            return IndexPath(item: pageCount - 1, section: 0)
        } else if indexPath.row == numberOfPages - 1 {
            return IndexPath(item: 0, section: 0)
        } else {
            return IndexPath(item: indexPath.row - 1, section: 0)
        }
    }
}

// MARK: - Flow Layout

extension PWInfiniteCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: pageWidth, height: pageHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(0)
    }
}

// MARK: - Scroll View Delegate

extension PWInfiniteCollectionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //left scroll
        if scrollView.contentOffset.x <= frame.origin.x {
            let lastColorFrame = CGRect(x: pageWidth*CGFloat(pageCount), y: 0, width: pageWidth, height: frame.height)
            scrollRectToVisible(lastColorFrame, animated: false)
        } else if scrollView.contentOffset.x >= (contentSize.width - pageWidth) {
            let firstColorFrame = CGRect(x: pageWidth, y: 0, width: pageWidth, height: frame.height)
            scrollRectToVisible(firstColorFrame, animated: false)
        }
        let newPageIndex = calculatePageIndex(withOffset: contentOffset.x)
        infiniteDelegate?.currentPageIndexDidChange(with: newPageIndex)
    }
    
    private func calculatePageIndex(withOffset offset:CGFloat) -> Int{
        let pageNumber = Int(offset/pageWidth)
        if pageNumber == 0 {
            return numberOfPages - 1
        } else if pageNumber == numberOfPages - 1 {
            return 0
        } else {
            return pageNumber - 1
        }
    }
}

