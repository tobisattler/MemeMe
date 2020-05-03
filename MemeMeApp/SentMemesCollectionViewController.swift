//
//  SentMemesCollectionViewController.swift
//  MemeMeApp
//
//  Created by Tobias Sattler on 03.05.20.
//  Copyright © 2020 Tobias Sattler. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: SentMemesViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let frameSize = self.view.frame.size
        
        // if view is loaded in portrait mode, use width for calculating size of cell. In landscape mode, use height
        let referenceSize = frameSize.height > frameSize.width ? frameSize.width : frameSize.height
        let dimension = (referenceSize - (2 * space)) / 3.0
        
        self.flowLayout.minimumLineSpacing = space
        self.flowLayout.minimumInteritemSpacing = space
        self.flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
        // calculate left and right margins, if in landscape mode
        calculateSectionInset(frameSize: frameSize)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // calculate left and right margins, if in landscape mode
        calculateSectionInset(frameSize: size)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reload data for the collectionView
        self.collectionView.reloadData()
        
        // TODO: Add only new items (get old size of list and append only new ones)
    }
    
    // MARK: - UI helpers
    
    func calculateSectionInset(frameSize size: CGSize) {
        if (self.flowLayout == nil) {
            return
        }
        
        // create a left and right section inset if device orientation is landscape with using the additional width that would otherwise lead to a larger horizontal space between the entries
        if (size.width > size.height) {
            let additionalSpace = (size.width - self.flowLayout.minimumInteritemSpacing).truncatingRemainder(dividingBy: (self.flowLayout.itemSize.width + self.flowLayout.minimumInteritemSpacing))
            
            self.flowLayout.sectionInset.left = additionalSpace / 2
            self.flowLayout.sectionInset.right = additionalSpace / 2
        } else {
            self.flowLayout.sectionInset.left = 0
            self.flowLayout.sectionInset.right = 0
        }
    }
    
    // MARK: - Collection View handlers
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionCell", for: indexPath) as! MemeCollectionCell
        
        cell.imageView.image = self.memes[indexPath.row].memedImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // showMemeDetails is implemented in SentMemesViewController base class
        self.showMemeDetails(memeId: indexPath.row)
    }
    
}
