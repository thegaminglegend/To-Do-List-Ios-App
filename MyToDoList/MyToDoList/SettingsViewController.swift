//
//  SettingsViewController.swift
//  MyToDoList
//  Author: Mengen Zhao
//  Date: 4/11/23
//  Professor: Dr. O
//  Class: CIT 352
//  Description: This is a to do list app that stores user's list of things to do and display each instances
//  This class has controls for the settings scene
//

//Imports
import UIKit

class SettingsViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{

    //Instance Variables
    let sortByFields: [String] = ["Due Date", "Task Name", "Priority"]
    let userPreferences = UserDefaults.standard
    @IBOutlet weak var pckSortItem: UIPickerView!
    @IBOutlet weak var sgmtSortDir: UISegmentedControl!
    @IBOutlet weak var swTaskCompleted: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Establish Connection of pickerView
        pckSortItem.delegate = self
        pckSortItem.dataSource = self
                
        //retrieve and set preferences
        let sortPref: String = userPreferences.string(forKey: "SortField")!
        let sortPrefIndex = sortByFields.firstIndex(of: sortPref)!
        pckSortItem.selectRow(sortPrefIndex, inComponent:0, animated: false)
        let sortDirPref: String = userPreferences.string(forKey: "SortDirection")!
        if sortDirPref == "ASC" {
            sgmtSortDir.selectedSegmentIndex = 0
        }
        else {
            sgmtSortDir.selectedSegmentIndex = 1
        }
        
        let showCompletedTaskPref: Bool = userPreferences.bool(forKey: "TaskCompleted")
        swTaskCompleted.isOn = showCompletedTaskPref

    }
    
    //Function for sgmt to change sort order
    @IBAction func sgmtSortDirChanged(_ sender: UISegmentedControl) {
        //If the segmented control is changed, new preference value is stored to preferences
        if sgmtSortDir.selectedSegmentIndex == 0 {
            userPreferences.set("ASC", forKey: "SortDirection")
        } else {
            userPreferences.set("DESC", forKey: "SortDirection")
        }
        userPreferences.synchronize()
        //NSLog("SOrt data: %@", String(describing: userPreferences.string(forKey: "SortDirection")))
    }
    
    //Function for switch to set to show completed tasks
    @IBAction func swShowCompletedTasks(_ sender: UISwitch) {
        //if the switch is switched, new preference value is stored to preferences
        userPreferences.set(swTaskCompleted.isOn, forKey: "TaskCompleted")
        userPreferences.synchronize()
        //NSLog("Sort data: %@", swTaskCompleted.isOn.description)
    }
    
    
    
    //Specify there is one component for the pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Specify the number of elements to be loaded into the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortByFields.count
    }
    
    //Load the pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortByFields[row]
    }
    
    //retrieve the pickerView row number selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //if the picker is used, new preference value is stored to preferences
        userPreferences.set(sortByFields[row], forKey: "SortField")
        userPreferences.synchronize()
        //NSLog("Sort item selected: %@", sortByFields[row])
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
