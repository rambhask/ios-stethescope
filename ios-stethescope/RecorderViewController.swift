//
//  FirstViewController.swift
//  ios-stethescope
//
//  Created by Ram Bhaskar on 12/4/16.
//  Copyright © 2016 Ram Bhaskar. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderVC: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var recordedFileList: Array<String>!
    
    var audioRecorder: AVAudioRecorder!
    
    var meterTimer:Timer!
    @IBOutlet weak var statusLabel: UILabel!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordedFileList = getRecordedFileList();
        print(recordedFileList);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startRecording(_ sender: Any) {
        print("Audio Recording started")
        recordButton.isEnabled = false
        
        stopRecordingButton.isEnabled = true;
        
        if audioRecorder == nil {
            print("recording. recorder nil")
            recordWithPermission(setup: true)
        } else {
            recordWithPermission(setup: true)
        }
    }

    @IBAction func stopRecording(_ sender: Any) {
        print("Audio Recording finished")
        recordButton.setTitle("Start Recording", for: .normal)
        recordButton.isEnabled = true
        
        stopRecordingButton.isEnabled = false;
        
        
        audioRecorder?.stop()
        
        meterTimer.invalidate()
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
        
        recordedFileList = getRecordedFileList()
       // RecordingListTable.reloadData()
    }
    
    
    

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        print("finished recording \(flag)")
        
        // iOS8 and later
        let alert = UIAlertController(title: "Recorder",
                                      message: "Finished Recording",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Keep", style: .default, handler: {action in
            print("keep was tapped")
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: {action in
            print("delete was tapped")
            self.audioRecorder.deleteRecording()
            
            self.recordedFileList = self.getRecordedFileList()
            //self.RecordingListTable.reloadData()
        }))
        self.present(alert, animated:true, completion:nil)
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder,
                                          error: Error?) {
        
        if let e = error {
            print("\(e.localizedDescription)")
        }
    }
    
    func setupRecorder() {
        
        let soundFileURL = getDestinationFileURL()
        
        
        let recordSettings:[String : AnyObject] = [
            AVFormatIDKey: NSNumber(value:kAudioFormatAppleLossless),
            AVEncoderAudioQualityKey : AVAudioQuality.max.rawValue as AnyObject,
            AVEncoderBitRateKey : 320000 as AnyObject,
            AVNumberOfChannelsKey: 2 as AnyObject,
            AVSampleRateKey : 44100.0 as AnyObject
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: soundFileURL as URL, settings: recordSettings)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch let error as NSError {
            audioRecorder = nil
            print(error.localizedDescription)
        }
        
    }
    
    func updateAudioMeter(timer:Timer) {
        
        if audioRecorder.isRecording {
            let min = Int(audioRecorder.currentTime / 60)
            let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            audioRecorder.updateMeters()
            // if you want to draw some graphics...
            //var apc0 = recorder.averagePowerForChannel(0)
            //var peak0 = recorder.peakPowerForChannel(0)
        }
    }
    
    func recordWithPermission(setup : Bool) {
        
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                    print("Permission to record granted")
                    if setup {
                        self.setupRecorder()
                    }
                    self.audioRecorder.record()
                    self.meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                                             target:self,
                                                                             selector:#selector(self.updateAudioMeter(timer:)),
                                                                             userInfo:nil,
                                                                             repeats:true)
                } else {
                    print("Permission to record not granted")
                }
            })
        }

    
    // MARK:  Utility functions

    func getDocumentsDirectory() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print (documentsPath);
        return documentsPath;
    }
    
    func getDestinationFileURL() -> NSURL {
        let format = DateFormatter()
        format.dateFormat="yyyy-MM-dd-HH-mm-ss"
        
        let fileName = "recording-\(format.string(from: NSDate() as Date)).m4a"
        
        print("Unique Filename : " + fileName);
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let soundFileURL = documentsDirectory.appendingPathComponent(fileName)
        
        return soundFileURL as NSURL
    }

    func getRecordedFileList() -> Array<String> {
        var filelist = [String]()
        
        let filemanager:FileManager = FileManager()
        
        let files = filemanager.enumerator(atPath: getDocumentsDirectory())
        while let file = files?.nextObject() {
            print("=> ", file)
            filelist.append(file as! String);
        }
        
        if filelist.count == 0 {
            filelist.append("No Recordings present")
        }
        return filelist
    }
    
}

