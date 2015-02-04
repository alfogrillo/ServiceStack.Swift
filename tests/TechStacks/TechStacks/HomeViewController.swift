//
//  FirstViewController.swift
//  TechStacks
//
//  Created by Demis Bellot on 2/2/15.
//  Copyright (c) 2015 ServiceStack LLC. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    UIPickerViewDataSource, UIPickerViewDelegate
{
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var technologyPicker: UIPickerView!
    var selectedTechnology:TechnologyTier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.storyboard!.headerViewController().view)
        
        tblView.delegate = self
        tblView.dataSource = self
        technologyPicker.delegate = self
        technologyPicker.dataSource = self
        
        self.appData.observe(self, property: AppData.Property.TopTechnologies)
        self.appData.observe(self, property: AppData.Property.AllTiers)
        self.appData.loadOverview()
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        switch keyPath {
        case AppData.Property.AllTiers:
            self.technologyPicker.reloadAllComponents()
        case AppData.Property.TopTechnologies:
            self.tblView.reloadData()
        default: break
        }
    }
    deinit { self.appData.unobserve(self, property: AppData.Property.TopTechnologies) }
    
    var selectedTechnologies:[TechnologyInfo] {
        return selectedTechnology == nil
            ? appData.topTechnologies
            : appData.topTechnologies.filter { $0.tier! == self.selectedTechnology! }
    }

    /* PickerView */
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appData.allTiers.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return appData.allTiers[row].title
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedTechnology = appData.allTiers[row].value
        tblView.reloadData()
        println("You selected row #\(row)!")
    }
    
    /* TableView */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTechnologies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.tblView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
            ?? UITableViewCell()
        
        let tech = selectedTechnologies[indexPath.row]
        cell.textLabel?.text = "\(tech.name!) (\(tech.stacksCount!))"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
    }
}
