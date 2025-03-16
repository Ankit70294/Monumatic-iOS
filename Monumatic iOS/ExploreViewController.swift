//import UIKit
//import FirebaseFirestore
//import SDWebImage // For loading images from URLs
//
//struct Destination {
//    let name: String
//    let location: String
//    let imageUrl: String
//}
//
//class ExploreViewController: UIViewController, UISearchBarDelegate {
//    // UI Components
//    let greetingLabel = UILabel()
//    let headingLabel = UILabel()
//    let profileImageView = UIImageView()
//    let searchBar = UISearchBar()
//    let trendingLabel = UILabel()
//    let trendingCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.register(DestinationCell.self, forCellWithReuseIdentifier: "DestinationCell")
//        return cv
//    }()
//    let popularLabel = UILabel()
//    let popularCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.register(DestinationCell.self, forCellWithReuseIdentifier: "DestinationCell")
//        return cv
//    }()
//    
//    var trendingDestinations: [Destination] = []
//    var filteredTrendingDestinations: [Destination] = [] // For search results
//    var popularDestinations: [Destination] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        fetchData()
//        loadProfilePicture() // Load the profile picture
//        
//        // Set up search bar delegate
//        searchBar.delegate = self
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadProfilePicture() // Reload the profile picture when the view appears
//    }
//    
//    func setupUI() {
//        // Greeting Label
//        greetingLabel.text = "Welcome to Monumatic"
//        greetingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        view.addSubview(greetingLabel)
//        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Heading Label
//        headingLabel.text = "What to Explore now?"
//        headingLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
//        headingLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(headingLabel)
//        // Profile Image View
//        profileImageView.image = UIImage(systemName: "person.circle") // Placeholder image
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.layer.cornerRadius = 20 // Circular profile picture
//        profileImageView.clipsToBounds = true
//        profileImageView.isUserInteractionEnabled = true // Enable user interaction
//        view.addSubview(profileImageView)
//        profileImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Add tap gesture to profile image view
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
//        profileImageView.addGestureRecognizer(tapGesture)
//        
//        // Search Bar
//        searchBar.placeholder = "Search"
//        view.addSubview(searchBar)
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        
//        trendingLabel.text = "Explore Cities"
//        trendingLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
//        view.addSubview(trendingLabel)
//        trendingLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Trending Collection View
//        trendingCollectionView.backgroundColor = .clear
//        trendingCollectionView.delegate = self
//        trendingCollectionView.dataSource = self
//        view.addSubview(trendingCollectionView)
//        trendingCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        popularLabel.text = "Must Visit"
//        popularLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
//        view.addSubview(popularLabel)
//        popularLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Popular Collection View
//        popularCollectionView.backgroundColor = .clear
//        popularCollectionView.delegate = self
//        popularCollectionView.dataSource = self
//        view.addSubview(popularCollectionView)
//        popularCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        // Constraints
//        NSLayoutConstraint.activate([
//            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            headingLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
//            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
//            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            profileImageView.widthAnchor.constraint(equalToConstant: 40),
//            profileImageView.heightAnchor.constraint(equalToConstant: 40),
//            
//            searchBar.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            trendingLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
//            trendingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            trendingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            trendingCollectionView.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: 20),
//            trendingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            trendingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            trendingCollectionView.heightAnchor.constraint(equalToConstant: 200),
//            
//            popularLabel.topAnchor.constraint(equalTo: trendingCollectionView.bottomAnchor, constant: 10),
//            popularLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            popularLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            popularCollectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 20),
//            popularCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            popularCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            popularCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            popularCollectionView.heightAnchor.constraint(equalToConstant: 200)
//        ])
//    }
//
//    func fetchData() {
//        let db = Firestore.firestore()
//
//        db.collection("trendingDestinations").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                self.trendingDestinations = querySnapshot!.documents.compactMap { document in
//                    let data = document.data()
//                    return Destination(name: data["name"] as? String ?? "", location: data["location"] as? String ?? "", imageUrl: data["imageUrl"] as? String ?? "")
//                }
//                self.filteredTrendingDestinations = self.trendingDestinations // Initialize filtered array
//                self.trendingCollectionView.reloadData()
//            }
//        }
//
//        db.collection("popularDestinations").getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                self.popularDestinations = querySnapshot!.documents.compactMap { document in
//                    let data = document.data()
//                    return Destination(name: data["name"] as? String ?? "", location: data["location"] as? String ?? "", imageUrl: data["imageUrl"] as? String ?? "")
//                }
//                self.popularCollectionView.reloadData()
//            }
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
//    // MARK: - Profile Image Tap Action
//    @objc private func profileImageTapped() {
//        let profileVC = ProfileViewController()
//        navigationController?.pushViewController(profileVC, animated: true)
//    }
//    
//    // MARK: - Search Bar Delegate Methods
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            // If search text is empty, show all trending destinations
//            filteredTrendingDestinations = trendingDestinations
//        } else {
//            // Filter trending destinations based on search text
//            filteredTrendingDestinations = trendingDestinations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//        }
//        trendingCollectionView.reloadData() // Refresh the collection view
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder() // Dismiss the keyboard
//    }
//}
//
//extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == trendingCollectionView {
//            return filteredTrendingDestinations.count // Use filtered data for trending
//        } else {
//            return popularDestinations.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
//        let destination = collectionView == trendingCollectionView ? filteredTrendingDestinations[indexPath.row] : popularDestinations[indexPath.row]
//        cell.nameLabel.text = destination.name
//        cell.locationLabel.text = destination.location
//        if let url = URL(string: destination.imageUrl) {
//            // Load the destination image using SDWebImage
//            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
//        }
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 150, height: 200)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView == trendingCollectionView {
//            let selectedCity = filteredTrendingDestinations[indexPath.row].name
//            let cityDetailsVC = CityDetailsViewController()
//            cityDetailsVC.cityName = selectedCity
//            navigationController?.pushViewController(cityDetailsVC, animated: true)
//        }
//        // Do nothing if the popularCollectionView is selected
//    }
//}
//
//#Preview{
//    ExploreViewController()
//}

import UIKit
import FirebaseFirestore
import SDWebImage // For loading images from URLs

struct Destination {
    let name: String
    let location: String
    let imageUrl: String
}

class ExploreViewController: UIViewController, UISearchBarDelegate {
    // UI Components
    let greetingLabel = UILabel()
    let headingLabel = UILabel()
    let profileImageView = UIImageView()
    let searchBar = UISearchBar()
    let trendingLabel = UILabel()
    let trendingCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DestinationCell.self, forCellWithReuseIdentifier: "DestinationCell")
        return cv
    }()
    let popularLabel = UILabel()
    let popularCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(DestinationCell.self, forCellWithReuseIdentifier: "DestinationCell")
        return cv
    }()
    
    var trendingDestinations: [Destination] = []
    var filteredTrendingDestinations: [Destination] = [] // For search results
    var popularDestinations: [Destination] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchData()
        loadProfilePicture() // Load the profile picture
        
        // Set up search bar delegate
        searchBar.delegate = self
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProfilePicture() // Reload the profile picture when the view appears
    }
    
    func setupUI() {
        // Greeting Label
        greetingLabel.text = "Welcome to Monumatic"
        greetingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(greetingLabel)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Heading Label
        headingLabel.text = "What to Explore now?"
        headingLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headingLabel)
        // Profile Image View
        profileImageView.image = UIImage(systemName: "person.circle") // Placeholder image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20 // Circular profile picture
        profileImageView.clipsToBounds = true
        profileImageView.isUserInteractionEnabled = true // Enable user interaction
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add tap gesture to profile image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        
        // Search Bar
        searchBar.placeholder = "Search"
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        trendingLabel.text = "Explore Cities"
        trendingLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(trendingLabel)
        trendingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Trending Collection View
        trendingCollectionView.backgroundColor = .clear
        trendingCollectionView.delegate = self
        trendingCollectionView.dataSource = self
        view.addSubview(trendingCollectionView)
        trendingCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        popularLabel.text = "Must Visit"
        popularLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(popularLabel)
        popularLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Popular Collection View
        popularCollectionView.backgroundColor = .clear
        popularCollectionView.delegate = self
        popularCollectionView.dataSource = self
        view.addSubview(popularCollectionView)
        popularCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            headingLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            profileImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            searchBar.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 20),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            trendingLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            trendingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trendingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            trendingCollectionView.topAnchor.constraint(equalTo: trendingLabel.bottomAnchor, constant: 20),
            trendingCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trendingCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trendingCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            popularLabel.topAnchor.constraint(equalTo: trendingCollectionView.bottomAnchor, constant: 10),
            popularLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            popularLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            popularCollectionView.topAnchor.constraint(equalTo: popularLabel.bottomAnchor, constant: 20),
            popularCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            popularCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            popularCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            popularCollectionView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    func fetchData() {
        let db = Firestore.firestore()

        db.collection("trendingDestinations").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.trendingDestinations = querySnapshot!.documents.compactMap { document in
                    let data = document.data()
                    return Destination(name: data["name"] as? String ?? "", location: data["location"] as? String ?? "", imageUrl: data["imageUrl"] as? String ?? "")
                }
                self.filteredTrendingDestinations = self.trendingDestinations // Initialize filtered array
                self.trendingCollectionView.reloadData()
            }
        }

        db.collection("popularDestinations").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                self.popularDestinations = querySnapshot!.documents.compactMap { document in
                    let data = document.data()
                    return Destination(name: data["name"] as? String ?? "", location: data["location"] as? String ?? "", imageUrl: data["imageUrl"] as? String ?? "")
                }
                self.popularCollectionView.reloadData()
            }
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

    // MARK: - Profile Image Tap Action
    @objc private func profileImageTapped() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    // MARK: - Search Bar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If search text is empty, show all trending destinations
            filteredTrendingDestinations = trendingDestinations
        } else {
            // Filter trending destinations based on search text
            filteredTrendingDestinations = trendingDestinations.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
        trendingCollectionView.reloadData() // Refresh the collection view
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ExploreViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == trendingCollectionView {
            return filteredTrendingDestinations.count // Use filtered data for trending
        } else {
            return popularDestinations.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DestinationCell", for: indexPath) as! DestinationCell
        let destination = collectionView == trendingCollectionView ? filteredTrendingDestinations[indexPath.row] : popularDestinations[indexPath.row]
        cell.nameLabel.text = destination.name
        cell.locationLabel.text = destination.location
        if let url = URL(string: destination.imageUrl) {
            // Load the destination image using SDWebImage
            cell.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == trendingCollectionView {
            let selectedCity = filteredTrendingDestinations[indexPath.row].name
            let cityDetailsVC = CityDetailsViewController()
            cityDetailsVC.cityName = selectedCity
            navigationController?.pushViewController(cityDetailsVC, animated: true)
        }
        // Do nothing if the popularCollectionView is selected
    }
}

#Preview{
    ExploreViewController()
}
