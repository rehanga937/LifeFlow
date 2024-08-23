//
//  QRGeneratorView.swift
//  LifeFlow_vishwa
//
//  Created by user239248 on 8/15/23.
//

import SwiftUI

struct QRView: View {
    let defaultPerson: Person
    @State private var isBottomViewVisible = false

    var body: some View {
        NavigationView{
            ZStack {
                Color(#colorLiteral(red: 0.8392156863, green: 0.1215686275, blue: 0.1490196078, alpha: 1))
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()
                    
                    Text("Generate a QR code of me")
                        .font(
                            .system(size: 46, weight: .bold)
                        )
                        .multilineTextAlignment(.center)
                    
                    //Spacer()

                    Button(action: {
                        isBottomViewVisible.toggle()
                    }) {
                        Image("qr_code")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 250)
                            .overlay(Circle().stroke(Color.white, lineWidth: 5))
                            .shadow(color: .white, radius: 5)
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())

                    Spacer()
                }
            }
            //.navigationBarTitle("QR Code Generator")
            .foregroundColor(.white)
            .sheet(isPresented: $isBottomViewVisible) {
                QRGeneratorView(person: defaultPerson)
                //BottomView()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}



struct QRGeneratorView: View {
    let person: Person
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Generated QR Code for \(person.name):")
                    .font(.headline)
                    .padding()
                
                // Generate and display QR code here
                if let qrCodeImage = generateQRCode(from: person) {
                    Image(uiImage: qrCodeImage)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .padding()
                }
            }
                        
        }
        
    }

    func generateQRCode(from person: Person) -> UIImage? {
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(person)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let data = jsonString.data(using: .utf8)!
                
                if let filter = CIFilter(name: "CIQRCodeGenerator") {
                    filter.setValue(data, forKey: "inputMessage")
                    let transform = CGAffineTransform(scaleX: 10, y: 10)
                    
                    if let output = filter.outputImage?.transformed(by: transform) {
                        let context = CIContext()
                        if let cgImage = context.createCGImage(output, from: output.extent) {
                            return UIImage(cgImage: cgImage)
                        }
                    }
                }
            }
        } catch {
            print("QR code generation failed: \(error)")
        }
        
        return nil
    }
}

struct QRGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        let person = Person(name: "Rumesh Herath", NIC: "973050000V")
        return QRView(defaultPerson: person)
    }
}
