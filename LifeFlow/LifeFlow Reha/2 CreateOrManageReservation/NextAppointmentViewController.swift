//
//  NextAppointmentViewController.swift
//  LifeFlow Reha
//
//  Created by Rehanga Gamage on 2023-08-24.
//

import UIKit
import MapKit

class NextAppointmentViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var UpcomingAppointmentTV: UITextView!
    
    //need to update URL paths, we currently don't have a static public IP
    let urlPath: String = "http://112.135.192.229/readCenters.php"
    let urlPath2: String = "http://112.135.192.229/selectFromAppointments.php"
    var Appointments = [BloodAppointment]()
    var Centers = [BCP]()
    var NIC: String = ""
    var password: String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getting credentials from tab bar controller (required for authentication against server)
        let tabBar = tabBarController as! TabBarController
        NIC = tabBar.NIC
        password = tabBar.password
        
        //map prep:
        map.delegate = self
        // Create a coordinate region that encompasses Sri Lanka
        let sriLankaRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
        )
        // Set the initial region of the MapView
        map.setRegion(sriLankaRegion, animated: true)
        
        //API prep to get Blood Collection Centers from server
        let url = URL(string: urlPath)
        guard url != nil else {
            print("url error")
            return
        }
        let session = URLSession.shared
        
        //get center (Blood Collection Points) data from server
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error == nil && data != nil{
                //parse json
                let decoder = JSONDecoder()
                do{
                    let CentersAttempt = try decoder.decode([BCP].self, from: data!)
                    self.Centers = CentersAttempt
                    
                    //add locations to map
                    DispatchQueue.main.async {
                        for item in self.Centers{
                            let annotation = MKPointAnnotation()
                            annotation.title = item.CenterName
                            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(item.CenterLat),longitude:CLLocationDegrees(item.CenterLon))
                            self.map.addAnnotation(annotation)
                        }
                    }
                }catch{
                    print("error in json parsing \(error)")
                }
            }
        }
        dataTask.resume()
        
        
        
        
        //API prep and API call for checking for existing appointments of the logged-in donor:
        
        //API prep
        let url2 = URL(string: urlPath2)
        guard url2 != nil else {
            print("url error")
            return
        }
        var urlRequest = URLRequest(url: url2!)
        urlRequest.httpMethod = "POST"
        
        let postString = "NIC=\(NIC)&password=\(password)"
        urlRequest.httpBody = postString.data(using: .utf8)
        urlRequest.timeoutInterval = 15
        
        
        //get existing appointment data from server
        let dataTask2 = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil && data != nil{
                //parse json
                let decoder = JSONDecoder()
                do{
                    let AppointmentsAttempt = try decoder.decode([BloodAppointment].self, from: data!)
                    self.Appointments = AppointmentsAttempt
                    
                    //update view with existing appointment
                    DispatchQueue.main.async {
                        for item in self.Appointments{
                            self.UpcomingAppointmentTV.text = "Upcoming appointment at "
                            self.UpcomingAppointmentTV.text += item.locationName
                            self.UpcomingAppointmentTV.text += " on "
                            self.UpcomingAppointmentTV.text += item.appointmentDateTime.date
                        }
                    }
                }catch{
                    print("error in json parsing \(error)")
                }
            }
        }
        dataTask2.resume()
        
        

    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            let name = annotation.title ?? "Default Name"
            performSegue(withIdentifier: "CreateAppointment", sender: name)
        }
    }//used to pass info of center name when performing segue on-tap of blood collection center location

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateAppointment" {
            if let destinationVC = segue.destination as? CreateAppointmentViewController,
               let name = sender as? String {
                destinationVC.locationName = name
                destinationVC.NIC = NIC
                destinationVC.password = password
            }
        }
    }
    
    @IBAction func unwindToNextAppointmentFromCreateAppointmentLanding(sender: UIStoryboardSegue) {}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewDidLoad()
    }//to refresh view when unwinding after creating a new appointment
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        if (UpcomingAppointmentTV.text == "None") { return true}
        else{return false}
        
    }//disables creation of new appointment if donor already has an appointment

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
