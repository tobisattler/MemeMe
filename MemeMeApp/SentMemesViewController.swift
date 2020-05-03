//
//  SentMemesViewController.swift
//  MemeMeApp
//
//  Created by Tobias Sattler on 03.05.20.
//  Copyright © 2020 Tobias Sattler. All rights reserved.
//

import UIKit

// provides basic functionality, that both SentMemesTableViewController and SentMemesCollectionViewController need
class SentMemesViewController: UIViewController {
    // MARK: - Properties
    
    // Memes array from AppDelegate class
    var memes: [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: - App Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(showMemeEditor))
    }
    
    // MARK: - helper functions
    @objc func showMemeEditor() {
        let memeEditorVC = self.storyboard?.instantiateViewController(identifier: "MemeEditor") as! MemeEditorViewController
        memeEditorVC.modalPresentationStyle = .fullScreen
        self.present(memeEditorVC, animated: true, completion: nil)
    }
    
    func showMemeDetails(memeId id: Int) {
        // instantiate MemeDetailViewController, set the correct meme and push it to the navigation stack
        let meme = self.memes[id]
        let memeDetailVC = self.storyboard?.instantiateViewController(identifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailVC.meme = meme
        self.navigationController!.pushViewController(memeDetailVC, animated: true)
    }
}
