//
//  AutoGravityCollectionViewController.swift
//  Image-Downloading
//
//  Created by Thinh Le on 1/7/16.
//  Copyright © 2016 Lac Viet Inc. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MyCell"

class AutoGravityCollectionViewController: UICollectionViewController {
    
    var arrayOfImageURL = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //do_matrix_refresh();
        get_data_from_url("https://pixabay.com/api/?key=103582-ced4be9ff789b472fbfd89dd7&q=yellow+flower&image_type=photo")
        
        print("source control")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfImageURL.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ImageCollectionViewCell
        
        let url = NSURL(string: self.arrayOfImageURL[indexPath.row])
        let contentURL = NSData(contentsOfURL: url!)
        let image = UIImage(data: contentURL!)
        cell.imageView.image = image
        
        return cell
    }
    
    func get_data_from_url(url:String)
    {
        let url = NSURL(string: url)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) -> Void in
            if error != nil {
                print(error)
            } else {
                if data!.length > 0 {
                    self.extract_json(data!)
                } else if data!.length == 0 {
                    print("Nothing was downloaded")
                }
            }
        }
        
        task.resume()
    }
    
    func extract_json(jsonData:NSData) {

        do {
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers)
            if let items = jsonResult["hits"] as? NSArray {
                for item in items {
                    if let previewURL = item["previewURL"] as? String {
                        self.arrayOfImageURL.append(previewURL)
                        //print(previewURL)
                        
                    }
                }
            }
            
            do_matrix_refresh();

        } catch {
            print("JSON serialization failed")
        }
        
    }
    
    func do_matrix_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView!.reloadData()
            return
        })
    }
    
}
