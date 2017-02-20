//
//  BowtieViewController.swift
//  CoreDataSecondSwift
//
//  Created by songbiwen on 2017/2/17.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

import UIKit
import CoreData;

class BowtieViewController: UIViewController {

    var managedObjectContext:NSManagedObjectContext!;
    //当前的领带
    var currentBowtie = BowTie();
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var bowtieImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var wearCountLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate;
        managedObjectContext = appdelegate.persistentContainer.viewContext;
        
        //保存数据
        savaData();
        
        updateUI(sender: self.segmentedControl.titleForSegment(at: 0)!);
        
    }

    

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        updateUI(sender: sender.titleForSegment(at: sender.selectedSegmentIndex)!);
    }
    
    @IBAction func wearButtonAction(_ sender: UIButton) {
    }
    
    //评分
    @IBAction func rateButtonAction(_ sender: UIButton) {
        let alertController = UIAlertController(title: "新评分", message: "请输入评分", preferredStyle: UIAlertControllerStyle.alert);
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil);
        let saveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.default) { (action) in
            let textField:UITextField = alertController.textFields![0];
            if let valueForTextField = Int(textField.text!) {
                if valueForTextField <= 5 && valueForTextField >= 0 {
                    self.currentBowtie.rating = Int16(valueForTextField);
                    self.scoreLabel.text = "当前评分：\(self.currentBowtie.rating)/5";
                    
                    do {
                        try self.managedObjectContext.save();
                    }catch let error as NSError {
                        print("failed for \(error),\(error.userInfo)")
                    }

                    
                }else {
                    print("输入数据只能不大于5，不小于0");
                }
            }else {
                print("输入数据类型不为数字");
            }
        }
        
        alertController.addAction(cancelAction);
        alertController.addAction(saveAction);
        alertController.addTextField { (textField) in
            textField.placeholder = "请输入您的评分";
            //设置textField的输入类型为数字
            textField.keyboardType = UIKeyboardType.numberPad;
        }
        
        self.present(alertController, animated: true, completion: nil);
        
    }
    
   
    //保存数据
    func savaData() {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BowTie");
        
        do {
            
            let count = try managedObjectContext.count(for: fetchRequest);
            
            if count > 0 {
                return;
            }
            
            //获取本地文件
            let path = Bundle.main.path(forResource: "SampleData", ofType: "plist");
            let dataArray = NSArray(contentsOfFile: path!);
            for var dict in dataArray! {
                
                var bowtieInfo = dict as! Dictionary<String, Any>;
                
                let entity = NSEntityDescription.entity(forEntityName: "BowTie", in: managedObjectContext);
                let bowtie = BowTie(entity: entity!, insertInto: managedObjectContext);
                bowtie.name = bowtieInfo["name"] as? String;
                bowtie.searchKey = bowtieInfo["searchKey"] as? String;
                bowtie.rating = (bowtieInfo["rating"] as? Int16)!;
                bowtie.tintcolor = (colorTransform(colorInfo: bowtieInfo["tintColor"] as! Dictionary<String, Double>) as AnyObject) as? NSObject;
                
                let photo = UIImage(named: bowtieInfo["imageName"] as! String);
                bowtie.photoData = UIImagePNGRepresentation(photo!) as NSData?;
                
                bowtie.lastWorn = bowtieInfo["lastWorn"] as! NSDate?;
                bowtie.timesWorn = bowtieInfo["timesWorn"] as! Int32;
                bowtie.isFavorite = bowtieInfo["isFavorite"] as! Bool;
                
                do {
                    try managedObjectContext.save();
                }catch let error as NSError {
                    print("failed for \(error),\(error.userInfo)")
                }
                
            }
            
        }catch let error as NSError {
            print("failed for \(error),\(error.userInfo)")
        }
        
    }
    
    
    func colorTransform(colorInfo: Dictionary<String,Double>) -> UIColor {
        return UIColor(colorLiteralRed: Float(colorInfo["red"]!)/255.0, green: Float(colorInfo["green"]!)/255.0, blue: Float(colorInfo["blue"]!)/255.0, alpha: 1.0);
    }
    
    
    //更新界面数据
    func updateUI(sender:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BowTie");
        let predicate = NSPredicate(format: "searchKey == %@", sender);
        fetchRequest.predicate = predicate;
        do {
            let result = try managedObjectContext.fetch(fetchRequest) as! [BowTie];
            if result.count > 0 {
                let bowtie = result[0];
                
                currentBowtie = bowtie;
                
                self.bowtieImageView.image = UIImage(data:bowtie.photoData! as Data);
                self.nameLabel.text = bowtie.name!;
                self.scoreLabel.text = "当前评分：\(bowtie.rating)/5";
                self.wearCountLabel.text = "戴了\(bowtie.timesWorn)次";
                
                
                let dateFormatter = DateFormatter();
                dateFormatter.dateStyle = .short;
                dateFormatter.timeStyle = .none;
                
                self.timeLabel.text = dateFormatter.string(from: bowtie.lastWorn as! Date);
                
                self.view.tintColor = bowtie.tintcolor as! UIColor!;
            }
            
        }catch let error as NSError {
            print("failed for error \(error),\(error.userInfo)");
        }
        
    }
}
