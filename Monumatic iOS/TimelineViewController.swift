//import UIKit
//import FirebaseFirestore
//
//class TimelineViewController: UIViewController {
//
//    // MARK: - UI Components
//    private let monumentNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 24)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical // Ensure vertical scrolling
//        layout.minimumLineSpacing = 16 // Space between cells
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .clear
//        collectionView.alwaysBounceVertical = true // Enable bouncing
//        return collectionView
//    }()
//
//    // MARK: - Properties
//    private var timelineEvents: [TimelineEvent] = []
//    private let db = Firestore.firestore()
//    var monumentId: String? // Passed from MonumentListViewController
//    var monumentName: String? // Passed from MonumentListViewController
//    private var currentlySelectedIndexPath: IndexPath? // Track the currently selected cell
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        fetchTimelineEvents()
//        
//        // Set the monument name label
//        if let monumentName = monumentName {
//            monumentNameLabel.text = monumentName
//        }
//
//        // Add long-press gesture recognizer
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//        collectionView.addGestureRecognizer(longPressGesture)
//    }
//
//    // MARK: - Setup UI
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        // Add subviews
//        view.addSubview(monumentNameLabel)
//        view.addSubview(collectionView)
//
//        // Set constraints
//        NSLayoutConstraint.activate([
//            monumentNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            monumentNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            monumentNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//
//            collectionView.topAnchor.constraint(equalTo: monumentNameLabel.bottomAnchor, constant: 16),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
//        ])
//
//        // Configure CollectionView
//        collectionView.register(TimelineEventCell.self, forCellWithReuseIdentifier: "TimelineEventCell")
//        collectionView.dataSource = self
//        collectionView.delegate = self
//    }
//
//    // MARK: - Fetch Timeline Events from Firestore
//    private func fetchTimelineEvents() {
//        guard let monumentId = monumentId else { return }
//
//        db.collection("monuments_list").document(monumentId).collection("timeline_events").getDocuments { [weak self] (querySnapshot, error) in
//            guard let self = self else { return }
//            if let error = error {
//                print("Error fetching timeline events: \(error.localizedDescription)")
//                return
//            }
//
//            self.timelineEvents = querySnapshot?.documents.compactMap { document in
//                let data = document.data()
//                let eventName = data["eventName"] as? String ?? ""
//                let eventTime = data["eventTime"] as? String ?? ""
//                let eventDescription = data["eventDescription"] as? String ?? ""
//                let eventImageURL = data["eventImageURL"] as? String ?? ""
//                return TimelineEvent(eventName: eventName, eventTime: eventTime, eventDescription: eventDescription, eventImageURL: eventImageURL)
//            } ?? []
//
//            self.collectionView.reloadData()
//        }
//    }
//
//    // MARK: - Handle Long Press Gesture
//    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
//        let location = gesture.location(in: collectionView)
//        
//        switch gesture.state {
//        case .began, .changed:
//            if let indexPath = collectionView.indexPathForItem(at: location) {
//                if indexPath != currentlySelectedIndexPath {
//                    // Reset the previously selected cell
//                    if let previousIndexPath = currentlySelectedIndexPath {
//                        resetCell(at: previousIndexPath)
//                    }
//                    
//                    // Scale up the new cell
//                    scaleUpCell(at: indexPath)
//                    currentlySelectedIndexPath = indexPath
//                }
//            }
//        case .ended, .cancelled:
//            if let indexPath = currentlySelectedIndexPath {
//                resetCell(at: indexPath)
//                currentlySelectedIndexPath = nil
//            }
//        default:
//            break
//        }
//    }
//
//    // MARK: - Cell Animation Methods
//    private func scaleUpCell(at indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            UIView.animate(withDuration: 0.2) {
//                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // Scale up by 10%
//            }
//        }
//    }
//
//    private func resetCell(at indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            UIView.animate(withDuration: 0.2) {
//                cell.transform = .identity // Reset to original size
//            }
//        }
//    }
//}
//
//// MARK: - CollectionView DataSource and Delegate
//extension TimelineViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return timelineEvents.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineEventCell", for: indexPath) as! TimelineEventCell
//        let event = timelineEvents[indexPath.row]
//        cell.configure(with: event)
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView.frame.width - 32, height: 120) // Adjust width to account for leading/trailing constraints
//    }
//}
//
//// MARK: - TimelineEventCell
//class TimelineEventCell: UICollectionViewCell {
//    private let eventImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let eventNameLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let eventTimeLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.textColor = .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let eventDescriptionLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        // Add subviews
//        contentView.addSubview(eventImageView)
//        contentView.addSubview(eventNameLabel)
//        contentView.addSubview(eventTimeLabel)
//        contentView.addSubview(eventDescriptionLabel)
//
//        // Set constraints
//        NSLayoutConstraint.activate([
//            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            eventImageView.widthAnchor.constraint(equalToConstant: 100),
//
//            eventNameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
//            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//
//            eventTimeLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
//            eventTimeLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 4),
//            eventTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//
//            eventDescriptionLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
//            eventDescriptionLabel.topAnchor.constraint(equalTo: eventTimeLabel.bottomAnchor, constant: 4),
//            eventDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            eventDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
//        ])
//    }
//
//    func configure(with event: TimelineEvent) {
//        eventNameLabel.text = event.eventName
//        eventTimeLabel.text = event.eventTime
//        eventDescriptionLabel.text = event.eventDescription
//        if let url = URL(string: event.eventImageURL) {
//            // Load image from URL (use a library like SDWebImage or Kingfisher for better performance)
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                if let data = data {
//                    DispatchQueue.main.async {
//                        self.eventImageView.image = UIImage(data: data)
//                    }
//                }
//            }.resume()
//        }
//    }
//}
//
//// MARK: - TimelineEvent Model
//struct TimelineEvent {
//    let eventName: String
//    let eventTime: String
//    let eventDescription: String
//    let eventImageURL: String
//}

import UIKit
import FirebaseFirestore

class TimelineViewController: UIViewController {

    // MARK: - UI Components
    private let monumentNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical // Ensure vertical scrolling
        layout.minimumLineSpacing = 16 // Space between cells
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true // Enable vertical bouncing
        collectionView.alwaysBounceHorizontal = false // Disable horizontal bouncing
        return collectionView
    }()

    // MARK: - Properties
    private var timelineEvents: [TimelineEvent] = []
    private let db = Firestore.firestore()
    var monumentId: String? // Passed from MonumentListViewController
    var monumentName: String? // Passed from MonumentListViewController
    private var currentlySelectedIndexPath: IndexPath? // Track the currently selected cell

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTimelineEvents()
        
        // Set the monument name label
        if let monumentName = monumentName {
            monumentNameLabel.text = monumentName
        }

        // Add long-press gesture recognizer
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        // Add subviews
        view.addSubview(monumentNameLabel)
        view.addSubview(collectionView)

        // Set constraints
        NSLayoutConstraint.activate([
            monumentNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            monumentNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            monumentNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: monumentNameLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80)
        ])

        // Configure CollectionView
        collectionView.register(TimelineEventCell.self, forCellWithReuseIdentifier: "TimelineEventCell")
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - Fetch Timeline Events from Firestore
    private func fetchTimelineEvents() {
        guard let monumentId = monumentId else { return }

        db.collection("monuments_list").document(monumentId).collection("timeline_events").getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching timeline events: \(error.localizedDescription)")
                return
            }

            self.timelineEvents = querySnapshot?.documents.compactMap { document in
                let data = document.data()
                let eventName = data["eventName"] as? String ?? ""
                let eventTime = data["eventTime"] as? String ?? ""
                let eventDescription = data["eventDescription"] as? String ?? ""
                let eventImageURL = data["eventImageURL"] as? String ?? ""
                return TimelineEvent(eventName: eventName, eventTime: eventTime, eventDescription: eventDescription, eventImageURL: eventImageURL)
            } ?? []

            self.collectionView.reloadData()
        }
    }

    // MARK: - Handle Long Press Gesture
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: collectionView)
        
        switch gesture.state {
        case .began, .changed:
            if let indexPath = collectionView.indexPathForItem(at: location) {
                if indexPath != currentlySelectedIndexPath {
                    // Reset the previously selected cell
                    if let previousIndexPath = currentlySelectedIndexPath {
                        resetCell(at: previousIndexPath)
                    }
                    
                    // Scale up the new cell
                    scaleUpCell(at: indexPath)
                    currentlySelectedIndexPath = indexPath
                }
            }
        case .ended, .cancelled:
            if let indexPath = currentlySelectedIndexPath {
                resetCell(at: indexPath)
                currentlySelectedIndexPath = nil
            }
        default:
            break
        }
    }

    // MARK: - Cell Animation Methods
    private func scaleUpCell(at indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1) // Scale up by 10%
            }
        }
    }

    private func resetCell(at indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity // Reset to original size
            }
        }
    }
}

