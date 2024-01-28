//
//  ContentView.swift
//  PlantsApp
//
//  Created by Khawlah Khalid on 25/01/2024.
//

import SwiftUI
import SwiftUI

struct PlantsListView: View {
    @StateObject var viewModel = PlantsViewModel()
    var body: some View {
        NavigationStack{
            ZStack{
                if viewModel.allPlants.isEmpty{
                    ContentUnavailableView("You don't have plants yet", systemImage: "magnifyingglass")
                }
                else{
                    List {
                        ForEach(viewModel.allPlants){ plant in
                            NavigationLink {
                            AddUpdatePlantView(viewModel: viewModel, plantToUpdate: plant)
                            } label: {
                                Text(plant.name)
                            }
                            
                        }
                        .onDelete(perform: { indexSet in
                            Task{
                              await viewModel.deletePlant(indexSet: indexSet)
                            }
                        })
                    }.listStyle(.plain)
                }
            }
            .navigationTitle("My plants 🌱")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        viewModel.showAddPlantSheet.toggle()
                    }label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddPlantSheet) {
                AddUpdatePlantView(viewModel: viewModel)
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("Ok"){ }
            } message: {
                Text(viewModel.alertMessage)
            }
            .task {
               await viewModel.fetchPlants()
            }
        }
    }
}

#Preview {
    PlantsListView()
}
