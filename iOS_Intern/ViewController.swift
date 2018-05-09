//
//  ViewController.swift
//  iOS_Intern
//
//  Created by 土居将史 on 2018/05/01.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore


class ViewController: UIViewController, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var Collection: UICollectionView!
    var clientError: NSError?
    var json: NSDictionary!
    var count: Int = 0
    var twtext: [String] = []
    var twname: [String] = []
    var twid: [String] = []
    
    
    override func viewDidLoad() {
//        TWTRTwitter.sharedInstance().logIn { session, error in
//            guard let session = session else {
//                if let error = error {
//                    print("エラーが起きました => \(error.localizedDescription)")
//                }
//                return
//            }
//            print("@\(session.userName)でログインしました")
            self.GetTweet()
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TWCollectionViewCell
        if self.count > 0 {
        cell.TWname.text = String(twname[indexPath.row])
        cell.TWscname.text = String("@"+twid[indexPath.row])
        cell.TWtext.text = String(twtext[indexPath.row])
        cell.TWtext.sizeToFit()
        }
        return cell
    }
    
    func GetTweet(){
        let client = TWTRAPIClient.withCurrentUser()
        let URLEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        let params = ["q": "iQON","count": "100"]
        var clientError : NSError?
        
        let request = client.urlRequest(
            withMethod: "GET",
            urlString: URLEndpoint,
            parameters: params,
            error: &clientError
        )
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            if (json["statuses"] as? NSArray) != nil {
                let twArray = TWTRTweet.tweets(withJSONArray: json["statuses"] as! [AnyObject]) as! [TWTRTweet]
                for i in 0..<twArray.count {
                    self.twtext.append(twArray[i].text)
                    self.twname.append(twArray[i].author.name)
                    self.twid.append(twArray[i].author.screenName)
                }
                if self.count == 0{
                    self.count = 100
                }
                DispatchQueue.main.async {
                    self.Collection.reloadData()
                }
            }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        if Collection.contentOffset.y + Collection.frame.size.height > Collection.contentSize.height && Collection.isDragging {
//            print("一番下に来た時の処理")
//            self.count += 100
//            self.GetTweet()
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

