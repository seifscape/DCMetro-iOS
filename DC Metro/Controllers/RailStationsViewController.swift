//
//  RailStationsViewController.swift
//  DC Metro
//
//  Created by Seif Kobrosly on 8/25/18.
//  Copyright © 2018 District Meta Works, LLC. All rights reserved.
//

import UIKit
import Alamofire
import PromiseKit
import SkeletonView
import ObjectMapper
import LetterAvatarKit

class RailStationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView?
    let customSessionManager = APIManager.sessionManager
    private let sharedInstance = APIManager.sharedInstance
    var metroLine:MetroLine = MetroLine.init()
//    var listOfStations:Promise<[MetroStation]>?
    var listOfStations:Promise<[MetroStation]>?
    var metroLineJsonFile:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tableView?.dataSource = self
        self.tableView?.delegate   = self
        self.listOfStations = self.readJson(fileName: metroLineJsonFile)
        //self.listOfStations = self.retrivePathBetweenStations(fromStation: (metroLine.startStationCode), toStation: metroLine.endStationCode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch metroLine.lineCode {
        case "BL":
            self.navigationController?.navigationBar.barTintColor = metroLineColors.kBL_Color
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.title = "Blue Line"
            self.title = "Blue Line"
        case "GR":
            self.navigationController?.navigationBar.barTintColor = metroLineColors.kGR_COLOR
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.title = "Green Line"
            self.title = "Green Line"
        case "OR":
            self.navigationController?.navigationBar.barTintColor = metroLineColors.kOR_COLOR
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.title = "Orange Line"
            self.title = "Orange Line"
        case "RD":
            self.navigationController?.navigationBar.barTintColor = metroLineColors.kRD_COLOR
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.title = "Red Line"
            self.title = "Red Line"
        case "SV":
            self.navigationController?.navigationBar.barTintColor = metroLineColors.kSV_COLOR
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.title = "Silver Line"
            self.title = "Silver Line"
        case "YL":
            self.navigationController?.navigationBar.barTintColor = metroLineColors.kYL_COLOR
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
            self.navigationController?.title = "Yellow Line"
            self.title = "Yellow Line"
        default:
            self.navigationController?.navigationBar.barTintColor = UIColor.white
            self.navigationController?.navigationBar.tintColor = UIColor.black
            self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
    }
    
    /*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .red
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let unwrapped = listOfStations?.value?.count {
            print(unwrapped)
            return unwrapped
        }
        else
        {
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "metroLineCell", for: indexPath)
        //        cell.textLabel?.text = "cell => \(indexPath.row)"
        
        
        
        let metroLine:MetroStation = (self.listOfStations?.value?[indexPath.row])!
        cell.textLabel?.text = metroLine.stationName
        cell.detailTextLabel?.text = metroLine.lineCode
        
        var circleColor:UIColor? = nil
        
        switch metroLine.lineCode {
        case "BL":
            circleColor = metroLineColors.kBL_Color
        case "GR":
            circleColor = metroLineColors.kGR_COLOR
        case "OR":
            circleColor = metroLineColors.kOR_COLOR
        case "RD":
            circleColor = metroLineColors.kRD_COLOR
        case "SV":
            circleColor = metroLineColors.kSV_COLOR
        case "YL":
            circleColor = metroLineColors.kYL_COLOR
        default:
            circleColor = UIColor.clear
        }
        cell.imageView?.image = UIImage.circle(diameter: 20, color: circleColor!)
        //        cell.imageView?.setImage(string:metroLine?.lineCode, color: UIColor.blue, circular: true, stroke: false)
        
        return cell
    }
    
    func retrivePathBetweenStations(fromStation: String, toStation:String)-> Promise <[MetroStation]> {
        return Promise { seal in
            let router = RailsRouter(endpoint: .getPathOfStations(fromStationCode: fromStation, toStationCode: toStation))
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
                                if let rawJson = data["Path"] as? [[String: AnyObject]] {
                                    let metroStations : Array<MetroStation> = Mapper<MetroStation>().mapArray(JSONArray: rawJson)
                                    seal.fulfill(metroStations)
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

    func retriveStations(lineCodeString: String)-> Promise <[MetroStation]> {
        return Promise { seal in
            let router = RailsRouter(endpoint: .getStations(lineCode: lineCodeString))
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
                                if let rawJson = data["Stations"] as? [[String: AnyObject]] {
                                    let metroStations : Array<MetroStation> = Mapper<MetroStation>().mapArray(JSONArray: rawJson)
                                    seal.fulfill(metroStations)
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // First load the tracks, followed by the unordered list and add the lines
    
    private func readJson(fileName:String) -> Promise <[MetroStation]>{
        return Promise { seal in
            do {
                if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [String: Any] {
                        // json is a dictionary
                        print(object)
                        if let stations = object["Path"] as? Array<AnyObject> {
                            print(stations.first ?? "")
                            let metroStations : Array<MetroStation> = Mapper<MetroStation>().mapArray(JSONArray: stations as! [[String : Any]])
                            seal.fulfill(metroStations)
                            self.tableView?.reloadData()

                        }
                    } else if let object = json as? [Any] {
                        // json is an array
                        print(object)
                    } else {
                        print("JSON is invalid")
                    }
                } else {
                    print("no file")
                }
            } catch {
                print(error.localizedDescription)
            }
        }
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
