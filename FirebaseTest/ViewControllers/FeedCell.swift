//
//  FeedCell.swift
//  FirebaseTest
//
//  Created by SHAILENDRA KUSHWAHA on 24/06/21.
//

import UIKit
import SDWebImage

class FeedCell: UICollectionViewCell {
    
    let idLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "heart_fill")
        return imageView
    }()
    
    let likeView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likeButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(named: "heart_fill")?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor   = .gray
        button.addTarget(self, action: #selector(self.likeThisPost), for: .touchUpInside)
        return button
    }()
    
    let commentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var commentButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(named: "comment")?.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.tintColor   = .gray
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        button.addTarget(self, action: #selector(self.likeThisPost), for: .touchUpInside)
        return button
    }()
    
    let likeCountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0 Likes"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    var post:Post?{
        didSet{
            setupLayoutVariables()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        contentView.frame = frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for constraint in idLabel.constraints{
            constraint.isActive = false
        }
        
        for constraint in imageView.constraints{
            constraint.isActive = false
        }
        
        for constraint in likeView.constraints{
            constraint.isActive = false
        }
        
        for constraint in likeButton.constraints{
            constraint.isActive = false
        }
        
        for constraint in likeCountLabel.constraints{
            constraint.isActive = false
        }
        
        for constraint in commentView.constraints{
            constraint.isActive = false
        }
        
        for constraint in commentButton.constraints{
            constraint.isActive = false
        }
        
        idLabel.removeFromSuperview()
        imageView.removeFromSuperview()
        commentButton.removeFromSuperview()
        commentView.removeFromSuperview()
        likeView.removeFromSuperview()
        likeCountLabel.removeFromSuperview()
        likeButton.removeFromSuperview()
    }
    
    private func setupLayoutVariables(){
        
        idLabel.text = post?.userId
        imageView.sd_setImage(with: URL(string: post!.imgURL ?? "" ), completed: nil)
        likeCountLabel.text = String(post!.likecount ?? 0) + " likes"
        
        if post?.isLiked == false  {
            self.likeButton.tintColor = .gray
        }else{
            self.likeButton.tintColor = .red
        }
        setupLayout()
    }
    
    private func setupLayout(){
        
        contentView.addSubview(idLabel)
        idLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 20).isActive = true
        idLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 8).isActive = true
        idLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        idLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor,multiplier: 0.65).isActive = true
        imageView.topAnchor.constraint(equalTo: idLabel.bottomAnchor,constant: 20).isActive = true
        
        contentView.addSubview(likeView)
        likeView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        likeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        likeView.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.25).isActive = true
        likeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        likeView.addSubview(likeButton)
        likeButton.topAnchor.constraint(equalTo: likeView.topAnchor).isActive = true
        likeButton.bottomAnchor.constraint(equalTo: likeView.bottomAnchor).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: likeView.leadingAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalToConstant:45).isActive = true
        
        likeView.addSubview(likeCountLabel)
        likeCountLabel.topAnchor.constraint(equalTo: likeView.topAnchor).isActive = true
        likeCountLabel.bottomAnchor.constraint(equalTo: likeView.bottomAnchor).isActive = true
        likeCountLabel.trailingAnchor.constraint(equalTo: likeView.trailingAnchor).isActive = true
        likeCountLabel.widthAnchor.constraint(equalTo: likeView.widthAnchor,multiplier: 0.5).isActive = true
        
        contentView.addSubview(commentView)
        commentView.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        commentView.leadingAnchor.constraint(equalTo: likeView.trailingAnchor).isActive = true
        commentView.widthAnchor.constraint(equalTo: contentView.widthAnchor,multiplier: 0.25).isActive = true
        commentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        commentView.addSubview(commentButton)
        commentButton.topAnchor.constraint(equalTo: commentView.topAnchor).isActive = true
        commentButton.bottomAnchor.constraint(equalTo: commentView.bottomAnchor).isActive = true
        commentButton.leadingAnchor.constraint(equalTo: commentView.leadingAnchor).isActive = true
        commentButton.widthAnchor.constraint(equalToConstant:45).isActive = true
        
    }
    
    @objc private func likeThisPost(){
        
        if likeButton.imageView?.tintColor == .gray {
            likeButton.imageView?.tintColor = .red
            post?.isLiked = true
        }
        else {
           likeButton.imageView?.tintColor = .gray
            post?.isLiked = false
        }
        likeCountLabel.text = String(post!.likecount ?? 0) + " likes"
    }

}
