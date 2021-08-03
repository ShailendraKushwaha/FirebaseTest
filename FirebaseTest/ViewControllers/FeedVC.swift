//
//  FeedVC.swift
//  FirebaseTest
//
//  Created by SHAILENDRA KUSHWAHA on 24/06/21.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class FeedVC: UIViewController {
    
    // Adding Without Navigation Bar for now
    //Container is in place for navigation bar
    let container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let border: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    let logoLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TEST"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 38)
        return label
    }()
    
    lazy var uploadButton : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(self.didTapOnUploadButton(sender:)), for: .touchUpInside)
        button.setImage(UIImage(named: "button"), for: .normal)
        button.layer.cornerRadius = 22
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var postCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: "post")
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    var imagePicker = UIImagePickerController()
    var chosenImage : UIImage?
    
    let storageRef = Storage.storage().reference().child("test")
    let database   = Firestore.firestore().collection("posts")
    var dbListener:ListenerRegistration?
    
    var posts:[Post] = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        imagePicker.delegate = self
        
        view.addSubview(container)
        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 56).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        container.addSubview(logoLabel)
        logoLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        logoLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        logoLabel.widthAnchor.constraint(equalTo:container.widthAnchor,multiplier: 0.6).isActive = true
        logoLabel.heightAnchor.constraint(equalToConstant:54).isActive = true
        
        container.addSubview(border)
        border.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        border.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        border.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        border.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        
        container.addSubview(uploadButton)
        uploadButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        uploadButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        uploadButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12).isActive = true
        uploadButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 5 ).isActive = true
        
        
        view.addSubview(postCollectionView)
        postCollectionView.topAnchor.constraint(equalTo: container.bottomAnchor,constant: 1).isActive = true
        postCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        postCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postCollectionView.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        getOldPosts()
        self.attatchListenerForNewPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @objc private func didTapOnUploadButton(sender:Any){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .currentContext
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func getOldPosts(){
        
        database.getDocuments(){ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.posts.removeAll()
                for document in querySnapshot!.documents {
                    let doc = document.data()
                    if let json = try? JSONSerialization.data(withJSONObject: doc, options: .prettyPrinted){
                        let post: Post = try! JSONDecoder().decode(Post.self,from:json)
                        self.posts.append(post)
                    }
                }
                self.postCollectionView.reloadData()
//                self.attatchListenerForNewPosts()
            }
        }
    }
    
    private func attatchListenerForNewPosts(){
        
        database.order(by: "timeStamp",descending: false)
        dbListener = database.addSnapshotListener({ (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            self.posts.removeAll()
            for document in snapshot.documents {
                let doc = document.data()
                if let json = try? JSONSerialization.data(withJSONObject: doc, options: .prettyPrinted){
                    let post: Post = try! JSONDecoder().decode(Post.self,from:json)
                    self.posts.append(post)
                }
            }
            self.postCollectionView.reloadData()
        })
    }
    
    deinit {
        dbListener?.remove()
    }
}

extension FeedVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post", for: indexPath) as? FeedCell else {
            fatalError("Error: Cell not dequeued")
        }
        cell.post = posts[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 400)
    }
}

extension FeedVC : UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            chosenImage = image
        } else if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            chosenImage = image
        }
        
        uploadImageToFirebase()
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    private func uploadImageToFirebase(){
        
        guard let image = chosenImage else {
            return
        }
        
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            return
        }

        let uploadTask = storageRef.putData(data, metadata: nil) { (metadata, error) in
          
            self.storageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              return
            }
                
            self.uploadToFirestore(url: downloadURL.absoluteString)
          }
        }
        
        uploadTask.resume()
     
    }
    
    private func uploadToFirestore(url:String) {
        
        let data : [String:Any] = ["userId":AppData.shared.getUserId() as Any,"imgURL":url,"likecount":0,"timeStamp":Date().timeIntervalSince1970]
        database.addDocument(data: data, completion: {error in
            
            print(error?.localizedDescription)
            
        })
    }
    
    
}
