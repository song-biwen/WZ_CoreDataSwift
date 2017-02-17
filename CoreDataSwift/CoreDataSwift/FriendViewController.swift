//
//  FriendViewController.swift
//  CoreDataSwift
//
//  Created by songbiwen on 2017/2/16.
//  Copyright © 2017年 songbiwen. All rights reserved.
//

import UIKit
import CoreData;

class FriendViewController: UITableViewController {

    
    var people = Array<NSManagedObject>();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取数据
        fetchData();
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
        return people.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell");
        
        let person:NSManagedObject = people[indexPath.row];
        let name:String = person.value(forKey: "name") as! String;
        cell?.textLabel?.text = name;
        return cell!;
    }
    

    //添加姓名
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: "请输入您的好友姓名", preferredStyle: UIAlertControllerStyle.alert);
        let saveAction = UIAlertAction(title: "保存", style: UIAlertActionStyle.default) { (action) in
            let textField:UITextField = alertController.textFields![0]
            
            //将内容创建一个表，请求添加到coredata中
            self.saveName(name: textField.text!);
            let indexPath:IndexPath = IndexPath(row: self.people.count - 1, section: 0);
            self.tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil);
        
        alertController.addAction(cancelAction);
        alertController.addAction(saveAction);
        alertController.addTextField { (textField) in
            textField.textColor = UIColor.red;
        }
        
        self.present(alertController, animated: true, completion: nil);
        
    }

    
    func saveName(name:String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext;
        let entity = NSEntityDescription.entity(forEntityName:"Person", in: managedObjectContext);
        let person = NSManagedObject(entity: entity!, insertInto: managedObjectContext);
        person.setValue(name, forKey: "name");
        
        //存储
        do {
            try managedObjectContext.save();
        }catch {
            
        }
        people.append(person);
    }
    
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        let managedObjectContext = appDelegate.persistentContainer.viewContext;
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person");
        
        do {
            
            let result = try managedObjectContext.fetch(fetchRequest);
            
            people = result as! Array<NSManagedObject>;
            
            if people.count > 0 {
                self.tableView.reloadData();
            }
            
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        
    }
}
