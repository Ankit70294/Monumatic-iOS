//import UIKit
//import FirebaseFirestore
//import FirebaseStorage
//import FirebaseAuth
//import GoogleSignIn
//import AVFoundation
//import AVKit
//import SDWebImage
//
//class MonumaticFinalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//    // MARK: - UI Components
//    let scrollView = UIScrollView()
//    let contentView = UIView()
//    let monumentImageView = UIImageView()
//    let nameLabel = UILabel()
//    let locationLabel = UILabel()
//    let audioGuideButton = UIButton()
//    let talkWithAIButton = UIButton()
//    let segmentedControl = UISegmentedControl(items: ["Brief Synthesis", "Anecdotes"])
//    let descriptionTextView = UITextView()
//    let reviewsLabel = UILabel()
//    let addReviewButton = UIButton()
//    let reviewsStackView = UIStackView()
//
//    // Firestore
//    let db = Firestore.firestore()
//    var monumentId: String?
//    var monumentData: [String: Any]?
//    var reviews: [Review] = []
//
//    // Image/Video Picker
//    let imagePicker = UIImagePickerController()
//    var selectedImage: UIImage?
//    var selectedVideoURL: URL?
//
//    // Audio
//    let speechSynthesizer = AVSpeechSynthesizer()
//
//    struct Review {
//        let reviewText: String
//        let userName: String
//        let timestamp: Timestamp
//        let imageUrl: String?
//        let videoUrl: String?
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        fetchMonumentData()
//        setupImagePicker()
//    }
//
//    // MARK: - Setup UI
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//        scrollView.addSubview(contentView)
//
//        monumentImageView.contentMode = .scaleAspectFill
//        monumentImageView.clipsToBounds = true
//        monumentImageView.layer.cornerRadius = 12
//        monumentImageView.layer.shadowColor = UIColor.black.cgColor
//        monumentImageView.layer.shadowOpacity = 0.3
//        monumentImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        monumentImageView.layer.shadowRadius = 4
//        monumentImageView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(monumentImageView)
//
//        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
//        nameLabel.textColor = .black
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(nameLabel)
//
//        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
//        locationLabel.textColor = .gray
//        locationLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(locationLabel)
//
//        audioGuideButton.setTitle("Audio Guide", for: .normal)
//        audioGuideButton.backgroundColor = .systemBlue
//        audioGuideButton.layer.cornerRadius = 8
//        audioGuideButton.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(audioGuideButton)
//        audioGuideButton.addTarget(self, action: #selector(playAudioGuide), for: .touchUpInside)
//
//        talkWithAIButton.setTitle("Talk with AI", for: .normal)
//        talkWithAIButton.backgroundColor = .systemPurple
//        talkWithAIButton.layer.cornerRadius = 8
//        talkWithAIButton.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(talkWithAIButton)
//        talkWithAIButton.addTarget(self, action: #selector(talkWithAI), for: .touchUpInside)
//
//        segmentedControl.selectedSegmentIndex = 0
//        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(segmentedControl)
//        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
//
//        descriptionTextView.isEditable = false
//        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
//        descriptionTextView.textColor = .darkGray
//        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(descriptionTextView)
//
//        reviewsLabel.text = "Customer Reviews"
//        reviewsLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(reviewsLabel)
//
//        addReviewButton.setTitle("Add Review", for: .normal)
//        addReviewButton.backgroundColor = .systemGreen
//        addReviewButton.layer.cornerRadius = 8
//        addReviewButton.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(addReviewButton)
//        addReviewButton.addTarget(self, action: #selector(openAddReview), for: .touchUpInside)
//
//        reviewsStackView.axis = .vertical
//        reviewsStackView.spacing = 16
//        reviewsStackView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(reviewsStackView)
//
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//
//            monumentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            monumentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            monumentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            monumentImageView.heightAnchor.constraint(equalToConstant: 200),
//
//            nameLabel.topAnchor.constraint(equalTo: monumentImageView.bottomAnchor, constant: 16),
//            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
//            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            audioGuideButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
//            audioGuideButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            audioGuideButton.widthAnchor.constraint(equalToConstant: 150),
//            audioGuideButton.heightAnchor.constraint(equalToConstant: 40),
//
//            talkWithAIButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
//            talkWithAIButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            talkWithAIButton.widthAnchor.constraint(equalToConstant: 150),
//            talkWithAIButton.heightAnchor.constraint(equalToConstant: 40),
//
//            segmentedControl.topAnchor.constraint(equalTo: audioGuideButton.bottomAnchor, constant: 20),
//            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            descriptionTextView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
//            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            descriptionTextView.heightAnchor.constraint(equalToConstant: 150),
//
//            reviewsLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
//            reviewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            reviewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
//            addReviewButton.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 20),
//            addReviewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            addReviewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            addReviewButton.heightAnchor.constraint(equalToConstant: 50),
//
//            reviewsStackView.topAnchor.constraint(equalTo: addReviewButton.bottomAnchor, constant: 20),
//            reviewsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            reviewsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            reviewsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
//        ])
//    }
//
//    // MARK: - Update UI
//    private func updateUI() {
//        guard let data = monumentData else { return }
//        
//        nameLabel.text = data["name"] as? String
//        locationLabel.text = data["location"] as? String
//        
//        if let imageUrl = data["imageUrl"] as? String, let url = URL(string: imageUrl) {
//            DispatchQueue.global().async {
//                if let imageData = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async {
//                        self.monumentImageView.image = UIImage(data: imageData)
//                    }
//                }
//            }
//        }
//        
//        segmentChanged()
//    }
//
//    // MARK: - Fetch Monument Data
//    private func fetchMonumentData() {
//        guard let monumentId = monumentId else { return }
//        
//        db.collection("monuments_final").document(monumentId).getDocument { [weak self] (document, error) in
//            guard let self = self, let document = document, document.exists else {
//                print("Monument document not found")
//                return
//            }
//            
//            self.monumentData = document.data()
//            self.updateUI()
//            self.fetchReviews()
//        }
//    }
//
//    // MARK: - Fetch Reviews
//    private func fetchReviews() {
//        guard let monumentId = monumentId else { return }
//        
//        db.collection("monuments_final").document(monumentId).collection("reviews")
//            .order(by: "timestamp", descending: true)
//            .getDocuments { [weak self] (querySnapshot, error) in
//                guard let self = self, let documents = querySnapshot?.documents else { return }
//                
//                self.reviews = documents.compactMap { document in
//                    let data = document.data()
//                    return Review(
//                        reviewText: data["reviewText"] as? String ?? "",
//                        userName: data["userName"] as? String ?? "Anonymous",
//                        timestamp: data["timestamp"] as? Timestamp ?? Timestamp(),
//                        imageUrl: data["imageUrl"] as? String,
//                        videoUrl: data["videoUrl"] as? String
//                    )
//                }
//                
//                self.updateReviewsUI()
//            }
//    }
//
//    // MARK: - Update Reviews UI
//    private func updateReviewsUI() {
//        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
//        
//        for review in reviews {
//            let reviewView = ReviewView(review: review)
//            reviewsStackView.addArrangedSubview(reviewView)
//        }
//    }
//
//    // MARK: - Segment Changed
//    @objc private func segmentChanged() {
//        guard let data = monumentData else { return }
//        
//        if segmentedControl.selectedSegmentIndex == 0 {
//            descriptionTextView.text = data["briefSynthesis"] as? String
//        } else {
//            descriptionTextView.text = data["anecdotes"] as? String
//        }
//    }
//
//    // MARK: - Open Add Review
//    @objc private func openAddReview() {
//        let addReviewVC = AddReviewViewController()
//        addReviewVC.delegate = self
//        self.present(addReviewVC, animated: true, completion: nil)
//    }
//
//    // MARK: - Save Review
//    func saveReview(reviewText: String, image: UIImage?, videoURL: URL?) {
//        guard let monumentId = monumentId, let user = Auth.auth().currentUser else { return }
//        
//        let reviewData: [String: Any] = [
//            "reviewText": reviewText,
//            "userName": user.displayName ?? "Anonymous",
//            "timestamp": Timestamp(date: Date()),
//            "imageUrl": "",
//            "videoUrl": ""
//        ]
//        
//        let reviewRef = db.collection("monuments_final").document(monumentId).collection("reviews").document()
//        
//        if let image = image {
//            uploadImage(image) { imageUrl in
//                reviewRef.setData(reviewData.merging(["imageUrl": imageUrl], uniquingKeysWith: { $1 })) { error in
//                    if let error = error {
//                        print("Error adding review: \(error)")
//                    } else {
//                        self.fetchReviews()
//                    }
//                }
//            }
//        } else if let videoURL = videoURL {
//            uploadVideo(videoURL) { videoUrl in
//                reviewRef.setData(reviewData.merging(["videoUrl": videoUrl], uniquingKeysWith: { $1 })) { error in
//                    if let error = error {
//                        print("Error adding review: \(error)")
//                    } else {
//                        self.fetchReviews()
//                    }
//                }
//            }
//        } else {
//            reviewRef.setData(reviewData) { error in
//                if let error = error {
//                    print("Error adding review: \(error)")
//                } else {
//                    self.fetchReviews()
//                }
//            }
//        }
//    }
//
//    // MARK: - Upload Image
//    private func uploadImage(_ image: UIImage, completion: @escaping (String) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
//        
//        let storageRef = Storage.storage().reference().child("review_images/\(UUID().uuidString).jpg")
//        storageRef.putData(imageData, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading image: \(error)")
//                return
//            }
//            
//            storageRef.downloadURL { url, error in
//                if let url = url {
//                    completion(url.absoluteString)
//                }
//            }
//        }
//    }
//
//    // MARK: - Upload Video
//    private func uploadVideo(_ videoURL: URL, completion: @escaping (String) -> Void) {
//        let storageRef = Storage.storage().reference().child("review_videos/\(UUID().uuidString).mp4")
//        storageRef.putFile(from: videoURL, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading video: \(error)")
//                return
//            }
//            
//            storageRef.downloadURL { url, error in
//                if let url = url {
//                    completion(url.absoluteString)
//                }
//            }
//        }
//    }
//
//    // MARK: - Image Picker
//    private func setupImagePicker() {
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.mediaTypes = ["public.image", "public.movie"]
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            selectedImage = image
//        } else if let videoURL = info[.mediaURL] as? URL {
//            selectedVideoURL = videoURL
//        }
//        
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    // MARK: - Play Audio Guide
//    @objc private func playAudioGuide() {
//        guard let audioguideText = monumentData?["audioguide"] as? String else { return }
//        let speechUtterance = AVSpeechUtterance(string: audioguideText)
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
//        speechSynthesizer.speak(speechUtterance)
//    }
//
//    // MARK: - Talk with AI
//    @objc private func talkWithAI() {
//        guard let data = monumentData,
//              let name = data["name"] as? String else {
//            let alert = UIAlertController(title: "Error", message: "Monument data not available.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//        
//        let chatbotVC = ChatbotViewController(monumentName: name)
//        if let navController = navigationController {
//            navController.pushViewController(chatbotVC, animated: true)
//        } else {
//            self.present(chatbotVC, animated: true, completion: nil)
//        }
//    }
//}
//
//// MARK: - AddReviewViewController
//class AddReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    weak var delegate: MonumaticFinalViewController?
//
//    private let reviewTextView = UITextView()
//    private let addImageButton = UIButton()
//    private let addVideoButton = UIButton()
//    private let submitButton = UIButton()
//    private let cancelButton = UIButton()
//    private let imagePicker = UIImagePickerController()
//
//    private var selectedImage: UIImage?
//    private var selectedVideoURL: URL?
//
//    // Container to display selected media
//    private let mediaContainerView = UIView()
//    private let mediaImageView = UIImageView()
//    private let removeMediaButton = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupImagePicker()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        // Review Text View
//        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
//        reviewTextView.layer.borderWidth = 1.0
//        reviewTextView.layer.cornerRadius = 8.0
//        reviewTextView.font = UIFont.systemFont(ofSize: 16)
//        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(reviewTextView)
//
//        // Add Image Button
//        addImageButton.setTitle("Add Image", for: .normal)
//        addImageButton.backgroundColor = .systemBlue
//        addImageButton.layer.cornerRadius = 8
//        addImageButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(addImageButton)
//        addImageButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
//
//        // Add Video Button
//        addVideoButton.setTitle("Add Video", for: .normal)
//        addVideoButton.backgroundColor = .systemPurple
//        addVideoButton.layer.cornerRadius = 8
//        addVideoButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(addVideoButton)
//        addVideoButton.addTarget(self, action: #selector(openVideoPicker), for: .touchUpInside)
//
//        // Submit Button
//        submitButton.setTitle("Submit", for: .normal)
//        submitButton.backgroundColor = .systemGreen
//        submitButton.layer.cornerRadius = 8
//        submitButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(submitButton)
//        submitButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)
//
//        // Cancel Button
//        cancelButton.setTitle("Cancel", for: .normal)
//        cancelButton.backgroundColor = .systemRed
//        cancelButton.layer.cornerRadius = 8
//        cancelButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(cancelButton)
//        cancelButton.addTarget(self, action: #selector(cancelReview), for: .touchUpInside)
//
//        // Media Container View
//        mediaContainerView.isHidden = true // Initially hidden
//        mediaContainerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(mediaContainerView)
//
//        // Media Image View
//        mediaImageView.contentMode = .scaleAspectFit
//        mediaImageView.layer.cornerRadius = 8
//        mediaImageView.clipsToBounds = true
//        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
//        mediaContainerView.addSubview(mediaImageView)
//
//        // Remove Media Button
//        removeMediaButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//        removeMediaButton.tintColor = .red
//        removeMediaButton.translatesAutoresizingMaskIntoConstraints = false
//        removeMediaButton.addTarget(self, action: #selector(removeMedia), for: .touchUpInside)
//        mediaContainerView.addSubview(removeMediaButton)
//
//        // Constraints
//        NSLayoutConstraint.activate([
//            reviewTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            reviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            reviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            reviewTextView.heightAnchor.constraint(equalToConstant: 150),
//
//            addImageButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20),
//            addImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            addImageButton.widthAnchor.constraint(equalToConstant: 150),
//            addImageButton.heightAnchor.constraint(equalToConstant: 40),
//
//            addVideoButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20),
//            addVideoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            addVideoButton.widthAnchor.constraint(equalToConstant: 150),
//            addVideoButton.heightAnchor.constraint(equalToConstant: 40),
//
//            mediaContainerView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20),
//            mediaContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            mediaContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            mediaContainerView.heightAnchor.constraint(equalToConstant: 200),
//
//            mediaImageView.topAnchor.constraint(equalTo: mediaContainerView.topAnchor),
//            mediaImageView.leadingAnchor.constraint(equalTo: mediaContainerView.leadingAnchor),
//            mediaImageView.trailingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor),
//            mediaImageView.bottomAnchor.constraint(equalTo: mediaContainerView.bottomAnchor),
//
//            removeMediaButton.topAnchor.constraint(equalTo: mediaContainerView.topAnchor, constant: 10),
//            removeMediaButton.trailingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor, constant: -10),
//            removeMediaButton.widthAnchor.constraint(equalToConstant: 30),
//            removeMediaButton.heightAnchor.constraint(equalToConstant: 30),
//
//            submitButton.topAnchor.constraint(equalTo: mediaContainerView.bottomAnchor, constant: 20),
//            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            submitButton.heightAnchor.constraint(equalToConstant: 50),
//
//            cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
//            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            cancelButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//
//    private func setupImagePicker() {
//        imagePicker.delegate = self
//        imagePicker.sourceType = .photoLibrary
//        imagePicker.mediaTypes = ["public.image", "public.movie"]
//    }
//
//    @objc private func openImagePicker() {
//        imagePicker.mediaTypes = ["public.image"]
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//
//    @objc private func openVideoPicker() {
//        imagePicker.mediaTypes = ["public.movie"]
//        self.present(imagePicker, animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        if let image = info[.originalImage] as? UIImage {
//            selectedImage = image
//            selectedVideoURL = nil
//            mediaImageView.image = image
//            mediaContainerView.isHidden = false
//        } else if let videoURL = info[.mediaURL] as? URL {
//            selectedVideoURL = videoURL
//            selectedImage = nil
//            mediaImageView.image = UIImage(systemName: "play.circle.fill") // Placeholder for video
//            mediaContainerView.isHidden = false
//        }
//        
//        dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @objc private func removeMedia() {
//        selectedImage = nil
//        selectedVideoURL = nil
//        mediaImageView.image = nil
//        mediaContainerView.isHidden = true
//    }
//
//    @objc private func submitReview() {
//        guard let reviewText = reviewTextView.text, !reviewText.isEmpty else {
//            let alert = UIAlertController(title: "Error", message: "Please enter a review.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//
//        delegate?.saveReview(reviewText: reviewText, image: selectedImage, videoURL: selectedVideoURL)
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    @objc private func cancelReview() {
//        self.dismiss(animated: true, completion: nil)
//    }
//}
//
//// MARK: - ReviewView
//class ReviewView: UIView {
//    private let userNameLabel = UILabel()
//    private let timestampLabel = UILabel()
//    private let reviewTextLabel = UILabel()
//    private let mediaImageView = UIImageView()
//    private let videoPlayerView = UIView()
//    private let playButton = UIButton()
//
//    private var review: MonumaticFinalViewController.Review?
//
//    init(review: MonumaticFinalViewController.Review) {
//        self.review = review
//        super.init(frame: .zero)
//        setupUI()
//        configure(with: review)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupUI() {
//        backgroundColor = .systemBackground
//        layer.cornerRadius = 8
//        layer.borderWidth = 1
//        layer.borderColor = UIColor.lightGray.cgColor
//        translatesAutoresizingMaskIntoConstraints = false
//
//        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        userNameLabel.textColor = .label
//        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(userNameLabel)
//
//        timestampLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        timestampLabel.textColor = .gray
//        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(timestampLabel)
//
//        reviewTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        reviewTextLabel.textColor = .label
//        reviewTextLabel.numberOfLines = 0
//        reviewTextLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(reviewTextLabel)
//
//        mediaImageView.contentMode = .scaleAspectFill
//        mediaImageView.clipsToBounds = true
//        mediaImageView.layer.cornerRadius = 8
//        mediaImageView.isHidden = true
//        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(mediaImageView)
//
//        videoPlayerView.backgroundColor = .black
//        videoPlayerView.layer.cornerRadius = 8
//        videoPlayerView.isHidden = true
//        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(videoPlayerView)
//
//        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
//        playButton.tintColor = .white
//        playButton.translatesAutoresizingMaskIntoConstraints = false
//        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
//        videoPlayerView.addSubview(playButton)
//
//        NSLayoutConstraint.activate([
//            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
//            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
//
//            timestampLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
//            timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
//
//            reviewTextLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 12),
//            reviewTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            reviewTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
//
//            mediaImageView.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor, constant: 12),
//            mediaImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            mediaImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
//            mediaImageView.heightAnchor.constraint(equalToConstant: 200),
//
//            videoPlayerView.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor, constant: 12),
//            videoPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
//            videoPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
//            videoPlayerView.heightAnchor.constraint(equalToConstant: 200),
//
//            playButton.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor),
//            playButton.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor),
//            playButton.widthAnchor.constraint(equalToConstant: 50),
//            playButton.heightAnchor.constraint(equalToConstant: 50),
//
//            bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: 12),
//            bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 12)
//        ])
//    }
//
//    private func configure(with review: MonumaticFinalViewController.Review) {
//        userNameLabel.text = review.userName
//        timestampLabel.text = review.timestamp.dateValue().formatted()
//        reviewTextLabel.text = review.reviewText
//
//        if let imageUrl = review.imageUrl, let url = URL(string: imageUrl) {
//            mediaImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
//            mediaImageView.isHidden = false
//            videoPlayerView.isHidden = true
//        } else if review.videoUrl != nil {
//            mediaImageView.isHidden = true
//            videoPlayerView.isHidden = false
//        } else {
//            mediaImageView.isHidden = true
//            videoPlayerView.isHidden = true
//        }
//    }
//
//    @objc private func playVideo() {
//        guard let review = review,
//              let videoUrl = review.videoUrl,
//              let url = URL(string: videoUrl) else {
//            return
//        }
//
//        let player = AVPlayer(url: url)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//
//        if let parentViewController = self.parentViewController {
//            parentViewController.present(playerViewController, animated: true) {
//                player.play()
//            }
//        }
//    }
//}
//
//// MARK: - Helper Extension to Find Parent View Controller
//extension UIView {
//    var parentViewController: UIViewController? {
//        var parentResponder: UIResponder? = self
//        while parentResponder != nil {
//            parentResponder = parentResponder?.next
//            if let viewController = parentResponder as? UIViewController {
//                return viewController
//            }
//        }
//        return nil
//    }
//}
//
//#Preview {
//    MonumaticFinalViewController()
//}

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth
import GoogleSignIn
import AVFoundation
import AVKit
import SDWebImage

class MonumaticFinalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    let monumentImageView = UIImageView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    let audioGuideButton = UIButton()
    let talkWithAIButton = UIButton()
    let segmentedControl = UISegmentedControl(items: ["Brief Synthesis", "Anecdotes"])
    let descriptionTextView = UITextView()
    let reviewsLabel = UILabel()
    let addReviewButton = UIButton()
    let reviewsStackView = UIStackView()

    // Firestore
    let db = Firestore.firestore()
    var monumentId: String?
    var monumentData: [String: Any]?
    var reviews: [Review] = []

    // Image/Video Picker
    let imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var selectedVideoURL: URL?

    // Audio
    let speechSynthesizer = AVSpeechSynthesizer()

    struct Review {
        let reviewText: String
        let userName: String
        let timestamp: Timestamp
        let imageUrl: String?
        let videoUrl: String?
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMonumentData()
        setupImagePicker()

        // Add tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Ensure it doesn't interfere with other touches
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        loadProfilePicture() // Reload the profile picture when the view appears
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        monumentImageView.contentMode = .scaleAspectFill
        monumentImageView.clipsToBounds = true
        monumentImageView.layer.cornerRadius = 12
        monumentImageView.layer.shadowColor = UIColor.black.cgColor
        monumentImageView.layer.shadowOpacity = 0.3
        monumentImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
        monumentImageView.layer.shadowRadius = 4
        monumentImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(monumentImageView)

        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        locationLabel.textColor = .gray
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationLabel)

        audioGuideButton.setTitle("Audio Guide", for: .normal)
        audioGuideButton.backgroundColor = .systemBlue
        audioGuideButton.layer.cornerRadius = 8
        audioGuideButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(audioGuideButton)
        audioGuideButton.addTarget(self, action: #selector(playAudioGuide), for: .touchUpInside)

        talkWithAIButton.setTitle("Talk with AI", for: .normal)
        talkWithAIButton.backgroundColor = .systemPurple
        talkWithAIButton.layer.cornerRadius = 8
        talkWithAIButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(talkWithAIButton)
        talkWithAIButton.addTarget(self, action: #selector(talkWithAI), for: .touchUpInside)

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)

        descriptionTextView.isEditable = false
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.textColor = .darkGray
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionTextView)

        reviewsLabel.text = "Customer Reviews"
        reviewsLabel.font = UIFont.boldSystemFont(ofSize: 20)
        reviewsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reviewsLabel)

        addReviewButton.setTitle("Add Review", for: .normal)
        addReviewButton.backgroundColor = .systemGreen
        addReviewButton.layer.cornerRadius = 8
        addReviewButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(addReviewButton)
        addReviewButton.addTarget(self, action: #selector(openAddReview), for: .touchUpInside)

        reviewsStackView.axis = .vertical
        reviewsStackView.spacing = 16
        reviewsStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(reviewsStackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            monumentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            monumentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            monumentImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            monumentImageView.heightAnchor.constraint(equalToConstant: 200),

            nameLabel.topAnchor.constraint(equalTo: monumentImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            audioGuideButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            audioGuideButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            audioGuideButton.widthAnchor.constraint(equalToConstant: 150),
            audioGuideButton.heightAnchor.constraint(equalToConstant: 40),

            talkWithAIButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            talkWithAIButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            talkWithAIButton.widthAnchor.constraint(equalToConstant: 150),
            talkWithAIButton.heightAnchor.constraint(equalToConstant: 40),

            segmentedControl.topAnchor.constraint(equalTo: audioGuideButton.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            descriptionTextView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 150),

            reviewsLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 20),
            reviewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reviewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            addReviewButton.topAnchor.constraint(equalTo: reviewsLabel.bottomAnchor, constant: 20),
            addReviewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addReviewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addReviewButton.heightAnchor.constraint(equalToConstant: 50),

            reviewsStackView.topAnchor.constraint(equalTo: addReviewButton.bottomAnchor, constant: 20),
            reviewsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reviewsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reviewsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }

    // MARK: - Update UI
    private func updateUI() {
        guard let data = monumentData else { return }
        
        nameLabel.text = data["name"] as? String
        locationLabel.text = data["location"] as? String
        
        if let imageUrl = data["imageUrl"] as? String, let url = URL(string: imageUrl) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.monumentImageView.image = UIImage(data: imageData)
                    }
                }
            }
        }
        
        segmentChanged()
    }

    // MARK: - Fetch Monument Data
    private func fetchMonumentData() {
        guard let monumentId = monumentId else { return }
        
        db.collection("monuments_final").document(monumentId).getDocument { [weak self] (document, error) in
            guard let self = self, let document = document, document.exists else {
                print("Monument document not found")
                return
            }
            
            self.monumentData = document.data()
            self.updateUI()
            self.fetchReviews()
        }
    }

    // MARK: - Fetch Reviews
    private func fetchReviews() {
        guard let monumentId = monumentId else { return }
        
        db.collection("monuments_final").document(monumentId).collection("reviews")
            .order(by: "timestamp", descending: true)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard let self = self, let documents = querySnapshot?.documents else { return }
                
                self.reviews = documents.compactMap { document in
                    let data = document.data()
                    return Review(
                        reviewText: data["reviewText"] as? String ?? "",
                        userName: data["userName"] as? String ?? "Anonymous",
                        timestamp: data["timestamp"] as? Timestamp ?? Timestamp(),
                        imageUrl: data["imageUrl"] as? String,
                        videoUrl: data["videoUrl"] as? String
                    )
                }
                
                self.updateReviewsUI()
            }
    }

    // MARK: - Update Reviews UI
    private func updateReviewsUI() {
        reviewsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for review in reviews {
            let reviewView = ReviewView(review: review)
            reviewsStackView.addArrangedSubview(reviewView)
        }
    }

    // MARK: - Segment Changed
    @objc private func segmentChanged() {
        guard let data = monumentData else { return }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            descriptionTextView.text = data["briefSynthesis"] as? String
        } else {
            descriptionTextView.text = data["anecdotes"] as? String
        }
    }

    // MARK: - Open Add Review
    @objc private func openAddReview() {
        let addReviewVC = AddReviewViewController()
        addReviewVC.delegate = self
        self.present(addReviewVC, animated: true, completion: nil)
    }

    // MARK: - Save Review
    func saveReview(reviewText: String, image: UIImage?, videoURL: URL?) {
        guard let monumentId = monumentId, let user = Auth.auth().currentUser else { return }
        
        let reviewData: [String: Any] = [
            "reviewText": reviewText,
            "userName": user.displayName ?? "Anonymous",
            "timestamp": Timestamp(date: Date()),
            "imageUrl": "",
            "videoUrl": ""
        ]
        
        let reviewRef = db.collection("monuments_final").document(monumentId).collection("reviews").document()
        
        if let image = image {
            uploadImage(image) { imageUrl in
                reviewRef.setData(reviewData.merging(["imageUrl": imageUrl], uniquingKeysWith: { $1 })) { error in
                    if let error = error {
                        print("Error adding review: \(error)")
                    } else {
                        self.fetchReviews()
                    }
                }
            }
        } else if let videoURL = videoURL {
            uploadVideo(videoURL) { videoUrl in
                reviewRef.setData(reviewData.merging(["videoUrl": videoUrl], uniquingKeysWith: { $1 })) { error in
                    if let error = error {
                        print("Error adding review: \(error)")
                    } else {
                        self.fetchReviews()
                    }
                }
            }
        } else {
            reviewRef.setData(reviewData) { error in
                if let error = error {
                    print("Error adding review: \(error)")
                } else {
                    self.fetchReviews()
                }
            }
        }
    }

    // MARK: - Upload Image
    private func uploadImage(_ image: UIImage, completion: @escaping (String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let storageRef = Storage.storage().reference().child("review_images/\(UUID().uuidString).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url.absoluteString)
                }
            }
        }
    }

    // MARK: - Upload Video
    private func uploadVideo(_ videoURL: URL, completion: @escaping (String) -> Void) {
        let storageRef = Storage.storage().reference().child("review_videos/\(UUID().uuidString).mp4")
        storageRef.putFile(from: videoURL, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading video: \(error)")
                return
            }
            
            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(url.absoluteString)
                }
            }
        }
    }

    // MARK: - Image Picker
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
        } else if let videoURL = info[.mediaURL] as? URL {
            selectedVideoURL = videoURL
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Play Audio Guide
    @objc private func playAudioGuide() {
        guard let audioguideText = monumentData?["audioguide"] as? String else { return }
        let speechUtterance = AVSpeechUtterance(string: audioguideText)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        speechSynthesizer.speak(speechUtterance)
    }

    // MARK: - Talk with AI
    @objc private func talkWithAI() {
        guard let data = monumentData,
              let name = data["name"] as? String else {
            let alert = UIAlertController(title: "Error", message: "Monument data not available.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let chatbotVC = ChatbotViewController(monumentName: name)
        if let navController = navigationController {
            navController.pushViewController(chatbotVC, animated: true)
        } else {
            self.present(chatbotVC, animated: true, completion: nil)
        }
    }
}

// MARK: - AddReviewViewController
class AddReviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var delegate: MonumaticFinalViewController?

    private let reviewTextView = UITextView()
    private let addImageButton = UIButton()
    private let addVideoButton = UIButton()
    private let submitButton = UIButton()
    private let cancelButton = UIButton()
    private let imagePicker = UIImagePickerController()

    private var selectedImage: UIImage?
    private var selectedVideoURL: URL?

    // Container to display selected media
    private let mediaContainerView = UIView()
    private let mediaImageView = UIImageView()
    private let removeMediaButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupImagePicker()

        // Add tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // Ensure it doesn't interfere with other touches
        view.addGestureRecognizer(tapGesture)
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Review Text View
        reviewTextView.layer.borderColor = UIColor.lightGray.cgColor
        reviewTextView.layer.borderWidth = 1.0
        reviewTextView.layer.cornerRadius = 8.0
        reviewTextView.font = UIFont.systemFont(ofSize: 16)
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(reviewTextView)

        // Add Image Button
        addImageButton.setTitle("Add Image", for: .normal)
        addImageButton.backgroundColor = .systemBlue
        addImageButton.layer.cornerRadius = 8
        addImageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addImageButton)
        addImageButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)

        // Add Video Button
        addVideoButton.setTitle("Add Video", for: .normal)
        addVideoButton.backgroundColor = .systemPurple
        addVideoButton.layer.cornerRadius = 8
        addVideoButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addVideoButton)
        addVideoButton.addTarget(self, action: #selector(openVideoPicker), for: .touchUpInside)

        // Submit Button
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemGreen
        submitButton.layer.cornerRadius = 8
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(submitReview), for: .touchUpInside)

        // Cancel Button
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.layer.cornerRadius = 8
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(cancelReview), for: .touchUpInside)

        // Media Container View
        mediaContainerView.isHidden = true // Initially hidden
        mediaContainerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mediaContainerView)

        // Media Image View
        mediaImageView.contentMode = .scaleAspectFit
        mediaImageView.layer.cornerRadius = 8
        mediaImageView.clipsToBounds = true
        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
        mediaContainerView.addSubview(mediaImageView)

        // Remove Media Button
        removeMediaButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        removeMediaButton.tintColor = .red
        removeMediaButton.translatesAutoresizingMaskIntoConstraints = false
        removeMediaButton.addTarget(self, action: #selector(removeMedia), for: .touchUpInside)
        mediaContainerView.addSubview(removeMediaButton)

        // Constraints
        NSLayoutConstraint.activate([
            reviewTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            reviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            reviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            reviewTextView.heightAnchor.constraint(equalToConstant: 150),

            addImageButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20),
            addImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addImageButton.widthAnchor.constraint(equalToConstant: 150),
            addImageButton.heightAnchor.constraint(equalToConstant: 40),

            addVideoButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20),
            addVideoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addVideoButton.widthAnchor.constraint(equalToConstant: 150),
            addVideoButton.heightAnchor.constraint(equalToConstant: 40),

            mediaContainerView.topAnchor.constraint(equalTo: addImageButton.bottomAnchor, constant: 20),
            mediaContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mediaContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mediaContainerView.heightAnchor.constraint(equalToConstant: 200),

            mediaImageView.topAnchor.constraint(equalTo: mediaContainerView.topAnchor),
            mediaImageView.leadingAnchor.constraint(equalTo: mediaContainerView.leadingAnchor),
            mediaImageView.trailingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor),
            mediaImageView.bottomAnchor.constraint(equalTo: mediaContainerView.bottomAnchor),

            removeMediaButton.topAnchor.constraint(equalTo: mediaContainerView.topAnchor, constant: 10),
            removeMediaButton.trailingAnchor.constraint(equalTo: mediaContainerView.trailingAnchor, constant: -10),
            removeMediaButton.widthAnchor.constraint(equalToConstant: 30),
            removeMediaButton.heightAnchor.constraint(equalToConstant: 30),

            submitButton.topAnchor.constraint(equalTo: mediaContainerView.bottomAnchor, constant: 20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50),

            cancelButton.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]
    }

    @objc private func openImagePicker() {
        imagePicker.mediaTypes = ["public.image"]
        self.present(imagePicker, animated: true, completion: nil)
    }

    @objc private func openVideoPicker() {
        imagePicker.mediaTypes = ["public.movie"]
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            selectedVideoURL = nil
            mediaImageView.image = image
            mediaContainerView.isHidden = false
        } else if let videoURL = info[.mediaURL] as? URL {
            selectedVideoURL = videoURL
            selectedImage = nil
            mediaImageView.image = UIImage(systemName: "play.circle.fill") // Placeholder for video
            mediaContainerView.isHidden = false
        }
        
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @objc private func removeMedia() {
        selectedImage = nil
        selectedVideoURL = nil
        mediaImageView.image = nil
        mediaContainerView.isHidden = true
    }

    @objc private func submitReview() {
        guard let reviewText = reviewTextView.text, !reviewText.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please enter a review.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }

        delegate?.saveReview(reviewText: reviewText, image: selectedImage, videoURL: selectedVideoURL)
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func cancelReview() {
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true) // Dismiss the keyboard
    }
}

