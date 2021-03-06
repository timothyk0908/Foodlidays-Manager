//
//  ViewController.swift
//  Foodlidays Manager
//
//  Created by Timothy Khoury on 18/04/15.
//  Copyright (c) 2015 Timothy Khoury. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var labelEmail: UITextField!
    @IBOutlet weak var labelPassword: UITextField!
    
    var id: Int!
    
    var infoManager : JSON!
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = testStr.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgFoodlidays")!)
        labelEmail.attributedPlaceholder = NSAttributedString(string:"Email",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        labelPassword.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(msg : String)
    {
        let alertController = UIAlertController(title: "Error", message: "\(msg)", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
        })
        alertController.addAction(ok)
        presentViewController(alertController, animated: true, completion: nil)
    }
    

    @IBAction func signInPressed(sender: AnyObject) {
    let alertController = UIAlertController(title: "Error", message: "Please enter a valid email", preferredStyle: .Alert)

        if self.isValidEmail(labelEmail.text) {
            let parameters = [
                "email": labelEmail.text,
                "password": labelPassword.text
            ]
        
            Alamofire.request(.POST, "http:foodlidays.dev.innervisiongroup.com/api/v1/resto/login",parameters: parameters).responseJSON() {
                (_, _, jsonData, error) in
            
                if (error == nil) {
                            self.infoManager = JSON(jsonData!)
                            self.id = self.infoManager["id"].intValue
                        self.performSegueWithIdentifier("goto_orders", sender: nil)
                    }
                
                    else {
                        println("Bad identifiers")
                        self.showAlert("Wrong Email/Password combination")
                        self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
         else {
            println("Bad email")
            self.showAlert("Please enter a correct e-mail")
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if(segue.identifier == "goto_orders"){
            let destinationVC = segue.destinationViewController as! OrdersVC
            destinationVC.id = self.id
        }
    }

}

