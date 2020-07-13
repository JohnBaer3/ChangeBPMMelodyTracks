//
//  ViewController.swift
//  AudioManipMelodyTracks
//
//  Created by John Baer on 7/12/20.
//  Copyright © 2020 John Baer. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    let engine = AVAudioEngine()
    let speedControl = AVAudioUnitVarispeed()
    let pitchControl = AVAudioUnitTimePitch()
    var bpm: Float = 120
    var lastTap: Date? = nil

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func clickChangePitch(_ sender: Any) {
        //1.5 is a good amount to subtract BPM by
        pitchControl.pitch -= 154
        speedControl.rate += 0.1
        
        label.text = String(speedControl.rate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = String(speedControl.rate)
        
        let url = Bundle.main.url(forResource: "Misery", withExtension: ".mp3")
        do{
            try play(url!)}
        catch{}
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

}

