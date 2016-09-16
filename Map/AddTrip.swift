

import UIKit

protocol  reloadTableDelegate {
    func reloadtable(trip:Trip)
}

class AddTrip: UIViewController,addChildViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,passTripParaDelegate,cameraAndPicLibDelegate,PassPhotosDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var categoryView: TripCategoryView!

    @IBOutlet weak var titleView: TripTitleView!
    
    @IBOutlet weak var timeView: TripTimeView!
    
    @IBOutlet weak var locationView: TripLocationView!
    
    @IBOutlet weak var photoView: TripPhotoView!
    
    //collection view
    let themeGreenColor = UIColor(red: 86, green: 171, blue: 59)
    let SCREEN_WIDTH:CGFloat = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT:CGFloat = UIScreen.mainScreen().bounds.size.height
    
    var collectionView:UICollectionView?
    var imageArray:[GalleryImage] = []
    var imagesToBeSaved:[UIImage] = []
    var fileNames = [String]()

    //trip
    var delegate:reloadTableDelegate?
    var category:String?
    var tripTitle:String?
    var departure:String?
    var returnTime:String?
    var lat:String?
    var lgt:String?

    var imageStr:String?
    
    var trip: Trip? = Trip()
    var userid: String?
    
    var tripDB:TripDB = TripDB()
    var tripList = [Trip]()
    var editOrCreateFlag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    passValueToSubViews()
    
    //get userid
     self.userid = NSUserDefaults.standardUserDefaults().stringForKey("userid")
    //set userid to trip
    self.trip?.userID = self.userid

    addRightButtonToNavBar()
    setDelegateForPopUp()
    makeRoundCorners()
        
    loadViews()
        
    initCollectionViews()


    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
       //reload collection view
        self.collectionView!.reloadData()

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //collection views
    
    func initCollectionViews(){
        //get images
      //  tripDB.
       // tripDB.loadImagesFromUrls(<#T##fileName: [String]##[String]#>, view: UIImageView)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection =  UICollectionViewScrollDirection.Vertical
        let itemWidth = SCREEN_WIDTH/4 - 1.5
        let itemHeight:CGFloat = SCREEN_WIDTH/4 - 1.5
        flowLayout.itemSize = CGSize(width: itemWidth , height: itemHeight)
        flowLayout.minimumLineSpacing = 0.5 //上下间隔
        flowLayout.minimumInteritemSpacing = 0.5 //左右间隔
        //define screen height
        let screenHeight = (itemWidth * 2) + 0.5
        self.collectionView = UICollectionView(frame: CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT),collectionViewLayout:flowLayout)
        
        self.view.addSubview(self.collectionView!)
        self.collectionView!.backgroundColor = UIColor.clearColor()
        //register
        self.collectionView!.registerClass(GetImageCell.self,forCellWithReuseIdentifier:"cell")
        //set delegate
        self.collectionView!.delegate = self
        self.collectionView!.dataSource = self
        
        
    }
    
   
    
    
    func passPhotos(selected: [GalleryImage]) {
        imageArray = selected
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return imageArray.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        print(collectionView)
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! GetImageCell;
        cell.update(imageArray[indexPath.row])
        return cell;
        
    }

    func makeRoundCorners(){
        categoryView.layer.cornerRadius = 5
        categoryView.layer.masksToBounds = true
        titleView.layer.cornerRadius = 5
        titleView.layer.masksToBounds = true
        timeView.layer.cornerRadius = 5
        timeView.layer.masksToBounds = true
        locationView.layer.cornerRadius = 5
        locationView.layer.masksToBounds = true
      
        photoView.layer.cornerRadius = 5
        photoView.layer.masksToBounds = true
        
    }
    
    func addChildView(popUpView: UIViewController,viewIdentifier:String)
    {
        //convert AnyClass to specific type
        
      
        
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
    }

    func setDelegateForPopUp()
    {
    
        categoryView.delegate = self
        titleView.delegate = self
        timeView.delegate = self
        locationView.delegate = self
 
        photoView.delegate = self
        
        categoryView.passParaDelegate = self
        titleView.passParaDelegate = self
        timeView.passParaDelegate = self
        locationView.passParaDelegate = self
      
//        photoView.delegate = self
    
    }
    
    func loadViews()
    {
        categoryView.loadViews()
        titleView.loadViews()
        timeView.loadViews()
        locationView.loadViews()
        photoView.loadViews()

    }

    func addRightButtonToNavBar()
    {
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveTrip))

    }
    
    func saveTrip(trip:Trip)
    {
        convertGalleryImageToUIImage(self.imageArray)

        getFileNames()
        //convert
        //save images to server
        setTripID(self.trip!)
        tripDB.uploadPhotos(self.imagesToBeSaved,trip:self.trip!)
        

//        if(self.editOrCreateFlag == "add"){
//
//        checkTripAttributes()
//
//      
//        
//        //set tripid to be maxid (in list) + 1
//        setTripID(self.trip!)
//        
//            if(self.imagesToBeSaved.count == 0)
//            {
//                tripDB.saveTrip(self.trip!)
//            }
//            else{
//                
//                //define picture file name: userid + index
//                getFileNames()
//                
//                
//                //convert
//                convertGalleryImageToUIImage(self.imageArray)
//                //save images to server
//                tripDB.uploadPhotos(self.imagesToBeSaved,trip:self.trip!)
//                
//                //save tirp and image to database
//               // tripDB.uploadTrips( self.imagesToBeSaved, trip:self.trip!)
//            }
//        }
//        else if (editOrCreateFlag == "edit")
//        {
//            if(self.trip?.tripImage == nil)
//            {
//                tripDB.updateTrip(self.trip!)
//            }
//            else{
//                //save tirp and image to database
//                //tripDB.myImageUploadRequest( self.trip!.tripImage!, trip:self.trip!)
//                
//                //define picture file name: userid + timestamp
//                getFileNames()
//                tripDB.updateImageUploadRequest(self.imagesToBeSaved, trip: self.trip!)
//                
//            }
//        }
//        
//        self.navigationController?.popViewControllerAnimated(true)
//        delegate?.reloadtable(self.trip!)

    }
    
