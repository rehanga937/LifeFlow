//
//  DonationHistoryView.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/22/23.
//

import SwiftUI

struct DonationHistoryView: View {
    var reservations: [Reservation]
    @State private var selectedReservation: Reservation?
    @State var showProgressView: Bool = false
    let logoimage: Image = Image("logo1")
    //@State var currentstage: bloodprogress?
    
    var body: some View {
        VStack{
            Text("Your Donation History")
                .font(
                    .system(size: 46, weight: .bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
            //Text("gdgdg")
            ScrollView {
                ForEach(0..<reservations.count) { reservationindex in
                    
                    //currentstage = reservation.bloodprogress
                    VStack{
                        
                        Button(
                            action: {
                                selectedReservation = reservations[reservationindex]
                                showProgressView.toggle()
                            },
                            label: {
                                ZStack {
                                    HStack {
                                        Image("logo1")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100, alignment: .leading)
                                        
                                        VStack {
                                            Text("Place of donation: \(reservations[reservationindex].DonationPlace)")
                                            Text("Date of Donation: \(formatDate(reservations[reservationindex].DonationDate.date))")


                                        }
                                        .foregroundColor(.white)
                                    }
                                }
                            }
                        )
                        .padding()
                        .background(Color.red) // Use Color.red instead of .red
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 2, y: 2)

                    }
                    .padding(8)
                    .sheet(item: $selectedReservation) { reservation in
                        let bloodProgressValue: bloodprogress = reservation.BloodProgress
                        if let index = indexForBloodProgress(bloodProgressValue) {
                            //print("Index for \(bloodProgressValue): \(index)")
                            BloodProgressView(currentStage: index)

                        } else {
                            //print("Blood progress value not found in enum")
                        }

                                            }
                    
                }
            }
            
            
            
        }
        
        
        
    }
}





struct DonationHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        DonationHistoryView(reservations: sampleReservations)
    }
}

// Sample reservation data
let sampleReservations: [Reservation] = [
    Reservation(NIC: "973050000V",
                DonationPlace: "Colombo South Teaching Hospital (Kalubowila)",
                DonationDate: DonationDate(date: "2023-08-01 00:00:00.000000", timezone_type: 3, timezone: "Europe/Berlin"),
                BloodProgress: .received),
    
    Reservation(NIC: "973050000V",
                DonationPlace: "Colombo South Teaching Hospital (Kalubowila)",
                DonationDate: DonationDate(date: "2023-06-01 00:00:00.000000", timezone_type: 3, timezone: "Europe/Berlin"),
                BloodProgress: .storage),
    
    Reservation(NIC: "973050000V",
                DonationPlace: "National Hospital of Sri Lanka",
                DonationDate: DonationDate(date: "2023-05-01 00:00:00.000000", timezone_type: 3, timezone: "Europe/Berlin"),
                BloodProgress: .delivered)
]


func dateFromString(_ dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    return dateFormatter.date(from: dateString)
}

func formatDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "d 'of' MMMM yyyy"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    } else {
        return "Invalid Date"
    }
}


func indexForBloodProgress(_ bloodProgress: bloodprogress) -> Int? {
    return bloodprogress.allCases.firstIndex(of: bloodProgress)
}





