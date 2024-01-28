//
//  PlantsViewModel.swift
//  PlantsApp
//
//  Created by Khawlah Khalid on 25/01/2024.
//

import Foundation
final class PlantsViewModel: ObservableObject{
    @Published var allPlants: [Plant] = []
    @Published var name: String = ""
    @Published var showAddPlantSheet: Bool = false

    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    let urlString = "http://127.0.0.1:8080/plants/"
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    func fetchPlants() async{
        guard let url = URL(string: urlString) else { return  }
        do{
            let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
            self.allPlants = try decoder.decode([Plant].self, from: data)
        }
        catch{
            alertMessage = "Faild to get plants, please try again later"
            showAlert = true
        }
        
    }
    
    func savePlant() async{
        let plant = Plant(name: name)
        guard let url = URL(string: urlString) else { return  }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        do{
            let plantData = try encoder.encode(plant)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = plantData
            let (data, _) = try await URLSession.shared.data(for: request)
            let newPlant = try decoder.decode(Plant.self, from: data)
            self.allPlants.append(newPlant)
        }
        
        catch{
            alertMessage = "Faild to save the plant, please try again later"
            showAlert = true
        }
    }
    
    func updatePlant(newPlant: Plant) async{
        guard let url = URL(string: urlString) else {  return }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        
        do{
            let plantData = try JSONEncoder().encode(newPlant)
            request.httpBody = plantData
            let (data, _ ) = try await URLSession.shared.data(for: request)
            let _ = try decoder.decode(Plant.self, from: data)
            
            let index = self.allPlants.firstIndex {  $0.id == newPlant.id }
            if let index{
                self.allPlants[index].name = newPlant.name
            }
        }
        catch{
            alertMessage = "Faild to uodate the plant, please try again later"
            showAlert = true
        }
        
    }
    
    func deletePlant(indexSet: IndexSet) async{
        guard let index = indexSet.first else {return}
        let plant = self.allPlants[index]
        
        guard let plantId = plant.id?.uuidString else {return}
        let urlString = urlString + plantId
        guard let url = URL(string: urlString) else {  return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        do{
            let (data, _ ) = try await URLSession.shared.data(for: request)
            let _ = try decoder.decode(Plant.self, from: data)
            self.allPlants.remove(at: index)
        }
        
        catch{
            alertMessage = "Faild to delete the plant, please try again later"
            showAlert = true
        }
            
    }
    
    

}


enum MyError: Error {
    case rror(String)
}
