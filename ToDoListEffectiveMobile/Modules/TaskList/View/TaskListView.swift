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
                .padding(.horizontal, 16)

                // Grey bottom bar
                ZStack {
                    Color.gray
                        .frame(maxWidth: .infinity, maxHeight: 60) // Full width, fixed height for bottom bar
                        .edgesIgnoringSafeArea(.bottom)// To cover the entire width and bottom

                    HStack {
                        Spacer()
                        Text(" \(presenter.filteredTasks.count) задач")
                            .foregroundColor(.white) // White text for contrast against grey
                            .font(.caption)
                        Spacer()
                    }

                    HStack {
                        Spacer()
                        Button(action: { presenter.addNewTask() }) {
                            Image(systemName: "square.and.pencil")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .frame(maxWidth: .infinity) // Full width for bottom bar
                .padding(.bottom, 0) // Ensures the bottom bar is pinned to the bottom edge
            }
        }
    }
}
