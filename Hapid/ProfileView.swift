//
//  ProfileView.swift
//  Hapid
//
//  Created by Liven on 27/05/24.
//

import SwiftUI
import UIKit
import CoreLocation

struct ProfileView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var postalCode = ""
    @State private var isLocationPickerPresented = false
    @State private var submissionSuccess = false
    @State private var submittedData: [String: Any] = [:]
    @State private var isImagePickerPresented = false
    @State private var profileImage: UIImage?
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Create Your Profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    ZStack {
                        if let profileImage = profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 100, height: 100)
                                .overlay(
                                    Circle()
                                        .stroke(Color(hex: "#FF7F5D"), lineWidth: 2)
                                )
                            Image(systemName: "camera.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 20)

                    Button(action: {
                        isImagePickerPresented.toggle()
                    }) {
                        Text("Set Profile Picture")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)



                    VStack(spacing: 20) {
                        TextField("First Name", text: $firstName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#FF7F5D"), lineWidth: 1)
                            )

                        TextField("Last Name", text: $lastName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#FF7F5D"), lineWidth: 1)
                            )

                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#FF7F5D"), lineWidth: 1)
                            )
                    }
                    .padding(.top, 20)

                    Button(action: {
                        locationManager.requestLocation()
                    }) {
                        HStack {
                            Text("Pick Your Current Location")
                            Spacer()
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#FF7F5D"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.top, 20)

                    Text("or")
                        .padding(.top, 20)

                    TextField("Postal Code", text: $postalCode)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#FF7F5D"), lineWidth: 1)
                        )
                        .padding(.top, 10)

                    Button(action: {
                        submitForm()
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 20)

                    if submissionSuccess {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Submitted Data:")
                                .font(.headline)
                            ForEach(submittedData.keys.sorted(), id: \.self) { key in
                                Text("\(key): \(submittedData[key] ?? "")")
                            }
                        }
                        .padding(.top, 20)
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.horizontal, 24)
                .alert(isPresented: $submissionSuccess) {
                    Alert(title: Text("Success"), message: Text("Profile submitted successfully!"), dismissButton: .default(Text("OK")))
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: $profileImage, isPresented: $isImagePickerPresented)
            }
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }

    private func submitForm() {
        let profileData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "phoneNumber": phoneNumber,
            "postalCode": postalCode,
            "location": [
                "latitude": locationManager.location?.coordinate.latitude ?? 0,
                "longitude": locationManager.location?.coordinate.longitude ?? 0
            ]
        ]

        guard let url = URL(string: "https://postman-echo.com/post") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: profileData, options: [])
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    print("Invalid response or status code")
                    return
                }

                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let formData = jsonResponse["data"] as? [String: Any] {
                        DispatchQueue.main.async {
                            submittedData = formData
                            submissionSuccess = true
                        }
                    }
                } catch {
                    print("Error parsing response: \(error.localizedDescription)")
                }
            }.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
}

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let red = Double((rgbValue >> 16) & 0xff) / 255
        let green = Double((rgbValue >> 8) & 0xff) / 255
        let blue = Double(rgbValue & 0xff) / 255
        self.init(red: red, green: green, blue: blue)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestWhenInUseAuthorization() {
        manager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        manager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        authorizationStatus = status
    }
}
