import UIKit

class FeaturesViewController: UIViewController {

    // Feature data
    private let featureTitles = ["Explore Monuments", "Audio Guides", "Timelines", "Nearby Monuments"]
    private let featureDescriptions = [
        "Discover historical monuments around the world in just a click.",
        "Listen to the Audio Guide for an immersive experience.",
        "Travel thorugh a monument's Timeline.",
        "Explore Monuments Nearby you."
    ]
    private let featureImages = ["istockphoto-510795912-612x612", "acoustiguide-hero", "-IND-004-073-_How_To_Create_a_Timeline_Final", "Landing Page-7"]
    private var currentFeatureIndex = 0

    // UI Components
    private let stackView = UIStackView()
    private let nextButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showNextFeature()
    }

    private func setupUI() {
        // Add background image
        let backgroundImage = UIImageView(image: UIImage(named: "monuments_background"))
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundImage)

        // Add overlay to make features visible
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.white.withAlphaComponent(0.7) // Light overlay
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overlayView)

        // Stack view to hold features
        stackView.axis = .vertical
        stackView.spacing = 40 // Increased spacing between features
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        // Next button
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        nextButton.backgroundColor = .systemBlue
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 10
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.isHidden = true // Initially hidden
        view.addSubview(nextButton)

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

            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func showNextFeature() {
        guard currentFeatureIndex < featureTitles.count else {
            // Show the "Next" button after all features are displayed
            nextButton.isHidden = false
            return
        }

        // Create a feature view
        let featureView = createFeatureView(
            title: featureTitles[currentFeatureIndex],
            description: featureDescriptions[currentFeatureIndex],
            imageName: featureImages[currentFeatureIndex],
            animateFromLeft: currentFeatureIndex == 2 // Last feature animates from the left
        )

        // Add the feature view to the stack view
        stackView.addArrangedSubview(featureView)

        // Animate the feature view
        animateFeatureView(featureView)

        // Move to the next feature
        currentFeatureIndex += 1

        // Show the next feature after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextFeature()
        }
    }

    private func createFeatureView(title: String, description: String, imageName: String, animateFromLeft: Bool) -> UIView {
        let featureView = UIView()
        featureView.translatesAutoresizingMaskIntoConstraints = false

        // Feature image view
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20 // Rounded corners
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowOffset = CGSize(width: 0, height: 5)
        imageView.layer.shadowRadius = 10
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        featureView.addSubview(imageView)

        // Feature title label
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        featureView.addSubview(titleLabel)

        // Feature description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        featureView.addSubview(descriptionLabel)

        // Constraints
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: featureView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: featureView.leadingAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: featureView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: featureView.trailingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: featureView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: featureView.bottomAnchor)
        ])

        return featureView
    }

    private func animateFeatureView(_ featureView: UIView) {
        // Set initial position outside the screen
        if currentFeatureIndex == 2 {
            featureView.transform = CGAffineTransform(translationX: -view.bounds.width, y: 0) // Left side
        } else {
            featureView.transform = CGAffineTransform(translationX: view.bounds.width, y: 0) // Right side
        }
        featureView.alpha = 0

        // Animate the feature view into place
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            featureView.transform = .identity
            featureView.alpha = 1
        }, completion: nil)
    }

    @objc private func nextTapped() {
        // Navigate to LoginViewController
        let loginVC = LoginViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }
}


