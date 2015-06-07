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
    
    var allOrders: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.frame.origin.y = -10
        
        println(self.id)
        loadOrders()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func loadOrders()
    {
        
        Alamofire.request(.GET, "http:foodlidays.dev.innervisiongroup.com/api/v1/resto/\(self.id)/orders")
            .responseJSON() { (request, response, data, error) in
                if(error == nil) {
                    self.allOrders = JSON(data!)
                    println(self.allOrders)
                }
                    
            else { println("erreur") }
                
        }
    }


}
