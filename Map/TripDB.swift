 import UIKit
 
 
 protocol addTripsDelegate {
    
    func updateList(tripList:[Trip])
 }
 
 class TripDB: NSObject{
    
    var tripList = [Trip]()
    var delegate :addTripsDelegate?
    
    //save trip without image
    func saveTrip(trip:Trip)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals//SaveJournal.php")!)
        request.HTTPMethod = "POST"
        

        
        let postString = "userid=\(trip.userID!)&tripid=\(trip.tripID!)&category=\(trip.category!)&tripTitle=\(trip.tripTitle!)&departTime=\(trip.departTime!)&returnTime=\(trip.returnTime!)&lat=\(trip.lat!)&lgt=\(trip.lgt!)&emergencyContactName=\(trip.emergencyContactName!)&emergencyContactPhone=\(trip.emergencyContactPhone!)&emergencyContactEmail=\(trip.emergencyContactEmail!)&desc=\(trip.desc!)"

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
        
        
        
        let postString = "userid=\(trip.userID!)&tripid=\(trip.tripID!)&category=\(trip.category!)&tripTitle=\(trip.tripTitle!)&departTime=\(trip.departTime!)&returnTime=\(trip.returnTime!)&lat=\(trip.lat!)&lgt=\(trip.lgt!)&emergencyContactName=\(trip.emergencyContactName!)&emergencyContactPhone=\(trip.emergencyContactPhone!)&emergencyContactEmail=\(trip.emergencyContactEmail!)&desc=\(trip.desc!)"
        
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
    
    //load
    func loadJournal(userid:String) {
        
        
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
                        let title = tripInfo["tripTitle"]as?String
                        
                        let departTime = tripInfo["departTime"] as! String
                        
                        let category = tripInfo["category"] as! String
                        
                        let returntime = tripInfo["returnTime"] as! String

                        let lat  = tripInfo["lat"] as! String
                        let lgt  = tripInfo["lgt"] as! String
                        let emergencyContactName  = tripInfo["emergencyContactName"] as! String
                        let emergencyContactPhone  = tripInfo["emergencyContactPhone"] as! String
                        let emergencyContactEmail  = tripInfo["emergencyContactEmail"] as! String
                        let desc  = tripInfo["tripdesc"] as! String
                        let imagefilename = tripInfo["imagefilename"] as!String

                        let trip  = Trip(tripID: tripid!,userID: userid!,category:category,tripTitle: title!,departTime: departTime,returnTime:returntime ,lat:lat,lgt:lgt,emergencyContactName: emergencyContactName,emergencyContactPhone: emergencyContactPhone,emergencyContactEmail: emergencyContactEmail,desc: desc,imagefilename: imagefilename)
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
            
        })
       
        task.resume()

    }
    
    
    func myImageUploadRequest(image:UIImage,trip:Trip)
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
            "tripTitle":"\(trip.tripTitle!)",
            "departTime":"\(trip.departTime!)",
            "returnTime":"\(trip.returnTime!)",
            "lat":"\(trip.lat!)",
            "lgt":"\(trip.lgt!)",
            "emergencyContactName":"\(trip.emergencyContactName!)",
            "emergencyContactPhone":"\(trip.emergencyContactPhone!)",
            "emergencyContactEmail":"\(trip.emergencyContactEmail!)",
            "desc":"\(trip.desc!)",
            "imagefilename":"\(trip.imagefilename!)"
        ]
        
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // convert image to data
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
       
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
    
    func updateImageUploadRequest(image:UIImage,trip:Trip)
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
            "tripTitle":"\(trip.tripTitle!)",
            "departTime":"\(trip.departTime!)",
            "returnTime":"\(trip.returnTime!)",
            "lat":"\(trip.lat!)",
            "lgt":"\(trip.lgt!)",
            "emergencyContactName":"\(trip.emergencyContactName!)",
            "emergencyContactPhone":"\(trip.emergencyContactPhone!)",
            "emergencyContactEmail":"\(trip.emergencyContactEmail!)",
            "desc":"\(trip.desc!)",
            "imagefilename":"\(trip.imagefilename!)"
        ]
        
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // convert image to data
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        
        
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

    
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
       
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(parameters!["imagefilename"]!)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
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
 }
 
 
 
 
 extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
 }
 
    


 
 
 

 

 