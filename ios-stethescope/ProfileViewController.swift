//
//  ProfileViewController.swift
//  ios-stethescope
//
//  Created by Ram Bhaskar on 12/5/16.
//  Copyright © 2016 Ram Bhaskar. All rights reserved.
//

import Foundation
import UIKit
import AudioKit

class ProfileViewController: UIViewController {

    
    @IBOutlet weak var startRecording: UIButton!
    @IBOutlet weak var stop: UIButton!
    
    let mic = AKMicrophone()
    var tracker : AKFrequencyTracker!
    var tape : AKAudioFile!
    var recorder : AKNodeRecorder!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        
        
        tracker = AKFrequencyTracker.init(mic, hopSize: 200, peakCount: 2000)
        let silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        
//        tape = try AKAudioFile()
//        
//        recorder = try AKNodeRecorder(node: mic, file: tape)
//        
//        try recorder.stop()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupPlot()
    }
    @IBOutlet weak var audioInputPlot: EZAudioPlot!
    
    func setupPlot() {
        let plot = AKNodeOutputPlot(mic, frame: audioInputPlot.bounds)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.blue
        audioInputPlot.addSubview(plot)
    }
    
    @IBAction func start(_ sender: Any) {
        AudioKit.start()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        AudioKit.stop()
    }
    
    
    func updateUI() {
        /*
        if tracker.amplitude > 0.1 {
            frequencyLabel.text = String(format: "%0.1f", tracker.frequency)
            
            var frequency = Float(tracker.frequency)
            while (frequency > Float(noteFrequencies[noteFrequencies.count-1])) {
                frequency = frequency / 2.0
            }
            while (frequency < Float(noteFrequencies[0])) {
                frequency = frequency * 2.0
            }
            
            var minDistance: Float = 10000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count {
                let distance = fabsf(Float(noteFrequencies[i]) - frequency)
                if (distance < minDistance){
                    index = i
                    minDistance = distance
                }
            }
            let octave = Int(log2f(Float(tracker.frequency) / frequency))
            noteNameWithSharpsLabel.text = "\(noteNamesWithSharps[index])\(octave)"
            noteNameWithFlatsLabel.text = "\(noteNamesWithFlats[index])\(octave)"
        }
        amplitudeLabel.text = String(format: "%0.2f", tracker.amplitude)
 */
    }
    
}
