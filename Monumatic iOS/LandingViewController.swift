//import UIKit
//import FirebaseFirestore
//import SDWebImage // For loading images from URLs
//import CoreLocation // For location-based filtering
//
//class LandingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
//    
//    // MARK: - UI Components
//    let welcomeLabel = UILabel()
//    let nearbyLabel = UILabel()
//    let profileImageView = UIImageView()
//    let searchBar = UISearchBar()
//    let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        layout.minimumLineSpacing = 16 // Space between rows
//        layout.minimumInteritemSpacing = 0 // Space between columns
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//    
//    // Data
//    var monuments: [Monument] = []
//    var filteredMonuments: [Monument] = []
//    
//    // Location Manager
//    let locationManager = CLLocationManager()
//    var userLocation: CLLocation?
//    
//    // MARK: - View Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        
//        setupUI()
//        setupLocationManager()
//        fetchMonumentsFromFirestore()
//        loadProfilePicture() // Load the profile picture
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadProfilePicture() // Reload the profile picture when the view appears
//    }
//    
//    // MARK: - Setup UI
//    private func setupUI() {
//        // Welcome Label
//        welcomeLabel.text = "Welcome to Monumatic"
//        welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(welcomeLabel)
//        
//        // Nearby Label
//        nearbyLabel.text = "Nearby Monuments"
//        nearbyLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        nearbyLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(nearbyLabel)
//        
//        // Profile Image View
//        profileImageView.image = UIImage(systemName: "person.circle") // Placeholder image
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.clipsToBounds = true
//        profileImageView.layer.cornerRadius = 20
//        profileImageView.isUserInteractionEnabled = true
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(profileImageView)
//        
//        // Add tap gesture to profile image view
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
//        profileImageView.addGestureRecognizer(tapGesture)
//
//        // Search Bar
//        searchBar.delegate = self
//        searchBar.placeholder = "Search monuments..."
//        searchBar.searchBarStyle = .minimal
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar)
//        
//        // Collection View
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.register(MonumentCell.self, forCellWithReuseIdentifier: "MonumentCell")
//        view.addSubview(collectionView)
//        
//        // Layout Constraints
//        NSLayoutConstraint.activate([
//            // Welcome Label
//            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            // Nearby Label
//            nearbyLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
//            nearbyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            // Profile Image View
//            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
//            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            profileImageView.widthAnchor.constraint(equalToConstant: 40),
//            profileImageView.heightAnchor.constraint(equalToConstant: 40),
//            
//            // Search Bar
//            searchBar.topAnchor.constraint(equalTo: nearbyLabel.bottomAnchor, constant: 16),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            // Collection View
//            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//    }
//   
//    
//    // MARK: - Setup Location Manager
//    private func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//    
//    // MARK: - CLLocationManagerDelegate
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            userLocation = location
//            locationManager.stopUpdatingLocation() // Stop updating to save battery
//            filterMonumentsByLocation()
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Failed to find user's location: \(error.localizedDescription)")
//    }
//    
//    // MARK: - Filter Monuments by Location
//    private func filterMonumentsByLocation() {
//        guard let userLocation = userLocation else { return }
//        
//        // Filter monuments within a 50 km radius (adjust as needed)
//        filteredMonuments = monuments.filter { monument in
//            if let monumentLocation = monument.location {
//                let distance = userLocation.distance(from: monumentLocation)
//                return distance <= 50000 // 50 km radius
//            }
//            return false
//        }
//        
//        collectionView.reloadData()
//    }
//    
//    // MARK: - Fetch Data from Firestore
//    private func fetchMonumentsFromFirestore() {
//        let db = Firestore.firestore()
//        db.collection("monuments").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error fetching documents: \(error)")
//                return
//            }
//            
//            guard let documents = querySnapshot?.documents else {
//                print("No documents found")
//                return
//            }
//            
//            // Parse Firestore documents into Monument objects
//            self.monuments = documents.compactMap { document in
//                let data = document.data()
//                let name = data["name"] as? String ?? ""
//                let description = data["description"] as? String ?? ""
//                let imageUrl = data["imageUrl"] as? String ?? ""
//                
//                // Parse location data
//                let latitude = data["latitude"] as? Double ?? 0
//                let longitude = data["longitude"] as? Double ?? 0
//                let location = CLLocation(latitude: latitude, longitude: longitude)
//                
//                return Monument(
//                    name: name,
//                    description: description,
//                    imageUrl: imageUrl,
//                    location: location
//                )
//            }
//            
//            // Update filteredMonuments and reload collection view
//            self.filteredMonuments = self.monuments
//            self.collectionView.reloadData()
//        }
//    }
//    
//    // MARK: - Load Profile Picture
//    private func loadProfilePicture() {
//        if let profileImageURLString = UserDefaults.standard.string(forKey: "profileImageURL"),
//           let profileImageURL = URL(string: profileImageURLString) {
//            // Load the profile picture using SDWebImage
//            profileImageView.sd_setImage(with: profileImageURL, placeholderImage: UIImage(systemName: "person.circle"))
//        } else {
//            // Set a default profile picture if no URL is found
//            profileImageView.image = UIImage(systemName: "person.circle")
//        }
//    }
//    
//    @objc private func profileImageTapped() {
//        let profileVC = ProfileViewController()
//        navigationController?.pushViewController(profileVC, animated: true)
//    }
//    
//    // MARK: - UICollectionViewDataSource
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return filteredMonuments.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonumentCell", for: indexPath) as! MonumentCell
//        let monument = filteredMonuments[indexPath.row]
//        cell.configure(with: monument)
//        return cell
//    }
//    
//    // MARK: - UICollectionViewDelegateFlowLayout
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.width - 32 // Adjust for left and right padding
//        
//        // Get the monument for the current cell
//        let monument = filteredMonuments[indexPath.row]
//        
//        // Calculate the height of the description label
//        let descriptionHeight = monument.description.height(withConstrainedWidth: width - 16, font: UIFont.systemFont(ofSize: 14))
//        
//        // Calculate the total height of the cell
//        let imageHeight: CGFloat = 120 // Fixed height for the image
//        let nameLabelHeight: CGFloat = 20 // Fixed height for the name label
//        let spacing: CGFloat = 24 // Total spacing (top + bottom + between elements)
//        
//        let totalHeight = imageHeight + nameLabelHeight + descriptionHeight + spacing
//        
//        return CGSize(width: width, height: totalHeight)
//    }
//    
//    // MARK: - UISearchBarDelegate
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredMonuments = monuments
//        } else {
//            filteredMonuments = monuments.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//        }
//        collectionView.reloadData()
//    }
//    
//    // Add this method to dismiss the keyboard when the search button is clicked
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder() // Dismiss the keyboard
//    }
//}
//
//// MARK: - MonumentCell
//class MonumentCell: UICollectionViewCell {
//    
//    // MARK: - UI Components
//    let imageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 8
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.textColor = .black
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .darkGray
//        label.numberOfLines = 0 // Allow multiple lines
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    // MARK: - Initializers
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup UI
//    private func setupUI() {
//        // Add subviews
//        contentView.addSubview(imageView)
//        contentView.addSubview(nameLabel)
//        contentView.addSubview(descriptionLabel)
//        
//        // Set constraints
//        NSLayoutConstraint.activate([
//            // ImageView constraints
//            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            imageView.heightAnchor.constraint(equalToConstant: 120), // Fixed height for image
//            
//            // NameLabel constraints
//            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            
//            // DescriptionLabel constraints
//            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
//            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8) // Ensure it's pinned to the bottom
//        ])
//        
//        // Optional: Add a shadow or border to the cell for better visual appeal
//        contentView.layer.cornerRadius = 8
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.lightGray.cgColor
//        contentView.layer.masksToBounds = true
//    }
//    
//    // MARK: - Configure Cell
//    func configure(with monument: Monument) {
//        nameLabel.text = monument.name
//        descriptionLabel.text = monument.description
//        
//        // Load image from URL using SDWebImage
//        if let imageUrl = URL(string: monument.imageUrl) {
//            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder")) // Add a placeholder image
//        }
//    }
//}
//
//// MARK: - Monument Model
//struct Monument {
//    let name: String
//    let description: String
//    let imageUrl: String
//    let location: CLLocation? // Add location property
//}
//
//// MARK: - Helper Extension for Dynamic Height Calculation
//extension String {
//    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//        return ceil(boundingBox.height)
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//extension LandingViewController {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedMonument = filteredMonuments[indexPath.row]
//        
//        // Instantiate MonumaticFinalViewController
//        let detailVC = MonumaticFinalViewController()
//        
//        // Pass the monument's name (or ID) to the detail view controller
//        detailVC.monumentId = selectedMonument.name // Use the monument's name as the document ID
//        
//        // Push the detail view controller
//        navigationController?.pushViewController(detailVC, animated: true)
//    }
//}
//
//#Preview{
//    LandingViewController()
//}

