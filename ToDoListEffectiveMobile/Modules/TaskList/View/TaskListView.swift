import SwiftUI

struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter

    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchText) { oldValue, newValue in
                        presenter.searchTasks(query: newValue)
                    }

                List {
                    ForEach(presenter.filteredTasks) { task in
                        HStack {
                            Text(task.isCompleted ? "checkmark.circle" : "circlebadge")
                                .foregroundColor(task.isCompleted ? .green : .orange)
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
                .navigationTitle("ToDo List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { presenter.addNewTask() }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        ZStack {
                            HStack{
                                Spacer()
                                Text(" \(presenter.filteredTasks.count) задач")
                                Spacer()
                            }
                            HStack{
                                Spacer()
                                Button(action: { presenter.addNewTask() }) {
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                        }
                    }
                }
                .onAppear {
                    presenter.loadTasks()
                }
            }
        }
    }
}
