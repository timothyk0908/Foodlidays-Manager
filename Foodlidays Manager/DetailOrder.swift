//
//  DetailOrder.swift
//  Foodlidays Manager
//
//  Created by Timothy Khoury on 12/06/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit

class DetailOrder: UIViewController {

    var id: Int!
    var restoId: Int!
    
    @IBOutlet weak var labelId: UILabel!
    @IBAction func goBack(sender: AnyObject) {
        performSegueWithIdentifier("go_back", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(self.id != nil) {
            labelId.text = String(self.id)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "go_back"){
            let destinationVC = segue.destinationViewController as! OrdersVC
            destinationVC.id = self.restoId
        }
    }
}
