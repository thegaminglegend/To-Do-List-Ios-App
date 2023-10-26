//
//  DueDateViewController.swift
//  MyToDoList
//  Author: Mengen Zhao
//  Date: 4/13/23.
//  Professor: Dr. O
//  Class: CIT 352
//  Description: This is a to do list app that stores user's list of things to do and display each instances
//  This class has controls for the Due date scene
//

//Imports
import UIKit

// Declared in this class but used in anohter class
protocol DueDateViewDelegate {
    func dateChanged(_ dueDate: Date)
}

class DueDateViewController: UIViewController {

    //Instance Variables
    var dueDate: Date?
    var delegate: DueDateViewDelegate! = nil

    //Reference Variable
    @IBOutlet weak var pckDueDate: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set date picker to date value sent from calling view
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM/dd/yyyy"
        //NSLog("Current due date is " + dateFormatter.string(from: dueDate!), pckDueDate.setDate(dueDate!, animated: false))
        
        
    }
    
    //Function to pass the new date back to To Do item Scene when save is clicked
    @IBAction func btnSave(_ sender: Any) {
        delegate.dateChanged(pckDueDate.date)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if(segue.identifier == "segueDueDate") {
            
        }
    }*/
    

}
