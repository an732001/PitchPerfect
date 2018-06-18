//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ansh Nanda on 12/06/18.
//  Copyright © 2018 Ansh Nanda. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    //MARK: View methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Configures UI State ready to take recording
        configureUIState(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    //MARK: Button actions (record and stop)
    @IBAction func recordAudio(_ sender: Any) {
        configureUIState(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath!)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUIState(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    
    //MARK: Helper Functions
    //Checks to see if the recording is over to transition to next ViewController
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("Recording was not successful")
        }
    }
    
    
    //Makes sure UI state is correct and correct buttons are enabled
    func configureUIState (_ isRecording: Bool){
        stopRecordingButton.isEnabled = isRecording
        recordButton.isEnabled = !isRecording
        if isRecording{
            recordingLabel.text = "Recording in Progress"
        }
        else {
            recordingLabel.text = "Tap to Record"
        }
    }
    //Makes sure segue to next screen happens after recording has stopped
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
        
    
        
    }
    
}

