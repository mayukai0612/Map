 import UIKit
 
 
 protocol addTripsDelegate {
    
    func updateList(tripList:[Trip])
 }
 protocol PassFileNamesDelegate{
    func passFileNames(filename:[String])
 }
 
 class TripDB: NSObject{
    
    var tripList = [Trip]()
    var delegate :addTripsDelegate?
    var passPhotosDelegate:PassPhotosDelegate?
    var images = [Photo]()
    var passFileNamesDelegate:PassFileNamesDelegate?

 //*****Add******
    //save trip without image
    func saveTrip(trip:Trip)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals//SaveJournal.php")!)
        request.HTTPMethod = "POST"
        

        
        let postString = "userid=\(trip.userID!)&tripid=\(trip.tripID!)&category=\(trip.category!)&tripContent=\(trip.tripTitle!)&departTime=\(trip.departTime!)&returnTime=\(trip.returnTime!)&lat=\(trip.lat!)&lgt=\(trip.lgt!)"

        print(postString)
        
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

        // Excute HTTP Request
        
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
        
                // Check for error
                if error != nil
                {
                    print("error=\(error)")
                    return
                }
        
                // Print out response string
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("responseString = \(responseString)")
        
            })
        
            task.resume()
            
          }
    
    //uploadPhotos and insert records into table 'TripPhotos' in the database
    func uploadPhotos(images:[UIImage],trip:Trip)
    {
        
        // server url
        let myUrl = NSURL(string: "http://173.255.245.239/DangerousAnimals/uploadImages.php");
        
        //request
        let request = NSMutableURLRequest(URL:myUrl!);
        //request method
        request.HTTPMethod = "POST";
        
        //parameterrs
        let param = [
            "userid": "\(trip.userID!)",
            "tripid":"\(trip.tripID!)",
            "imagefilename":trip.imagefilename
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // convert image to data
        var imagesData = [NSData]()
        for image in images
        {
            let imageData = UIImageJPEGRepresentation(image, 1)
            imagesData.append(imageData!)
        }
        
        if(imagesData.count == 0)  { return; }
        
        //because uploading multiple photos, here should add '[]' to the file path key
        request.HTTPBody = createBodyWithParameters(param as? [String : AnyObject], filePathKey: "files[]", imageDataKey: imagesData, boundary: boundary)
        
        
        //myActivityIndicator.startAnimating();
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            
            do{
                _ = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
            }catch _ as NSError{
                print("error")
                
            }
            catch
            {
                
            }
        }
        
        task.resume()
    }
  
 //*******Update******
    //update trip without image
    func updateTrip(trip:Trip)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals/updateTrip.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "userid=\(trip.userID!)&tripid=\(trip.tripID!)&category=\(trip.category!)&tripContent=\(trip.tripTitle!)&departTime=\(trip.departTime!)&returnTime=\(trip.returnTime!)&lat=\(trip.lat!)&lgt=\(trip.lgt!)"
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Excute HTTP Request
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        })
        
        task.resume()

    }
    
   

    //upload Photos and delete photos from the the database
    //update records in the database
    func updatePhotos()
    {
        //how to check which photos are changed
        
        //if get which photos are changed,update that photo and the photo
        
    
    
    }
    