// MARK: - ReviewView
class ReviewView: UIView {
    private let userNameLabel = UILabel()
    private let timestampLabel = UILabel()
    private let reviewTextLabel = UILabel()
    private let mediaImageView = UIImageView()
    private let videoPlayerView = UIView()
    private let playButton = UIButton()

    private var review: MonumaticFinalViewController.Review?

    init(review: MonumaticFinalViewController.Review) {
        self.review = review
        super.init(frame: .zero)
        setupUI()
        configure(with: review)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        userNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        userNameLabel.textColor = .label
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(userNameLabel)

        timestampLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        timestampLabel.textColor = .gray
        timestampLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timestampLabel)

        reviewTextLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        reviewTextLabel.textColor = .label
        reviewTextLabel.numberOfLines = 0
        reviewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(reviewTextLabel)

        mediaImageView.contentMode = .scaleAspectFill
        mediaImageView.clipsToBounds = true
        mediaImageView.layer.cornerRadius = 8
        mediaImageView.isHidden = true
        mediaImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mediaImageView)

        videoPlayerView.backgroundColor = .black
        videoPlayerView.layer.cornerRadius = 8
        videoPlayerView.isHidden = true
        videoPlayerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(videoPlayerView)

        playButton.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        playButton.tintColor = .white
        playButton.translatesAutoresizingMaskIntoConstraints = false
        playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        videoPlayerView.addSubview(playButton)

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            timestampLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            timestampLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            timestampLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            reviewTextLabel.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 12),
            reviewTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            reviewTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),

            mediaImageView.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor, constant: 12),
            mediaImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mediaImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mediaImageView.heightAnchor.constraint(equalToConstant: 200),

            videoPlayerView.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor, constant: 12),
            videoPlayerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            videoPlayerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            videoPlayerView.heightAnchor.constraint(equalToConstant: 200),

            playButton.centerXAnchor.constraint(equalTo: videoPlayerView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: videoPlayerView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50),

            bottomAnchor.constraint(equalTo: mediaImageView.bottomAnchor, constant: 12),
            bottomAnchor.constraint(equalTo: videoPlayerView.bottomAnchor, constant: 12)
        ])
    }

    private func configure(with review: MonumaticFinalViewController.Review) {
        userNameLabel.text = review.userName
        timestampLabel.text = review.timestamp.dateValue().formatted()
        reviewTextLabel.text = review.reviewText

        if let imageUrl = review.imageUrl, let url = URL(string: imageUrl) {
            mediaImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            mediaImageView.isHidden = false
            videoPlayerView.isHidden = true
        } else if review.videoUrl != nil {
            mediaImageView.isHidden = true
            videoPlayerView.isHidden = false
        } else {
            mediaImageView.isHidden = true
            videoPlayerView.isHidden = true
        }
    }

    @objc private func playVideo() {
        guard let review = review,
              let videoUrl = review.videoUrl,
              let url = URL(string: videoUrl) else {
            return
        }

        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        if let parentViewController = self.parentViewController {
            parentViewController.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }
}

// MARK: - Helper Extension to Find Parent View Controller
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

#Preview {
    MonumaticFinalViewController()
}
