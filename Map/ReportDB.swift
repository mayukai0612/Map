//
//  ReportDB.swift
//  Map
//
//  Created by Yukai Ma on 18/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//
import UIKit

class ReportDB: NSObject{
    
    var tripList = [Trip]()
    var delegate :addTripsDelegate?
    var passPhotosDelegate:PassPhotosDelegate?
    var images = [Photo]()
    var passFileNamesDelegate:PassFileNamesDelegate?
    
    //*****Add******
    //save report
    func saveReport(report:Report,imageArray:[UIImage],navigationController:UINavigationController)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://13.73.113.104/ReportDanger/SaveReport.php")!)
        request.HTTPMethod = "POST"
        
        
        
        let postString = "userid=\(report.userid!)&category=\(report.reportCategory!)&reportTitle=\(report.reportTitle!)&reportContent=\(report.reportContent!)&reportTime=\(report.reportTime!)&reportImageFilename=\(report.imageFileName!)&lat=\(report.reportLat!)&lgt=\(report.reportLgt!)&address=\(report.reportAddress!)"
        
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
            
            
            //get report id
           // var reportid:Int?
            do{
                let reportIdDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                   let  reportid = reportIdDictionary?.objectForKey("reportid") as? Int
                
                //save image
                
                if(imageArray.count != 0)
                {
                    report.reportid = reportid
                    print("reportid + \(report.reportid!)")
                    self.saveReportImage(imageArray, report: report)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    navigationController.popViewControllerAnimated(true)

                })
            }catch _ as NSError{
                print("error")
                
            }
            catch
            {
                
            }
            
            
        
        })
        
        task.resume()
        
    }
    
    
    
    //uploadPhotos and insert records into table 'TripPhotos' in the database
    func saveReportImage(images:[UIImage],report:Report)
    {
        
        // server url
        let myUrl = NSURL(string: "http://173.255.245.239/DangerousAnimals/uploadReportImage.php");
        
        //request
        let request = NSMutableURLRequest(URL:myUrl!);
        //request method
        request.HTTPMethod = "POST";
        
        //parameterr
        let param = [
            "userid": "\(report.userid!)",
            "reportid":"\(report.reportid!)",
            "imagefilename":"\(report.imageFileName!)"
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
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "files[]", imageDataKey: imagesData, boundary: boundary)
        
        
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

   
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: [NSData], boundary: String) -> NSData {
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
        let fileName = parameters!["imagefilename"]
       // let fileName = "test.jpg"
        print("file name  \(fileName)")
        let mimetype = "image/jpg"
        var i = 0;
        for data in imageDataKey{
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(fileName!)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.appendData(data)
            body.appendString("\r\n")
            i+=1
        }
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
  
    //Download
    
    func downloadReportData(reportsList:NSMutableArray,tmpList:NSMutableArray,tableView:UITableView) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://13.73.113.104/ReportDanger/downloadReport.php")!)
        request.HTTPMethod = "POST"
        
        
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
            
      
            do{
                let reportsArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray
                
//                "report_id":"1","user_id":"1","report_title":"11","report_latitude":"-37.866684","report_longitude":"145.039362","report_address":null,"report_content":"22","report_imageFileName":"nil_20160921025723.jpg","report_time":"20160921025542
                for report in reportsArray!
                {
                    let rid = Int (report["report_id"] as! String)
                    let userid = report["user_id"] as! String
                    let cat =  report["category"] as!String
                    let title = report["report_title"] as! String
                    let lat = (report["report_latitude"] as! NSString).doubleValue
                    let lgt = (report["report_longitude"] as! NSString).doubleValue
                    let add = report["report_address"] as! String
                    let content = report["report_content"] as! String
                    let filename = report["report_imageFileName"] as! String
                    let time = report["report_time"] as! String

                    let oneReport = Report(userid: userid, reportid:rid!,reportCat: cat, reportTitle: title, reportContent: content, reportTime: time, reportLat: lat, reportLgt: lgt, reportAddress: add, imageFileName: filename)
                    
                    reportsList.addObject(oneReport)
                    tmpList.addObject(oneReport)
                    dispatch_async(dispatch_get_main_queue(), { 
                        tableView.reloadData()
                    })
                }
                
              
                
               
            }catch _ as NSError{
                print("error")
                
            }
            catch
            {
                
            }
            
            
            
        })
        
        task.resume()
      
    }
    
    
    func downLoadImageWithUrl(url:NSURL,imageView:UIImageView)
    {
        print("000")
        print(url)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            // if responseData is not null...
            if let data = responseData{
                
                let image = UIImage(data: data)
                dispatch_async(dispatch_get_main_queue(), { 
                    imageView.image = image
                })
            }
            // Check for error
            if error != nil
            {
                print("error///////")
                print(error?.description)

                return
            }

            
        }
        // Run task
        task.resume()
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

//    
//    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
//        let body = NSMutableData();
//        
//        if parameters != nil {
//            for (key, value) in parameters! {
//                body.appendString("--\(boundary)\r\n")
//                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//                body.appendString("\(value)\r\n")
//            }
//        }
//        
//      //  let filename = parameters!["imagefilename"]
//        let filename = "user.jpg"
//        let mimetype = "image/jpg"
//        
//        body.appendString("--\(boundary)\r\n")
//        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
//        body.appendData(imageDataKey)
//        body.appendString("\r\n")
//        
//        
//        
//        body.appendString("--\(boundary)--\r\n")
//        
//        return body
//    }
//    
    

    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    

}
