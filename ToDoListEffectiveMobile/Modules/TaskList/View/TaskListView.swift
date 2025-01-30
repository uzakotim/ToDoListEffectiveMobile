import SwiftUI
import Speech
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
    // To handle speech recognition
    @State private var isDictating = false
    private let speechRecognizer = SFSpeechRecognizer()
    
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
                .disableAutocorrection(true)  // Disable autocorrect for dictation

            Button(action: {
                startDictation()
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

    
    private func startDictation() {
            if SFSpeechRecognizer.authorizationStatus() == .authorized {
                isDictating = true
                _ = AVAudioEngine()
                let request = SFSpeechAudioBufferRecognitionRequest()
                _ = speechRecognizer?.recognitionTask(with: request) { result, error in
                    if let result = result {
                        // Use the text result for dictation
                        self.searchText = result.bestTranscription.formattedString
                    }
                    if let error = error {
                        print("Dictation error: \(error.localizedDescription)")
                        self.isDictating = false
                    }
                }
                // Set up and start the audio engine to capture voice input.
                // You can add audio engine setup code here (requires AVFoundation setup)
            } else {
                // Handle error when speech recognition is not authorized
                print("Speech recognition not authorized")
            }
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
    let emptyTask: Task = .init(id: -1, title: "", description: "", isCompleted: false)
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
            requestPermissions()
        }
    }
    // The requestPermissions function
    func requestPermissions() {
        // Request microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { (isGranted) in
            if isGranted {
                print("Microphone permission granted")
            } else {
                print("Microphone permission denied")
            }
        }
        
        // Request speech recognition permission
        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                print("Speech recognition authorized")
            case .denied:
                print("Speech recognition denied")
            case .restricted:
                print("Speech recognition restricted")
            case .notDetermined:
                print("Speech recognition not determined")
            @unknown default:
                break
            }
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
