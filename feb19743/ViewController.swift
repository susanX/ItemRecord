//
//  ViewController.swift
//  feb19743
//
//  Created by s gooding on 19/02/2016.
//  Copyright © 2016 susan.gooding. All rights reserved.
//

import UIKit
import CloudKit


class ViewController: UIViewController {

    
    @IBOutlet weak var tView: UITextView!
   
    @IBOutlet weak var tAdd: UITextField!
    
    @IBOutlet weak var tDelete: UITextField!
    
    var db:CKDatabase!
    var itemRecord:[CKRecord] = []
    
    @IBAction func didTapAdd(sender: AnyObject) {
                if tAdd.text == "" || tAdd.text == nil {
                    return
                }
        
        let itemRecord:CKRecord = CKRecord(recordType: "MyList")
        
        let audioPath = NSBundle.mainBundle().pathForResource("hello", ofType: "mp3")!
        let file: CKAsset? = CKAsset(fileURL: NSURL(fileURLWithPath: audioPath))
        
        itemRecord.setValue(file, forKey: "AudioFile")

        itemRecord.setObject(tAdd.text, forKey: "item")
        
        

        
        db.saveRecord(itemRecord) { (record:CKRecord?, error:NSError?) -> Void in
                    if error == nil {
                        print("record saved successfully!")
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.tAdd.text = ""
                        })
                    }
            
                }
        

    }
    class func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String]
        let documentsDirectory = paths[0]
        print(documentsDirectory)
        return documentsDirectory
        
    }
    
    class func getMp3URL() -> NSURL {
        let audioFilename = getDocumentsDirectory().stringByAppendingPathComponent("meet.m3a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        print(audioURL)
        return audioURL
    }
    
    @IBAction func didTapDelete(sender: AnyObject) {
        deleteRecord(tDelete.text!)
    }
    
    func deleteRecord(recordName:String){
        var recordToDelete:CKRecord?
        for record in itemRecord {
            let item:String = record.objectForKey("item") as! String
            if item == recordName {
                recordToDelete = record
            }
        }
        if recordToDelete == nil {
            return
    }
        db.deleteRecordWithID(recordToDelete!.recordID) { (rID:CKRecordID?, error:NSError?) -> Void in
            if error != nil {
                return
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tView.text = "(record deleted successfully)"
                self.tDelete.text = ""
            })
            func startRecroding(){
                let bb = ViewController.getDocumentsDirectory()
                //let aa = ViewController.getMp3URL()
                print(bb)
            }

        }
    }
    
    @IBAction func didTapRefresh(sender: AnyObject) {
        self.loadCloudData()
    }
    
    func loadCloudData(){
        let predicate:NSPredicate = NSPredicate(value: true)
        tView.text = "(fetching cloud data...)"
        let query:CKQuery = CKQuery(recordType: "MyList", predicate: predicate)
        db.performQuery(query, inZoneWithID: nil) { (records:[CKRecord]?, error:NSError?) -> Void in
            if error != nil || records == nil {
                return
            }
            self.itemRecord.removeAll()
            self.itemRecord = records!
            
            var aList:[String] = []
            for var i:Int = 0; i < records?.count; i++ {
                let record:CKRecord = records![i]
                aList.append(record.objectForKey("item") as! String)
            }
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.tView.text = aList.joinWithSeparator("\n")
            })
        }
           }
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        db = CKContainer.defaultContainer().publicCloudDatabase
        // 3 whistle
        
       
    }
    override func viewDidAppear(animated: Bool) {
       
       
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

