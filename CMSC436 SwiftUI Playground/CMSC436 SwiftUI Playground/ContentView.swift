//
//  ContentView.swift
//  CMSC436 SwiftUI Playground
//
//  Created by Mateos O'Connor on 3/1/22.
//

import SwiftUI
import AudioToolbox



public struct ContentView: View {
    
    @StateObject var game = Sudoku()
    public var body: some View {
        NavigationView{
            GeometryReader { geometry in
                ZStack {
                    //background image
                    Image("final")
                        .resizable()
                        .aspectRatio(geometry.size, contentMode: .fill)
                        .edgesIgnoringSafeArea(.all).offset(y:0)
                    VStack{
                        Text("Shake Sudoku").font(.system(size: 55).weight(.bold)).foregroundColor(Color.white).toolbar{
                            ToolbarItemGroup(placement: .navigationBarTrailing) {
                                HStack{
                                    Link(destination: URL(string: "https://sudoku.com/how-to-play/sudoku-rules-for-complete-beginners/")!){
                                        Image(systemName: "questionmark.circle").resizable().frame(width: 35, height: 35).foregroundColor(Color.white)
                                    }
                                    NavigationLink(destination: statView(game: game)) {
                                        Image(systemName: "note.text").resizable().frame(width: 35, height: 35).foregroundColor(Color.white)
                                    }
                                    NavigationLink(destination: settingView(game: game)) {
                                        Image(systemName: "gearshape").resizable().frame(width: 35, height: 35).foregroundColor(Color.white)
                                    }
                                }
                            }
                        }.offset(x: 0, y: -10)
                        Spacer()
                        
                        //no game yet
                        if !(game.hasGame){
                            VStack{
                                NavigationLink(destination: currentGame(game: game)) {
                                    VStack{
                                        Image("umd-logo").resizable().frame(width: 300, height: 300)
                                        Text("Start Game").font(.system(size: 35).weight(.bold)).foregroundColor(Color.white)
                                    }.frame(width: 350, height: 400).border(Color.white, width:6).cornerRadius(6).foregroundColor(Color.white)
                                    
                                }.foregroundColor(Color.black).simultaneousGesture(TapGesture().onEnded {
                                    game.newgame()
                                })
                                Text("To lower difficulty, shake the iPhone at the start of").font(.system(size: 30).weight(.bold)).frame(width:350,alignment: .center).foregroundColor(Color.white)
                                Text("the game!").font(.system(size: 30).weight(.bold)).frame(width:350,alignment: .center).foregroundColor(Color.white)
                            }
                            
                            Spacer()
                        } else{
                            NavigationLink(destination: currentGame(game: game)) {
                                VStack{
                                    Image("umd-logo").resizable().frame(width: 300, height: 300)
                                    Text("Current Game").font(.system(size: 35).weight(.bold)).foregroundColor(Color.white)
                                }.frame(width: 350, height: 400).border(Color.white, width:6).cornerRadius(6)
                                
                            }.foregroundColor(Color.black)
                            
                            Spacer()
                            
                            NavigationLink(destination: currentGame(game: game)) {
                                Text("New Game").font(.system(size: 35).weight(.bold)).foregroundColor(Color.white)
                            }.offset(y:-0).simultaneousGesture(TapGesture().onEnded {
                                game.newgame()
                            })
                            
                            Spacer()
                        }
                    }
                }
                
            }
            
        }.frame(width:400, height:800).navigationBarBackButtonHidden(true)
    }
    
    struct currentGame: View{
        @ObservedObject var game: Sudoku
        @State var change = false
        @State var crossed = false
        @State var notes = false
        @Environment(\.presentationMode) var mode: Binding<PresentationMode>
        let columns = Array(repeating: GridItem(.fixed(9), spacing: 30), count:9)
        @State public var isSelected = -1
        
