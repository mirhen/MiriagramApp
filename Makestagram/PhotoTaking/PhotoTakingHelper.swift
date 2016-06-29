//
//  PhotoTakingHelper.swift
//  Makestagram
//
//  Created by Miriam Hendler on 6/24/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallBack = UIImage? -> Void

class PhotoTakingHelper: NSObject {

    weak var viewController: UIViewController!
    var callBack: PhotoTakingHelperCallBack
    var imagePickerController: UIImagePickerController?
    
    init(viewController: UIViewController, callBack: PhotoTakingHelperCallBack) {
        self.viewController = viewController
        self.callBack = callBack
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection(){
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel,handler: nil)
        alertController.addAction(cancelAction)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .Default) { (action) in
            self.showImagePickerController(.PhotoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        if (UIImagePickerController.isCameraDeviceAvailable(.Rear) || UIImagePickerController.isCameraDeviceAvailable(.Front)) {
        let cameraAction = UIAlertAction(title: "Take Photo", style: .Default) { (action) in
            self.showImagePickerController(.Camera)
        }
            alertController.addAction(cameraAction)
        }
        
        viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.sourceType = sourceType
        imagePickerController?.delegate = self
        
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
}

extension PhotoTakingHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [String : AnyObject]!) {
        viewController.dismissViewControllerAnimated(false, completion: nil)
        
        callBack(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



