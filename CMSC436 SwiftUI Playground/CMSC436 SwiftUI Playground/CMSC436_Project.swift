//
//  CMSC436_SwiftUI_PlaygroundApp.swift
//  CMSC436 SwiftUI Playground
//
//  Created by Mateos O'Connor on 3/1/22.
//

import SwiftUI

@main
struct CMSC436_SwiftUI_PlaygroundApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(Sudoku())
        }
    }
}
