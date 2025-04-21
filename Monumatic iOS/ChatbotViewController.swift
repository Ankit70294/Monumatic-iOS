//import UIKit
//
//class ChatbotViewController: UIViewController, UITextFieldDelegate {
//    
//    // MARK: - Properties
//    private let monumentName: String
//    private let apiKey: String = "AIzaSyChTHVJgMnm5m8i-nlD7I2x6UyPgPWZ0c4" // Replace with your actual Gemini API key
//    private var messages: [(sender: String, text: String)] = []
//    
//    private let chatTableView = UITableView()
//    private let messageTextField = UITextField()
//    private let sendButton = UIButton()
//    
//    // MARK: - Initialization
//    init(monumentName: String) {
//        self.monumentName = monumentName
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        configureTableView()
//        title = "Talk with AI about \(monumentName)"
//        
//        messages.append((sender: "AI", text: "Hello! I’m here to help you with any questions about the \(monumentName). Ask away!"))
//        chatTableView.reloadData()
//    }
//    
//    // MARK: - Setup UI
//    private func setupUI() {
//        view.backgroundColor = .white
//        
//        chatTableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(chatTableView)
//        
//        messageTextField.placeholder = "Type your question..."
//        messageTextField.borderStyle = .roundedRect
//        messageTextField.delegate = self
//        messageTextField.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(messageTextField)
//        
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.backgroundColor = .systemBlue
//        sendButton.layer.cornerRadius = 8
//        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(sendButton)
//        
//        NSLayoutConstraint.activate([
//            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            chatTableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -10),
//            
//            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
//            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
//            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
//            messageTextField.heightAnchor.constraint(equalToConstant: 40),
//            
//            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor),
//            sendButton.widthAnchor.constraint(equalToConstant: 60),
//            sendButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
//    
//    // MARK: - Configure Table View
//    private func configureTableView() {
//        chatTableView.delegate = self
//        chatTableView.dataSource = self
//        chatTableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
//    }
//    
//    // MARK: - Send Message
//    @objc private func sendMessage() {
//        guard let message = messageTextField.text, !message.isEmpty else { return }
//        
//        messages.append((sender: "User", text: message))
//        messageTextField.text = ""
//        chatTableView.reloadData()
//        scrollToBottom()
//        
//        fetchGeminiResponse(for: message) { [weak self] response in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                self.messages.append((sender: "AI", text: response))
//                self.chatTableView.reloadData()
//                self.scrollToBottom()
//            }
//        }
//    }
//    
//    // MARK: - Fetch Gemini API Response
//    private func fetchGeminiResponse(for question: String, completion: @escaping (String) -> Void) {
//        // Updated model name to gemini-1.5-flash
//        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)"
//        guard let url = URL(string: urlString) else {
//            completion("Error: Invalid URL for Gemini API.")
//            return
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let systemPrompt = "You are an expert on the \(monumentName). Answer questions only about the \(monumentName) and its history, architecture, location, significance, or related topics. If the question is unrelated, politely redirect the user to ask about the \(monumentName)."
//        
//        let body: [String: Any] = [
//            "contents": [
//                [
//                    "role": "user",
//                    "parts": [
//                        ["text": systemPrompt]
//                    ]
//                ],
//                [
//                    "role": "user",
//                    "parts": [
//                        ["text": question]
//                    ]
//                ]
//            ],
//            "generationConfig": [
//                "maxOutputTokens": 500,
//                "temperature": 0.7
//            ]
//        ]
//        
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("API Error: \(error)")
//                completion("Sorry, I couldn’t fetch a response. Try again!")
//                return
//            }
//            
//            guard let data = data else {
//                completion("Error: No data received from the API.")
//                return
//            }
//            
//            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
//            
//            // Check for success response
//            if let candidates = json?["candidates"] as? [[String: Any]],
//               let firstCandidate = candidates.first,
//               let content = firstCandidate["content"] as? [String: Any],
//               let parts = content["parts"] as? [[String: Any]],
//               let firstPart = parts.first,
//               let text = firstPart["text"] as? String {
//                completion(text)
//                return
//            }
//            
//            // Handle error response
//            if let errorDict = json?["error"] as? [String: Any],
//               let errorMessage = errorDict["message"] as? String {
//                print("Gemini API Error: \(errorMessage)")
//                completion("Error: \(errorMessage)")
//                // Attempt to list models if the model is not found
//                self.listAvailableModels { modelList in
//                    print("Available models: \(modelList)")
//                }
//            } else {
//                completion("Sorry, I couldn’t process that. Ask me something else about the \(self.monumentName)!")
//            }
//        }
//        task.resume()
//    }
//    
//    // MARK: - List Available Models
//    private func listAvailableModels(completion: @escaping ([String]) -> Void) {
//        let urlString = "https://generativelanguage.googleapis.com/v1beta/models?key=\(apiKey)"
//        guard let url = URL(string: urlString) else {
//            completion([])
//            return
//        }
//        
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data,
//               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//               let models = json["models"] as? [[String: Any]] {
//                let modelNames = models.compactMap { $0["name"] as? String }
//                completion(modelNames)
//            } else {
//                completion([])
//            }
//        }
//        task.resume()
//    }
//    
//    // MARK: - Scroll to Bottom
//    private func scrollToBottom() {
//        let indexPath = IndexPath(row: messages.count - 1, section: 0)
//        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
//    }
//    
//    // MARK: - Text Field Delegate
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        sendMessage()
//        return true
//    }
//}
//
//// MARK: - Table View Data Source & Delegate
//extension ChatbotViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
//        let message = messages[indexPath.row]
//        cell.configure(with: message.text, isUser: message.sender == "User")
//        return cell
//    }
//}
//
//// MARK: - Chat Message Cell
//class ChatMessageCell: UITableViewCell {
//    private let messageLabel = PaddedLabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupUI() {
//        messageLabel.numberOfLines = 0
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(messageLabel)
//        
//        NSLayoutConstraint.activate([
//            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
//            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
//            messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
//            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
//        ])
//    }
//    
//    func configure(with message: String, isUser: Bool) {
//        messageLabel.text = message
//        messageLabel.textAlignment = isUser ? .right : .left
//        messageLabel.textColor = isUser ? .white : .black
//        messageLabel.backgroundColor = isUser ? .systemBlue : .systemGray5
//        messageLabel.layer.cornerRadius = 8
//        messageLabel.clipsToBounds = true
//    }
//}
//
//// MARK: - Padded Label Subclass
//class PaddedLabel: UILabel {
//    private var paddingInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
//
//    override func drawText(in rect: CGRect) {
//        let insetRect = rect.inset(by: paddingInsets)
//        super.drawText(in: insetRect)
//    }
//
//    override var intrinsicContentSize: CGSize {
//        let size = super.intrinsicContentSize
//        return CGSize(width: size.width + paddingInsets.left + paddingInsets.right,
//                      height: size.height + paddingInsets.top + paddingInsets.bottom)
//    }
//}

