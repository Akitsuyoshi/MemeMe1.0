//
//  SentMemesTableViewController.swift
//  MemeMe1.0
//
//  Created by 秋山剛 on 2018/04/29.
//  Copyright © 2018 秋山剛. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesTableViewCell"

class SentMemesTableViewController: UITableViewController {
    // MARK: Properties
    
    var memes: [Memes]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Outlet
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SentMemesTableViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]

        // Configure the cell...
        cell.memedImg.image = meme.memedImage
        cell.textL.text = meme.topText + meme.bottomText
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        detailVC.meme = meme
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
 

}
