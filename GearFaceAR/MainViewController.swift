//
//  ViewController.swift
//  GearFaceAR
//
//  Created by Oscar Santos on 11/18/20.
//

import UIKit
import ARGear

let API_HOST = "https://apis.argear.io/api/v3/"
let API_KEY = "2f7b45e1314ef1d07abb3959"
let API_SECRET_KEY = "2986ecc1ee2ffadc6927a382674d8ab40d44c79da45aab8cc9326590295448f5"
let API_AUTH_KEY = "U2FsdGVkX1+h5jjopWLhGL0SysmPHFpPAmpNHZAdwJL3f1NqnAeiMQRa/xAHq5x0"

class MainViewController: UIViewController {
    
    var argSession: ARGSession?

    override func viewDidLoad() {
        super.viewDidLoad()
        startARSessions()
    }
    
    func startARSessions(){
        do {
            let config = ARGConfig(
                apiURL: API_HOST,
                apiKey: API_KEY,
                secretKey: API_SECRET_KEY,
                authKey: API_AUTH_KEY
            )
            argSession = try ARGSession(argConfig: config, feature: [.faceLowTracking])
            argSession?.delegate = self
        }
        catch let error as NSError {
            print(error)
        }
        catch let exception as NSException {
            print(exception)
        }
    }
    
    @IBAction func runSession(_ sender: Any) {
        argSession?.run()
    }
    


}

extension MainViewController: ARGSessionDelegate{
    func didUpdate(_ frame: ARGFrame) {
        
    }
}
