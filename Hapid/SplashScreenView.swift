//
//  SplashScreenView.swift
//  Hapid
//
//  Created by Liven on 28/05/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    var body: some View {
        ZStack {
            Image("bgimg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .padding(.top,50)

            VStack {
                Spacer()
                Text("Find Nearest Local Market")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top,600)
                Spacer()
            }
        }
        .onAppear {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                      withAnimation {
                          isActive = true
                      }
                  }
              }
              .fullScreenCover(isPresented: $isActive, content: {
                  SplashScreen2View()
              })
          }
      }
struct SplashScreenView_Previews: PreviewProvider {
          static var previews: some View {
              SplashScreenView()
          }
      }
