import UIKit
import SwiftUI

struct CustomerDetailScreen: View {
    
    let customer: Customer
    
    var body: some View {
        Text(customer.name)
            .font(.largeTitle)
    }
}

struct SettingsScreen: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Text("Settings go here")
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}



// MARK: - Model
struct Customer {
    let name: String
}

// MARK: - Customers List
final class CustomersViewController: UITableViewController {

    private let customers: [Customer] = [
        .init(name: "Alice Johnson"),
        .init(name: "Brian Chen"),
        .init(name: "Carla Gomez"),
        .init(name: "Diego Martinez"),
        .init(name: "Eva Patel")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Customers"
        view.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 56

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
    }

    // MARK: - Table Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        customers.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let customer = customers[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = customer.name
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    // MARK: - Table Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        let customer = customers[indexPath.row]
        
        let detail = UIHostingController(rootView: CustomerDetailScreen(customer: customer))
                navigationController?.pushViewController(detail, animated: true)
    }

    @objc private func openSettings() {
        let settingsScreenHC = UIHostingController(rootView: SettingsScreen())
        present(settingsScreenHC, animated: true)
    }

}

// MARK: - Settings Screen
final class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemGroupedBackground

        let label = UILabel()
        label.text = "Settings go here"
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
    }
}

#Preview {
    UINavigationController(rootViewController: CustomersViewController())
}
