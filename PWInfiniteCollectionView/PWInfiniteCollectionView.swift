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

class PWInfiniteCollectionView: UICollectionView {
    var infiniteDataSource: PWInfiniteCollectionViewDataSource?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
    }
    
}

extension PWInfiniteCollectionView: UICollectionViewDataSource {
    
    // Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let newNumberOfItems = infiniteDataSource?.numberOfItems(collectionView: self) ?? 0
        print("INDEXPATH ITEMCOUNT: \(newNumberOfItems + 2)")
        return newNumberOfItems + 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let infiniteDataSource = infiniteDataSource else {
            fatalError()
        }
        return infiniteDataSource.cellForItemAt(collectionView: self, indexPath: indexPath, dataIndexPath: calculateNewIndexPath(with: indexPath))
    }
    
    func calculateNewIndexPath(with indexPath: IndexPath) -> IndexPath {
        let totalNumberOfItems = infiniteDataSource?.numberOfItems(collectionView: self) ?? 0
        if indexPath.row == 0 {
            return IndexPath(item: 5, section: 0)
        } else if indexPath.row == 7 {
            return IndexPath(item: 0, section: 0)
        } else {
            return IndexPath(item: indexPath.row - 1, section: 0)
        }
    }
}

extension PWInfiniteCollectionView {
//    override var dataSource: UICollectionViewDataSource? {
//        didSet {
//            if let dataSource = self.dataSource {
//                self.dataSource = dataSource.isEqual(self) ? self : dataSource
//            }
//        }
//    }
}