        var body: some View {
            
            //insert timer, difficulty, etc.
            VStack{
                
                HStack{
                    if(game.trackScore) {
                        Text("\(String(describing: game.difficulty))").frame(width: 80).offset(x:20)
                        Text("Score: \(game.score)").frame(width: 150).offset(x:25).font(.system(size: 24))
                        Text("Mistakes: \(game.numWrong)/3").frame(width: 150)
                    } else {
                        Text("\(String(describing: game.difficulty))").frame(width: 80).offset(x:20)
                        Text("          ").frame(width: 150).offset(x:25).font(.system(size: 24))
                        Text("Mistakes: \(game.numWrong)/3").frame(width: 150)
                    }
                }.padding().frame(width: 370, height: 20).offset(y: -50).toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading){
                        Button(action: {
                            self.mode.wrappedValue.dismiss()
                            game.hasGame = true
                        }) {
                            Image(systemName: "house").resizable().frame(width: 40, height: 40)
                        }
                        
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Toggle("", isOn: $game.useSFX).toggleStyle(CustomToggleStyle())
                        
                    }
                }.alert(isPresented: $game.lose) {
                    Alert(
                        title: Text("Game Over!"),
                        message: Text("Score: \(game.score)"),
                        primaryButton: .default(
                            Text("New Game"),
                            action: {
                                game.newgame()
                                isSelected = -1
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("Main Menu"),
                            action: {self.mode.wrappedValue.dismiss()}
                        )
                    )
                }
                
                //sudoku board and stuff
                HStack{
                    LazyVGrid(columns: columns, spacing: -0.2) {
                        ForEach(0...80, id: \.self) {
                            index in Button(action: {}){
                                if (game.startingBoard[index] != 0) {
                                    Rectangle().border(Color.black)
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color.white)
                                        .overlay(Text(game.stringBoard[index]).foregroundColor(Color.black).font(.system(size: 32)))
                                } else {
                                    if (isSelected == index) {
                                        if (game.tileColor[index] == 0) {
                                            Rectangle().border(Color.black)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color(UIColor.lightGray))
                                                .overlay(Text(game.stringBoard[index]).foregroundColor(Color.blue).font(.system(size: 32)))
                                                .onTapGesture {
                                                    isSelected = index
                                                }
                                        } else if (game.tileColor[index] == 1){
                                            //incorrect
                                            Rectangle().border(Color.black)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color(UIColor(red: 1, green: 0, blue: 0, alpha: 0.40)))
                                                .overlay(Text(game.stringBoard[index]).foregroundColor(Color.blue).font(.system(size: 32)))
                                                .onTapGesture {
                                                    isSelected = index
                                                }
                                        } /*else if (game.tileColor[index] == 2) {
                                            //notes
                                            Rectangle().border(Color.black)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color.white)
                                                .overlay(Text(game.notesStrings[index]).foregroundColor(Color.blue).font(.system(size: 16)))
                                                .onTapGesture {
                                                    isSelected = index
                                                }
                                        }*/
                                    } else {
                                        if (game.tileColor[index] == 0) {
                                            Rectangle().border(Color.black)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color.white)
                                                .overlay(Text(game.stringBoard[index]).foregroundColor(Color.blue).font(.system(size: 32)))
                                                .onTapGesture {
                                                    isSelected = index
                                                }
                                        } else if (game.tileColor[index] == 1) {
                                            //incorrect
                                            Rectangle().border(Color.black)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color(UIColor(red: 1, green: 0, blue: 0, alpha: 0.40)))
                                                .overlay(Text(game.stringBoard[index]).foregroundColor(Color.blue).font(.system(size: 32)))
                                                .onTapGesture {
                                                    isSelected = index
                                                }
                                        } /*else if (game.tileColor[index] == 2){
                                            //notes
                                            Rectangle().border(Color.black)
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color.white)
                                                .overlay(Text(game.notesStrings[index]).foregroundColor(Color.blue).font(.system(size: 16)))
                                                .onTapGesture {
                                                    isSelected = index
                                                }
                                        }*/
                                    }
                                }
                            }
                        }
                    }.offset(x:186,y: -50).alert(isPresented: $change) {
                        Alert(
                            title: Text("Decrease Difficulty?"),
                            message: Text("This action cannot be undone."),
                            primaryButton: .default(
                                Text("Yes"),
                                action: {
                                    game.addNumbers(level: game.difficulty)
                                    change = false
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("No"),
                                action: {
                                    change = false
                                    game.stopAlerts = true
                                }
                            )
                        )
                    }
                    .onShake(perform: {
                        changeDiff()
                    })
                    
                    //extra lines to look like sudoku
                    VStack{
                        HStack{
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120)
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120).offset(x: -8)
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120).offset(x:-16)
                        }
                        HStack{
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120)
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120).offset(x: -8)
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120).offset(x:-16)
                        }.offset(y:-8)
                        HStack{
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120)
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120).offset(x: -8)
                            Rectangle().stroke(Color.black, lineWidth:3).frame(width: 117, height: 120).offset(x:-16)
                        }.offset(y:-16)
                    }.offset(x:-157, y:-42)
                }
                
                HStack(spacing: 40){
                    Button(action:{game.eraseTile(index: isSelected)}){
                        VStack{
                            Image(systemName: "trash.circle").resizable().frame(width: 50, height: 50).foregroundColor(Color.black).padding()
                            Text("Erase").font(.system(size: 30)).offset(y:-20).foregroundColor(Color.black)
                        }
                        
                    }.offset(x:-10)
                    
                    Button(action:{
                        if notes == false {
                            notes = true
                        } else {
                            notes = false
                        }
                    }){
                        VStack{
                            Image(systemName: "pencil.tip.crop.circle").resizable().frame(width: 50, height: 50).foregroundColor(Color.orange).padding()
                            Text("Notes").font(.system(size: 30)).offset(y:-20).foregroundColor(Color.black)
                            if notes == false {
                                Text("Off").font(.system(size: 16).weight(.bold)).offset(y:-20).foregroundColor(Color.red)
                            } else {
                                Text("On").font(.system(size: 16).weight(.bold)).offset(y:-20).foregroundColor(Color.red)
                            }
                            
                        }
                    }.offset(y: 10)
                    if (game.useHints) {
                        Button(action:{
                            game.addHint()
                            AudioServicesPlaySystemSound(0x450)
                        }){
                            VStack{
                                Image(systemName: "lightbulb.circle").resizable().frame(width: 50, height: 50).foregroundColor(Color.yellow).padding()
                                Text("Hint").font(.system(size: 30)).offset(y:-20).foregroundColor(Color.black)
                            }
                        }.offset(x:10).alert(isPresented: $game.noMoreHints) {
                            Alert(title: Text("No Hints Remaining!"))
                        }
                    }
                    
                    
                }.offset(y:-50).alert(isPresented: $game.win) {
                    Alert(
                        title: Text("You Win!"),
                        message: Text("Score: \(game.score)"),
                        primaryButton: .default(
                            Text("New Game"),
                            action: {
                                game.newgame()
                                isSelected = -1
                            }
                        ),
                        secondaryButton: .destructive(
                            Text("Main Menu"),
                            action: {self.mode.wrappedValue.dismiss()}
                        )
                    )
                }
                
                HStack(spacing: 18){
                    Button("1", action: {
                        insertNumber(num: 1)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }
                    }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("2", action: {
                        insertNumber(num: 2)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                    }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("3", action: {
                        insertNumber(num: 3)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                    }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("4", action: {
                        insertNumber(num: 4)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                   }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("5", action: {
                        insertNumber(num: 5)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                   }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("6", action: {
                        insertNumber(num: 6)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                  }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("7", action: {
                        insertNumber(num: 7)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                   }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("8", action: {
                        insertNumber(num: 8)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                   }).foregroundColor(Color.blue).font(.system(size: 40))
                    Button("9", action: {
                        insertNumber(num: 9)
                        if(game.useSFX){
                            AudioServicesPlaySystemSound(0x450)
                        }                   }).foregroundColor(Color.blue).font(.system(size: 40))
                }.offset(y:-30).frame(width: 400)
            }.offset(y:0).navigationBarBackButtonHidden(true)
            
        }
        
        func insertNumber(num: Int) {
            if notes == false {
                game.changeTile(index: isSelected, num: num)
            } else {
                game.addNote(index: isSelected, num: num)
            }
        }
        func changeDiff(){
            if (game.difficulty != .Easy && game.hasAddedNum == false && game.stopAlerts == false){
                change = true
            }
        }
    }
    
    struct statView: View{
        @ObservedObject var game: Sudoku
        @State var showReset = false
        var body: some View {
            
            List{
                Section(header:Text("General Statistics")) {
                    Text("Games Started: \(game.gamesStarted)")
                    Text("Games Won: \(game.gamesWon)")
                    Text("Current Win Streak: \(game.winStreak)")
                    Text("High Score: \(game.highScore)")
                    Text("Recent High Score: \(game.highScoreDate.formatted())").listRowSeparator(.hidden).listRowBackground(Color.clear)
                }
                Section{
                    Button(action: {showReset = true}){
                        Text("Reset Statistics").foregroundColor(Color.red)
                    }.alert(isPresented: $showReset) {
                        Alert(
                            title: Text("Clear Stats"),
                            message: Text("Are you sure?"),
                            primaryButton: .default(
                                Text("Yes"),
                                action: {
                                    game.gamesStarted = 0
                                    game.gamesWon = 0
                                    game.winStreak = 0
                                    game.highScore = 0
                                    game.highScoreDate = Date()
                                    showReset = false
                                }
                            ),
                            secondaryButton: .destructive(
                                Text("No"),
                                action: {showReset = false}
                            )
                        )
                    }
                    
                }
            }.navigationBarTitle("Statistics")
        }
    }
}



struct settingView: View{
    @ObservedObject var game: Sudoku
    var body: some View {
        VStack{
            List{
                Toggle(isOn: $game.useSFX){
                    Text("Sound Effects")
                }.padding()
                Toggle(isOn: $game.useHints){
                    Text("Use Hints")
                }.padding()
                Toggle(isOn: $game.trackScore){
                    Text("Track Score")
                }.padding()
            }.navigationBarTitle("Settings")
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}

//SHAKEGESTURE

// The notification we'll send when a shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}


struct CustomToggleStyle : ToggleStyle{
    //@ObservedObject var game : Sudoku
    func makeBody(configuration: Configuration) -> some View {
        VStack{
            Button(action: {configuration.isOn.toggle()}, label: {
                Image(systemName: configuration.isOn ? "speaker.wave.3" : "speaker.slash").renderingMode(.template).foregroundColor(Color.blue).font(.system(size:25))
            })
        }
        
    }
}

//For button sounds
extension UIInputView : UIInputViewAudioFeedback {
    
    public var enableInputClicksWhenVisible: Bool {
        return true
    }
    
}
