//
//  TabBarController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-24.
//

import UIKit

class TabBarController: UITabBarController {

    //these will be passed to each tab, as they are needed to authenticate against the server when performing CRUD on sensitive data
    var NIC: String = ""
    var password: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
