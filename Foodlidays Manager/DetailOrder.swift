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
    
    @IBOutlet weak var labelId: UILabel!
    
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
}
