//
//  ToDoItemTableViewController.swift
//  MyToDoList
//  Author: Mengen Zhao
//  Date: 4/27/23.
//  Professor: Dr. O
//  Class: CIT 352
//  Description: This is a to do list app that stores user's list of things to do and display each instances
//  This class has controls for ToDoItemTableView
//

//Imports
import UIKit
import CoreData

class ToDoItemTableViewController: UITableViewController {
    
    //an array of ToDoItems
    var toDoItems: [ToDoItem]?
    //variable for core data
    let appDelegate = UIApplication.shared.delegate as? AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }
    
    //Function to reload the screen with the saved data
      override func viewWillAppear(_ animated: Bool) {
          self.loadDataFromCoreData()
          self.tableView.reloadData()
      }

    // MARK: - Table view data source
    
    //Function to load data from core data
    func loadDataFromCoreData() {
        //Instance Variable
        var sortColumn: String
        var sortDirASC: Bool
        
        //retrieve user preferences
        let userPreferences = UserDefaults.standard
        
        //extract sort field preference and specify associated core data variable
        let sortPref: String = userPreferences.string(forKey: "SortField")!
        //Set sort in DB accordingly
        if sortPref == "Task Name" {
            sortColumn = "taskName"
        }
        else if sortPref == "Due Date" {
            sortColumn = "dueDate"
        }
        else {
            sortColumn = "taskPriority"
        }
        
        //extract sort direction, set boolean variable for later use
        let sortDirPref: String = userPreferences.string(forKey: "SortDirection")!
        //Set sort in DB accordingly
        if sortDirPref == "ASC" {
            sortDirASC = true
        }
        else {
            sortDirASC = false
        }
        
        //extract show or not show completed task preference, set boolean variable for later use
        let showCompletedTaskPref: Bool = userPreferences.bool(forKey: "TaskCompleted")
        
        //set up context for core data
        let context = appDelegate?.persistentContainer.viewContext
        
        //build and make core data fetch request
        let request = NSFetchRequest<NSManagedObject>(entityName:"ToDoItem")
        let listItemEntity = NSEntityDescription.entity(forEntityName: "ToDoItem", in: context!)
        request.entity = listItemEntity
        
        //Set the sort preferences
        let sortDescriptor = NSSortDescriptor(key: sortColumn, ascending: sortDirASC)
        request.sortDescriptors = [sortDescriptor]
        
        //Check what is preference for completed taks preferences
        if !showCompletedTaskPref {
            let taskCompletedPredicate = NSPredicate(format:"taskComplete == false")
            request.predicate = taskCompletedPredicate
        }
        do {
            toDoItems = try context?.fetch(request) as! [ToDoItem]?
        } catch {
            print("Error in executeFetchRequest: \(error)")
        }
    }
    
    //Function to get the number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        //return the number of sections
        return 1
    }

    //Funciton to get the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #return the number of rows
        return toDoItems!.count
    }
    
    //Function to populate the cell with the stored information
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //create a ToDoItemTableViewCell
        let cell: ToDoItemTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) as! ToDoItemTableViewCell
        
        //add the disclosure indicator
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        
        //retrieve relavent variables from a toDoItem and load them into the cell
        cell.taskName.text = toDoItems![indexPath.row].taskName
        
        //Get and set the date
        let dateFormatter:DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString: String = dateFormatter.string(from: toDoItems![indexPath.row].dueDate! as Date)
        cell.taskDueDate.text = dateString
        
        var priorityString : String
        
        //Get and set the priority
        switch toDoItems![indexPath.row].taskPriority {
        case 0:
            priorityString = "Low"
        case 1:
            priorityString = "Medium"
        case 2:
            priorityString = "High"
        default:
            priorityString = "Meh"
        }
        
        cell.taskPriority.text = priorityString
        
        //Show or hide the check mark for task completed
        if toDoItems![indexPath.row].taskComplete == true {
            cell.imgCheckMark.isHidden = false
        }
        else {
            cell.imgCheckMark.isHidden = true
        }
        
        return cell
    }

    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

         Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //Check if is in delete mode
        if editingStyle == .delete {
            // Delete the row from the data source
            let toDoItem = toDoItems![indexPath.row] as ToDoItem
            //set up context for core data
            let context = appDelegate?.persistentContainer.viewContext
            //Delete the object from the database
            context!.delete(toDoItem)
            do {
                try context!.save()
            }
            catch {
                fatalError("Error saving context: \(error)")
            }
            //Refresh and reload the view
            loadDataFromCoreData()
            //Remove the row from the table
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array,
            //and add a new row to the table view
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         //Get the new view controller using segue.destination.
         //Pass the selected object to the new view controller.
        
        //segue for item edit
        //transfer data to the todoitemview in that instance
        if(segue.identifier == "editToDoItem") {
            //Get the destination
            let destination: ToDoItemViewController = segue.destination as! ToDoItemViewController
            let selectedPath : IndexPath  = self.tableView.indexPathForSelectedRow!
            
            //get the item to edit and set destination variable to it
            let toDoItem : ToDoItem = toDoItems![selectedPath.row]
            destination.listItem = toDoItem
        }
    }
}
