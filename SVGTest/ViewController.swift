//
//  ViewController.swift
//  SVGTest
//
//  Created by Tatyana Paushkina on 25.10.2021.
//

import UIKit
import Macaw
import SVGKit
import SVGParser

extension UIViewController {
    public func printTime(startTime: Date, string: String) {
        let tsp = Date().timeIntervalSince(startTime)
        let prefix = String(format: "UIViewController %.3fs ", tsp)
        let str = "\(prefix)- \(string)"
        Swift.print(str)
    }
}

class ViewController: UIViewController {

//    let urlString = "https://www.avito.st/s/common/components/monetization/icons/web/x5_1.svg"
    let urlString = "https://www.avito.st/s/common/components/monetization/bundles/au/01/mid-medium.svg"
    var macawView: SVGView!
    var svgkImage: MySVGKFastImageView! //SVGKFastImageView! //SVGKImage!
    var svgParserImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let url = URL(string: urlString) else {
            print("bad url")
            return
        }
        
        testMacaw(url: url)
        testSvgkImage(url: url)
        testSVGParser(url: url)
    }

    func testMacaw(url: URL) {
        macawView = SVGView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.addSubview(macawView)
        
        DispatchQueue.global().async {
            let time = Date()
            guard let data = try? Data(contentsOf: url) else {
                print("bad data")
                return
            }
            self.printTime(startTime: time, string: "load data for macaw")
            let string = String(data: data, encoding: .utf8)
            
            DispatchQueue.main.async {
                self.macawView.fileString(s: string)
            }
        }
    }
    
    func testSvgkImage(url: URL) {
//        DispatchQueue.global().async { [weak self] in
        DispatchQueue.main.async { [weak self] in
        
            let s = Date()
            let i = SVGKImage(contentsOf: url)
            self?.printTime(startTime: s, string: "SVGKit image")
            
            DispatchQueue.main.async {
                self?.svgkImage = MySVGKFastImageView(svgkImage: i)
                
                self?.view.addSubview(self!.svgkImage)
                self?.svgkImage.frame = CGRect(x: 0, y: 200, width: 100, height: 100)
            }
        }
    }
    
    func testSVGParser(url: URL) {
        svgParserImageView = UIImageView(frame: CGRect(x: 0, y: 500, width: 100, height: 100))
        view.addSubview(svgParserImageView)

        let s = Date()
        SVGParser(contentsOfURL: url).scaledImageWithSize(CGSize(width: 300, height: 300), completion: { [weak self] image in
            if let img = image {
                self?.printTime(startTime: s, string: "SVGParser all work")
                self?.svgParserImageView.image = img
            }
        })
    }
}


extension SVGView {
    func fileString(s: String?) {
        if let s = s {
            node = (try? SVGParser.parse(text: s)) ?? Group()
        }
    }
}

class MySVGKFastImageView: SVGKFastImageView {
    override func draw(_ rect: CGRect) {
        let s = Date()
        super.draw(rect)
        UIViewController().printTime(startTime: s, string: "SVGKFastImageView drawRect")
    }
}
