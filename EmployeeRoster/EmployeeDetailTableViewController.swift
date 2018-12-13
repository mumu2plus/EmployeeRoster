
import UIKit

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate,
EmployeeTypeDelegate {
    func didSelect(employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.text = employeeType.description()
        employeeTypeLabel.textColor = .black
    }
    

    struct PropertyKeys {
        static let unwindToListIndentifier = "UnwindToListSegue"
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dobLabel: UILabel!
    @IBOutlet weak var employeeTypeLabel: UILabel!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
    var employeeType: EmployeeType?
    var employee: Employee?
    var isEditingBirthday: Bool = false {
        didSet {
            birthDatePicker.isHidden = !isEditingBirthday
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dobLabel.text = dateFormatter.string(from: employee.dateOfBirth)
            dobLabel.textColor = .black
            employeeTypeLabel.text = employee.employeeType.description()
            employeeTypeLabel.textColor = .black
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    func updateBirthDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dobLabel.textColor = .black
        dobLabel.text = dateFormatter.string(for: birthDatePicker.date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (0, 2):
            if isEditingBirthday {
                return 216.0
            } else {
                return 0.0
            }
                    
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (0, 1):
            isEditingBirthday = !isEditingBirthday
            
            tableView.beginUpdates()
            tableView.endUpdates()
        default:
            break
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let name = nameTextField.text,
            let employeeType = employeeType {
            employee = Employee(name: name, dateOfBirth: birthDatePicker.date, employeeType: employeeType)
            performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
        performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
    }
    
    
    @IBAction func birthdayChanged(_ sender: UIDatePicker) {
        updateBirthDate()
    }
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectEmployType" {
            let destinationViewController = segue.destination as?
            EmployeeTypeTableViewController
            destinationViewController?.delegate = self
            destinationViewController?.employeeType = employeeType
        }

    }
}
