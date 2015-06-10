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

class OrderCell : UITableViewCell{
    
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var prix: UILabel!
}

class OrdersVC:UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var id: Int!
    var navigationBar:UINavigationBar=UINavigationBar()
    
    var allOrders: JSON = []
    
    var cpt: Int!
    
    @IBAction func categoryPicker(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var prix: UILabel!
    
    override func viewDidLoad() {
        self.loadOrders()
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.cpt = self.allOrders.count
            self.tableView.reloadData()
        })
        println(self.cpt)
        println(self.allOrders.count)
        
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCellOne")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cpt
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! OrderCell!
        cell.numero.text = self.allOrders[indexPath.row]["place_room_number"].stringValue
        cell.prix.text = self.allOrders[indexPath.row]["total_price"].stringValue
        println(self.allOrders.count)
        
        return cell
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func loadOrders()
    {
        Alamofire.request(.GET, "http:foodlidays.dev.innervisiongroup.com/api/v1/resto/\(self.id)/orders").responseJSON() { (request, response, data, error) in
            dispatch_async(dispatch_get_main_queue()) {
            self.cpt = JSON(data!).count
            self.allOrders = JSON(data!)
            
            }
        }
    }
}
