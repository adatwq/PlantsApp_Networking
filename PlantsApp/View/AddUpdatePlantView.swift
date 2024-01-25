//
//  AddPlantView.swift
//  PlantsApp
//
//  Created by Khawlah Khalid on 25/01/2024.
//

import SwiftUI

struct AddUpdatePlantView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: PlantsViewModel
    @State var isUpdate: Bool = false
    var plantToUpdate: Plant? = nil

    var body: some View {
        NavigationStack{
            Form{
                TextField("Plant name", text: $viewModel.name)
                
            }
            .navigationTitle("New plant")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    
                    Button("Cancel"){
                            dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button("Save"){
                        Task{
                            if isUpdate{
                                await viewModel.updatePlant()
                            }
                            else {
                                await viewModel.savePlant()
                            }
                            
                            dismiss()
                        }
                    }
                }
            }
            .onAppear{
                if let plantToUpdate{
                    self.isUpdate = true
                    self.viewModel.name = plantToUpdate.name
                }
            }
        }
    }
}

#Preview {
    AddUpdatePlantView(viewModel: .init())
}

