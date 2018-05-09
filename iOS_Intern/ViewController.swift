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
    
    //変数群、配列
    var set: Int = 0
    var count: Int = 0
    var flag: Int = 0
    var max_id: String = "-1"
    var twtext: [String] = []
    var twname: [String] = []
    var twid: [String] = []
    
    
    override func viewDidLoad() {
            self.GetTweet()
    }
    
    //セルの個数設定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.count
    }
    
    //Cellの情報設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TWCollectionViewCell
        //順番にセルの作成
        if twname.count > indexPath.row{
        cell.TWname.text = String(twname[indexPath.row])
        cell.TWscname.text = String("@"+twid[indexPath.row])
        cell.TWtext.text = String(twtext[indexPath.row])
        
        //ツイート内容に合わせてサイズを調整
        //cell.TWtext.sizeToFit()
        }
        return cell
    }
    
    //APIを叩き、tweetDataを取得
    func GetTweet(){
        //searchの実行
        let client = TWTRAPIClient.withCurrentUser()
        let URLEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
        //q:検索条件、count:取得個数、max_id:取得開始tweet番号（−１だと最新のものから取得）
        let params = ["q": "iQON","count": "100", "max_id" : max_id]
        var clientError : NSError?
        
        //requestの設定
        let request = client.urlRequest(
            withMethod: "GET",
            urlString: URLEndpoint,
            parameters: params,
            error: &clientError
        )
        
        //URLを使い、APIにrequest
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(String(describing: connectionError))")
            }
        //connct成功時,tweetのjsondataをAPIにより取得
        do {
            //設定した条件によりtweetを取得
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
            if (json["statuses"] as? NSArray) != nil {
                //Array<TWTRTweet>型としてtwArrayに代入する
                let twArray = TWTRTweet.tweets(withJSONArray: json["statuses"] as! [AnyObject]) as! [TWTRTweet]
                //格配列に代入していく
                for i in 0..<twArray.count {
                    self.twtext.append(twArray[i].text)
                    self.twname.append(twArray[i].author.name)
                    self.twid.append(twArray[i].author.screenName)
                    let num = Int(twArray[i].tweetID)! + 1
                    self.max_id = String(num)
                }
                //カウントが初期値の場合、100に設定する
                if self.count == 0{
                    self.count = 100
                }else{
                    self.count = self.twtext.count
                }
                //再読み込み
                self.Collection.reloadData()
                self.Collection.layoutIfNeeded()
            }
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    //スクロールでの読み込みメソッド
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Collection.contentOffset.y + Collection.frame.size.height > Collection.contentSize.height && Collection.isDragging && self.flag < 10 && self.count%100 == 0{
            //誤作動しないように時間を置く
            sleep(1)
            print(self.twname)
            self.flag = self.flag + 1
            self.GetTweet()
            //誤作動しないように時間を置く
            sleep(1)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

