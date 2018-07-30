//
//  FirstViewController.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 7/29/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import SkeletonView
import ObjectMapper

class RailsViewController: UIViewController, SkeletonTableViewDataSource {

    @IBOutlet var tableView:UITableView?
    var numberOfLines: Promise<[MetroLine]>?
    let customSessionManager = APIManager.sessionManager
    private let sharedInstance = APIManager.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        numberOfLines = self.retriveLines()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let unwrapped = numberOfLines?.value?.count {
            print(unwrapped)
            return unwrapped
        }
        else
        {
            return 0
        }
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdenfierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "metroLineCell"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "metroLineCell", for: indexPath)
//        cell.textLabel?.text = "cell => \(indexPath.row)"
        let metroLine = self.numberOfLines?.value![indexPath.row] as MetroLine?
        cell.textLabel?.text = metroLine?.lineCode

        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func retriveLines()-> Promise <[MetroLine]> {
        return Promise { seal in
            let router = RailsRouter(endpoint: .getRails)
            customSessionManager.request(router)
                .responseJSON {
                    response in
                    guard response.result.error == nil
                        else {
                            print("error")
                            print(response.result.error!)
                            return
                    }
                    switch response.result {
                    case .success(let jsonResponse):
                        print(jsonResponse)
                        if response.response?.statusCode == 200 {
                            if let data = jsonResponse as? Dictionary<String, AnyObject> {
                                if let rawJson = data["Lines"] as? [[String: AnyObject]] {
                                    let metroLines : Array<MetroLine> = Mapper<MetroLine>().mapArray(JSONArray: rawJson)
                                    seal.fulfill(metroLines)
                                    self.tableView?.reloadData()
                                }
                            }
                        }
                    case .failure(let error):
                        print(error)
                        seal.reject(NSError(domain: "error retriving user", code:404, userInfo: nil))
                    }
            }
        }
    }



}

