//
//  PlaySoundViewController.swift
//  ios-stethescope
//
//  Created by Ram Bhaskar on 12/4/16.
//  Copyright © 2016 Ram Bhaskar. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerVC: UIViewController {
    
    var audioFile = "";
    var player:AVPlayer!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var filename: UITextField!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Audio Player"
        self.navigationItem.hidesBackButton = false
        self.navigationItem.title = "Play Recording"
        let barButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(deleteAudio(_:)))
        self.navigationItem.setRightBarButton(barButton, animated: true)
        self.navigationItem.backBarButtonItem?.title = "Back"
        //self.navigationItem.rightBarButtonItem?.title = "Save"
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(audioFile)
        filename.text = audioFile
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        player = nil
    }
    
    
    func getURLForFile( fileName: String) -> URL {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let soundFileURL = documentsDirectory.appendingPathComponent(fileName)
        return soundFileURL as URL;
    }
    
    @IBAction func playAudio(_ sender: Any) {
        print(audioFile)
        let url = self.getURLForFile(fileName: audioFile)
        //        let url = NSURL(string: audioFile)
        
        print("playing \(url)")
        
        //           let playerItem = AVPlayerItem( URL:NSURL( string:audioFile )! )
        let playerItem = AVPlayerItem(url: url as URL)
        player = AVPlayer(playerItem:playerItem)
        player.rate = 1.0;
        player.play()
    }
    
    @IBAction func saveAudioChanges(_ sender: Any) {
    }

    func deleteAudio(_ sender: Any) {
        //TODO: delete recording and go back to previous page
        
    }
    
    
    
}

