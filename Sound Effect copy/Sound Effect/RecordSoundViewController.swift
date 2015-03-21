//
//  RecordSoundViewController.swift
//  Sound Effect
//
//  Created by Yerzhan Assanov on 3/21/15.
//  Copyright (c) 2015 EA. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordAudio: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    @IBOutlet weak var pauseRecordingButton: UIButton!
    
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    var recordingBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordingLabel.hidden = false
        recordingLabel.text = "Tap to record"
        stopRecordingButton.hidden = true
        pauseRecordingButton.hidden = true
        recordAudio.enabled = true
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.text = "recording..."
        stopRecordingButton.hidden = false
        pauseRecordingButton.hidden = false
        pauseRecordingButton.enabled = true
        recordAudio.enabled = false
        
        if(recordingBool == true) {
            audioRecorder.record()
        } else {
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            recordingBool = true
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            //TODO: Step 1 - Save the recorded video
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            
            //TODO: Step 2 - Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordAudio.enabled = true
            stopRecordingButton.hidden = true
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    @IBAction func stopRecordingButton(sender: UIButton) {
        recordingBool = false
        recordingLabel.hidden = true
        recordAudio.enabled = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseRecordingButton(sender: UIButton) {
        recordingLabel.text = "Tap to resume recording"
        recordAudio.enabled = true
        pauseRecordingButton.enabled = false
        
        audioRecorder.pause()
    }

}

