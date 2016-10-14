////
////  CategoryEditView.swift
////  Map
////
////  Created by Yukai Ma on 26/08/2016.
////  Copyright © 2016 Yukai Ma. All rights reserved.
////
//
//import UIKit
//
//
//protocol CategoryEditViewDelegate {
//    func changeView()
//}
//
//
//class CategoryEditView: UIViewController {
//    
//    var delegate: CategoryEditViewDelegate?
//
//    
//    @IBAction func saveEditBtnClicked(sender: AnyObject) {
//        saveEdit()
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func saveEdit()
//    {
//        delegate?.changeView()
//        navigationController?.popViewControllerAnimated(true)
//
//    }
//
//}
