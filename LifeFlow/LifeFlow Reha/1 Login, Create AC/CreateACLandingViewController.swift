//
//  CreateACLandingViewController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-23.
//

import UIKit

class CreateACLandingViewController: UIViewController {

    
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var Message: UITextView!
    
    var label : String = ""
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        //displays success or failure messages depending on result of previous segue
        Label.text = label
        Message.text = message
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
