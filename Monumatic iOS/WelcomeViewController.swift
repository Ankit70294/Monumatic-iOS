import UIKit

class WelcomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // Add background image
        let backgroundImage = UIImageView(image: UIImage(named: "monuments_background"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)
        
        // Add overlay to make text more readable
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.7) // Light overlay
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)
        
        // Welcome label
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to Monumatic"
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: 28)
        welcomeLabel.textColor = .darkText
        welcomeLabel.textAlignment = .center
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)
        
        // Get Started button
        let getStartedButton = UIButton(type: .system)
        getStartedButton.setTitle("Get Started", for: .normal)
        getStartedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        getStartedButton.backgroundColor = .systemBlue
        getStartedButton.setTitleColor(.white, for: .normal)
        getStartedButton.layer.cornerRadius = 10
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        getStartedButton.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        view.addSubview(getStartedButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 90),
            getStartedButton.widthAnchor.constraint(equalToConstant: 200),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
        @objc private func getStartedTapped() {
            let featuresVC = FeaturesViewController()
            navigationController?.pushViewController(featuresVC, animated: true)
        }
    }

#Preview{
    WelcomeViewController()
}