//    func passUImages(images: [UIImage]) {
//       self.
//    }
//    
    func convertGalleryImageToUIImage(imageArray:[GalleryImage])
        
    {
        
        for galleryImage in imageArray{
            //convert GalleryImage type to UIImage type
            let image = UIImage(CGImage: galleryImage.asset.aspectRatioThumbnail().takeUnretainedValue())
            self.imagesToBeSaved.append(image)
        }
        
    }
    
    
    
    //set tripid of one trip
    func setTripID(trip:Trip)
    {
        var maxid:Int = 0
        
        for oneTrip in tripList
        {
            if(Int(oneTrip.tripID!)! > maxid)
            {
                maxid = Int(oneTrip.tripID!)!
            }
        
        }
        
        trip.tripID = String(maxid + 1)
    }
    
    
    //action sheet used to pick photos or take pictures using a camera
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    
    //go to photo library to pick photos
    func photoLibrary()
    {
        
        print("photoLibary")
        let vc =  self.storyboard?.instantiateViewControllerWithIdentifier("PhotoLibary") as! PhotoLibary
        vc.photoDelegate = self

        self.navigationController?.pushViewController(vc, animated: true)
    }
    


    func passTripPara(tripAttribute:String,paraIdentifier:String)
    {
        switch paraIdentifier {
            case  "category":
                self.trip!.category = tripAttribute;
            case "title":
                self.trip!.tripTitle = tripAttribute;
            case "departure":
                self.trip!.departTime = tripAttribute;
            case "return":
                self.trip!.returnTime = tripAttribute;
            case "lat":
                self.trip!.lat = tripAttribute;
            case "lgt":
                self.trip!.lgt = tripAttribute;
            default:
                print("nothing is delivered")
        }
    }
    
    
    func checkTripAttributes()
    {
        
        if (self.trip!.category == nil)
        {
            self.trip!.category = ""
        }
        if(self.trip!.tripTitle == nil)
        {
            self.trip!.tripTitle = ""
        }
        if (self.trip!.departTime == nil)
        {
            self.trip!.departTime = ""
        }

        if (self.trip!.returnTime == nil)
        {
            self.trip!.returnTime = ""
        }
        if (self.trip!.lat == nil)
        {
            self.trip!.lat = ""
        }
        if (self.trip!.lgt == nil)
        {
            self.trip!.lgt = ""
        }
    
    }
    
    func passValueToSubViews()
    {
        categoryView.category = self.trip?.category
        if(self.trip?.tripTitle != nil){
            titleView.tripTitle = (self.trip?.tripTitle)!
        }
        timeView.departtime = self.trip?.departTime
        timeView.returntime = self.trip?.returnTime
        locationView.lgt = self.trip?.lgt
        locationView.lat = self.trip?.lat
    
    }
    
    func getFileNames()
    {
        let count =   imagesToBeSaved.count
        
        //define picture file name: userid + timestamp + index
        if count >= 1{
        for var index in 1...count{
        let date = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let timeStamp = dateFormatter.stringFromDate(date)
        let stringOfIndex = String(index)
        let filename = userid! + "_" + stringOfIndex + ".jpg"
        fileNames.append(filename)
            index += 1
        }
            self.trip?.imagefilename = fileNames
        }
        
        
    }

    
}
