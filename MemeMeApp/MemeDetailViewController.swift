//
//  MemeDetailViewController.swift
//  MemeMeApp
//
//  Created by Tobias Sattler on 03.05.20.
//  Copyright © 2020 Tobias Sattler. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display memed image
        imageView.image = meme.memedImage
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editMeme))
    }
    
    @objc func editMeme() {
        // instantiate MemeEditorViewController
        let memeEditorVC = self.storyboard?.instantiateViewController(identifier: "MemeEditor") as! MemeEditorViewController
        // set the meme for the MemeEditorViewController to start editor with that meme pre-populated
        memeEditorVC.meme = meme
        // set modalPresentationStyle to fullScreen, so that viewWillAppear will be invoked on list and collection view controllers after editor is closed.
        memeEditorVC.modalPresentationStyle = .fullScreen
        // show editor
        self.present(memeEditorVC, animated: true, completion: nil)
        // remove current controller from navigation stack, so that list / collection view will be shown after editor is being closed.
        self.navigationController!.popViewController(animated: false)
    }
}
