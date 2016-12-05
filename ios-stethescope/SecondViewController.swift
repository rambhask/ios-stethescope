//
//  SecondViewController.swift
//  ios-stethescope
//
//  Created by Ram Bhaskar on 12/4/16.
//  Copyright © 2016 Ram Bhaskar. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var recordedFileList: Array<String>!
    @IBOutlet weak var RecordingListTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        recordedFileList = getRecordedFileList();
//        RecordingListTable.delegate = self
//        RecordingListTable.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recordedFileList = getRecordedFileList();
        RecordingListTable.delegate = self
        RecordingListTable.dataSource = self
        RecordingListTable.reloadData()
    }
    
    func getDocumentsDirectory() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print (documentsPath);
        return documentsPath;
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is AudioPlayerVC) {
            let ap = segue.destination as? AudioPlayerVC
            ap?.audioFile = sender as! String
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("lalal")
        return recordedFileList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = RecordingListTable.dequeueReusableCell(withIdentifier: "Cell")
        
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
            cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        }
        
        let workout = self.recordedFileList[indexPath.row]
        
        cell!.textLabel!.text = workout;
        //        cell!.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Row selected - play file
        let audioFile = self.recordedFileList[indexPath.row]
        print(audioFile)
//        let player = AudioPlayerVC(nibName: "AudioPlayerVC", bundle: nil)
//        player.audioFile = self.recordedFileList[indexPath.row]
//        
//        self.present(AudioPlayerVC, animated: true, completion: nil)
        //self.navigationController?.pushViewController(player, animated: true)
        
       self.performSegue(withIdentifier: "playAudio", sender: audioFile)
//        let player = AudioPlayerVC(nibName: "AudioPlayerVC", bundle: nil)
//        player.audioFile = (self.recordedFileList[indexPath.row] as? String)!
        
        print("something has been clicked fuckers")
        //print("Testing click", player.audioFile, " - ", indexPath.row)
        //self.navigationController?.pushViewController(player, animated: true)
    }


}

