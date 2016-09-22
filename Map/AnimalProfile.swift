//
//  AnimalProfile.swift
//  Map
//
//  Created by Yukai Ma on 21/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class AnimalProfile: UIViewController {
    
    
    @IBOutlet weak var scientificNameLabel: UILabel!
    
    @IBOutlet weak var vernacularNameLabel: UILabel!
    
    @IBOutlet weak var animalImageView: UIImageView!
    
    
    @IBOutlet weak var levelOfDangerLabel: UILabel!
    

    @IBOutlet weak var descTextView: UITextView!
    
    
    var animalName: String?
    let urlPrefix = "http://13.73.113.104/DangerousAnimals/Images/"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.descTextView.userInteractionEnabled  = false
        self.loadProfile(animalName!)
        
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   // http://13.73.113.104/DangerousAnimals/Images/Bluebottle.jpg
    func loadViews(animalProfile:Profile)
    {
        
        self.scientificNameLabel.text = animalProfile.scientificName
        self.vernacularNameLabel.text = animalProfile.vernacularName
        self.levelOfDangerLabel.text = animalProfile.dangerLevel
        self.descTextView.text = animalProfile.desc
    
    
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
    
    func loadProfile(animalName:String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://13.73.113.104/GetCertainAnimal.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "animalName=\(animalName)"
        
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
            print("responseString = \(responseString)")
            
            
            do{
                let profileArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray
                
                let profile = profileArray![0] as! NSDictionary
                
                    let vName = profile["VernacularName"] as! String
                let sName = profile["Scientific_Name"]as! String
                let desc = profile["Description"]  as! String
                let dangerLevel = profile["Level_of_Dangers"]as! String
                let firstAid = profile["First_aid_info"]as! String
                let imageFileName = profile["imageFileName"] as! String
                
                let urlString = self.urlPrefix  + imageFileName
                let newString = urlString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
                let url = NSURL(string: newString)

          let animalProfile = Profile(vName:vName,sName:sName,desc:desc,dangerLevel:dangerLevel,firstAid:firstAid)
                
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.loadViews(animalProfile)
                        
                        self.downLoadImageWithUrl(url!, imageView: self.animalImageView)


                    })
               
                }
                

            catch _ as NSError{
                print("error")
                
            }
            catch
            {
                
            }
        
    })
    
    task.resume()
    
}



}