//
//  CreateAppointmentLandingVCViewController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-26.
//

import UIKit

class CreateAppointmentLandingVCViewController: UIViewController {

    @IBOutlet weak var Message: UITextView!
    @IBOutlet weak var Label: UILabel!
    var label : String = ""
    var message: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
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
