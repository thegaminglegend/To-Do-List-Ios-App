//
//  ToDoItemViewController.swift
//  MyToDoList
//  Author: Mengen Zhao
//  Date: 4/18/23.
//  Professor: Dr. O
//  Class: CIT 352
//  Description: This is a to do list app that stores user's list of things to do and display each instances
//  This class controls the toDoItemView

//Imports
import UIKit
import CoreData

class ToDoItemViewController: UIViewController, DueDateViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Delegate for DueDateViewController
    //Funciton to change the dueDate with correct format
    func dateChanged(_ dueDate: Date) {
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM/dd/yyyy"
        lblDueDate.text = dateFormatter.string(from: dueDate)
        itemDueDate = dueDate
    }
    
    // Instance Variables
    var itemDueDate: Date?
    //Priority picker values
    let pickerData: [String] = ["Low", "Medium", "High"]
    //list item variable
    var listItem: ToDoItem?
    //delegate variable for Core Data
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    //Reference Variables
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    @IBOutlet weak var swTaskComplete: UISwitch!

    @IBOutlet weak var btnDueDate: UIButton!
    @IBOutlet weak var lblDueDate: UILabel!
    @IBOutlet weak var pckPriority: UIPickerView!
    @IBOutlet weak var txtTaskDesc: UITextView!
    @IBOutlet weak var txtTaskName: UITextField!
    
    @IBOutlet weak var btnSave: UIBarButtonItem!
    
    
    //Function to change edit mode
    @IBAction func ChangeEditMode(_ sender: Any) {
        //depending on the selection made in segmented control, set fields for edit/view
        if sgmtEditMode.selectedSegmentIndex == 0 {
            txtTaskName.isUserInteractionEnabled = false
            txtTaskName.borderStyle = UITextField.BorderStyle.none
            txtTaskDesc.isUserInteractionEnabled = false
            pckPriority.isUserInteractionEnabled = false
            btnDueDate.isHidden = true
            swTaskComplete.isUserInteractionEnabled = false
            btnSave.isEnabled = false
        }
        else {
            txtTaskName.isUserInteractionEnabled = true
            txtTaskName.borderStyle = UITextField.BorderStyle.roundedRect
            txtTaskDesc.isUserInteractionEnabled = true
            pckPriority.isUserInteractionEnabled = true
            btnDueDate.isHidden = false
            swTaskComplete.isUserInteractionEnabled = true
            btnSave.isEnabled = true
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pckPriority.delegate = self
        pckPriority.dataSource = self
        
        //Check if there is item in item list
        if listItem != nil {
            //If there is populate the view with the data transfered
            sgmtEditMode.selectedSegmentIndex = 0
            txtTaskName.text = listItem!.taskName
            txtTaskDesc.text = listItem?.taskDesc
            let itemPriority: Int = Int(listItem!.taskPriority)
            pckPriority.selectRow(itemPriority, inComponent:0, animated: false)
            let dateFormatter:DateFormatter = DateFormatter();
            dateFormatter.dateFormat = "MM/dd/yyyy"
            lblDueDate.text = dateFormatter.string(from: listItem!.dueDate! as Date)
            itemDueDate = listItem!.dueDate as Date?
            swTaskComplete.setOn(listItem!.taskComplete, animated: false)
        } else {
            //if there is not one initialize date as today's date and initialize the buttons
            //NSLog("no list item received")
            sgmtEditMode.selectedSegmentIndex = 1
            let dateFormatter:DateFormatter = DateFormatter();
            dateFormatter.dateFormat = "MM/dd/yyyy"
            itemDueDate = Date()
            lblDueDate.text = dateFormatter.string(from: itemDueDate!)
            swTaskComplete.setOn(false, animated: false)
        }
        ChangeEditMode(self)
    }
    
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if the segue is to the date picker, pass date to DueDateViewController
        if(segue.identifier == "segueDueDate") {
            //set destination to be Due Date Scence and get the date
            let destination = segue.destination as! DueDateViewController
            
            //Convert date string to Date object
            let dateFormatter:DateFormatter = DateFormatter();
            //Set date format and set the date as the default date
            dateFormatter.dateFormat = "MM/dd/yyyy"
            itemDueDate = dateFormatter.date(from: lblDueDate.text!)
            destination.dueDate = itemDueDate
            //Let destination know who is calling it
            destination.delegate = self
        }
    }
    
    //Specify there is one component for the pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Specify the number of elements to be loaded into the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //Load the pickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    //retrieve the pickerView row number selected
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // NSLog("Priority selected: %@", pickerData[row])
    }
    
    //Function to save the information to DB
    @IBAction func saveItem(_ sender: Any) {
        //NSLog("In saveItem")
        //set up for save to core data
        let context = appDelegate?.persistentContainer.viewContext
        
        //if no item was passed in, a new one needs to be created
        if listItem == nil {
            listItem = ToDoItem(context: context!)
        }
        
        //item's values must be updated
        listItem!.taskName = txtTaskName.text
        listItem!.taskDesc = txtTaskDesc.text
        listItem!.taskPriority = Int16(pckPriority.selectedRow(inComponent: 0))
        listItem!.taskComplete = swTaskComplete.isOn
        listItem!.dueDate = itemDueDate as Date?
        
        //save to core data
        appDelegate?.saveContext()
        
        //set up to return to View Mode
        sgmtEditMode.selectedSegmentIndex = 0
        ChangeEditMode(self)
    }
    
}

