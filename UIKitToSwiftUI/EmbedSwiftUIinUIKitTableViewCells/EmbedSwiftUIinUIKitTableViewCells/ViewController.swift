import UIKit
import SwiftUI

struct CustomerRow: View {
    let name: String
    let city: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text(city)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "person.circle.fill")
                .font(.largeTitle)
                .foregroundStyle(.blue)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Model
struct Customer {
    let name: String
    let city: String
}

// MARK: - Table View Controller
final class CustomersViewController: UITableViewController {

    private let customers: [Customer] = [
        Customer(name: "Alice Johnson", city: "Houston"),
        Customer(name: "Brian Chen", city: "Austin"),
        Customer(name: "Carla Gomez", city: "Dallas"),
        Customer(name: "David Lee", city: "San Antonio"),
        Customer(name: "Emma Thompson", city: "El Paso")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Customers"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomerCell")
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        customers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
                    withIdentifier: "CustomerTableViewCell",
                    for: indexPath
                )
        
        let customer = customers[indexPath.row]
       
        cell.contentConfiguration = UIHostingConfiguration {
            // CustomerRow is the SwiftUI view
            CustomerRow(name: customer.name, city: customer.city)
        }
        
        return cell
    }

    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let customer = customers[indexPath.row]
        print("Selected customer: \(customer.name)")
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

#Preview {
    CustomersViewController()
}
