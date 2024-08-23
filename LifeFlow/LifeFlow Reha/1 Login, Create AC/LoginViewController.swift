//
//  LoginViewController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-23.
//

import UIKit

class LoginViewController: UIViewController {

    var NIC: String = ""
    var password: String = ""
    
    @IBOutlet weak var NICTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var TextView: UITextView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch (segue.identifier ?? ""){
        case "login":
            let destVC = segue.destination as! TabBarController
            destVC.NIC = NIC
            destVC.password = password
        default: fatalError("Unexpected Segue identifier: \(segue.identifier ?? "unidentified segue") ")
        }
    }//transfer username (NIC) and password for server authentication during app operation
    
    @IBAction func TapLogin(_ sender: Any) {
        NIC = NICTextField.text ?? ""
        password = PasswordTextField.text ?? ""
        
        var responseStringMessage: String = ""
        
        let alert = UIAlertController(title: "Logging in...", message: "",
        preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let urlPath: String = "http://112.135.192.229/login.php" //need to update, we currently don't have a static public IP
        let insertURL = URL(string: urlPath)!
        var urlRequest = URLRequest(url: insertURL)
        urlRequest.httpMethod = "POST"
        
        let postString = "NIC=\(NIC)&password=\(password)"
        urlRequest.httpBody = postString.data(using: .utf8)
        urlRequest.timeoutInterval = 15
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            
            //error connecting to server
            if error != nil {
                
                print("URLSession Error. Error = \(error!)")
                DispatchQueue.main.async {
                    alert.dismiss(animated: true)
                    self.TextView.text = "Error conencting to server"
                }
                return
            }
            
            //no issue in connecting to server
            //print("response - \(response!)")
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("response string - \(responseString!)")
            responseStringMessage = responseString! as String
            
            if (responseStringMessage == "success") {
                DispatchQueue.main.async {
                    alert.dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }
                        self.performSegue(withIdentifier: "login", sender: self)
                        TextView.text = "Logged in"
                    }
                }
            } else {
                DispatchQueue.main.async {
                    alert.dismiss(animated: true) { [weak self] in
                        guard let self = self else { return }
                        self.TextView.text = "Invalid Credentials"
                    }
                }
            }
            
        }
        task.resume()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
