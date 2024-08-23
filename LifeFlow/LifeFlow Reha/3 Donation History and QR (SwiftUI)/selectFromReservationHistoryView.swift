import Foundation
import SwiftUI

enum bloodprogress: String, CaseIterable, Decodable {
    case received = "received"
    case testing = "testing"
    case storage = "storage"
    case delivered = "delivered"
    
    var description: String {
        switch self {
            case .received: return "Donation Received"
            case .testing: return "Testing & Processing"
            case .storage: return "Keeping it safe"
            case .delivered: return "You have saved a life"
        }
    }
}

struct Reservation: Identifiable, Decodable {
    var id: UUID? = UUID()
    let NIC: String
    let DonationPlace: String
    let DonationDate: DonationDate
    let BloodProgress: bloodprogress
}



struct DonationDate: Decodable {
    let date: String
    let timezone_type: Int
    let timezone: String
    
    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(identifier: timezone)
        
        return dateFormatter.date(from: date)
    }
}


// Function to create Reservation array from JSON data
func createReservations(from jsonData: Data) -> [Reservation]? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601

    do {
        let reservations = try decoder.decode([Reservation].self, from: jsonData)
        return reservations
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

// Function to perform network request and handle response
func insertDonorData(NIC: String, completion: @escaping ([Reservation]?) -> Void) {
    let urlPath: String = "http://112.135.192.229/selectFromReservationHistory.php"
    guard let insertURL = URL(string: urlPath) else {
        print("Invalid URL")
        return
    }
    
    var urlRequest = URLRequest(url: insertURL)
    urlRequest.httpMethod = "POST"
    
    let postString = "NIC=\(NIC)"
    urlRequest.httpBody = postString.data(using: .utf8)
    urlRequest.timeoutInterval = 30
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
        if let error = error {
            print("URLSession Error. Error = \(error)")
            completion(nil)
            return
        }
        
        if let data = data {
            if let reservations = createReservations(from: data) {
                for reservation in reservations {
                       print("NIC: \(reservation.NIC)")
                       print("DonationPlace: \(reservation.DonationPlace)")
                       print("DonationDate: \(reservation.DonationDate.date)")
                       print("BloodProgress: \(reservation.BloodProgress.rawValue)") // Print the raw value of the enum
                       print("--------------------")
                   }
                completion(reservations)
            } else {
                print("Failed to decode reservations or other cases")
                completion(nil)
            }
        }
    }
    task.resume()
}
