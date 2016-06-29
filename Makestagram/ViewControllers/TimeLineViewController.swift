//
//  TimeLineViewController.swift
//  Makestagram
//
//  Created by Miriam Hendler on 6/23/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit


//public protocol TimelineComponentTarget: class {
//    associatedtype ContentType
    
//    var defaultRange: Range<Int> { get }
//    var additionalRangeSize: Int { get }
//    var tableView: UITableView! { get }
//    func loadInRange(range: Range<Int>, completionBlock: ([ContentType]?) -> Void)
//}

class TimeLineViewController: UIViewController, TimelineComponentTarget {

    
    var timelineComponent: TimelineComponent<Post, TimeLineViewController>!
    
    var photoTakingHelper: PhotoTakingHelper?
    
    let defaultRange: Range<Int> = 0...4
    let additionalRangeSize = 5
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        timelineComponent = TimelineComponent(target: self)
        self.tabBarController?.delegate = self
    }
    
    
    // MARK: Table View Delegate
    
    var posts: [Post] = []
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        timelineComponent.loadInitialIfRequired()
        // self.tableVIew.reloadData()
    }
    
    
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
        // 1
        ParseHelper.timelineRequestForCurrentUser(range) { (result: [PFObject]?, error: NSError?) -> Void in
            // 2
            let posts = result as? [Post] ?? []
            // 3
            completionBlock(posts)
            
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
        }
    }
}

extension TimeLineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.timelineComponent.content.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 470
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowsInSection: \(posts.count)")
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath: \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
        
        let post = timelineComponent.content[indexPath.section]
        post.downloadImage()
        post.fetchLikes()
        cell.post = post
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        timelineComponent.targetWillDisplayEntry(indexPath.section)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("postHeader") as! PostSectionHeaderView
        
        let post = self.timelineComponent.content[section]
        headerCell.post = post
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}



// MARK: Tab Bar Delegate

extension TimeLineViewController: UITabBarControllerDelegate {
    
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool{
        
        func takePhoto() {
            photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!, callBack: { (image: UIImage?) in
                print("taking a photo!!!!")
                let post = Post()
                post.image.value = image!
                post.uploadPost()
            })
        }
        
        if (viewController is PhotoViewController) {
            takePhoto()
            return false
        } else {
            return true
        }
        
    }
    
}





















