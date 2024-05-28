//
//  Networking.swift
//  Hapid
//
//  Created by Liven on 27/05/24.
//

import Foundation

func sendFormData(mobileNumber: String, otp: String, completion: @escaping (Bool) -> Void) {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let formData = ["mobileNumber": mobileNumber, "otp": otp]
    guard let httpBody = try? JSONSerialization.data(withJSONObject: formData, options: []) else { return }
    
    request.httpBody = httpBody
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            completion(false)
        } else {
            completion(true)
        }
    }.resume()
}
