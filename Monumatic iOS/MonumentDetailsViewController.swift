import UIKit
import FirebaseFirestore
import CoreLocation
import MapKit

class MonumentDetailsViewController: UIViewController {
    // UI Components
    let scrollView = UIScrollView()
    let contentView = UIView() // Container for all UI components

    let monumentImageView = UIImageView()
    let monumentNameLabel = UILabel()
    let locationIcon = UIImageView()
    let locationLabel = UILabel()
    let descriptionLabel = UILabel()
    let detailsLabel = UILabel()
    let timingsIcon = UIImageView()
    let timingsLabel = UILabel()
    let pricesIcon = UIImageView()
    let pricesLabel = UILabel()
    let reachHereButton = UIButton()
    let moreInfoButton = UIButton()

    // Data
    var monumentName: String?
    var monumentLocation: String?
    var monumentDescription: String?
    var monumentImageUrl: String?
    var monumentTimings: String?
    var monumentPrices: String?
    var monumentCoordinates: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchMonumentDetails()
    }

    func setupUI() {
        // Set up ScrollView and ContentView
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for ScrollView and ContentView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // Ensure contentView width matches scrollView
        ])

        // Add UI components to contentView
        setupContentUI()
    }

    func setupContentUI() {
        // Monument Image View
        monumentImageView.contentMode = .scaleAspectFill
        monumentImageView.clipsToBounds = true
        monumentImageView.layer.cornerRadius = 8
        contentView.addSubview(monumentImageView)
        monumentImageView.translatesAutoresizingMaskIntoConstraints = false

        // Monument Name Label
        monumentNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(monumentNameLabel)
        monumentNameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Location Icon
        locationIcon.image = UIImage(systemName: "mappin.circle.fill")
        locationIcon.tintColor = .red
        contentView.addSubview(locationIcon)
        locationIcon.translatesAutoresizingMaskIntoConstraints = false

        // Location Label
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(locationLabel)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        // Description Label
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Details Label
        detailsLabel.text = "Details"
        detailsLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        contentView.addSubview(detailsLabel)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false

        // Timings Icon
        timingsIcon.image = UIImage(systemName: "clock.fill")
        timingsIcon.tintColor = .blue
        contentView.addSubview(timingsIcon)
        timingsIcon.translatesAutoresizingMaskIntoConstraints = false

        // Timings Label
        timingsLabel.font = UIFont.systemFont(ofSize: 16)
        timingsLabel.numberOfLines = 0 // Allow multiple lines
        contentView.addSubview(timingsLabel)
        timingsLabel.translatesAutoresizingMaskIntoConstraints = false

        // Prices Icon
        pricesIcon.image = UIImage(systemName: "indianrupeesign.circle.fill")
        pricesIcon.tintColor = .green
        contentView.addSubview(pricesIcon)
        pricesIcon.translatesAutoresizingMaskIntoConstraints = false

        // Prices Label
        pricesLabel.font = UIFont.systemFont(ofSize: 16)
        pricesLabel.numberOfLines = 0 // Allow multiple lines
        contentView.addSubview(pricesLabel)
        pricesLabel.translatesAutoresizingMaskIntoConstraints = false

        // Reach Here Button
        reachHereButton.setTitle("Reach Here", for: .normal)
        reachHereButton.backgroundColor = .systemBlue
        reachHereButton.layer.cornerRadius = 8
        reachHereButton.addTarget(self, action: #selector(openMaps), for: .touchUpInside)
        contentView.addSubview(reachHereButton)
        reachHereButton.translatesAutoresizingMaskIntoConstraints = false

        // More Info Button
        moreInfoButton.setTitle("More Info", for: .normal)
        moreInfoButton.backgroundColor = .systemGreen
        moreInfoButton.layer.cornerRadius = 8
        moreInfoButton.addTarget(self, action: #selector(openMonumaticFinalViewController), for: .touchUpInside)
        contentView.addSubview(moreInfoButton)
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false

        // Constraints for UI components
        NSLayoutConstraint.activate([
            monumentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            monumentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            monumentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            monumentImageView.heightAnchor.constraint(equalToConstant: 200),

            monumentNameLabel.topAnchor.constraint(equalTo: monumentImageView.bottomAnchor, constant: 20),
            monumentNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            monumentNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            locationIcon.topAnchor.constraint(equalTo: monumentNameLabel.bottomAnchor, constant: 10),
            locationIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationIcon.widthAnchor.constraint(equalToConstant: 24),
            locationIcon.heightAnchor.constraint(equalToConstant: 24),

            locationLabel.centerYAnchor.constraint(equalTo: locationIcon.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: locationIcon.trailingAnchor, constant: 8),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionLabel.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            detailsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            timingsIcon.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 10),
            timingsIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            timingsIcon.widthAnchor.constraint(equalToConstant: 24),
            timingsIcon.heightAnchor.constraint(equalToConstant: 24),

            timingsLabel.topAnchor.constraint(equalTo: timingsIcon.topAnchor),
            timingsLabel.leadingAnchor.constraint(equalTo: timingsIcon.trailingAnchor, constant: 8),
            timingsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            pricesIcon.topAnchor.constraint(equalTo: timingsLabel.bottomAnchor, constant: 10),
            pricesIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            pricesIcon.widthAnchor.constraint(equalToConstant: 24),
            pricesIcon.heightAnchor.constraint(equalToConstant: 24),

            pricesLabel.topAnchor.constraint(equalTo: pricesIcon.topAnchor),
            pricesLabel.leadingAnchor.constraint(equalTo: pricesIcon.trailingAnchor, constant: 8),
            pricesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            reachHereButton.topAnchor.constraint(equalTo: pricesLabel.bottomAnchor, constant: 20),
            reachHereButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reachHereButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reachHereButton.heightAnchor.constraint(equalToConstant: 50),

            moreInfoButton.topAnchor.constraint(equalTo: reachHereButton.bottomAnchor, constant: 20),
            moreInfoButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            moreInfoButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moreInfoButton.heightAnchor.constraint(equalToConstant: 50),
            moreInfoButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20) // Ensure contentView expands
        ])
    }

    func fetchMonumentDetails() {
        guard let monumentName = monumentName else { return }
        let db = Firestore.firestore()

        db.collection("monuments1").document(monumentName).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.monumentNameLabel.text = data?["name"] as? String
                self.locationLabel.text = data?["location"] as? String
                self.descriptionLabel.text = data?["description"] as? String
                self.timingsLabel.text = data?["timings"] as? String
                self.pricesLabel.text = data?["prices"] as? String

                if let imageUrl = data?["imageUrl"] as? String, let url = URL(string: imageUrl) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.monumentImageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }

                if let coordinates = data?["coordinates"] as? GeoPoint {
                    self.monumentCoordinates = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
                }
            } else {
                print("Monument document does not exist")
            }
        }
    }

    @objc func openMaps() {
        guard let monumentCoordinates = monumentCoordinates else { return }
        let placemark = MKPlacemark(coordinate: monumentCoordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = monumentNameLabel.text
        mapItem.openInMaps(launchOptions: nil)
    }

    @objc func openMonumaticFinalViewController() {
        guard let monumentName = monumentNameLabel.text else { return }
        
        let monumaticFinalVC = MonumaticFinalViewController()
        monumaticFinalVC.monumentId = monumentName // Pass the monument name to MonumaticFinalViewController
        navigationController?.pushViewController(monumaticFinalVC, animated: true)
    }
}

#Preview{
    MonumentDetailsViewController()
}
