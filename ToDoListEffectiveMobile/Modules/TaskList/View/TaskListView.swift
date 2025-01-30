import SwiftUI
struct CustomContextMenuPreviewView: View {
    let task: Task

    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(nil) // Allows unlimited lines
                    .fixedSize(horizontal: false, vertical: true) // Prevents text from getting cut off
                
                Text(task.descriptionData)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(task.dateCreatedFormatted)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(25)
        .cornerRadius(12)
        .frame(minWidth: 200, maxWidth: 400)
    }
}
struct SearchBar: View {
    @Binding var searchText: String
    @ObservedObject var presenter: TaskListPresenter
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "magnifyingglass") // Search icon
                .foregroundColor(Color(UIColor.placeholderText))

            TextField("Search", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle()) // Plain style for custom background
                .cornerRadius(6)
                .padding(.vertical, 8)  // Adjust vertical padding
                .padding(.horizontal, 6)  // Adjust horizontal padding
                .frame(maxWidth: .infinity)  // Set a fixed width for the TextField
                .onChange(of: searchText) { oldValue, newValue in
                    presenter.searchTasks(query: newValue)
                }

            Button(action: {
                // Microphone button action here
            }) {
                Image(systemName: "mic.fill") // Microphone icon
                    .foregroundColor(Color(UIColor.placeholderText))
            }
            Spacer()
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

extension UUID {
    var intID: Int {
        return abs(self.uuidString.hash)
    }
}

struct BottomToolbar: View {
    @ObservedObject var presenter: TaskListPresenter
    @Binding var isNavigatingToTaskDetail: Bool
    @Binding var selectedTask: Task
    
    // create int from UUID
    let emptyTask: Task = .init(id: UUID().intID, title: "", description: "", isCompleted: false)
    var body: some View {
        ZStack{
            HStack{
                Spacer()
                Text("\(presenter.filteredTasks.count) задач").font(.caption).fontWeight(.light).foregroundColor(Color(UIColor.placeholderText))
                Spacer()
            }
           
            HStack{
                Spacer()
                Button(action: {
                    isNavigatingToTaskDetail = true
                    selectedTask = emptyTask
                }) {
                    Image(systemName: "square.and.pencil")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}


struct TaskList: View {
    let tasks: [Task]
    let onEdit: (Task) -> Void
    let onDelete: (Task) -> Void
    let onShare: (Task) -> Void
    @ObservedObject var presenter: TaskListPresenter
    @Binding var isNavigatingToTaskDetail: Bool
    @Binding var selectedTask: Task
   
    var body: some View {
        List {
            ForEach(tasks) { task in
                ListItemView(task: task)
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button(action: { onEdit(task) }) {
                            Label("Редактировать", systemImage: "square.and.pencil")
                        }
                        Button(action: { onShare(task) }) {
                            Label("Поделиться", systemImage: "square.and.arrow.up")
                        }
                        Button(role: .destructive, action: { onDelete(task) }) {
                            Label("Удалить", systemImage: "trash")
                        }
                    } preview: { CustomContextMenuPreviewView(task: task) }
                    .listRowSeparator(.hidden)
                    .padding(0)
                    .onTapGesture {
                        presenter.toggleTask(task: task)
                    }
                    
            }
            
            .onDelete { indexSet in
                for index in indexSet {
                    let taskToDelete = presenter.tasks[index] // Get the task at the index
                    presenter.deleteTask(task: taskToDelete) // Delete the task from Core Data
                }
            }
            
        }
        .listStyle(PlainListStyle())
        .background(Color(.systemBackground))
        .navigationDestination(isPresented: $isNavigatingToTaskDetail){
            presenter.router.navigateToTaskDetails(with: selectedTask)
        }
        .listStyle(PlainListStyle())
        .frame(maxWidth: .infinity)
        .navigationTitle("Задачи")
        .onAppear {
            presenter.loadData()
        }
    }
}

struct TaskListView: View {
    @ObservedObject var presenter: TaskListPresenter
    @State private var isNavigatingToTaskDetail = false
    @State private var searchText: String = ""
    @State private var selectedTask: Task = Task(id: 0, title: "", description: "", isCompleted: false)

    var body: some View {
        NavigationStack {
            VStack {
                        // Main content
                        SearchBar(searchText: $searchText, presenter: presenter)
                        TaskList(
                            tasks: presenter.filteredTasks,
                            onEdit: { task in
                                selectedTask = task
                                isNavigatingToTaskDetail = true
                            },
                            onDelete: presenter.deleteTask,
                            onShare: shareTask,
                            presenter: presenter,
                            isNavigatingToTaskDetail: $isNavigatingToTaskDetail,
                            selectedTask: $selectedTask
                        )
                
            }
            .toolbar{
                ToolbarItem(placement: .bottomBar) {
                    BottomToolbar(presenter: presenter, isNavigatingToTaskDetail: $isNavigatingToTaskDetail, selectedTask: $selectedTask
                    )
                    
                }
                
            }
            .toolbarBackground(Color(UIColor.systemBackground), for: .tabBar)
            .toolbarBackground(Color(UIColor.secondarySystemBackground), for: .automatic)
            .edgesIgnoringSafeArea(.bottom)
        }
        
    }
    func shareTask(_ task: Task) {
        let activityVC = UIActivityViewController(activityItems: [task.title, task.descriptionData], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }
}
