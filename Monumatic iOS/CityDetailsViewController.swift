import UIKit
import FirebaseFirestore

class CityDetailsViewController: UIViewController {
    // UI Components
    let cityImageView = UIImageView()
    let cityNameLabel = UILabel()
    let cityDescriptionLabel = UILabel()
    let monumentsTableView = UITableView()

    // Data
    var cityName: String?
    var cityDescription: String?
    var cityImageUrl: String?
    var monuments: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchCityDetails()
    }

    func setupUI() {
        // City Image View
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.clipsToBounds = true
        cityImageView.layer.cornerRadius = 8
        view.addSubview(cityImageView)
        cityImageView.translatesAutoresizingMaskIntoConstraints = false

        // City Name Label
        cityNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        view.addSubview(cityNameLabel)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false

        // City Description Label
        cityDescriptionLabel.font = UIFont.systemFont(ofSize: 16)
        cityDescriptionLabel.numberOfLines = 0
        view.addSubview(cityDescriptionLabel)
        cityDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Monuments Table View
        monumentsTableView.delegate = self
        monumentsTableView.dataSource = self
        monumentsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MonumentCell")
        view.addSubview(monumentsTableView)
        monumentsTableView.translatesAutoresizingMaskIntoConstraints = false

        // Constraints
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cityImageView.heightAnchor.constraint(equalToConstant: 200),

            cityNameLabel.topAnchor.constraint(equalTo: cityImageView.bottomAnchor, constant: 20),
            cityNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            cityDescriptionLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 10),
            cityDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cityDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            monumentsTableView.topAnchor.constraint(equalTo: cityDescriptionLabel.bottomAnchor, constant: 20),
            monumentsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            monumentsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            monumentsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    func fetchCityDetails() {
        guard let cityName = cityName else { return }
        let db = Firestore.firestore()

        db.collection("cities").document(cityName).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.cityNameLabel.text = data?["name"] as? String
                self.cityDescriptionLabel.text = data?["description"] as? String
                self.monuments = data?["monuments"] as? [String] ?? []

                if let imageUrl = data?["imageUrl"] as? String, let url = URL(string: imageUrl) {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data {
                            DispatchQueue.main.async {
                                self.cityImageView.image = UIImage(data: data)
                            }
                        }
                    }.resume()
                }

                self.monumentsTableView.reloadData()
            } else {
                print("City document does not exist")
            }
        }
    }
}

extension CityDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monuments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonumentCell", for: indexPath)
        cell.textLabel?.text = monuments[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMonument = monuments[indexPath.row]
        let monumentDetailsVC = MonumentDetailsViewController()
        monumentDetailsVC.monumentName = selectedMonument
        navigationController?.pushViewController(monumentDetailsVC, animated: true)
    }
    
}

#Preview{
    CityDetailsViewController()
}
