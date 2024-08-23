//
//  CreateACPage2ViewController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-16.
//

import UIKit

class CreateACPage2ViewController: UIViewController {

    //variables passed from previous page
    var errorCount = 0
    var fullName: String = ""
    var emailAddress: String = ""
    var NIC: String = ""
    var sex = false
    var password: String = ""
    var DOBEntry: Date?
    
    //new variables added on this page
    var ABO: String = "A"
    var RhD = true //true for +, false for -
    var Ad1 = ""
    var Ad2 = ""
    var Ad3 = ""
    var mobile = 0
    var donateFreq = 1
    var contactBloodShortage = false //true for consenting to contact
    var hasAcceptedTC = false
    
    var responseStringMessage: String = "hasnt been edited"
    var passMessage: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //terms and conditions link
        let attributedString = NSMutableAttributedString(string: "Terms & Conditions")
        let url = URL(string: "https://www.apple.com")!//change once we launch a proper web page
        attributedString.setAttributes([.link: url], range: NSMakeRange(0, 18))
        TandCTextView.attributedText = attributedString

        
    }
    
    @IBOutlet weak var Mobile: UITextField!
    @IBOutlet weak var AL3: UITextField!
    @IBOutlet weak var AL2: UITextField!
    @IBOutlet weak var AL1: UITextField!
    @IBOutlet weak var ABOSegControlOutlet: UISegmentedControl!
    @IBOutlet weak var RhDOutlet: UISegmentedControl!
    @IBOutlet weak var DonateFreqOutlet: UISegmentedControl!
    @IBOutlet weak var TandCSwitchOutlet: UISwitch!
    @IBOutlet weak var NotifySwitchOutlet: UISwitch!
    
    @IBOutlet weak var ErrorText: UITextView!
    @IBOutlet weak var TandCTextView: UITextView!
    
    @IBAction func ABOSegControlAction(_ sender: Any) {
        switch ABOSegControlOutlet.selectedSegmentIndex{
            case 0: ABO = "A"
            case 1: ABO = "B"
            case 2: ABO = "AB"
            case 3: ABO = "O"
            default: break
        }
    }
    @IBAction func RhDSegControlAction(_ sender: Any) {
        switch RhDOutlet.selectedSegmentIndex{
            case 0: RhD = true
            case 1: RhD = false
            default: break
        }
    }
    @IBAction func DonorFreqSegCtrl(_ sender: Any) {
        switch DonateFreqOutlet.selectedSegmentIndex{
            case 0: donateFreq = 1
            case 1: donateFreq = 2
            case 2: donateFreq = 3
            case 3: donateFreq = 4
            case 4: donateFreq = 5
            default: break
        }
    }
    @IBAction func NotifySwitch(_ sender: Any) {
        if (NotifySwitchOutlet.isOn) { contactBloodShortage = true }
        else { contactBloodShortage = false }
    }
    @IBAction func TCSwitch(_ sender: Any) {
        if (TandCSwitchOutlet.isOn) { hasAcceptedTC = true }
        else { hasAcceptedTC = false }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        switch (segue.identifier ?? ""){
        case "serverError":
            let destVC = segue.destination as! CreateACLandingViewController
            destVC.label = "Server Error"
            destVC.message = "Please show this message to our help desk: \n\n" + passMessage
        case "createSuccess":
            let destVC = segue.destination as! CreateACLandingViewController
            destVC.label = "Submission Successful"
            destVC.message = "You will be notified when your account is approved."
        case "createFail":
            let destVC = segue.destination as! CreateACLandingViewController
            destVC.label = "Submission Failed"
            destVC.message = "Please show this message to our help desk: \n\n" + passMessage
        default: fatalError("Unexpected Segue identifier: \(segue.identifier ?? "unidentified segue") ")
        }
    }//for data transfer to create account landing page according to whether the operation was successful or not
    
    
    
    @IBAction func TapCreate(_ sender: Any) {
        
        //initialize
        resetTextFieldBackgroundColor(AL1,AL2,AL3,Mobile)
        ErrorText.text = ""
        errorCount = 0
        
        Ad1 = AL1.text ?? ""
        Ad2 = AL2.text ?? ""
        Ad3 = AL3.text ?? ""
        
        if (Ad1 == "" || Ad2 == ""){
            AL1.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            AL2.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ErrorText.text += "Complete address required. "
            errorCount += 1
        }
        
        if (isStringInt(word: Mobile.text ?? "")){
            let x = Int(Mobile.text!)
            if(x! < 1000000000 && x! > 699999999){
                mobile = x!
            }else{
                errorCount += 1
                Mobile.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
                ErrorText.text += "Invalid length. "
            }
        }else{
            errorCount += 1
            Mobile.backgroundColor = UIColor(red: 255, green: 0, blue: 0, alpha: 0.3)
            ErrorText.text += "Mobile number can only contain numbers. "
        }
        
        if (!hasAcceptedTC){
            errorCount += 1
            ErrorText.text += "Terms and Conditions must be accepted to proceed. "
        }
        
        
        if (errorCount == 0){
            //can create account
            
            //alert/progress view while waiting for data to upload to server
            let alert = UIAlertController(title: "Uploading to Server", message: "Please Wait",
            preferredStyle: .alert)
            let progressBar = UIProgressView(progressViewStyle: .default)
            progressBar.setProgress(0.0, animated: true)
            progressBar.frame = CGRect(x: 10, y: 70, width: 150, height: 0)
            alert.view.addSubview(progressBar)
            
            //alert/progress view while waiting for data to upload to server
            self.present(alert, animated: true, completion: nil)
            var progress: Float = 0.0
            // Do the time critical stuff asynchronously:
            DispatchQueue.global(qos: .background).async {
                repeat {
                    progress += 0.1
                    Thread.sleep(forTimeInterval: 0.25)
                    DispatchQueue.main.async(flags: .barrier) {
                        progressBar.setProgress(progress, animated: true)
                    }
                } while progress < 1.0
            }
            

            
            let calendar = Calendar.current
            let year = calendar.component(.year, from: DOBEntry!)
            let month = calendar.component(.month, from: DOBEntry!)
            let day = calendar.component(.day, from: DOBEntry!)
            let DOBString : String = "\(year)-\(month)-\(day)"
            
            var sexChar: Character
            if sex { sexChar = "F"}
            else { sexChar = "M"}
            
            var RhDString: String = ""
            print("rhd \(RhD)")
            print("rhd string \(RhDString)")
            if (RhD) {
                RhDString = "p"
            }
            else {
                RhDString = "n"
            }
            
            var wishToBeContacted: String
            if contactBloodShortage { wishToBeContacted = "Y"}
            else { wishToBeContacted = "N"}
            
            //API prep
            let urlPath: String = "http://112.135.192.229/insertDonorID.php" //need to update, we currently don't have a static public IP
            let insertURL = URL(string: urlPath)!
            var urlRequest = URLRequest(url: insertURL)
            urlRequest.httpMethod = "POST"
            
            //API prep
            let postString = "NIC=\(NIC)&FullName=\(fullName)&Email=\(emailAddress)&DOB=\(DOBString)&Sex=\(sexChar)&Password=\(password)&ABO=\(ABO)&RHD=\(RhDString)&ADL1=\(Ad1)&ADL2=\(Ad2)&ADL3=\(Ad3)&MobileNo=\(mobile)&DonateFreq=\(donateFreq)&WishToBeContacted=\(wishToBeContacted)"
            urlRequest.httpBody = postString.data(using: .utf8)
            urlRequest.timeoutInterval = 30
            
            //API call to upload Donor ID
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
                
                //error connecting to server
                if error != nil {
                    
                    print("URLSession Error. Error = \(error!)")
                    self.passMessage = error!.localizedDescription
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            self.performSegue(withIdentifier: "serverError", sender: self)
                        }
                    }
                    return
                }
                
                //no issue in connecting to server
                print("response - \(response!)")
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("response string - \(responseString!)")
                self.responseStringMessage = responseString! as String
                
                if (self.responseStringMessage == "success") {
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            self.performSegue(withIdentifier: "createSuccess", sender: self)
                        }
                    }
                } else {
                    print(self.responseStringMessage)
                    self.passMessage = self.responseStringMessage
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true) { [weak self] in
                            guard let self = self else { return }
                            self.performSegue(withIdentifier: "createFail", sender: self)
                        }
                    }
                }
                
            }
            task.resume()
            
        }
        
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
