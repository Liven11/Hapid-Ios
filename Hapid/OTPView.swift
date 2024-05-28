//
//  OTPView.swift
//  Hapid
//
//  Created by Liven on 27/05/24.
//

import SwiftUI

struct OTPView: View {
    var mobileNumber: String
    var otpCode: String

    @State private var enteredOTP = ""
    @State private var isProfilePagePresented = false
    @State private var isOTPMatched = false
    @State private var isError = false

    var body: some View {
        VStack {

            Text("Enter OTP")
                .font(.title)
                .padding(.top, 200)
            
            TextField("OTP", text: $enteredOTP)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal, 20)
            
            if isError {
                Text("Invalid OTP. Please try again.")
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                if enteredOTP == otpCode {
                    sendFormData(mobileNumber: mobileNumber, otp: enteredOTP) { success in
                        if success {
                            isOTPMatched = true
                        } else {
                            isError = true
                        }
                    }
                } else {
                    isError = true
                }
            }) {
                Text("Verify OTP")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }
            
            Spacer()
        }
        .background(
            NavigationLink(
                destination: ProfileView(),
                isActive: $isProfilePagePresented,
                label: { EmptyView() }
            )
        )
        .alert(isPresented: $isOTPMatched) {
            Alert(title: Text("OTP Verified"), message: Text("OTP matched successfully"), dismissButton: .default(Text("OK"), action: {
                isProfilePagePresented = true
            }))
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(mobileNumber: "1234567890", otpCode: "1234")
    }
}
