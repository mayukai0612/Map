//
//  PhotoView.swift
//  Map
//
//  Created by Yukai Ma on 17/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

protocol DeletePhotoDelegate {
    func deletePhoto(index:Int)
}

class PhotoView: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var image: UIImage?
    var imageIndex: Int?
    var deletePhotoDelegate: DeletePhotoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add image to imageView
        self.photoImageView.image = image
        
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "Delete"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(PhotoView.deleteImage), forControlEvents: .TouchUpInside)
        
        let leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: #selector(back))

        //.... Set Right/Left Bar Button item
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = btnName
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func deleteImage()
    {
        deletePhotoDelegate?.deletePhoto(self.imageIndex!)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func back()
    {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
