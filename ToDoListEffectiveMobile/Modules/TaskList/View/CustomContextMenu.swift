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
            VStack(alignment: .leading, spacing: 8) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: false)
                
                Text(task.descriptionData)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: false)
                
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
