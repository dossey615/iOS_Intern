//
//  TwitterAPI.swift
//  iOS_Intern
//
//  Created by 土居将史 on 2018/05/01.
//  Copyright © 2018年 土居将史. All rights reserved.
//

import Foundation
import TwitterKit
import TwitterCore

func getTweet(){
    let client = TWTRAPIClient.withCurrentUser()
    let URLEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
    let params = ["q": "iQON","count": "10"]
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
            // print("json: \(json)")
            if (json["statuses"] as? NSArray) != nil {
                let twArray = TWTRTweet.tweets(withJSONArray: json["statuses"] as! [AnyObject]) as! [TWTRTweet]
                print(twArray[0].tweetID)
            }
        } catch let jsonError as NSError {
            print("json error: \(jsonError.localizedDescription)")
        }
    }
}
