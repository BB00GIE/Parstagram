//
//  FeedVC.swift
//  Parstagram
//
//  Created by Brandon Elmore on 2/23/20.
//  Copyright © 2020 CodePath. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedVC: UIViewController, UITableViewDelegate,UITableViewDataSource, MessageInputBarDelegate{
    
    let commentBar = MessageInputBar()
    
    var ShowsCommentsBar = false
    
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
       
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive

        // Do any additional setup after loading the view.
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        ShowsCommentsBar = false
        becomeFirstResponder()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className:"Posts")
        query.includeKeys(["author","comments", "comments.Author"])
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
                
            }
        }
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["Author"] = PFUser.current()!
        
        
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
        if success {
            print("Comment saved")
        
        }else{
            print("Error saving comment\(error?.localizedDescription)")
            
            }
            
        }
        tableView.reloadData()
        
        
        
        commentBar.inputTextView.text = nil
        ShowsCommentsBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        
        let comments = (post["comment"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            ShowsCommentsBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
//        comment["text"] = "This is a test comment by Boogie"
//        comment["post"] = post
//        comment["Author"] = PFUser.current()!
//
//
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground { (success, error) in
//            if success {
//                print("Comment saved")
//
//            }else{
//                print("Error saving comment\(error?.localizedDescription)")
//            }
//        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func onLogout(_ sender: Any) {
        
        PFUser.logOut()
        
        let scene = UIApplication.shared.connectedScenes.first
        if let sd: SceneDelegate = (scene?.delegate as? SceneDelegate) {
             let main = UIStoryboard(name: "Main", bundle: nil)
             let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
             sd.window?.rootViewController = loginViewController
        }
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return ShowsCommentsBar
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        let comments = (post["comments"] as? [PFObject])  ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        
        let comments = (post["comments"] as? [PFObject])  ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellVC") as! CellVC
            
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            cell.captionLabel.text = post["caption"] as! String
            
            let image = post["image"] as! PFFileObject
            let UrlString = image.url!
            let url = URL(string: UrlString)
            cell.photoVIew.af_setImage(withURL: url!)
            
            return cell
        }else if indexPath.row <= comments.count{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsVC") as! CommentsVC
            
            let comment = comments[indexPath.row-1]
            cell.CommentLabel.text = comment["text"] as? String
            
            let user = comment["Author"] as! PFUser
            cell.userLabel.text = user.username
            
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddComment")!
            
            return cell
            
        }
        
    }
    
}
