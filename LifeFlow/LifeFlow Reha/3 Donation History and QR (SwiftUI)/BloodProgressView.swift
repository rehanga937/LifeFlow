//
//  BloodProgressView.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/22/23.
//

import SwiftUI



struct BloodProgressView: View {
    @State var currentStage: Int

    var body: some View {
        VStack {
            Spacer()
            
            Text("Donation Progess")
                .font(
                    .system(size: 36, weight: .bold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(.red)
            
            Spacer()
            
            ForEach(bloodprogress.allCases, id: \.self) { stage in
                ZStack {
                    if let index = indexForBloodProgress(stage) {
                        RoundedRectangle(cornerRadius: 10) // Rounded corner
                            .foregroundColor(index <= currentStage ? .red : .gray)
                            .frame(width: 350, height: 100)
                            .shadow(color: .gray, radius: 5, x: 2, y: 2)
                        
                        HStack{
                            Image(systemName: "drop.fill")
                                //.font(.system(size: 25))
                                //.foregroundColor(.white)
                            
                            Text(stage.description)
                                
                        }
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                        .shadow(color: .gray, radius: 5, x: 2, y: 2)
                    }
                    
                    
                    
                    
                }
                .padding()
            }
            
            Spacer()
            
            //Text(currentStage.description)
            
            Spacer()
            
            /*
            Button(action: {
                if let nextStage = bloodprogress(rawValue: currentStage.rawValue + 1) {
                    currentStage = nextStage
                }
            }) {
                Text("Next Stage")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.bottom)
            .hidden()
             */
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BloodProgressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BloodProgressView(currentStage: 1)
        }
    }
}
