//
//  ContentView.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 28/01/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    private var router = TaskListRouter()
    var body: some View {
        router.createMainScreen()
    }
}
