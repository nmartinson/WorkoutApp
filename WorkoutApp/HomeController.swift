//
//  HomeController.swift
//  WorkoutApp
//
//  Created by Nick on 10/5/15.
//  Copyright © 2015 Nick. All rights reserved.
//

import Foundation
import UIKit

class HomeController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    /**************************************************************************
    *
    ***************************************************************************/
    override func viewDidLoad() {

    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        
        switch indexPath.item
        {
            case 0:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("HomeCell", forIndexPath: indexPath)
            case 1:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("SessionCell", forIndexPath: indexPath)
            case 2:
                cell = collectionView.dequeueReusableCellWithReuseIdentifier("HistoryCell", forIndexPath: indexPath)
            default:
                print("Error")
        }

        return cell!
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**************************************************************************
    *
    ***************************************************************************/
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    

}