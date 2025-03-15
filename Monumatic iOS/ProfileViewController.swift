import UIKit
import FirebaseAuth
import CoreLocation

class ProfileViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: - UI Components
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray // Placeholder color
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50 // Circular profile picture
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Data
    private var userDetails: [(title: String, value: String)] = []
    private let locationManager = CLLocationManager()
    private var userLocation: CLLocation?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemPink.withAlphaComponent(0.1) // Light pinkish background
        setupUI()
        fetchUserDetails()
        setupLocationManager()
        setupLogoutButton()
    }


    // MARK: - Setup UI
    private func setupUI() {
        // Add subviews
        view.addSubview(coverImageView)
        view.addSubview(profileImageView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(logoutButton)

        // Set constraints
        NSLayoutConstraint.activate([
            // Cover Image
            coverImageView.topAnchor.constraint(equalTo: view.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 200),

            // Profile Image
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            // ScrollView
            scrollView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: logoutButton.topAnchor, constant: -20),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Logout Button
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logoutButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Add user details boxes
        addUserDetailsBoxes()
    }

    // MARK: - Add User Details Boxes
    private func addUserDetailsBoxes() {
        var previousBox: UIView?

        for (index, detail) in userDetails.enumerated() {
            let box = createDetailBox(title: detail.title, value: detail.value)
            contentView.addSubview(box)

            NSLayoutConstraint.activate([
                box.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                box.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                box.heightAnchor.constraint(equalToConstant: 80)
            ])

            if let previousBox = previousBox {
                box.topAnchor.constraint(equalTo: previousBox.bottomAnchor, constant: 16).isActive = true
            } else {
                box.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
            }

            previousBox = box

            // Add bottom constraint for the last box
            if index == userDetails.count - 1 {
                box.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
            }
        }
    }

    // MARK: - Create Detail Box
    private func createDetailBox(title: String, value: String) -> UIView {
        let box = UIView()
        box.backgroundColor = .white
        box.layer.cornerRadius = 10
        box.layer.shadowColor = UIColor.black.cgColor
        box.layer.shadowOpacity = 0.1
        box.layer.shadowOffset = CGSize(width: 0, height: 2)
        box.layer.shadowRadius = 4
        box.translatesAutoresizingMaskIntoConstraints = false

        // Title Label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textColor = .darkGray
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(titleLabel)

        // Value Label
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        valueLabel.textColor = .black
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        box.addSubview(valueLabel)

        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: box.topAnchor, constant: 16),

            valueLabel.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 16),
            valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -16)
        ])

        return box
    }

    // MARK: - Fetch User Details
    private func fetchUserDetails() {
        if let user = Auth.auth().currentUser {
            // Fetch profile picture and cover photo from Google
            if let photoURL = user.photoURL {
                profileImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(systemName: "person.circle"))
                coverImageView.sd_setImage(with: photoURL, placeholderImage: UIImage(named: "cover_placeholder")) // Add a placeholder for cover
            }

            // Fetch user details
            let name = user.displayName ?? "N/A"
            let email = user.email ?? "N/A"
            let dateOfBirth = "N/A" // Date of birth is not available in Google profile

            // Populate user details
            userDetails = [
                ("Name", name),
                ("Date of Birth", dateOfBirth),
                ("Email", email),
                ("Location", "Fetching location...") // Placeholder for location
            ]

            // Add user details boxes
            addUserDetailsBoxes()
        }
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

            // Update location in user details
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching location: \(error.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    let city = placemark.locality ?? "Unknown City"
                    let country = placemark.country ?? "Unknown Country"
                    let locationString = "\(city), \(country)"

                    // Update location in user details
                    if let index = self.userDetails.firstIndex(where: { $0.title == "Location" }) {
                        self.userDetails[index].value = locationString
                        self.addUserDetailsBoxes() // Refresh the boxes
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }

    // MARK: - Setup Logout Button
    private func setupLogoutButton() {
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    @objc private func logoutTapped() {
        do {
            try Auth.auth().signOut()
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

#Preview{
    ProfileViewController()
}
