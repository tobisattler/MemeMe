//
//  SentMemesTableViewController.swift
//  MemeMeApp
//
//  Created by Tobias Sattler on 03.05.20.
//  Copyright © 2020 Tobias Sattler. All rights reserved.
//

import UIKit

class SentMemesTableViewController: SentMemesViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IBOutlets
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    // MARK: - UI helpers
    
    // Note: This is a helper function used as a workaround for an IOS 13.x bug, called within MemeEditorViewController. More information on this bug is inclueded there.
    func reloadData() {
        // reload data for the collectionView
        self.tableView.reloadData()
    }
    
    // MARK: - tableView handlers
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return the number of memes stored in the AppDelegate meme array
        let count = self.memes.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue table cell and populate it with the memedImage as well as the meme texts
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableCell") as! MemeTableCell
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.memedImage
        cell.topLabel.text = meme.topText
        cell.bottomLabel.text = meme.bottomText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // showMemeDetails is implemented in SentMemesViewController base class
        self.showMemeDetails(memeId: indexPath.row)
    }
    
}
