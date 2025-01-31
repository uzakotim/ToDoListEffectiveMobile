//
//  SpeechManager.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 30/01/25.
//

import SwiftUI
import AVFoundation
import Speech

// NOT WORKING : to be implemented...

class SpeechRecognitionManager: ObservableObject {
    private var audioEngine = AVAudioEngine()
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer = SFSpeechRecognizer()
    
    @Binding var searchText: String
    @Published var isDictating = false
    init(audioEngine: AVAudioEngine = AVAudioEngine(), recognitionTask: SFSpeechRecognitionTask? = nil, searchText: Binding<String>, isDictating: Bool = false) {
        self.audioEngine = audioEngine
        self.recognitionTask = recognitionTask
        self._searchText = searchText
        self.isDictating = isDictating
    }
    
    func startDictation() {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            print("Speech recognition not authorized")
            return
        }

        guard let recognizer = speechRecognizer, recognizer.isAvailable else {
            print("Speech recognizer is unavailable")
            return
        }

        isDictating = true
        audioEngine = AVAudioEngine()  // ✅ Ensure it's initialized properly

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Audio session setup failed: \(error.localizedDescription)")
            return
        }

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = false // ✅ Try true and false

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            request.append(buffer)
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()  // ✅ Start capturing microphone input
        } catch {
            print("Audio engine failed to start: \(error.localizedDescription)")
            return
        }

        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.searchText = result.bestTranscription.formattedString
                }
            }
            if let error = error {
                print("Dictation error: \(error.localizedDescription)")
                self.stopDictation()
            }
        }
    }

    func stopDictation() {
        isDictating = false
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionTask?.cancel()
        recognitionTask = nil
    }
    func requestPermissions() {
        // Request microphone permission
//        AVAudioSession.sharedInstance().requestRecordPermission { (isGranted) in
//            if isGranted {
//                print("Microphone permission granted")
//            } else {
//                print("Microphone permission denied")
//            }
//        }
        
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
