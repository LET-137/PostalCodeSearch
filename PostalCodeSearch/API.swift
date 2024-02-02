
import Foundation
import SwiftUI

struct AddressResponse: Codable {
    var status: Int
    var message: String?
    var results: [Address]?
}

struct Address: Codable {
    
    var zipcode: String
    var address1: String
    var address2: String
    var address3: String
}


class PostAddress: ObservableObject {
    @Published var address: [Address] = []
    @Published var zipAddress: String = ""
    func fetchZipcode(url: String) {
        guard let urlString = URL(string: url) else { return }
        let request = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            }
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(Int.self, from: data)
                DispatchQueue.main.async {
                    self.zipAddress = String(decodedResponse)
                    let firstAddress = self.zipAddress.prefix(3)
                    let secondAddressIndex = self.zipAddress.index(self.zipAddress.startIndex, offsetBy: 3)
                    let secondAddress = self.zipAddress[secondAddressIndex...]
                    self.zipAddress = firstAddress + String(secondAddress)
                }
            } catch {
                self.zipAddress = ""
            }
        }.resume()
    }
    
    func fetchAddress(url: String) {
        guard let urlString = URL(string: url) else { return }
        let request = URLRequest(url: urlString)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            }
            guard let data = data else { return }
            
            do {
                let decodedResponse = try JSONDecoder().decode(AddressResponse.self, from: data)
                DispatchQueue.main.async {
                    self.address = decodedResponse.results ?? []
                }
            } catch {
                self.address = []
            }
        }.resume()
    }
}

