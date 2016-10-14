//
//  PhotoLibary.swift
//  Map
//
//  Created by Yukai Ma on 13/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import AssetsLibrary


protocol PassPhotosDelegate{
    func passPhotos(selected:[GalleryImage])

    func passUImages(images:[Photo])
}


class PhotoLibary: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate{
    
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    
    @IBOutlet weak var cancleButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var confirmButtonItem: UIBarButtonItem!
    
    var photoDelegate:PassPhotosDelegate?

    var assetsLibrary:ALAssetsLibrary!
    var currentAlbum:ALAssetsGroup?
    var tempPickedImage:GalleryImage!
    var count = Int()
    var selectedImage:[GalleryImage] = []
    var imageArray:[GalleryImage] = []
    
    
    let themeGreenColor = UIColor(red: 86, green: 171, blue: 59)
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.size.height
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Please choose photos:"
        initCollectionView()
        getGroupList()
        self.confirmButtonItem.enabled = false
        print(self.navigationController?.navigationBar.frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection =  UICollectionViewScrollDirection.Vertical
        let itemWidth = SCREEN_WIDTH/4 - 1.5
        let itemHeight:CGFloat = SCREEN_WIDTH/4 - 1.5
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 0.5 //上下间隔
        flowLayout.minimumInteritemSpacing = 0.5 //左右间隔
        
        self.galleryCollectionView.collectionViewLayout = flowLayout
        self.galleryCollectionView.backgroundColor = UIColor.clearColor()
        //register
        self.galleryCollectionView.registerClass(ImageCell.self,forCellWithReuseIdentifier:"cell")
        //set delegate
        self.galleryCollectionView.delegate = self
        self.galleryCollectionView.dataSource = self
    }
    
    @IBAction func cancleAction(sender: AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    @IBAction func confirmAction(sender: AnyObject) {
        
        

            selectedImage=[]
            for  item in imageArray{
                if item.isSelect {
                    selectedImage.append(item)
                }
            }
            photoDelegate?.passPhotos(selectedImage)
            self.navigationController?.popViewControllerAnimated(true)
        
    
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return imageArray.count
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCell;
        cell.update(imageArray[indexPath.row])
        cell.handleSelect={
            if cell.isSelect{
                if self.count > 0{
                    
                    self.count -= 1
                    print(cell.isSelect)
                    print("- \(self.count)")
                }
                self.imageArray[indexPath.row].isSelect = false
                
                
            }else{
                print("beore add \(self.count)")
                self.count = self.count + 1
                self.imageArray[indexPath.row].isSelect = true
                
                print("before \(self.count)")
                if(self.count > 8)
                {
                    let alert = UIAlertController(title: "Exceed maximum limitation.", message: "The maximum limitaion is up to 8 photos.", preferredStyle: .Alert)
                    let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    cell.selectView.hidden = true
                    cell.isSelect = false
                    
                    self.count -= 1
                    print("after \(self.count)")
                    //set cell to be true
                    cell.isSelect = true
                    
                    //set item to be false
                    self.imageArray[indexPath.row].isSelect = false

                }
            }
            
            if(self.count == 1){
                self.title = "1 photo selected"
                self.confirmButtonItem.enabled = true
            }
            else if(self.count > 1)
            {
                self.title = "\(self.count) photos selected"
                self.confirmButtonItem.enabled = true

            }
            else{
                self.title = "Please select photos"
                self.confirmButtonItem.enabled = false
            }
        }
        return cell;
        
    }
    
    
}

extension PhotoLibary{
    
    func getGroupList(){
        
        let listGroupBlock:ALAssetsLibraryGroupsEnumerationResultsBlock = {(group,stop)->Void in
            
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()  //get all the photos
            if let group=group{
                
                group.setAssetsFilter(onlyPhotosFilter)
                
                if group.numberOfAssets() > 0{
                    
                    self.showOhoto(group)
                    
                }else{
                    
                    
                }
            }
        }
        getAssetsLibrary().enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: listGroupBlock, failureBlock: nil)
    }
    
    
    func getAssetsLibrary()->ALAssetsLibrary{
        
        struct Singleton{
            static var onceToken : dispatch_once_t = 0
            static var single:ALAssetsLibrary?
        }
        dispatch_once(&Singleton.onceToken,{
            Singleton.single=ALAssetsLibrary()
        })
        return Singleton.single!
        
    }
    
    func showOhoto(photos:ALAssetsGroup){
        
        if (currentAlbum == nil || currentAlbum?.valueForProperty(ALAssetsGroupPropertyName).isEqualToString(photos.valueForProperty(ALAssetsGroupPropertyName) as! String) != nil){
            
            self.currentAlbum = photos
            imageArray = []
            
            let assetsEnumerationBlock:ALAssetsGroupEnumerationResultsBlock = { (result,index,stop) in
                
                if (result != nil) {
                    self.tempPickedImage = GalleryImage()
                    self.tempPickedImage.asset = result
                    self.tempPickedImage.isSelect = false
                    self.imageArray.append(self.tempPickedImage)
                    self.galleryCollectionView.reloadData()
                    self.assetsLibrary = nil
                    self.currentAlbum = nil
                }else{
                    
                }
            }
            let  onlyPhotosFilter = ALAssetsFilter.allPhotos()
            self.currentAlbum?.setAssetsFilter(onlyPhotosFilter)
            self.currentAlbum?.enumerateAssetsUsingBlock(assetsEnumerationBlock)
        }
        
    }
    
    
}
