//
//  OrdersVC.swift
//  Foodlidays Manager
//
//  Created by Timothy Khoury on 18/04/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class OrdersVC: UITableViewController {
    
    var id: Int!
    var navigationBar:UINavigationBar=UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.frame.origin.y = -10
        
        println(self.id)
        
        
        loadOrders()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func changeCat(sender: AnyObject) {

    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func loadOrders()
    {
        
        Alamofire.request(.GET, "http:foodlidays.dev.innervisiongroup.com/api/v1/orders", parameters: ["id": id])
            .response { (request, response, data, error) in
                if(error == nil) {
                    println(response)
                }
                    
            else { println("erreur") }
                
        }
    }


}
