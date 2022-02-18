//
//  ContentView.swift
//  suryanamaskar
//
//  Created by karmaln technology on 31/01/22.
//

import AVFoundation
import SwiftUI
var player: AVAudioPlayer!

struct ContentView: View {
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @State var seconds: Int = 0
    @State var timerIsPaused: Bool = true
    @State var timer: Timer? = nil

    @State var slockno: Int = 0
    @State var dayNo: Int = Calendar.current.component(.weekday, from: Date()) - 2

    func sunNameText(name: String, fontcolor: Color, font: Font? = .headline) -> Text {
        return Text(name)
            .bold()
            .font(font)
            .foregroundColor(fontcolor)
    }

    var body: some View {
        ZStack {
            Image("bg")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()

                // MARK: - Days Name

                HStack {
                    ForEach(0 ..< 7) { i in
                        Button(action: {
                            dayNo = i
                            restartTimer()
                            stopTimer()
                        }) {
                            Text(Slock().days[i]).foregroundColor(dayNo == i ? .primary : Color("font")).font(dayNo == i ? .title3 : .headline)
                        }
                    }
                }.padding(10.0).border(Color.black, width: 2)

                // MARK: - Current Slock

                HStack {
                    sunNameText(name: String(self.slockno + 1) + " - ", fontcolor: Color("Corange"), font: .largeTitle)
                    ForEach(0 ..< 7) { i in
                        if dayNo == i {
                            sunNameText(name: Slock().sun108Name[dayNo][self.slockno], fontcolor: Color("Corange"), font: .largeTitle)
                        }
                    }
                }.padding(30)
                    .frame(height: 150, alignment: .center)

                // MARK: - 14 SunName

                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0 ..< 7) { i in
                            if dayNo == i {
                                ForEach(0 ..< 7) { j in
                                    sunNameText(name: Slock().sun108Name[dayNo][j], fontcolor: self.slockno == j ? Color("Corange") : .white)
                                }
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(0 ..< 7) { i in
                            if dayNo == i {
                                ForEach(7 ..< 14) { j in
                                    sunNameText(name: Slock().sun108Name[dayNo][j], fontcolor: self.slockno == j ? Color("Corange") : .white)
                                }
                            }
                        }
                    }
                }
                Spacer()

                // MARK: - Timer

                VStack {
                    Text("\(hours):\(minutes):\(seconds)")
                        .font(Font.system(.largeTitle, design: .monospaced))
                        .foregroundColor(Color("Corange"))
                    if timerIsPaused {
                        HStack {
                            Button(action: {
                                self.restartTimer()
                            }) {
                                Image(systemName: "backward.end.alt")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 35.0, height: 35.0)
                                    .padding(.all)
                                    .accentColor(Color("Corange"))
                            }
                            Button(action: {
                                self.startTimer()
                            }) {
                                Image(systemName: "play.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25.0, height: 25.0)
                                    .padding(.all)
                                    .accentColor(Color("Corange"))
                            }
                        }
                    } else {
                        Button(action: {
                            self.stopTimer()
                        }) {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35.0, height: 35.0)
                                .padding(.all)
                                .accentColor(Color("Corange"))
                        }
                    }
                }
            }
        }
    }

    // MARK: - Timer Function

    func startTimer() {
        timerIsPaused = false
        playSound()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.seconds == 59 {
                self.seconds = 0
                if self.minutes == 59 {
                    self.minutes = 0
                    self.hours = self.hours + 1
                } else {
                    self.minutes = self.minutes + 1
                }
            } else {
                self.seconds = self.seconds + 1
                if self.seconds % 8 == 0 {
                    self.slockno += 1
                    print("slock --> ")
                    playSound()
                }
                if self.slockno == 13 {
                    print("14 Slock Complete")
                    self.stopTimer()
                }
            }
        }
    }

    func stopTimer() {
        timerIsPaused = true
        timer?.invalidate()
        timer = nil
    }

    func restartTimer() {
        hours = 0
        minutes = 0
        seconds = 0
        slockno = 0
    }

    // MARK: - Play Sound Function

    func playSound() {
        let url = Bundle.main.url(forResource: "om", withExtension: "mp3")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
