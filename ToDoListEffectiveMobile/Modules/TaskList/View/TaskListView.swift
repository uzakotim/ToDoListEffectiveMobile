import SwiftUI

struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter
    @State private var isNavigatingToTaskDetail = false
    @State private var searchText: String = ""
    @State private var selectedTask: Task = Task(id: 0, title: "", description: "", isCompleted: false)
    
    var body: some View {
        NavigationStack {
            VStack {
                // Main content
                VStack {
                    HStack {
                        Image(systemName: "magnifyingglass") // Search icon
                            .foregroundColor(Color(UIColor.placeholderText))
    
                        
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
                                .foregroundColor(Color(UIColor.placeholderText))
                        }
                    }
                    .padding(.horizontal, 16)
                    .background(Color(.secondarySystemBackground)) // Grey background
                    .cornerRadius(12)
                    List(presenter.filteredTasks) { task in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(task.title)
                                .font(.headline)
                            
                            Text(task.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(task.dateCreatedFormatted)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .contextMenu {
                            Button(action: {
                                isNavigatingToTaskDetail = true
                                selectedTask = task
                            }) {
                                Label("Редактировать", systemImage: "square.and.pencil")
                            }

                            Button(action: {
                                shareTask(task)
                            }) {
                                Label("Поделиться", systemImage: "square.and.arrow.up")
                            }

                            Button(role: .destructive) {
                                presenter.deleteTask(task: task)
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                    }
                    .navigationDestination(isPresented: $isNavigatingToTaskDetail){
                        presenter.router.navigateToTaskDetails(with: selectedTask)
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
                        Text("\(presenter.filteredTasks.count) задач").font(.caption).fontWeight(.light).foregroundColor(Color(UIColor.placeholderText))
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
    func shareTask(_ task: Task) {
        let activityVC = UIActivityViewController(activityItems: [task.title, task.description], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
