//
//  PostViewController.swift
//  Instagram
//
//  Created by Vo Thuan Nguyen on 1/15/23.
//

import UIKit
import Appirater

class PostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let post: Post
    private let owner: String

    private var collectionView: UICollectionView?

    private var viewModels: [SinglePostCellType] = []

    private let commentBarView = CommentBarView()

    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?

    // MARK: - Init

    init(
        post: Post,
        owner: String
    ) {
        self.owner = owner
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        view.backgroundColor = .systemBackground
        configureCollectionView()
        view.addSubview(commentBarView)
        commentBarView.delegate = self
        fetchPost()
        observeKeyboardChange()

        // Appirater.tryToShowPrompt()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        commentBarView.frame = CGRect(
            x: 0,
            y: view.height-view.safeAreaInsets.bottom-70,
            width: view.width,
            height: 70
        )
    }

    private func observeKeyboardChange() {
        observer = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
                return
            }
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-60-height,
                    width: self.view.width,
                    height: 70
                )
            }
        }

        hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-self.view.safeAreaInsets.bottom-70,
                    width: self.view.width,
                    height: 70
                )
            }
        }
    }

    private func fetchPost() {
        // mock data
        let username = owner
        DatabaseManager.shared.getPost(with: post.id, from: username) { [weak self] post in
            guard let post = post else {
                return
            }

            self?.createViewModel(
                model: post,
                username: username,
                completion: { success in
                    guard success else {
                        return
                    }

                    DispatchQueue.main.async {
                        self?.collectionView?.reloadData()
                    }
                }
            )
        }
    }

    private func createViewModel(
        model: Post,
        username: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        StorageManager.shared.profilePictureURL(for: username) { [weak self] profilePictureURL in
            guard let strongSelf = self,
                  let postUrl = URL(string: model.postUrlString),
                  let profilePhotoUrl = profilePictureURL else {
                completion(false)
                return
            }

            let isLiked = model.likers.contains(currentUsername)

            DatabaseManager.shared.getComments(
                postID: strongSelf.post.id,
                owner: strongSelf.owner
            ) { comments in
                var postData: [SinglePostCellType] = [
                    .poster(
                        viewModel: PosterCollectionViewCellViewModel(
                            username: username,
                            profilePictureURL: profilePhotoUrl
                        )
                    ),
                    .post(
                        viewModel: PostCollectionViewCellViewModel(
                            postUrl: postUrl
                        )
                    ),
                    .actions(viewModel: PostActionsCollectionViewCellViewModel(isLiked: isLiked)),
                    .likeCount(viewModel: PostLikesCollectionViewCellViewModel(likers: model.likers)),
                    .caption(
                        viewModel: PostCaptionCollectionViewCellViewModel(
                            username: username,
                            caption: model.caption
                        )
                    ),
                ]

                if let comment = comments.first {
                    postData.append(
                        .comment(viewModel: comment)
                    )
                }

                postData.append(
                    .timestamp(
                        viewModel: PostDatetimeCollectionViewCellViewModel(
                            date: DateFormatter.formatter.date(from: model.postedDate) ?? Date()
                        )
                    )
                )
                self?.viewModels = postData
                completion(true)
            }
        }
    }

    // CollectionView

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .poster(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifer,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .post(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCollectionViewCell.identifer,
                for: indexPath
            ) as? PostCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .actions(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostActionsCollectionViewCell.identifer,
                for: indexPath
            ) as? PostActionsCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .likeCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifer,
                for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel, index: indexPath.section)
            return cell
        case .caption(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostCaptionCollectionViewCell.identifer,
                for: indexPath
            ) as? PostCaptionCollectionViewCell else {
                fatalError()
            }
            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .timestamp(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostDateTimeCollectionViewCell.identifer,
                for: indexPath
            ) as? PostDateTimeCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .comment(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CommentCollectionViewCell.identifier,
                for: indexPath
            ) as? CommentCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
}

extension PostViewController: CommentBarViewDelegate {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String) {
        guard let currentUsername = UserDefaults.standard.string(forKey: "username") else { return }
        DatabaseManager.shared.createComments(
            comment: Comment(
                username: currentUsername,
                comment: text,
                dateString: String.date(from: Date()) ?? ""
            ),
            postID: post.id,
            owner: owner
        ) { success in
            DispatchQueue.main.async {
                guard success else {
                    return
                }
            }
        }
    }
}

