//
//  OTPPopupView.swift
//  Hapid
//
//  Created by Liven on 28/05/24.
//

import SwiftUI

struct OTPPopupView: View {
    @Binding var isPresented: Bool
    let otpCode: String
    let onDismiss: () -> Void

    var body: some View {
        VStack {
            Text("Your confirmation code is below — enter it and we'll help you get signed in.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Text(otpCode)
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .contextMenu {
                    Button(action: {
                        UIPasteboard.general.string = otpCode
                        withAnimation {
                            isPresented = false
                        }
                        onDismiss()
                    }) {
                        Text("Copy OTP")
                        Image(systemName: "doc.on.doc")
                    }
                }
                }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.4))
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            withAnimation {
                isPresented = false
            }
            onDismiss()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    isPresented = false
                }
                onDismiss()
            }
        }
    }
}
