//
//  CustomContextMenu.swift
//  ToDoListEffectiveMobile
//
//  Created by Timur Uzakov on 31/01/25.
//
import SwiftUI

struct CustomContextMenuPreviewView: View {
    let task: Task

    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(task.descriptionData)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(task.dateCreatedFormatted)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(24)
            Spacer()
        }
        .padding(24)
        .cornerRadius(12)
        .frame(minWidth: 200, maxWidth: 400)
    }
}
