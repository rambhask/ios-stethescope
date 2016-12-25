//
//  ProfileViewController.swift
//  ios-stethescope
//
//  Created by Ram Bhaskar on 12/5/16.
//  Copyright © 2016 Ram Bhaskar. All rights reserved.
//

import Foundation
import UIKit
import EZAudio

class ProfileViewController: UIViewController, EZMicrophoneDelegate, EZAudioFFTDelegate {
    var audioPlotTime: EZAudioPlot!
    var maxFrequencyLabel: UILabel!
    var audioPlotFreq: EZAudioPlot!
    var microphone: EZMicrophone!
    var fft: EZAudioFFTRolling!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Profile"
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory("", mode: AVAudioSessionCategoryPlayAndRecord)
        }
        catch {
            print("blah")
        }
        do {
            try session.setActive(true)
        } catch {
            print("blah")
        }
        
        //
        // Setup time domain audio plot
        //
        
        self.audioPlotTime.plotType = EZPlotType.buffer
        self.maxFrequencyLabel.numberOfLines = 0
        
        //
        // Setup frequency domain audio plot
        //
        self.audioPlotFreq.shouldFill = true
        self.audioPlotFreq.plotType = EZPlotType.buffer
        self.audioPlotFreq.shouldCenterYAxis = false
        
        //
        // Create an instance of the microphone and tell it to use this view controller instance as the delegate
        //
        self.microphone = EZMicrophone.init(microphoneDelegate: self)
        
        self.fft = EZAudioFFTRolling.fft(withWindowSize: 4096, historyBufferSize: 100, sampleRate: Float(self.microphone.audioStreamBasicDescription().mSampleRate), delegate: self)
        
        
        self.microphone.startFetchingAudio()
        
    }
    
    //EZMicrophoneDelegate
    
    func microphone(_ microphone: EZMicrophone!, hasAudioReceived buffer: UnsafeMutablePointer<UnsafeMutablePointer<Float>?>!, withBufferSize bufferSize: UInt32, withNumberOfChannels numberOfChannels: UInt32) {
        //
        // Calculate the FFT, will trigger EZAudioFFTDelegate
        //
        self.fft.computeFFT(withBuffer: buffer[0], withBufferSize: bufferSize)
        
        DispatchQueue.main.async {
            self.audioPlotTime.updateBuffer(buffer[0], withBufferSize: bufferSize)
        }
    }
    
    //EZAudioFFTDelegate
    
    func fft(_ fft: EZAudioFFT!, updatedWithFFTData fftData: UnsafeMutablePointer<Float>!, bufferSize: vDSP_Length) {
        let maxFrequency = fft.maxFrequency
        let noteName = EZAudioUtilities.noteNameString(forFrequency: maxFrequency, includeOctave: true)
        
        DispatchQueue.main.async {
            self.maxFrequencyLabel.text = String(format: "Highest Note: %@, \n Frequency: %.2f", noteName!, maxFrequency)
            self.audioPlotFreq.updateBuffer(fftData, withBufferSize: UInt32(bufferSize))
        }
        
    }
    
}
