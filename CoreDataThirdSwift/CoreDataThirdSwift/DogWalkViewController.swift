//
//  DogWalkViewController.swift
//  CoreDataThirdSwift
//
//  Created by songbiwen on 2017/2/20.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

import UIKit
import CoreData

class DogWalkViewController: UITableViewController {

    var context:NSManagedObjectContext! ;
    var currentDog:Dog! ;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData();
        self.tableView.reloadData();
    }
    
    func fetchData() {
        let dogName = "Sam";
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Dog");
        fetchRequest.predicate = NSPredicate(format: "name == %@", dogName);
        
        do {
            let result = try context.fetch(fetchRequest) as! [Dog];
            
            if result.count > 0 {
                currentDog = result[0];
            }else {
                
                let entity = NSEntityDescription.entity(forEntityName: "Dog", in: context);
                currentDog = Dog(entity: entity!, insertInto: context);
                currentDog.name = dogName;
                
                do {
                    try context.save();
                }catch let error as NSError {
                    print("失败... \(error),\(error.userInfo)");
                }

            }
            
        }catch let error as NSError {
            print("失败... \(error),\(error.userInfo)");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (currentDog.walks?.count)!;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell");
        
        let walks = currentDog.walks;
        let walk = walks![indexPath.row] as! Walk;
        let dateFormatter = DateFormatter();
        dateFormatter.dateStyle = .full;
        dateFormatter.locale = Locale(identifier: "zh_cn");
        
        cell?.textLabel?.text = dateFormatter.string(from: walk.time! as Date);
        return cell!;
    }

   
    @IBAction func addBarButtonItemAction(_ sender: UIBarButtonItem) {
        let entity = NSEntityDescription.entity(forEntityName: "Walk", in: context);
        let walk = Walk(entity: entity!, insertInto: context);
        walk.time = NSDate();
        
        let walks = currentDog.walks!.mutableCopy() as! NSMutableOrderedSet;
        walks.add(walk);
        
        currentDog.walks = walks.copy() as? NSOrderedSet;
        
        do {
            try context.save();
        }catch let error as NSError {
            print("失败... \(error),\(error.userInfo)");
        }
        
        let indexPath = IndexPath(row: walks.count - 1, section: 0);
        
        self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic);
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let walks = currentDog.walks;
            let walk = walks![indexPath.row] as! Walk;
            context.delete(walk);
            do {
                try context.save();
            }catch let error as NSError {
                print("失败... \(error),\(error.userInfo)");
            }
            
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic);
        }
    }
}