extension PostViewController: PostLikesCollectionViewCellDelegate {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell, index: Int) {
        let vc = ListViewController(type: .likers(usernames: []))
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension PostViewController: PostCaptionCollectionViewCellDelegate {
    func postCaptionCollectionViewCellDidTapCaptioon(_ cell: PostCaptionCollectionViewCell) {
        print("tapped caption")
    }
}

extension PostViewController: PostActionsCollectionViewCellDelegate {
    func postActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int) {
        let cellType = viewModels[index]
        switch cellType {
        case .post(let viewModel):
            let vc = UIActivityViewController(
                activityItems: ["Check out this cool post!", viewModel.postUrl],
                applicationActivities: []
            )
            present(vc, animated: true)

        default:
            break
        }
    }

    func postActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int) {
        commentBarView.field.becomeFirstResponder()
    }

    func postActionsCollectionViewCellDidTapLike(
        _ cell: PostActionsCollectionViewCell,
        isLiked: Bool,
        index: Int) {
        DatabaseManager.shared.updateLikeState(
            state: isLiked ? .like : .unlike,
            postID: post.id,
            owner: owner
        ) { success in
            guard success else {
                return
            }
            print("Failed to like")
        }
    }
}

extension PostViewController: PostCollectionViewCellDelegate {
    func postCollectionViewCellDidLike(_ cell: PostCollectionViewCell, index: Int) {
        DatabaseManager.shared.updateLikeState(
            state: .like,
            postID: post.id,
            owner: owner
        ) { success in
            guard success else {
                return
            }
            print("Failed to like")
        }
    }
}

extension PostViewController: PosterCollectionViewCellDelegate {
    func posterCollectionViewCellDidTapMore(_ cell: PosterCollectionViewCell, index: Int) {
        let sheet = UIAlertController(
            title: "Post Actions",
            message: nil,
            preferredStyle: .actionSheet
        )
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Share Post", style: .default, handler: { [weak self]  _ in
            DispatchQueue.main.async {
                let cellType = self?.viewModels[index]
                switch cellType {
                case .post(let viewModel):
                    let vc = UIActivityViewController(
                        activityItems: ["Check out this cool post!", viewModel.postUrl],
                        applicationActivities: []
                    )
                    self?.present(vc, animated: true)

                default:
                    break
                }
            }
        }))
        sheet.addAction(UIAlertAction(title: "Report Post", style: .destructive, handler: { _ in
            // Report post
        }))
        present(sheet, animated: true)
    }

    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell, index: Int) {
        DatabaseManager.shared.findUser(username: owner) { [weak self] user in
            DispatchQueue.main.async {
                guard let user = user else {
                    return
                }
                let vc = ProfileViewController(user: user)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension PostViewController {
    func configureCollectionView() {
        let sectionHeight: CGFloat = 300 + view.width
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                // Item
                let posterItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let postItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(1)
                    )
                )

                let actionsItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                let likeCountItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                let captionItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let commentItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let timestampItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(sectionHeight)
                    ),
                    subitems: [
                        posterItem,
                        postItem,
                        actionsItem,
                        likeCountItem,
                        captionItem,
                        commentItem,
                        timestampItem
                    ]
                )

                // Section
                let section = NSCollectionLayoutSection(group: group)

                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)

                return section
            })
        )

        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifer
        )
        collectionView.register(
            PostCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCollectionViewCell.identifer
        )
        collectionView.register(
            PostActionsCollectionViewCell.self,
            forCellWithReuseIdentifier: PostActionsCollectionViewCell.identifer
        )
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifer
        )
        collectionView.register(
            PostCaptionCollectionViewCell.self,
            forCellWithReuseIdentifier: PostCaptionCollectionViewCell.identifer
        )
        collectionView.register(
            PostDateTimeCollectionViewCell.self,
            forCellWithReuseIdentifier: PostDateTimeCollectionViewCell.identifer
        )
        collectionView.register(CommentCollectionViewCell.self,
                                forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.collectionView = collectionView
    }
}
