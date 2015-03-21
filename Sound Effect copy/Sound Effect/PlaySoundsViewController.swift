//
//  PlaySoundsViewController.swift
//  Sound Effect
//
//  Created by Yerzhan Assanov on 3/21/15.
//  Copyright (c) 2015 EA. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var recievedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    var inputNode: AVAudioInputNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer  = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
        
        //This piece of code sets the sound to always play on the Speakers
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var player : AVAudioPlayer! = nil
    
    @IBAction func playAudioSlowButton(sender: UIButton) {
        playAudioWithSpeed(0.5)
    }
    
    @IBAction func playAudioFastButton(sender: UIButton) {
        playAudioWithSpeed(1.5)
    }
    
    func playAudioWithSpeed(speed: Float) {
        stopPlayAudio()
        
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = speed
        audioPlayer.play()
    }
    
    @IBAction func stopPlayAudioButton(sender: UIButton) {
        stopPlayAudio()
    }

    @IBAction func playAudioChipmunkButton(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    
    @IBAction func playAudioDarthVaderButton(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        engineConnectAndPlay(changePitchEffect)
    }
    
    
    @IBAction func playAudioReverbButton(sender: UIButton) {
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.wetDryMix = 100
        
        engineConnectAndPlay(reverbEffect)
    }
    
    @IBAction func playAudioEchoButton(sender: UIButton) {
        var echoEffect = AVAudioUnitDelay()
        echoEffect.delayTime = 0.2
        echoEffect.feedback = 80
        echoEffect.wetDryMix = 100
        
        engineConnectAndPlay(echoEffect)
    }
    
    func engineConnectAndPlay(effect: AVAudioUnit) {
        stopPlayAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(effect)
        
        audioEngine.connect(audioPlayerNode, to: effect, format: nil)
        audioEngine.connect(effect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    func stopPlayAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
