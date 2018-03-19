//
//  ViewController.swift
//  weather app
//
//  Created by Pranav Neyveli on 8/3/17.
//  Copyright © 2017 Pranav Neyveli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var locationField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func enterButton(_ sender: Any) {
        let url  = URL(string: "http://www.weather-forecast.com/locations/" + locationField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest")!
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            var message = ""
            if error  != nil {
                print(error!)
            } else {
                if let unwrappedData = data {
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    //escape double quotes inside the string
                    var stringSeperator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                    // splits the data into that one part only doe  and split into various arrays
                    if let contentArray = dataString?.components(separatedBy: stringSeperator) {
                        if contentArray.count > 1 {
                            stringSeperator = "</span>"
                            //we split in the closed span
                            let newContentArray = contentArray[1].components(separatedBy: stringSeperator)
                            // we then check to see the array count to only extract that small part
                            if newContentArray.count > 0 {
                                message = newContentArray[0].replacingOccurrences(of: "&deg;", with: "°")
                                print(message)
                            }
                        }
                    }
                }
                // if te city does not exist doe use multithreaded coding when dealing with web content shit
                if message == "" {
                    message = "The weather there could not have been found try again bitch"
                }
                DispatchQueue.main.sync(execute: {
                    // to reference the same view controller you have to do it like this doe
                    self.resultLabel.text = message
                })
            }
        }
        task.resume()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // start with obtaining the url sucessfully and check to see if it works before trying anything 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

