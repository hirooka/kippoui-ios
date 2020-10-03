import SwiftUI

enum ActiveAlert {
    case error, save, none
}

struct PreferencesView: View {
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var myAzimuth: MyAzimuth
    
    @Binding var isPreferencesPresenting: Bool
    
    @State var updatedArgument = ""
    var angle = ["30", "45"]
    
    @State var isAlert = false;
    @State var activeAlert: ActiveAlert = .error
    
    @State var arg = ""
    @State var sel = -1
    
    let formatter: NumberFormatter = {
        let numFormatter = NumberFormatter()
        numFormatter.numberStyle = .decimal
        return numFormatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("偏角 [度] (西偏を正としています)")) {
                    TextField("", text: $arg, onEditingChanged: { (editingChanged) in
                        if editingChanged {
                            
                        } else {
                            
                        }
                    }).onChange(of: preferences.argument) {text in
                        updatedArgument = text
                    }
                    .keyboardType(.decimalPad)
//                    TextField("Argument", value: $argumentValue, formatter: formatter)
//                        .keyboardType(.decimalPad)
                    .onAppear(perform: {
                        if arg == "" {
                            arg = preferences.argument
                        } else {
                            
                        }
                    })
                    .onDisappear(perform: {
                        
                    })
                }
                Section(header: Text("方位線のタイプ")) {
                    Picker(selection: $sel, label: Text("方位線のタイプ")) {
                        ForEach(0..<angle.count) {
                            Text(self.angle[$0])
                        }
                    }
                    .onAppear(perform: {
                        if sel == -1 {
                            sel = preferences.selected
                        } else {
                            
                        }
                    })
                    .onDisappear(perform: {
                    })
                    .onTapGesture {
                        //UIApplication.shared.endEditing()
                    }
                }
            }
            .navigationTitle("設定")
            .navigationBarItems(trailing:
                Button(action: {
                    //print("arg = \(arg), updatedArgument = \(updatedArgument), preferences.argument = \(preferences.argument)")
                    //print("arg = \(sel), preferences.selected = \(preferences.selected)")
                    
                    if arg == preferences.argument && sel == preferences.selected {
                        //print("無変更")
                        self.isAlert = true
                        self.activeAlert = .none
                        return
                    }
                    
                    if arg == preferences.argument && sel != preferences.selected {
                        //print("角度タイプのみ変更")
                        switch sel {
                        case 0:
                            self.preferences.selected = 0
                            self.preferences.angle = "0"
                        case 1:
                            self.preferences.selected = 1
                            self.preferences.angle = "1"
                        default:
                            self.preferences.selected = 0
                            self.preferences.angle = "0"
                        }
                        self.isAlert = true
                        self.activeAlert = .save
                        return
                    }
                    
                    if arg != preferences.argument && sel == preferences.selected {
                        //print("偏角のみ変更")
                        do {
                            let regex = try NSRegularExpression(pattern: "^([1-9]\\d*|0)(\\.\\d+)?$", options: [])
                            let results = regex.matches(in: arg, options: [], range: NSRange(0..<arg.count))
                            if results.count == 0 {
                                self.isAlert = true
                                self.activeAlert = .error
                            } else {
                                self.preferences.argument = arg
                                self.isAlert = true
                                self.activeAlert = .save
                            }
                        } catch {
                            print("\(error)")
                        }
                    }
                    
                    if arg != preferences.argument && sel != preferences.selected {
                        //print("偏角と角度タイプの両方を変更")
                        do {
                            let regex = try NSRegularExpression(pattern: "^([1-9]\\d*|0)(\\.\\d+)?$", options: [])
                            let results = regex.matches(in: arg, options: [], range: NSRange(0..<arg.count))
                            if results.count == 0 {
                                self.isAlert = true
                                self.activeAlert = .error
                            } else {
                                self.preferences.argument = arg
                                switch sel {
                                case 0:
                                    self.preferences.selected = 0
                                    self.preferences.angle = "0"
                                case 1:
                                    self.preferences.selected = 1
                                    self.preferences.angle = "1"
                                default:
                                    self.preferences.selected = 0
                                    self.preferences.angle = "0"
                                }
                                self.isAlert = true
                                self.activeAlert = .save
                                return
                            }
                        } catch {
                            print("\(error)")
                        }
                    }
                    
//                    print("updatedArgument = \(updatedArgument), preferences.selected = \(preferences.selected), preferences.angle = \(self.preferences.angle)")
//                    if updatedArgument == "" && preferences.selected == Int(self.preferences.angle) {
//                        self.isAlert = true
//                        self.activeAlert = .none
//                        return
//                    }
//                    if updatedArgument == preferences.argument && preferences.selected == Int(self.preferences.angle) {
//                        self.isAlert = true
//                        self.activeAlert = .none
//                        return
//                    }
//                    if updatedArgument == "" && preferences.selected != Int(self.preferences.angle) {
//                        switch preferences.selected {
//                        case 0:
//                            self.preferences.angle = "0"
//                        case 1:
//                            self.preferences.angle = "1"
//                        default:
//                            self.preferences.angle = "0"
//                        }
//                        self.isAlert = true
//                        self.activeAlert = .save
//                        return
//                    } else {
//                        do {
//                            let regex = try NSRegularExpression(pattern: "^([1-9]\\d*|0)(\\.\\d+)?$", options: [])
//                            let results = regex.matches(in: updatedArgument, options: [], range: NSRange(0..<updatedArgument.count))
//                            if results.count == 0 {
//                                self.isAlert = true
//                                self.activeAlert = .error
//                            } else {
//                                if updatedArgument != "" {
//                                    self.preferences.argument = updatedArgument
//                                }
//                                switch preferences.selected {
//                                case 0:
//                                    self.preferences.angle = "0"
//                                case 1:
//                                    self.preferences.angle = "1"
//                                default:
//                                    self.preferences.angle = "0"
//                                }
//                                self.isAlert = true
//                                self.activeAlert = .save
//                            }
//                        } catch {
//                            print("\(error)")
//                        }
//                    }
                }) {
                    Text("保存")
                }
                .alert(isPresented: $isAlert) {
                    switch activeAlert {
                    case .error:
                        return Alert(title: Text("エラー"), message: Text("偏角を正しく入力してください(0, 0.0, 正の整数、正の小数)。"), dismissButton: .default(Text("OK")))
                    case .save:
                        return Alert(title: Text("成功"), message: Text("設定が保存されました。"), dismissButton: .default(Text("OK"), action: {
                            self.isPreferencesPresenting.toggle()
                            let polylineCalculator = PolylineCalculator(preferences: preferences, myAzimuth: myAzimuth)
                            polylineCalculator.updatePreferences()
                        }))
                    case .none:
                        return Alert(title: Text("注意"), message: Text("何も変更されていません。"), dismissButton: .default(Text("OK")))
                    }
                }
            )
        }.onAppear(perform: {
            //print("\(#file) - \(#function)")
        })
        .onDisappear(perform: {
//            if updatedArgument != "" {
//                self.preferences.argument = updatedArgument
//            }
//            //print("selected = \(preferences.selected)")
//            switch preferences.selected {
//            case 0:
//                self.preferences.angle = "0"
//            case 1:
//                self.preferences.angle = "1"
//            default:
//                self.preferences.angle = "0"
//            }
        })
//        .onTapGesture {
//            UIApplication.shared.endEditing() // Picker機能しない
//        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
