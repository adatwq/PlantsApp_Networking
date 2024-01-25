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
    
    
    
    func fetchPlants() async{
        self.allPlants = [.init(id: UUID(), name: "Rose"),
                          .init(id: UUID(), name: "Apple")
        ]
    }
    
    func savePlant() async{
        
    }
    
    func updatePlant() async{
        
    }
    
    func deletePlant() async{
        
    }
    
    

}
