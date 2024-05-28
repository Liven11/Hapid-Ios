//
//  SplashScreen2View.swift
//  Hapid
//
//  Created by Liven on 28/05/24.
//

import Foundation
import SwiftUI

struct SplashScreen2View: View {
    @State private var isActive = false

    var body: some View {
        ZStack {
            Image("bgimg2")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                Text("Best Marketplace")
                    .font(.custom("Inter-Bold", size: 24))
                    .fontWeight(.black)
                    .lineLimit(1)
                    .padding(.top, 400)
                Text("""
                 On-Time Departures. Pay just for your seat. No Refusal from our end. Spacious & Comfortable Seating. Female passengers safety standards. Onboard Refreshments. Cab Tracking through Maps
                """)
                .font(.custom("Inter-Bold", size: 14))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 2)
                .padding(.bottom, -50)

                
                Spacer()
                
                Button(action: {
                    isActive = true
                }) {
                    Text("Get Started")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#5046BB"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }
                .fullScreenCover(isPresented: $isActive, content: {
                ContentView()
                })
                
                Spacer()
            }
        }
    }
}

struct SplashScreen2View_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen2View()
    }
}
