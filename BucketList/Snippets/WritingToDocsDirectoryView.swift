//
//  WritingToDocsDirectoryView.swift
//  BucketList
//
//  Created by Rodrigo on 16-08-24.
//

import SwiftUI

struct WritingToDocsDirectoryView: View {
    var body: some View {
        Button("Read and Write") {
            let data = Data("Test Message".utf8)
            let url = URL.documentsDirectory.appending(path: "message.txt")
            
            do {
                try data.write(to: url, options: [.atomic, .completeFileProtection])
                let input = try String(contentsOf: url)
                print(input)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    WritingToDocsDirectoryView()
}
