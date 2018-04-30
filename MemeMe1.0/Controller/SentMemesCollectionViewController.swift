//
//  SentMemesCollectionViewController.swift
//  MemeMe1.0
//
//  Created by 秋山剛 on 2018/04/29.
//  Copyright © 2018 秋山剛. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    // MARK: Properties
    
    var memes: [Memes]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Outlet
    
    @IBOutlet var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(SentMemesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        collectionView!.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemesCollectionViewCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Configure the cell
        cell.memedImg.image = meme.originalImage
        cell.topLabel.text = meme.topText
        cell.bootomLabel.text = meme.bottomText
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailMemeVC = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let meme = self.memes[(indexPath as NSIndexPath).row]
        detailMemeVC.meme = meme
        
        navigationController?.pushViewController(detailMemeVC, animated: true)
    }

}
