//
//  ViewController.swift
//  ChatApp
//
//  Created by Vicky Mohammad on 2017-06-28.
//  Copyright © 2017 Vicky Mohammad. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //add item on the bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
    }//end view did load
    
    func handleLogout(){
        //show the login page, through the loginController class
        present(loginController(), animated: true, completion: nil)
    }//end handle logout
    
}//end class