// MARK: - CollectionView DataSource and Delegate
extension TimelineViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return timelineEvents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimelineEventCell", for: indexPath) as! TimelineEventCell
        let event = timelineEvents[indexPath.row]
        cell.configure(with: event)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 32, height: 150) // Increased height to accommodate more text
    }
}

// MARK: - TimelineEventCell
class TimelineEventCell: UICollectionViewCell {
    private let eventImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let eventTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let eventDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        // Add subviews
        contentView.addSubview(eventImageView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(eventTimeLabel)
        contentView.addSubview(eventDescriptionLabel)

        // Set constraints
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            eventImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            eventImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            eventImageView.widthAnchor.constraint(equalToConstant: 100),

            eventNameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
            eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            eventTimeLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
            eventTimeLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 4),
            eventTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            eventDescriptionLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 16),
            eventDescriptionLabel.topAnchor.constraint(equalTo: eventTimeLabel.bottomAnchor, constant: 4),
            eventDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            eventDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    func configure(with event: TimelineEvent) {
        eventNameLabel.text = event.eventName
        eventTimeLabel.text = event.eventTime
        eventDescriptionLabel.text = event.eventDescription
        if let url = URL(string: event.eventImageURL) {
            // Load image from URL (use a library like SDWebImage or Kingfisher for better performance)
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.eventImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
    }
}

// MARK: - TimelineEvent Model
struct TimelineEvent {
    let eventName: String
    let eventTime: String
    let eventDescription: String
    let eventImageURL: String
}

#Preview{
    TimelineViewController()
}
