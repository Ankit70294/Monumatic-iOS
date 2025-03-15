//import UIKit
//import FirebaseAuth
//import UserNotifications
//import CoreLocation
//import AVFoundation
//import GoogleSignIn
//import FirebaseCore
//
//class SignUpViewController: UIViewController {
//
//    private let emailTextField = UITextField()
//    private let passwordTextField = UITextField()
//    private let locationManager = CLLocationManager()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//
//    private func setupUI() {
//        view.backgroundColor = .white
//
//        let titleLabel = UILabel()
//        titleLabel.text = "Sign Up"
//        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
//        titleLabel.textAlignment = .center
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(titleLabel)
//
//        emailTextField.placeholder = "Email"
//        emailTextField.borderStyle = .roundedRect
//        emailTextField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(emailTextField)
//
//        passwordTextField.placeholder = "Password"
//        passwordTextField.borderStyle = .roundedRect
//        passwordTextField.isSecureTextEntry = true
//        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(passwordTextField)
//
//        let signUpButton = UIButton(type: .system)
//        signUpButton.setTitle("Sign Up", for: .normal)
//        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
//        signUpButton.backgroundColor = .systemBlue
//        signUpButton.setTitleColor(.white, for: .normal)
//        signUpButton.layer.cornerRadius = 10
//        signUpButton.translatesAutoresizingMaskIntoConstraints = false
//        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
//        view.addSubview(signUpButton)
//        
//        let googleSignInButton = GIDSignInButton()
//        googleSignInButton.translatesAutoresizingMaskIntoConstraints = false
//        googleSignInButton.addTarget(self, action: #selector(googleSignInTapped), for: .touchUpInside)
//        view.addSubview(googleSignInButton)
//
//        NSLayoutConstraint.activate([
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
//
//            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
//            emailTextField.widthAnchor.constraint(equalToConstant: 300),
//            emailTextField.heightAnchor.constraint(equalToConstant: 40),
//
//            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
//            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
//            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
//
//            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
//            signUpButton.widthAnchor.constraint(equalToConstant: 200),
//            signUpButton.heightAnchor.constraint(equalToConstant: 50),
//            
//            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            googleSignInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),
//            googleSignInButton.widthAnchor.constraint(equalToConstant: 200),
//            googleSignInButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//
//    @objc private func signUpTapped() {
//        guard let email = emailTextField.text, !email.isEmpty,
//              let password = passwordTextField.text, !password.isEmpty else {
//            showAlert(message: "Please fill in all fields")
//            return
//        }
//
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
//            guard let self = self else { return }
//            if let error = error {
//                self.showAlert(message: error.localizedDescription)
//            } else {
//                // Request permissions after successful sign-up
//                self.requestNotificationPermission()
//                self.requestLocationPermission()
//                self.requestCameraPermission()
//                self.requestMicrophonePermission()
//
//                // Navigate to the main app screen
//                self.navigateToTabBar()
//            }
//        }
//    }
//    
//    @objc private func googleSignInTapped() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
//            guard let self = self else { return }
//
//            if let error = error {
//                self.showAlert(message: error.localizedDescription)
//                return
//            }
//
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString else {
//                self.showAlert(message: "Google Sign-In failed.")
//                return
//            }
//
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
//
//            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
//                guard let self = self else { return }
//
//                if let error = error {
//                    self.showAlert(message: error.localizedDescription)
//                } else {
//                    // Fetch the Google profile picture URL
//                    if let profile = user.profile, let profileImageURL = profile.imageURL(withDimension: 100) {
//                        // Save the profile picture URL to UserDefaults or a shared instance
//                        UserDefaults.standard.set(profileImageURL.absoluteString, forKey: "profileImageURL")
//                    }
//
//                    // Navigate to the main app screen
//                    self.navigateToTabBar()
//                }
//            }
//        }
//    }
//    
//    private func requestNotificationPermission() {
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if granted {
//                print("Notification permission granted.")
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            } else if let error = error {
//                print("Notification permission error: \(error.localizedDescription)")
//            }
//        }
//    }
//
//    private func requestLocationPermission() {
//        locationManager.requestWhenInUseAuthorization()
//    }
//
//    private func requestCameraPermission() {
//        AVCaptureDevice.requestAccess(for: .video) { granted in
//            if granted {
//                print("Camera permission granted.")
//            } else {
//                print("Camera permission denied.")
//            }
//        }
//    }
//
//    private func requestMicrophonePermission() {
//        if #available(iOS 17.0, *) {
//            AVAudioApplication.requestRecordPermission { granted in
//                if granted {
//                    print("Microphone permission granted.")
//                } else {
//                    print("Microphone permission denied.")
//                }
//            }
//        } else {
//            // Fallback for earlier versions
//            AVAudioSession.sharedInstance().requestRecordPermission { granted in
//                if granted {
//                    print("Microphone permission granted.")
//                } else {
//                    print("Microphone permission denied.")
//                }
//            }
//        }
//    }
//    
//    private func showAlert(message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alert, animated: true, completion: nil)
//    }
//    
//    private func navigateToTabBar() {
//        // Access the SceneDelegate and call goToTabBar()
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//            sceneDelegate.goToTabBar()
//        }
//    }
//}
//
//#Preview{
//    SignUpViewController()
//}

import UIKit
import FirebaseAuth
import UserNotifications
import CoreLocation
import AVFoundation
import GoogleSignIn
import FirebaseCore

class SignUpViewController: UIViewController {

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .white

        let titleLabel = UILabel()
        titleLabel.text = "Sign Up"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)

        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)

        let signUpButton = UIButton(type: .system)
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        signUpButton.backgroundColor = .white
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.layer.cornerRadius = 10
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.systemGray.cgColor
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        view.addSubview(signUpButton)

        let orLabel = UILabel()
        orLabel.text = "or continue with Google"
        orLabel.textColor = .gray
        orLabel.font = UIFont.systemFont(ofSize: 16)
        orLabel.textAlignment = .center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(orLabel)

        // Custom Google Sign-Up Button
        let googleSignUpButton = UIButton(type: .system)
        googleSignUpButton.setTitle("Sign Up with Google", for: .normal)
        googleSignUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        googleSignUpButton.backgroundColor = .white
        googleSignUpButton.setTitleColor(.black, for: .normal)
        googleSignUpButton.layer.cornerRadius = 10
        googleSignUpButton.layer.borderWidth = 1
        googleSignUpButton.layer.borderColor = UIColor.systemGray.cgColor
        googleSignUpButton.translatesAutoresizingMaskIntoConstraints = false
        googleSignUpButton.addTarget(self, action: #selector(googleSignUpTapped), for: .touchUpInside)
        view.addSubview(googleSignUpButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),

            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailTextField.widthAnchor.constraint(equalToConstant: 300),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            signUpButton.widthAnchor.constraint(equalToConstant: 200),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),

            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orLabel.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20),

            googleSignUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignUpButton.topAnchor.constraint(equalTo: orLabel.bottomAnchor, constant: 20),
            googleSignUpButton.widthAnchor.constraint(equalToConstant: 200),
            googleSignUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func signUpTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill in all fields")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                // Request permissions after successful sign-up
                self.requestNotificationPermission()
                self.requestLocationPermission()
                self.requestCameraPermission()
                self.requestMicrophonePermission()

                // Navigate to the main app screen
                self.navigateToTabBar()
            }
        }
    }
    
    @objc private func googleSignUpTapped() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }

            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                self.showAlert(message: "Google Sign-Up failed.")
                return
            }

            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let self = self else { return }

                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    // Fetch the Google profile picture URL
                    if let profile = user.profile, let profileImageURL = profile.imageURL(withDimension: 100) {
                        // Save the profile picture URL to UserDefaults or a shared instance
                        UserDefaults.standard.set(profileImageURL.absoluteString, forKey: "profileImageURL")
                    }

                    // Navigate to the main app screen
                    self.navigateToTabBar()
                }
            }
        }
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("Camera permission granted.")
            } else {
                print("Camera permission denied.")
            }
        }
    }

    private func requestMicrophonePermission() {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission { granted in
                if granted {
                    print("Microphone permission granted.")
                } else {
                    print("Microphone permission denied.")
                }
            }
        } else {
            // Fallback for earlier versions
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                if granted {
                    print("Microphone permission granted.")
                } else {
                    print("Microphone permission denied.")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func navigateToTabBar() {
        // Access the SceneDelegate and call goToTabBar()
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.goToTabBar()
        }
    }
}

#Preview{
    SignUpViewController()
}
