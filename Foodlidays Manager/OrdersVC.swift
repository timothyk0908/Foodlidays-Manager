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
    
    @IBOutlet weak var sender: UIButton!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var prix: UILabel!
    
    @IBOutlet weak var id: UILabel!
    
    @IBAction func toOrder(sender: AnyObject) {
        println(id)
    }
    
}

class OrdersVC:UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var id: Int!
    var navigationBar:UINavigationBar=UINavigationBar()
    
    var cat: String = "pending"
    var allOrders: JSON = []
    var cellId: Int!
    
    var cpt: Int!

    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var catChanger: UISegmentedControl!
    
    @IBAction func categoryPicker(sender: AnyObject) {
        switch catChanger.selectedSegmentIndex
        {
        case 0:
            self.cat = "pending"
        case 1:
            self.cat = "processed"
        case 2:
            self.cat = "delivered"
        case 3:
            self.cat = "canceled"
        default:
            break;
        }
        self.cpt = 0
        self.indexOrder = 0
        countCat(self.allOrders)
        self.tableView.reloadData()
    }
    
    func countCat(orders: JSON)
    {
        for(index,order) in self.allOrders
        {
            if(order["status"].stringValue == self.cat)
            {
                self.cpt = self.cpt + 1
            }
        }
    }
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var numero: UILabel!
    @IBOutlet weak var prix: UILabel!
    
    var indexOrder :Int = 0
    
    override func viewDidLoad() {
        self.loadOrders()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.cpt = self.allOrders.count
            println(self.cpt)
            self.tableView.reloadData()
        })
        
        super.viewDidLoad()
        self.toolbar.frame = CGRect(x: 0,y: 0,width: 320,height: 80)
        tableView.registerNib(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCellOne")
        catChanger.selectedSegmentIndex = 0
        indicator.startAnimating()
        
        let delay = 1.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.indicator.stopAnimating()
            self.categoryPicker(0)
            self.indicator.hidden = true
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cpt
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow();
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath!) as! OrderCell?;
        cellId = currentCell?.id.text?.toInt()
        performSegueWithIdentifier("goto_detail", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! OrderCell!
        
        while(self.allOrders[indexOrder]["status"].stringValue != self.cat)
        {
            self.indexOrder = self.indexOrder + 1
        }
        
                var prix = self.allOrders[indexOrder]["total_price"].stringValue
                cell.numero.text = self.allOrders[indexOrder]["place_room_number"].stringValue
                cell.prix.text = "\(prix)€"
                cell.email.text = self.allOrders[indexOrder]["client_email"].stringValue
                cell.date.text = self.allOrders[indexOrder]["created_at"].stringValue
                cell.id.text = self.allOrders[indexOrder]["id"].stringValue

        
        self.indexOrder = self.indexOrder + 1
        
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
            self.countCat(JSON(data!))
            
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "goto_detail"){
            let destinationVC = segue.destinationViewController as! DetailOrder
            var indexPath = self.tableView.indexPathForSelectedRow() //get index of data for selected row
            destinationVC.id = self.cellId
            destinationVC.restoId = self.id
        }
    }
            
}
