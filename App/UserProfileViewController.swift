import UIKit


class UserProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet private var avatarView: AvatarView!
    @IBOutlet private var postCountLabel: UILabel!
    @IBOutlet private var followerCountLabel: UILabel!
    @IBOutlet private var followedCountLabel: UILabel!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var bioLabel: UILabel!
    @IBOutlet private var followButton: UIButton!
    @IBOutlet private var editProfileButton: UIButton!
    @IBOutlet private var gridView: UICollectionView!
    @IBOutlet private var placeholderLabel: UILabel!
    private var user: User
    private var posts = [Post]()

    init(user: User) {
        self.user = user
        super.init(nibName: "UserProfileView", bundle: nil)
        self.navigationItem.title = user.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #warning("Not implemented")
        self.avatarView.showImageAsynchronously(imageURL: self.user.avatarURL)
        self.postCountLabel.text = "\(0)"
        self.followerCountLabel.text = "\(0)"
        self.followedCountLabel.text = "\(0)"
        self.userNameLabel.text = self.user.name
        self.bioLabel.text = self.user.bio
        
        if self.user == User.current {
            self.followButton.isHidden = true
        } else {
            self.editProfileButton.isHidden = true
            self.followButton.setTitleColor(UIColor.white, for: .selected)
            self.followButton.setTitleColor(UIColor.white, for: [.selected, .highlighted])
            self.followButton.setTitle("Unfollow", for: .selected)
            self.followButton.setTitle("Unfollow", for: [.selected, .highlighted])
        }
        
        gridView.register(PostTileCell.self, forCellWithReuseIdentifier: "Post cell")
        let cellWidth = UIScreen.main.bounds.size.width / 3.0
        let layout = self.gridView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        ServerAPI.shared.getPostsOf(user: user) { (posts: [Post]?, error: Error?) in
            if let posts = posts {
                if posts.count > 0 {
                    self.posts.append(contentsOf: posts)
                    self.placeholderLabel.isHidden = true
                    self.gridView.reloadData()
                    return
                }
            }
            self.placeholderLabel.isHidden = false
        }
    }
    
    @IBAction private func toggleFollow() {
        #warning("Not implemented")
        self.followButton.isSelected = !self.followButton.isSelected
        self.followButton.setBackgroundImage(UIImage(named: self.followButton.isSelected ? "small-button-on" : "small-button-off"), for: .normal)
    }
    
    @IBAction private func editProfile() {
        #warning("Not implemented")
    }
    
    // MARK: - UICollectionViewDataSource
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Post cell", for: indexPath) as! PostTileCell
        cell.imageView.showImageAsynchronously(imageURL: posts[indexPath.item].images?.first?.url)
        return cell
    }
}


fileprivate class PostTileCell: UICollectionViewCell {
    
    var imageView: AsynchronousImageView
    
    override init(frame: CGRect) {
        self.imageView = AsynchronousImageView(frame: frame)
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        super.init(frame: frame)
        contentView.addSubview(self.imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.frame = contentView.bounds
    }
}
