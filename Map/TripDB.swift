 import UIKit
 
 
 protocol addTripsDelegate {
    
    func updateList(tripList:[Trip])
 }
 
 class TripDB: NSObject{
    
    var tripList = [Trip]()
    var delegate :addTripsDelegate?
    var passPhotosDelegate:PassPhotosDelegate?
    var images = [UIImage]()
    
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
    
    //update trip
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
            
            
            
            dispatch_async(dispatch_get_main_queue(),{
                //                self.myActivityIndicator.stopAnimating()
                //                self.myImageView.image = nil;
            });
            
            /*
             if let parseJSON = json {
             var firstNameValue = parseJSON["firstName"] as? String
             println("firstNameValue: \(firstNameValue)")
             }
             */
            
        }
        
        task.resume()
        
    }

    
    
    //load
    func loadTrips(userid:String) {
        
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals//loadTrips.php")!)
        request.HTTPMethod = "POST"
        
        
        
        //        let postString = "userid=\(trip.userID)&tripid=\(trip.tripID)&category=\(trip.category)&tripTitle=\(trip.tripTitle)&departTime=\(trip.departTime)&returnTime=\(trip.returnTime)&lat=\(trip.lat)&lgt=\(trip.lgt)&emergencyContactName=\(trip.emergencyContactName)&emergencyContactPhone=\(trip.emergencyContactPhone)&emergencyContactEmail=\(trip.emergencyContactEmail)&desc=\(trip.desc)"
        //
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
                  
                  //      let imagefilename = tripInfo["imagefilename"] as! [String]

                //        print(imagefilename)
                        
                  //      let trip  = Trip(tripID: tripid!,userID: userid!,category:category,tripTitle: content!,departTime: departTime,returnTime:returntime ,lat:lat,lgt:lgt,imagefilename: imagefilename)
                  //      self.tripList.append(trip)
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
    
    
    func uploadTrips(images:[UIImage],trip:Trip)
    {
        
        // server url
       let myUrl = NSURL(string: "http://173.255.245.239/DangerousAnimals/postTrip.php");
        
        //request
        let request = NSMutableURLRequest(URL:myUrl!);
        //request method
        request.HTTPMethod = "POST";
        
        //parameterrs
        let param = [
            "userid": "\(trip.userID!)",
            "tripid":"\(trip.tripID!)",
            "category":"\(trip.category!)",
            "tripContent":"\(trip.tripTitle!)",
            "departTime":"\(trip.departTime!)",
            "returnTime":"\(trip.returnTime!)",
            "lat":"\(trip.lat!)",
            "lgt":"\(trip.lgt!)",
            "imagefilename":"\(trip.imagefilename)"
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
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file[]", imageDataKey: imagesData, boundary: boundary)
        
        
       
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
            
            
            dispatch_async(dispatch_get_main_queue(),{
//                self.myActivityIndicator.stopAnimating()
//                self.myImageView.image = nil;
            });
            
            /*
             if let parseJSON = json {
             var firstNameValue = parseJSON["firstName"] as? String
             println("firstNameValue: \(firstNameValue)")
             }
             */
            
        }
        
        task.resume()
        
    }
    
    func updateImageUploadRequest(images:[UIImage],trip:Trip)
    {
        
        // server url
        let myUrl = NSURL(string: "http://173.255.245.239/DangerousAnimals/updateImageTrip.php");
        
        //request
        let request = NSMutableURLRequest(URL:myUrl!);
        //request method
        request.HTTPMethod = "POST";
        
        //parameterrs
        let param = [
            "userid": "\(trip.userID!)",
            "tripid":"\(trip.tripID!)",
            "category":"\(trip.category!)",
            "tripContent":"\(trip.tripTitle!)",
            "departTime":"\(trip.departTime!)",
            "returnTime":"\(trip.returnTime!)",
            "lat":"\(trip.lat!)",
            "lgt":"\(trip.lgt!)",
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
        
        if(imagesData.count == 0) { return; }
        
        request.HTTPBody = createBodyWithParameters(param as! [String : AnyObject], filePathKey: "file", imageDataKey: imagesData, boundary: boundary)
        
        
        
        
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
            
            
            
            
            dispatch_async(dispatch_get_main_queue(),{
                //                self.myActivityIndicator.stopAnimating()
                //                self.myImageView.image = nil;
            });
            
            /*
             if let parseJSON = json {
             var firstNameValue = parseJSON["firstName"] as? String
             println("firstNameValue: \(firstNameValue)")
             }
             */
            
        }
        
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
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    
    //download image from url
    
//    func load_image(urlString:String)
//    {
//        
////        var imgURL: NSURL = NSURL(string: urlString)!
////        let request: NSURLRequest = NSURLRequest(URL: imgURL)
////        NSURLConnection.sendAsynchronousRequest(
////            request, queue: NSOperationQueue.mainQueue(),
////            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
////                if error == nil {
////                    self.image_element.image = UIImage(data: data)
////                }
////        })
////        
//        let downloadTask: NSURLSessionDataTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//            if (error != nil) {
//                completionHandler(image: nil, url: urlString)
//                return
//            }
//
//        
//    }
//    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        
        // Create Url from string
        let url = NSURL(string: url)!
        
        // Download task:
        // - sharedSession = global NSURLCache, NSHTTPCookieStorage and NSURLCredentialStorage objects.
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                   // uiView.addSubview(view)
                })
            }
        }
        
        // Run task
        task.resume()
    }
    
    func loadImagesFromUrls(fileName:[String], view: UIImageView){
        
        //convert file names to urls
        let picUrls = convertToUrls(fileName)

        // Download task:
      for url in picUrls{
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                // execute in UI thread
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let image = UIImage(data: data)
                    self.images.append(image!)
                    if(url == picUrls.last)
                    {
                 //       self.passPhotosDelegate?.passUImages(self.images)
                    }
                    
                    // uiView.addSubview(view)
                })
            }
        }
        
        // Run task
        task.resume()
    }
       
    }
    
    
    //get pictures from urls
    func getPicDataFromUrl(picUrl:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(picUrl) { (data, response, error) in
            completion(data:  data)
            }.resume()
    }
    
    // create a loop to start downloading your urls
    func startDownloadingUrls(fileName:[String]){
        
        let picUrls = convertToUrls(fileName)
        for url in picUrls {

                getPicDataFromUrl(url) { data in
                    dispatch_async(dispatch_get_main_queue()) {

                    }
            }
        }
    }
    
    // just convert your links to Urls
    func convertToUrls(urlsStrings:[String]) -> [NSURL]{
        
        return  urlsStrings
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
 
    


 
 
 

 

 