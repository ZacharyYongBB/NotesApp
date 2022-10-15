//
//  ContentView.swift
//  CoreDataExample
//
//  Created by Zachary on 15/10/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var textFieldText: String = ""
    
    @FetchRequest(
        entity: NoteEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \NoteEntity.name, ascending: true)])
    var notes: FetchedResults<NoteEntity>

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                TextField("Add note!", text: $textFieldText)
                    .foregroundColor(.black)
                    .padding(.leading)
                    .frame(height: 54)
                    .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.851))
                    .cornerRadius(10)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                
                Button {
                    addItem()
                } label: {
                    Text("Add")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color(hue: 0.759, saturation: 0.564, brightness: 0.813))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                
                List {
                    ForEach(notes) { note in
                        Text(note.name ?? "")
                            .onTapGesture {
                                updateItem(note: note)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle("Notes Core Data")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newNote = NoteEntity(context: viewContext)
            newNote.name = textFieldText
            textFieldText = ""

            saveItems()
        }
    }
    
    private func updateItem(note: NoteEntity) {
        withAnimation {
            let currentName = note.name ?? ""
            let newname = currentName + "!"
            note.name = newname
            
            saveItems()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
//            offsets.map { notes[$0] }.forEach(viewContext.delete)
            guard let index = offsets.first else { return }
            let NoteEntity = notes[index]
            viewContext.delete(NoteEntity)
            
            saveItems()
            
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
