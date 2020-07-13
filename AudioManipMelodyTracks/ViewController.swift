//
//  ViewController.swift
//  AudioManipMelodyTracks
//
//  Created by John Baer on 7/12/20.
//  Copyright © 2020 John Baer. All rights reserved.
//

import UIKit
import AVKit

//Bad Blood is 85 BPM
//Delilah is 109 BPM
//Misery is 103 BPM


class ViewController: UIViewController {

    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()

    let engineBPM = AVAudioEngine()
    let speedControlBPM = AVAudioUnitVarispeed()
    let pitchControlBPM = AVAudioUnitTimePitch()
    
    var speedOfBPM:Float = 0.0
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func clickChangePitch(_ sender: Any) {
        //1.5 is a good amount to subtract pitch by
        pitchControl.pitch -= 127
        speedControl.rate += 0.1
        
        speedOfBPM += 0.1
        speedControlBPM.rate = speedOfBPM
        
        label.text = String(speedControl.rate)
    }
    
    @IBAction func playButton(_ sender: Any) {
        let url = Bundle.main.url(forResource: "Delilah", withExtension: ".mp3")
        do{
            try play(url!)}
        catch{}
        
        
        let url2 = Bundle.main.url(forResource: "100BPM", withExtension: ".mp3")
        do{
            try playBPM(url2!)}
        catch{}
        
        speedControlBPM.rate += 0.09
        speedOfBPM = speedControlBPM.rate
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func play(_ url: URL) throws {
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let audioPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engine.attach(audioPlayer)
        engine.attach(pitchControl)
        engine.attach(speedControl)
        
        // 4: arrange the parts so that output from one is input to another
        engine.connect(audioPlayer, to: speedControl, format: nil)
        engine.connect(speedControl, to: pitchControl, format: nil)
        engine.connect(pitchControl, to: engine.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        audioPlayer.scheduleFile(file, at: nil)
        
        // 6: start the engine and player
        try engine.start()
        audioPlayer.play()
    }
    
    
    
    
    func playBPM(_ url: URL) throws {
        // 1: load the file
        let file = try AVAudioFile(forReading: url)

        // 2: create the audio player
        let audioPlayer = AVAudioPlayerNode()

        // 3: connect the components to our playback engine
        engineBPM.attach(audioPlayer)
        engineBPM.attach(pitchControlBPM)
        engineBPM.attach(speedControlBPM)
        
        // 4: arrange the parts so that output from one is input to another
        engineBPM.connect(audioPlayer, to: speedControlBPM, format: nil)
        engineBPM.connect(speedControlBPM, to: pitchControlBPM, format: nil)
        engineBPM.connect(pitchControlBPM, to: engineBPM.mainMixerNode, format: nil)

        // 5: prepare the player to play its file from the beginning
        audioPlayer.scheduleFile(file, at: nil)
        
        // 6: start the engine and player
        try engineBPM.start()
        audioPlayer.play()
    }

}