// ChatbotViewController.swift
import UIKit

class ChatbotViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    private let monumentName: String
    private let apiKey: String = "AIzaSyChTHVJgMnm5m8i-nlD7I2x6UyPgPWZ0c4"
    private var messages: [(sender: String, text: String)] = []
    
    private let chatTableView = UITableView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton()
    
    // MARK: - Initialization
    init(monumentName: String) {
        self.monumentName = monumentName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTableView()
        title = "Talk with AI about \(monumentName)"
        
        messages.append((sender: "AI", text: "Hello! I’m here to help you with any questions about the \(monumentName). Ask away!"))
        chatTableView.reloadData()
        
        // Add tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Add observer for text field changes
        messageTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chatTableView)
        
        messageTextField.placeholder = "Type your question..."
        messageTextField.borderStyle = .roundedRect
        messageTextField.delegate = self
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageTextField)
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .systemBlue
        sendButton.layer.cornerRadius = 8
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chatTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -10),
            
            messageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            messageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
            messageTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            messageTextField.heightAnchor.constraint(equalToConstant: 40),
            
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sendButton.centerYAnchor.constraint(equalTo: messageTextField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    // MARK: - Configure Table View
    private func configureTableView() {
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 44.0
    }
    
    // MARK: - Text Field Handling
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            // Remove any existing typing message
            messages.removeAll { $0.sender == "User" && $0.text.hasPrefix("Typing:") }
            messages.append((sender: "User", text: "Typing: \(text)"))
            chatTableView.reloadData()
            scrollToBottom()
        }
    }
    
    // MARK: - Send Message
    @objc private func sendMessage() {
        guard let message = messageTextField.text, !message.isEmpty else { return }
        
        // Remove typing message
        messages.removeAll { $0.sender == "User" && $0.text.hasPrefix("Typing:") }
        messages.append((sender: "User", text: message))
        messageTextField.text = ""
        chatTableView.reloadData()
        scrollToBottom()
        
        fetchGeminiResponse(for: message) { [weak self] response in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.messages.append((sender: "AI", text: response))
                self.chatTableView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    // MARK: - Fetch Gemini API Response
    private func fetchGeminiResponse(for question: String, completion: @escaping (String) -> Void) {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion("Error: Invalid URL for Gemini API.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let systemPrompt = "You are an expert on the \(monumentName). Answer questions only about the \(monumentName) and its history, architecture, location, significance, or related topics. If the question is unrelated, politely redirect the user to ask about the \(monumentName)."
        
        let body: [String: Any] = [
            "contents": [
                [
                    "role": "user",
                    "parts": [
                        ["text": systemPrompt]
                    ]
                ],
                [
                    "role": "user",
                    "parts": [
                        ["text": question]
                    ]
                ]
            ],
            "generationConfig": [
                "maxOutputTokens": 500,
                "temperature": 0.7
            ]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("API Error: \(error)")
                completion("Sorry, I couldn’t fetch a response. Try again!")
                return
            }
            
            guard let data = data else {
                completion("Error: No data received from the API.")
                return
            }
            
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            
            if let candidates = json?["candidates"] as? [[String: Any]],
               let firstCandidate = candidates.first,
               let content = firstCandidate["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let firstPart = parts.first,
               let text = firstPart["text"] as? String {
                completion(text)
                return
            }
            
            if let errorDict = json?["error"] as? [String: Any],
               let errorMessage = errorDict["message"] as? String {
                print("Gemini API Error: \(errorMessage)")
                completion("Error: \(errorMessage)")
                self.listAvailableModels { modelList in
                    print("Available models: \(modelList)")
                }
            } else {
                completion("Sorry, I couldn’t process that. Ask me something else about the \(self.monumentName)!")
            }
        }
        task.resume()
    }
    
    // MARK: - List Available Models
    private func listAvailableModels(completion: @escaping ([String]) -> Void) {
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let models = json["models"] as? [[String: Any]] {
                let modelNames = models.compactMap { $0["name"] as? String }
                completion(modelNames)
            } else {
                completion([])
            }
        }
        task.resume()
    }
    
    // MARK: - Scroll to Bottom
    private func scrollToBottom() {
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - Dismiss Keyboard
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

// MARK: - Table View Data Source & Delegate
extension ChatbotViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.row]
        cell.configure(with: message.text, isUser: message.sender == "User")
        return cell
    }
}

// MARK: - Chat Message Cell
class ChatMessageCell: UITableViewCell {
    private let messageLabel = PaddedLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 15),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -15),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75)
        ])
    }
    
    func configure(with message: String, isUser: Bool) {
        messageLabel.text = message
        messageLabel.textAlignment = isUser ? .right : .left
        messageLabel.textColor = isUser ? .white : .black
        messageLabel.backgroundColor = isUser ? .systemBlue : .systemGray5
        messageLabel.layer.cornerRadius = 8
        messageLabel.clipsToBounds = true
        
        // Adjust constraints based on sender
        messageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = !isUser
        messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15).isActive = isUser
    }
}

// MARK: - Padded Label Subclass
class PaddedLabel: UILabel {
    private var paddingInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)

    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: paddingInsets)
        super.drawText(in: insetRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + paddingInsets.left + paddingInsets.right,
                      height: size.height + paddingInsets.top + paddingInsets.bottom)
    }
}
