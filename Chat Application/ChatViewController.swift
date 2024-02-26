import UIKit
import SocketIO

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var manager: SocketManager!
    var socket: SocketIOClient!
    var messages: [[String: String]] = []
    var userName: String?

    private var tableView: UITableView!
    private var messageInputField: UITextField!
    private var sendButton: UIButton!

    var hasPromptedForUsername = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSocket()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasPromptedForUsername {
            promptForUserName()
            hasPromptedForUsername = true
        }
    }

    func setupSocket() {
        manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
        socket = manager.defaultSocket

        socket.on(clientEvent: .connect) { data, ack in
            print("socket connected")
        }
       
        socket.on("message") { data, ack in
            if let msgData = data[0] as? [String: String], let msg = msgData["text"], let sender = msgData["senderName"] {
                DispatchQueue.main.async {
                    self.messages.append(["text": msg, "senderName": sender])
                    print("Updated messages: \(self.messages)")
                    self.tableView.reloadData()
                }
            }
        }

        socket.connect()
    }

    func promptForUserName() {
        let alertController = UIAlertController(title: "Enter Your Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Name"
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [unowned alertController] _ in
            let textField = alertController.textFields![0]
            if let name = textField.text, !name.isEmpty {
                self.userName = name
            } else {
                self.userName = "Anonymous"
            }
            self.setupSocket()
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true)
    }

    func setupUI() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)

        messageInputField = UITextField()
        messageInputField.borderStyle = .roundedRect
        view.addSubview(messageInputField)

        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        view.addSubview(sendButton)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor, constant: -8),

            messageInputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            messageInputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            messageInputField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            messageInputField.heightAnchor.constraint(equalToConstant: 50),

            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 80),
            sendButton.heightAnchor.constraint(equalTo: messageInputField.heightAnchor)
        ])
    }

    @objc func sendMessage() {
        if let message = messageInputField.text, !message.isEmpty, let senderName = self.userName {
            let messageData = ["room": "room1", "message": message, "senderName": senderName]
            socket.emit("chatMessage", messageData)
            messageInputField.text = "" // Clear the text field
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        let message = messages[indexPath.row]
        cell.textLabel?.text = message["text"]
        cell.detailTextLabel?.text = message["senderName"]
        return cell
    }
}
