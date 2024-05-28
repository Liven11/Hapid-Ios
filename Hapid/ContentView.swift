//
//  ContentView.swift
//  Hapid
//
//  Created by Liven on 27/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var mobileNumber = ""
    @State private var isOTPPopupPresented = false
    @State private var countryCode = "+91"
    @State private var otpCode = ""
    @State private var navigateToOTPView = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .frame(width: 15, height: 15)
                        .padding(.leading, 24)
                        .padding(.top, 59)
                    Spacer()
                }

                VStack(alignment: .leading) {
                    Text("Enter Your Mobile Number")
                        .font(.custom("Montserrat-Bold", size: 34))
                        .fontWeight(.black)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 2)
                        .padding(.leading, 24)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Hello, Welcome Back to Our Account")
                        .font(.custom("Montserrat-SemiBold", size: 16))
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .frame(width: 327, height: 24, alignment: .leading)
                        .padding(.top, 3)
                        .padding(.leading, 24)
                }

                VStack {
                    HStack(spacing: 10) {
                        HStack {
                            Image("india_flag")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading, 8)
                            
                            TextField("Country Code", text: $countryCode)
                                .keyboardType(.phonePad)
                                .padding(.vertical)
                        }
                        .frame(width: 100, height: 60)
                        .background(Color(hexColor: "#FF7F5D").opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hexColor: "#FF7F5D"), lineWidth: 1)
                        )
                        .padding(.leading, 24)

                        TextField("Mobile Number", text: $mobileNumber)
                            .keyboardType(.numberPad)
                            .padding()
                            .frame(width: 217, height: 60)
                            .background(Color(hexColor: "#FF7F5D").opacity(0.05))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hexColor: "#FF7F5D"), lineWidth: 1)
                            )
                            .padding(.trailing, 24)
                    }

                    Button(action: {
                        let firstTwoDigits = String(mobileNumber.prefix(2))
                        let lastTwoDigits = String(mobileNumber.suffix(2))
                        otpCode = firstTwoDigits + lastTwoDigits
                        isOTPPopupPresented.toggle()
                    }) {
                        Text("Request OTP")
                            .frame(width: 326.94, height: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Text("------------ Login with ------------")
                        .frame(width: 327, height: 24)
                        .padding(.top, 10)
                        .padding(.horizontal, 24)

                    HStack(spacing: 10) {
                        Button(action: {
                            // nthing
                        }) {
                            HStack {
                                Image("google_logo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(EdgeInsets(top: 5.31, leading: 9.69, bottom: 5.31, trailing: 9.69))
                                Text("Google")
                            }
                            .frame(width: 150, height: 56.87)
                            .background(Color(hexColor: "#FF7F5D").opacity(0.05))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(hexColor: "#FF7F5D"), lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
//                            nthing
                        }) {
                            HStack {
                                Image("facebook_logo")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(EdgeInsets(top: 5.31, leading: 9.69, bottom: 5.31, trailing: 9.69))
                                Text("Facebook")
                            }
                            .frame(width: 150, height: 56.87)
                            .background(Color(hexColor: "#FF7F5D").opacity(0.05))
                            .cornerRadius(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color(hexColor: "#FF7F5D"), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.top, 40)
                }
                .frame(width: 375, height: 482.41)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.top, 20)

                Text("By creating passcode you agree with our Terms & Conditions and Privacy Policy")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.horizontal, 24)
                    .padding(.top, 10)
                    .padding(.bottom, 50)
            }
            .navigationBarHidden(true)
            .overlay(
                isOTPPopupPresented ? AnyView(
                    OTPPopupView(isPresented: $isOTPPopupPresented, otpCode: otpCode, onDismiss: {
                        navigateToOTPView = true
                    })
                ) : AnyView(EmptyView())
            )
            .background(
                NavigationLink(
                    destination: OTPView(mobileNumber: mobileNumber, otpCode: otpCode),
                    isActive: $navigateToOTPView,
                    label: { EmptyView() }
                )
            )
        }
        .onAppear {
            UINavigationBar.setAnimationsEnabled(false)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    init(hexColor: String) {
        let scanner = Scanner(string: hexColor)
        _ = scanner.scanString("#")
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue >> 16) & 0xff) / 255
        let green = Double((rgbValue >> 8) & 0xff) / 255
        let blue = Double(rgbValue & 0xff) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

#Preview {
    ContentView()
}
