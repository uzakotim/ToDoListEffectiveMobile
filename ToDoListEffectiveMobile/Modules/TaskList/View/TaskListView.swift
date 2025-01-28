import SwiftUI

struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter
    
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                // Main content
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass") // Search icon
                            .foregroundColor(.primary)
                        
                        TextField("Search", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle()) // Plain style for custom background
                            .cornerRadius(6)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                            .onChange(of: searchText) { oldValue, newValue in
                                presenter.searchTasks(query: newValue)
                            }
                        
                        Button(action: {
                            // Microphone button action here
                        }) {
                            Image(systemName: "mic.fill") // Microphone icon
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .background(.secondary) // Grey background
                    .cornerRadius(12)
                    
                    List {
                        ForEach(presenter.filteredTasks) { task in
                            HStack {
                                Image(systemName: task.isCompleted ? "checkmark.circle" : "circlebadge")
                                    .foregroundColor(.yellow)
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text(task.description)
                                        .font(.caption)
                                        .foregroundColor(.white)
                                    Text("\(task.dateCreatedFormatted)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                // if not last element, show divider
                                if task.id != presenter.filteredTasks.last?.id {
                                    Divider()
                                }
                            }
                        }
                        .onDelete { indexSet in
                            presenter.deleteTask(at: indexSet)
                        }
                    }
                    .navigationTitle("Задачи")
                    .onAppear {
                        presenter.loadTasks()
                    }
                    
                }
                
                
            }
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar) {
                ZStack{
                    HStack{
                        Spacer()
                        Text("\(presenter.filteredTasks.count) задач").font(.caption).fontWeight(.light).foregroundColor(.white)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Button(action: {
                            // Microphone button action here
                        }) {
                            Image(systemName: "square.and.pencil") // Microphone icon
                                .foregroundColor(.yellow)
                        }
                    }
                }
            }
        }
        .toolbarBackground(Color.black, for: .bottomBar)
        .padding()
        .ignoresSafeArea()
    }
}
