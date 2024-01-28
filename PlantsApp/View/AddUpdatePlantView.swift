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
                    if !isUpdate{
                        Button("Cancel"){
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button("Save"){
                        Task{
                            if isUpdate{
                                await viewModel.updatePlant(newPlant: .init(id:plantToUpdate?.id , name: viewModel.name))
                            }
                            else {
                                await viewModel.savePlant()
                            }
                            
                            dismiss()
                        }
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("Ok"){ }
            } message: {
                Text(viewModel.alertMessage)
            }
            .onAppear{
                if let plantToUpdate{
                    self.isUpdate = true
                    self.viewModel.name = plantToUpdate.name
                }
                else{
                    self.viewModel.name = ""
                }
            }
        }
    }
}

#Preview {
    AddUpdatePlantView(viewModel: .init())
}

