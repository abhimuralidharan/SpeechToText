//
//  ViewController.swift
//  SpeechToText
//
//  Created by Abhilash on 31/03/17.
//  Copyright © 2017 Abhilash. All rights reserved.
//

import UIKit
import Speech
import AVFoundation
import QuartzCore
class ViewController: UIViewController, AVAudioPlayerDelegate {
    
   @IBOutlet weak var recordButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var transcriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activitySpinner.isHidden = true
        recordButton.layer.cornerRadius = 5
    }
    
    @IBAction func playBtnIsPressed(_ sender: AnyObject) {
        activitySpinner.isHidden = false
        activitySpinner.startAnimating()
        requestSpeechAuth()
        transcriptionTextField.text = ""
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        player.stop()

    }
    
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                if let path = Bundle.main.url(forResource: "test2", withExtension: "mp3") {
                    do {
                        let sound = try AVAudioPlayer(contentsOf: path)
                        self.audioPlayer = sound
                        self.audioPlayer.delegate = self
                        sound.play()
                    } catch {
                        print("Error!")
                    }
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: path)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        if let error = error {
                            print("There was an error: \(error)")
                        } else {
                            self.transcriptionTextField.text = result?.bestTranscription.formattedString
                            if (result?.isFinal)! {
                                self.activitySpinner.stopAnimating()
                                self.activitySpinner.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }
}