//******Loading*****
    //load trips without images
    func loadTrips(userid:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals//loadTrips.php")!)
        request.HTTPMethod = "POST"
        

        let postString = "userid=\(userid)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Excute HTTP Request
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            do {
                if let tripArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray {
                    
                    // Print out array
                    for tripInfo in tripArray
                    {
                        
                        //convert Anyobject to a particular object type

                        let userid = tripInfo["userid"] as? String
                        let tripid = tripInfo["tripid"] as? String
                        let content = tripInfo["tripContent"]as?String
                        
                        let departTime = tripInfo["departTime"] as! String
                        
                        let category = tripInfo["category"] as! String
                        
                        let returntime = tripInfo["returnTime"] as! String

                        let lat  = tripInfo["lat"] as! String
                        let lgt  = tripInfo["lgt"] as! String
                  
                        
                        let trip  = Trip(tripID: tripid!,userID: userid!,category:category,tripTitle: content!,departTime: departTime,returnTime:returntime ,lat:lat,lgt:lgt)
                        self.tripList.append(trip)
                    }
                    
                    self.delegate?.updateList(self.tripList)
                    
                }
                
            }
            catch let error as NSError {
                print("error")
                print(error.localizedDescription)
                //  self.alertDelegate?.showAlert()
            }
            catch
            {
                
            }
        })
        task.resume()
    }
    
    
    //load filenames based on userid and tripid
    func loadFileNames(userid:String,tripid:Int)
    {
        print(userid)
        print(tripid)
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals/loadFileNames.php")!)
        request.HTTPMethod = "POST"
        
        
        
        let postString = "userid=\(userid)&tripid=\(tripid)"
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString!)")
            
           
            do {
                if let fileNameArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String] {
                    
                    dispatch_async(dispatch_get_main_queue(),
                        { 
                            self.passFileNamesDelegate?.passFileNames(fileNameArray)
                    })
                    
                    
                }
                
            }
            catch let error as NSError {
                print("error")
                print(error.localizedDescription)
                //if no record is returned, pass an empty array
                let filenameArray = [String]()
                dispatch_async(dispatch_get_main_queue(),
                    {
                        self.passFileNamesDelegate?.passFileNames(filenameArray)
                })
            }
            catch{
                    print("ERROR")
            }
            
            
        })
        task.resume()
        
    
    }
    
    func downLoadImageWithUrl(url:NSURL,index:Int)
    {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                    let image = UIImage(data: data)
                    //set index of photo
                    let photo = Photo(image: image!,index:index)
                    self.images.append(photo)
                    print(String(url))
            }
        }
        // Run task
        task.resume()
    }
    
    
    //load image from urls and show it on the colllection view
    func loadImagesFromUrls(fileName:[String],collectionView:UICollectionView){
        
        //convert file names to urls
        let picUrls = convertToUrls(fileName)
        //create a serial queue
     //   let serialQueue = dispatch_queue_create("imagesQueue", DISPATCH_QUEUE_SERIAL)
        
        
      
//        // Download task:
//        for url in picUrls{
//            var index = 1;
//            dispatch_async(serialQueue) { () -> Void in
//                self.downLoadImageWithUrl(url,index: index)
//                dispatch_async(dispatch_get_main_queue(), {
//                    if(url == picUrls.last){
//                        print("update view")
//                        self.passPhotosDelegate?.passUImages(self.images)
//                        collectionView.reloadData()
//                    }
//                   
//                })
//                
//            }
        
            //get index of the image
         //   index += 1
            
            for url in picUrls{

            var index = 1;
                
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
                // if responseData is not null...
                if let data = responseData{
                    
                    let image = UIImage(data: data)
                    let photo = Photo(image: image!,index:index)
                    self.images.append(photo)
                    print("get one image")
                    // execute in UI thread
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                      
                        if(url == picUrls.last)
                        {
                            print("update view")
                            self.passPhotosDelegate?.passUImages(self.images)
                            collectionView.reloadData()
                        }
                        
                    })
                }
                
                index += 1
            }
            
            // Run task
            task.resume()
            }
        }
        
    

//*****Delete******
    func deleteTrip(trip:Trip)
    {
        
        //DeleteTrip.php
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals//DeleteTrip.php")!)
        request.HTTPMethod = "POST"
        
        
        
        let postString = "userid=\(trip.userID!)&tripid=\(trip.tripID!)"
        
        print(postString)
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Excute HTTP Request
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        })
        
        task.resume()
    }
    
    
    func createBodyWithParameters(parameters: [String: AnyObject]?, filePathKey: String?, imageDataKey: [NSData], boundary: String) -> NSData {
        let body = NSMutableData();
        
        //string parameters
        if parameters != nil{
            for (key, value) in parameters! {
                if key != "imagefilename" {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
                }
            }
        }
        
       //images
        let fileNameArray = parameters!["imagefilename"] as! [String]
        print("file name Array \(fileNameArray)")
        let mimetype = "image/jpg"
        var i = 0;
        for data in imageDataKey{
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(fileNameArray[i])\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.appendData(data)
            body.appendString("\r\n")
            i+=1
        }

        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    // convert filenames to Urls
    func convertToUrls(urlsStrings:[String]) -> [NSURL]{
        //add prefix to the fileName
        var urlsStr = [String]()
        for urlStr in urlsStrings
        {
            let urlString = "http://173.255.245.239/DangerousAnimals/Images/" + urlStr
            urlsStr.append(urlString)
        }
        
        //convert string to NSURL
        return  urlsStr
            .map() { NSURL(string: $0)! }
            .filter() { $0 != nil }
    }



 
}
 
 
 extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
 }
 
    


 
 
 

 

 