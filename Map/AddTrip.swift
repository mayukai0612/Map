

import UIKit

protocol  reloadTableDelegate {
    func reloadtable(trip:Trip)
}

class AddTrip: UIViewController,addChildViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,cameraAndPicLibDelegate,passTripParaDelegate{
    
    @IBOutlet weak var categoryView: TripCategoryView!

    @IBOutlet weak var titleView: TripTitleView!
    
    @IBOutlet weak var timeView: TripTimeView!
    
    @IBOutlet weak var locationView: TripLocationView!
    
    
    @IBOutlet weak var contactView: TripEmergencyContactView!
    
    @IBOutlet weak var descView: TripDescView!
    
    
    @IBOutlet weak var photoView: TripPhotoView!
    
    var delegate:reloadTableDelegate?
    var category:String?
    var tripTitle:String?
    var departure:String?
    var returnTime:String?
    var lat:String?
    var lgt:String?
    var emergencyContactName:String?
    var emergencyContactPhone:String?
    var emergencyContactEmail:String?
    var desc:String?
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

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        contactView.layer.cornerRadius = 5
        contactView.layer.masksToBounds = true
        descView.layer.cornerRadius = 5
        descView.layer.masksToBounds = true
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
        contactView.delegate = self
        descView.delegate = self
        photoView.delegate = self
        
        categoryView.passParaDelegate = self
        titleView.passParaDelegate = self
        timeView.passParaDelegate = self
        locationView.passParaDelegate = self
        contactView.passParaDelegate = self
        descView.passParaDelegate = self
//        photoView.delegate = self
    
    }
    
    func loadViews()
    {
        categoryView.loadViews()
        titleView.loadViews()
        timeView.loadViews()
        locationView.loadViews()
        contactView.loadViews()
        descView.loadViews()
        if(self.trip?.imagefilename != "" && self.trip?.imagefilename != nil)
        {
            let url = "http://173.255.245.239/DangerousAnimals/Images/" + (self.trip?.imagefilename)!
        photoView.loadImage(url)
        }else
        {
        photoView.loadViews()
        }

    }

    func addRightButtonToNavBar()
    {
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(saveTrip))

    }
    
    func saveTrip(trip:Trip)
    {
        if(self.editOrCreateFlag == "add"){
        
        checkTripAttributes()

      
        
        //set tripid to be maxid (in list) + 1
        setTripID(self.trip!)
        
            if(self.trip?.tripImage == nil)
            {
                tripDB.saveTrip(self.trip!)
            }
            else{
                
                //define picture file name: userid + timestamp
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmmss"
                let timeStamp = dateFormatter.stringFromDate(date)
                let filename = userid! + "_" + timeStamp + ".jpg"
                self.trip!.imagefilename = filename
                
                //save tirp and image to database
                tripDB.myImageUploadRequest( self.trip!.tripImage!, trip:self.trip!)
            }
        }
        else if (editOrCreateFlag == "edit")
        {
            if(self.trip?.tripImage == nil)
            {
                tripDB.updateTrip(self.trip!)
            }
            else{
                //save tirp and image to database
                //tripDB.myImageUploadRequest( self.trip!.tripImage!, trip:self.trip!)
                
                //define picture file name: userid + timestamp
                let date = NSDate()
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmmss"
                let timeStamp = dateFormatter.stringFromDate(date)
                let filename = userid! + "_" + timeStamp + ".jpg"
                self.trip!.imagefilename = filename
                
                tripDB.updateImageUploadRequest((self.trip?.tripImage)!, trip: self.trip!)
                
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
        delegate?.reloadtable(self.trip!)

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
    
    func photoLibrary()
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            photoView.updateImage(originalImage)
            self.trip!.tripImage = originalImage
            convertImageToBase64EncodedString(originalImage)
        }
    }
    
    func convertImageToBase64EncodedString(image: UIImage){
        //covert pic to jpeg and compress to 0.3
        let imageData = UIImageJPEGRepresentation(image, 0.3)
        //encode image to base64 string
        let imageStr = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        
      // self.trip!.tripImage= imageStr
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
            case "emergencyContactName":
                self.trip!.emergencyContactName = tripAttribute;
            case "emergencyContactPhone":
                self.trip!.emergencyContactPhone = tripAttribute;
            case "emergencyContactEmail":
                self.trip!.emergencyContactEmail = tripAttribute;
            case "desc":
                self.trip!.desc = tripAttribute;
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
        if(self.trip!.emergencyContactName == nil)
        {
            self.trip!.emergencyContactName = ""
        }
        if (self.trip!.emergencyContactPhone == nil)
        {
            self.trip!.emergencyContactPhone = ""
        }
        if (self.trip!.emergencyContactEmail == nil)
        {
            self.trip!.emergencyContactEmail = ""
        }
        if(self.trip!.desc == nil)
        {
            self.trip!.desc = ""
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
        
         if(self.trip?.emergencyContactName != nil){
        contactView.emergencyContactName = (self.trip?.emergencyContactName)!
        }
        if(self.trip?.emergencyContactPhone != nil){
        contactView.emergencyContactPhone = (self.trip?.emergencyContactPhone)!
        }
        if(self.trip?.emergencyContactEmail != nil){
        contactView.emergencyContactEmail = (self.trip?.emergencyContactEmail)!
        }
        
        if(self.trip?.desc != nil){
        descView.tripdesc = (self.trip?.desc)!
        }
        photoView.imagefilename = self.trip?.imagefilename

    }

    
}




