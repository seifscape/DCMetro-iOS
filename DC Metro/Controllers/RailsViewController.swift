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
import LetterAvatarKit

class RailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView:UITableView?
    var numberOfLines: Promise<[MetroLine]>?
    let customSessionManager = APIManager.sessionManager
    private let sharedInstance = APIManager.sharedInstance

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.dataSource = self
        self.tableView?.delegate   = self
        // Do any additional setup after loading the view, typically from a nib.
//        numberOfLines = self.retriveLines()
        numberOfLines = self.readJson(fileName: "RailLines")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Rails"
        self.navigationController?.navigationBar.barStyle = .default
        // colormatchtabs yap database
//        self.navigationController?.navigationBar.barTintColor = UIColor.white
//        self.navigationController?.navigationBar.tintColor = UIColor.black
//        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
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
        cell.textLabel?.text = metroLine?.displayName
        cell.detailTextLabel?.text = metroLine?.lineCode
        
        var circleColor:UIColor? = nil
        
        switch metroLine?.lineCode {
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
        cell.imageView?.image = UIImage.circle(diameter: 35, color: circleColor!)
//        cell.imageView?.setImage(string:metroLine?.lineCode, color: UIColor.blue, circular: true, stroke: false)
        
        
        return cell
    }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard tableView.cellForRow(at: indexPath) != nil else {
        return
    }

    let metroLine:MetroLine = (self.numberOfLines?.value![indexPath.row])!
    var jsonFileName:String = ""
    
    switch metroLine.lineCode {
    case "BL":
        jsonFileName = "BlueLineStations"
    case "GR":
        jsonFileName = "GreenLineStations"
    case "OR":
        jsonFileName = "OrangeLineStations"
    case "RD":
        jsonFileName = "RedLineStations"
    case "SV":
        jsonFileName = "SilverLineStations"
    case "YL":
        jsonFileName = "YellowLineStations"
    default:
        return

    }

    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "listOfStationsViewController") as! RailStationsViewController
    controller.metroLine = metroLine
    controller.metroLineJsonFile = jsonFileName
    self.navigationController?.pushViewController(controller, animated: true)
//    let metroStations = self.retriveStations(lineCodeString: (metroLine.lineCode))
    
    
    
    DispatchQueue.main.async {
        //self.performSegue(withIdentifier: "listOfStationsSegue", sender:metroLine)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//    let controller = storyboard.instantiateViewControllerWithIdentifier("PlayViewController") as! PlayViewController
//    self.navigationController?.pushViewController(controller, animated: true)
//    let metroStations = self.retriveStations(lineCodeString: (metroLine?.lineCode)!)
//
    
    
    /*
    let alertController = UIAlertController(title: "Hint", message: "You have selected row \(indexPath.row).", preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
    alertController.addAction(alertAction)
    present(alertController, animated: true, completion: nil)
    */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = sender as? MetroLine{
            if segue.identifier == "listOfStationsSegue"{
                if let destinationViewController = segue.destination as? RailStationsViewController {
                    destinationViewController.metroLine = data
                }
            }
        }
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
                        //print(jsonResponse)
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

    private func readJson(fileName:String) -> Promise <[MetroLine]>{
        return Promise { seal in
            do {
                if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                    let data = try Data(contentsOf: file)
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let object = json as? [String: Any] {
                        // json is a dictionary
                        print(object)
                        if let stations = object["Lines"] as? Array<AnyObject> {
                            print(stations.first ?? "")
                            let metroLines : Array<MetroLine> = Mapper<MetroLine>().mapArray(JSONArray: stations as! [[String : Any]])
                            seal.fulfill(metroLines)
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
}


extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)
        
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
}

