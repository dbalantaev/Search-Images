//
//  GetData.swift
//  Search Images
//
//  Created by Дмитрий Балантаев on 27.01.2022.
//

import SwiftUI

class getData: ObservableObject {
    @Published var Images: [[Photo]] = []
    @Published var noresults = false
    
    init() {
        updateData()
    }
    
    func updateData() {
        
        self.noresults = false
        
        let key = "AfMzLNn7FN9YVCyvXNGGZ3EQnKETm0B-yB6cN31Umc8"
        let url = "https://api.unsplash.com/photos/random/?count=30&client_id=\(key)"
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            do {
                let json = try JSONDecoder().decode([Photo].self, from: data!)
                for i in stride(from: 0, to: json.count, by: 2) {
                    var ArrayData: [Photo] = []
                    for j in i..<i+2 {
                        if j < json.count {
                            ArrayData.append(json[j])
                        }
                    }
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    
    func SearchData(url: String) {
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            do {
                let json = try JSONDecoder().decode(SearchPhoto.self, from: data!)
                if json.results.isEmpty {
                    self.noresults = true
                } else {
                    self.noresults = false
                }
                for i in stride(from: 0, to: json.results.count, by: 2) {
                    var ArrayData: [Photo] = []
                    
                    for j in i..<i+2 {
                        if j < json.results.count {
                            ArrayData.append(json.results[j])
                        }
                    }
                    DispatchQueue.main.async {
                        self.Images.append(ArrayData)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
