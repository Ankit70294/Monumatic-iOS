import UIKit
import FirebaseFirestore
import SDWebImage // For loading images from URLs

class MonumentListViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate {

    // MARK: - UI Components
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Monumatic"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timelineLabel: UILabel = {
        let label = UILabel()
        label.text = "Timeline"
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle") // Placeholder image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20 // Circular profile picture
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search monuments..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Properties
    private var monuments: [MonumentList] = []
    private var filteredMonuments: [MonumentList] = []
    private let db = Firestore.firestore()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMonuments()
        searchBar.delegate = self
        loadProfilePicture() // Load the profile picture
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfilePicture() // Reload the profile picture when the view appears
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        // Add subviews
        view.addSubview(welcomeLabel)
        view.addSubview(timelineLabel)
        view.addSubview(profileImageView)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        profileImageView.isUserInteractionEnabled = true
        // Add tap gesture to profile image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)

        // Set constraints
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            timelineLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            timelineLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),

            searchBar.topAnchor.constraint(equalTo: timelineLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) // Adjusted to respect safe area
        ])

        // Configure TableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    // MARK: - Fetch Monuments from Firestore
    private func fetchMonuments() {
        db.collection("monuments_list").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching monuments: \(error.localizedDescription)")
                return
            }

            self.monuments = querySnapshot?.documents.compactMap { document in
                let data = document.data()
                let name = data["name"] as? String ?? ""
                return MonumentList(name: name)
            } ?? []

            self.filteredMonuments = self.monuments
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Load Profile Picture
    private func loadProfilePicture() {
        if let profileImageURLString = UserDefaults.standard.string(forKey: "profileImageURL"),
           let profileImageURL = URL(string: profileImageURLString) {
            // Load the profile picture using SDWebImage
            profileImageView.sd_setImage(with: profileImageURL, placeholderImage: UIImage(systemName: "person.circle"))
        } else {
            // Set a default profile picture if no URL is found
            profileImageView.image = UIImage(systemName: "person.circle")
        }
    }
    
    @objc private func profileImageTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    // MARK: - Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMonuments = monuments
        } else {
            filteredMonuments = monuments.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        tableView.reloadData()
    }
    
    // Add this method to dismiss the keyboard when the search button is clicked
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder() // Dismiss the keyboard
        }
}

// MARK: - TableView DataSource
extension MonumentListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMonuments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = filteredMonuments[indexPath.row].name
        return cell
    }
}

// MARK: - TableView Delegate
extension MonumentListViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMonument = filteredMonuments[indexPath.row]
        
        // Create an instance of TimelineViewController
        let timelineVC = TimelineViewController()
        
        // Pass the monument's document ID to TimelineViewController
        timelineVC.monumentId = selectedMonument.name.lowercased().replacingOccurrences(of: " ", with: "_")
        
        // Pass the monument's name to TimelineViewController
        timelineVC.monumentName = selectedMonument.name
        
        // Push to TimelineViewController
        navigationController?.pushViewController(timelineVC, animated: true)
    }
}

// MARK: - MonumentList Model
struct MonumentList {
    let name: String
}

#Preview{
    MonumentListViewController()
}


