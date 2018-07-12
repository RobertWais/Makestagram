//
//  HomeVC.swift
//  Makestagram
//
//  Created by Robert Wais on 7/10/18.
//  Copyright © 2018 Robert Wais. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    
//MARK: Outlets

    @IBOutlet var tableView: UITableView!
    
    //MARK: Properties
    var posts = [Post]()
    
    
    let timestampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        
        return dateFormatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        UserService.posts(for: User.current) { (Posts) in
            self.posts=Posts
            self.tableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.postHeaderCell) as! PostHeaderCell
            print("User: \(User.current.username)")
            cell.usernameLbl.text = User.current.username
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.postImageCells, for: indexPath) as! PostImageCell
            print("second")
            let imageURL = URL(string: post.imageURL)
            cell.imageViewinCell?.kf.setImage(with: imageURL)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.postActionCell, for: indexPath) as! PostActionCell
            cell.delegate = self
            configureCell(cell, with: post)
            return cell
        default:
            fatalError("Could not set tableView")
        }
        
        
    }
    
    func configureCell(_ cell: PostActionCell, with post: Post){
        cell.timeLbl.text = timestampFormatter.string(from: post.creationDate)
        cell.likeBtn.isSelected = post.isLiked
        cell.likesLbl.text = "\(post.likeCount) likes"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func configureTableView(){
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
    }
}

extension HomeVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return PostHeaderCell.height
            
        case 1:
            let post = posts[indexPath.section]
            return post.imageHeight
            
        case 2:
            return PostActionCell.height
            
        default:
            fatalError()
        }
    }
}

extension HomeVC: PostActionCellDelegate {
    func didTapLikeButton(_ likeButton: UIButton, on cell: PostActionCell) {
        print("did tap like button")
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        likeButton.isUserInteractionEnabled = false
        
        let post = posts[indexPath.section]
        
        LikeService.setIsLiked(!post.isLiked, for: post) { (success) in
            defer{
                //Once closure returns let the user interact with button
                likeButton.isUserInteractionEnabled = true
            }
            
            guard success else {return}
            
            post.likeCount += !post.isLiked ? 1 : -1
            post.isLiked = !post.isLiked
            
            guard let cell = self.tableView.cellForRow(at: indexPath) as? PostActionCell else {return}
            
            DispatchQueue.main.async {
                self.configureCell(cell, with: post)
            }
        }
    }
}