import UIKit
import FirebaseFirestore
import SDWebImage // For loading images from URLs
import CoreLocation // For location-based filtering

class LandingViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    // MARK: - UI Components
    let welcomeLabel = UILabel()
    let nearbyLabel = UILabel()
    let profileImageView = UIImageView()
    let searchBar = UISearchBar()
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16 // Space between rows
        layout.minimumInteritemSpacing = 0 // Space between columns
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // Data
    var monuments: [Monument] = []
    var filteredMonuments: [Monument] = []
    
    // Location Manager
    let locationManager = CLLocationManager()
    var userLocation: CLLocation?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        setupLocationManager()
        fetchMonumentsFromFirestore()
        loadProfilePicture() // Load the profile picture

        // Add tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Ensure it doesn't interfere with other touches
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfilePicture() // Reload the profile picture when the view appears
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Welcome Label
        welcomeLabel.text = "Welcome to Monumatic"
        welcomeLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        // Nearby Label
        nearbyLabel.text = "Nearby Monuments"
        nearbyLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nearbyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nearbyLabel)
        
        // Profile Image View
        profileImageView.image = UIImage(systemName: "person.circle") // Placeholder image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.isUserInteractionEnabled = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileImageView)
        
        // Add tap gesture to profile image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)

        // Search Bar
        searchBar.delegate = self
        searchBar.placeholder = "Search monuments..."
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        // Collection View
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MonumentCell.self, forCellWithReuseIdentifier: "MonumentCell")
        view.addSubview(collectionView)
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            // Welcome Label
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Nearby Label
            nearbyLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 8),
            nearbyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Profile Image View
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Search Bar
            searchBar.topAnchor.constraint(equalTo: nearbyLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
   
    
    // MARK: - Setup Location Manager
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            userLocation = location
            locationManager.stopUpdatingLocation() // Stop updating to save battery
            filterMonumentsByLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    // MARK: - Filter Monuments by Location
    private func filterMonumentsByLocation() {
        guard let userLocation = userLocation else { return }
        
        // Filter monuments within a 50 km radius (adjust as needed)
        filteredMonuments = monuments.filter { monument in
            if let monumentLocation = monument.location {
                let distance = userLocation.distance(from: monumentLocation)
                return distance <= 50000 // 50 km radius
            }
            return false
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - Fetch Data from Firestore
    private func fetchMonumentsFromFirestore() {
        let db = Firestore.firestore()
        db.collection("monuments").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            // Parse Firestore documents into Monument objects
            self.monuments = documents.compactMap { document in
                let data = document.data()
                let name = data["name"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let imageUrl = data["imageUrl"] as? String ?? ""
                
                // Parse location data
                let latitude = data["latitude"] as? Double ?? 0
                let longitude = data["longitude"] as? Double ?? 0
                let location = CLLocation(latitude: latitude, longitude: longitude)
                
                return Monument(
                    name: name,
                    description: description,
                    imageUrl: imageUrl,
                    location: location
                )
            }
            
            // Update filteredMonuments and reload collection view
            self.filteredMonuments = self.monuments
            self.collectionView.reloadData()
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
    
    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMonuments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonumentCell", for: indexPath) as! MonumentCell
        let monument = filteredMonuments[indexPath.row]
        cell.configure(with: monument)
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width - 32 // Adjust for left and right padding
        
        // Get the monument for the current cell
        let monument = filteredMonuments[indexPath.row]
        
        // Calculate the height of the description label
        let descriptionHeight = monument.description.height(withConstrainedWidth: width - 16, font: UIFont.systemFont(ofSize: 14))
        
        // Calculate the total height of the cell
        let imageHeight: CGFloat = 120 // Fixed height for the image
        let nameLabelHeight: CGFloat = 20 // Fixed height for the name label
        let spacing: CGFloat = 24 // Total spacing (top + bottom + between elements)
        
        let totalHeight = imageHeight + nameLabelHeight + descriptionHeight + spacing
        
        return CGSize(width: width, height: totalHeight)
    }
    
    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredMonuments = monuments
        } else {
            filteredMonuments = monuments.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        collectionView.reloadData()
    }
    
    // Add this method to dismiss the keyboard when the search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
}

// MARK: - MonumentCell
class MonumentCell: UICollectionViewCell {
    
    // MARK: - UI Components
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0 // Allow multiple lines
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Add subviews
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        
        // Set constraints
        NSLayoutConstraint.activate([
            // ImageView constraints
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 120), // Fixed height for image
            
            // NameLabel constraints
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            // DescriptionLabel constraints
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8) // Ensure it's pinned to the bottom
        ])
        
        // Optional: Add a shadow or border to the cell for better visual appeal
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.masksToBounds = true
    }
    
    // MARK: - Configure Cell
    func configure(with monument: Monument) {
        nameLabel.text = monument.name
        descriptionLabel.text = monument.description
        
        // Load image from URL using SDWebImage
        if let imageUrl = URL(string: monument.imageUrl) {
            imageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder")) // Add a placeholder image
        }
    }
}

// MARK: - Monument Model
struct Monument {
    let name: String
    let description: String
    let imageUrl: String
    let location: CLLocation? // Add location property
}

// MARK: - Helper Extension for Dynamic Height Calculation
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

// MARK: - UICollectionViewDelegate
extension LandingViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMonument = filteredMonuments[indexPath.row]
        
        // Instantiate MonumaticFinalViewController
        let detailVC = MonumaticFinalViewController()
        
        // Pass the monument's name (or ID) to the detail view controller
        detailVC.monumentId = selectedMonument.name // Use the monument's name as the document ID
        
        // Push the detail view controller
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

#Preview{
    LandingViewController()
}
