//
//  DetailOrder.swift
//  Foodlidays Manager
//
//  Created by Timothy Khoury on 12/06/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailOrder: UIViewController {

    var id: Int!
    var restoId: Int!
    
    var status: String!
    
    var order:JSON! = []
    
    @IBOutlet weak var labelId: UILabel!
    @IBAction func goBack(sender: AnyObject) {
        performSegueWithIdentifier("go_back", sender: self)
    }
    
    @IBAction func statusChanger(sender: AnyObject) {
        switch statusSC.selectedSegmentIndex
        {
        case 0:
            self.status = "pending"
        case 1:
            self.status = "processed"
        case 2:
            self.status = "delivered"
        case 3:
            self.status = "canceled"
        default:
            break;
        }
        changeStatus()
    }
    
    
    @IBOutlet weak var statusSC: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        loadOrder()
        super.viewDidLoad()
        
        if(self.id != nil) {
            labelId.text = String(self.id)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func orderDetails(DetailOrder: JSON)
    {
        for (index, food) in DetailOrder["foods"] {
            var name = food["food_name"].stringValue
            var quantity = food["ordered_quantity"].stringValue
            var price = food["food_price"].stringValue
            
            var prix = price as NSString
            var quantite = quantity as NSString
            prix = String(stringInterpolationSegment: prix.doubleValue * quantite.doubleValue)
            
            println("\(quantity)X \(name) | \(price)/u : \(prix)" )
        }
        
        self.status = DetailOrder["status"].stringValue
        switch self.status
        {
            case "pending":
                statusSC.selectedSegmentIndex = 0
            case "processed" :
                statusSC.selectedSegmentIndex = 1
            case "delivered":
                statusSC.selectedSegmentIndex = 2
            case "canceled":
                statusSC.selectedSegmentIndex = 3
            default:
                break;
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "go_back"){
            let destinationVC = segue.destinationViewController as! OrdersVC
            destinationVC.id = self.restoId
        }
    }
    
    func loadOrder()
    {
        Alamofire.request(.GET, "http:foodlidays.dev.innervisiongroup.com/api/v1/resto/order/\(self.id)").responseJSON() { (request, response, data, error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.order = JSON(data!)
                self.orderDetails(JSON(data!))
            }
        }
    }
    
    func changeStatus()
    {
        let parameters = [
            "status" : self.status
        ]
        
        Alamofire.request(.POST, "http:foodlidays.dev.innervisiongroup.com/api/v1/resto/order/\(self.id)/status",parameters: parameters).responseJSON() { (request, response, data, error) in
            dispatch_async(dispatch_get_main_queue()) {
                println(request)
                println(response)
            }
        }
    }
}
