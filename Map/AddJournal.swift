

import UIKit

class AddJournal: UIViewController,addChildViewDelegate{
    
    @IBOutlet weak var categoryView: TripCategoryView!

    @IBOutlet weak var titleView: TripTitleView!
    
    @IBOutlet weak var timeView: TripTimeView!
    
    @IBOutlet weak var locationView: TripLocationView!
    
    
    @IBOutlet weak var contactView: TripEmergencyContactView!
    
    @IBOutlet weak var descView: TripDescView!
    
    
    @IBOutlet weak var photoView: TripPhotoView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
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
    
    func addChildView(popUpView: UIViewController)
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

    
    }
    
    func loadViews()
    {
        categoryView.loadViews()
        titleView.loadViews()
        timeView.loadViews()
        locationView.loadViews()
        contactView.loadViews()
        descView.loadViews()
        

    }

 

    
}
