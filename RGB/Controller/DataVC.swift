//
//  DataVC.swift
//  RGB
//
//  Created by Brenno Ribeiro on 11/14/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import UIKit
import CoreData

class DataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // IB Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var clearDataBtn: RoundedShadowButton!
    @IBOutlet weak var uploadDataBtn: RoundedShadowButton!
    
    var dateArray: [Date] = []
    var locationArray: [String] = []
    var chemicalArray: [String] = []
    var concentrationArray: [Int] = []
    var temperatureArray: [String] = []
    var humidityArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RGB_Data")
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    dateArray.insert(result.value(forKey: "date") as! Date, at: 0)
                    locationArray.insert(result.value(forKey: "location") as! String, at: 0)
                    chemicalArray.insert(result.value(forKey: "chemical") as! String, at: 0)
                    concentrationArray.insert(result.value(forKey: "concentration") as! Int, at: 0)
                    temperatureArray.insert(result.value(forKey: "temperature") as! String, at: 0)
                    humidityArray.insert(result.value(forKey: "humidity") as! String, at: 0)
                }
            }
        } catch {
            // process error
        }
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateArray.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 90
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as? dataCell {
            let date = dateArray[indexPath.row]
            let location = locationArray[indexPath.row]
            let chemical = chemicalArray[indexPath.row]
            let concentration = concentrationArray[indexPath.row]
            let temperature = temperatureArray[indexPath.row]
            let humidity = humidityArray[indexPath.row]
            let data = RGBData(date: date, location: location, chemical: chemical, concentration: concentration, temperature: temperature, humidity: humidity)
            cell.updateData(data: data)
            return cell
        } else {
            return dataCell()
        }
    }
    
    @IBAction func clearDataBtnWasPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to clear all data?", message: "", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            self.clearData()
        })
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func uploadDataBtnWasPressed(_ sender: Any) {
    }
    
    func clearData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "RGB_Data")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            dateArray.removeAll()
            locationArray.removeAll()
            chemicalArray.removeAll()
            concentrationArray.removeAll()
            temperatureArray.removeAll()
            humidityArray.removeAll()
            tableView.reloadData()
        } catch {
            print ("There was an error")
        }
    }

}
