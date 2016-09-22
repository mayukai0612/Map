//
//  WildControl.swift
//  Map
//
//  Created by Yukai Ma on 22/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class WildControl: UIViewController {
    
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var firstPhoneLabel: UILabel!
    
    @IBOutlet weak var firstAddressLabel: UILabel!

    
    @IBOutlet weak var secPhoneLabel: UILabel!
    
    @IBOutlet weak var secondAddressLabel: UILabel!
    
    
    @IBOutlet weak var thirdPhoneLabel: UILabel!
    
    
    @IBOutlet weak var thirdAddressLab: UILabel!
    



    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func loadViews()
    {
        firstPhoneLabel.text = "0400 854 386"
    
        firstAddressLabel.text  = "Corryong: Biggara, Nariel, Lucyvale, Cudgewa, Tintaldra, Walwa, Burrowye, Shelley, Mt. Alfred"
        
        secPhoneLabel.text = "0409 188 465"
        
        secondAddressLabel.text  = "Tallangatta: Koetong, Granya, Tallangatta Valley, Mitta Valley, Sandy Creek, Gundowring"
        
        
        thirdPhoneLabel.text = "0427 538 708"
        
        thirdAddressLab.text  = "Ovens: Myrtleford, Mt. Beauty, Beechworth, Yackandandah, King Valley"
    
    }
    

}
