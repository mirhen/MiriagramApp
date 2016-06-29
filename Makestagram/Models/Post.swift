//
//  Post.swift
//  Makestagram
//
//  Created by Miriam Hendler on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond
import ConvenienceKit

class Post: PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    var image: Observable<UIImage?> = Observable(nil)
    var photoUploadTask: UIBackgroundTaskIdentifier?
    var likes: Observable<[PFUser]?> = Observable(nil)
    static var imageCache: NSCacheSwift<String, UIImage>!
    
    
    
    
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
            // 1
            Post.imageCache = NSCacheSwift<String, UIImage>()
        }
    }
    
    func uploadPost() {
        if let image = image.value {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {
                return
            }
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {
                return
            }
            
            user = PFUser.currentUser()
            self.imageFile = imageFile
            //this doesnt allow us to upload phto when app is closed
            //saveInBackgroundWithBlock(nil)
            print("post is uploaded!!")
            //this does
            photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
            
            }
            print(photoUploadTask)
            saveInBackgroundWithBlock() { (success: Bool, error: NSError?) in
                
                UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)

                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
            }
            
            
        }
    }
    
    func downloadImage() {
        // 1
        image.value = Post.imageCache[self.imageFile!.name]
        
        // if image is not downloaded yet, get it
        if (image.value == nil) {
            
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError?) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale:1.0)!
                    self.image.value = image
                    // 2
                    Post.imageCache[self.imageFile!.name] = image
                }
                if let error = error {
                    ErrorHandling.defaultErrorHandler(error)
                }
            }
        }
    }
    
        func fetchLikes() {
        if (likes.value != nil) {
            return
        }
        
        ParseHelper.likesForPost(self, completionBlock:{ (likes: [PFObject]?, error: NSError? ) -> Void in
            let validLikes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil }
            
            self.likes.value = validLikes?.map { like in
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
                
                return fromUser
                
            }
        })
    }
    
    func doesUserLikePost(user: PFUser) -> Bool {
        if let likes = likes.value {
            return likes.contains(user)
        }else {
            return false
        }
    
    }
    
    func toggleForPost(user: PFUser) {
        if (doesUserLikePost(user)) {
            likes.value = likes.value?.filter { $0 != user }
            ParseHelper.unlikePost(user, post: self)
        } else {
            likes.value?.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
    
    


}



























