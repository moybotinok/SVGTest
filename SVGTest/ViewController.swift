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
//import SwiftSVG
import PocketSVG

extension UIViewController {
    public func printTime(startTime: Date, string: String) {
        let time = Date().timeIntervalSince(startTime)
        let prefix = String(format: "%.3fs ", time)
        let str = "\(prefix)- \(string)\n"
        Swift.print(str)
        UIPasteboard.general.string = (UIPasteboard.general.string ?? "") + str
    }
}

class ViewController: UIViewController {

//    let urlString = "https://www.avito.st/s/common/components/monetization/icons/web/x5_1.svg"
    let urlString = "https://www.avito.st/s/common/components/monetization/bundles/au/01/mid-medium.svg"

    var macawView: Macaw.SVGView!
    var svgkImage: MySVGKFastImageView!
//    var swiftSVGImage: SwiftSVG.SVGView!
    var svgParserImageView: UIImageView!
    var imageView: UIImageView!
    var pocketSVGImahe: SVGImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        view.addSubview(imageView)
        
        SVGKit.enableLogging()
        UIPasteboard.general.string = ""
        let s = Date()
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url) else {
            print("bad url")
            return
        }
        printTime(startTime: s, string: "load data")

        
//        testSvgkImage(url: url)
//        testSVGParser(url: url)
        
        // Test with preloaded data
//        let d = try! Data(contentsOf: url)
//        testSvgkImage(data: d)
        testSvgkImage(data: data)
//        testSVGParser(data: data)
        
        // This libs failure tests
//        testMacaw(url: url)
//        testSwiftSVG(url: url)
//        testPocketSVG()
    }

    func testMacaw(url: URL) {
        macawView = SVGView(frame: CGRect(x: 300, y: 0, width: 100, height: 100))
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
//                self.macawView.fileName = "bad_auto_24"
            }
        }
    }
    
    func testSvgkImage(url: URL) {
        
        DispatchQueue.global().async { [weak self] in
            let s = Date()
            let i = SVGKImage(contentsOf: url)
            self?.printTime(startTime: s, string: "SVGKit create image by url")
            
            DispatchQueue.main.async {
                let s1 = Date()
                self?.svgkImage = MySVGKFastImageView(svgkImage: i)
                self?.printTime(startTime: s1, string: "SVGKit create SVGKFastImageView ")
                
                self?.view.addSubview(self!.svgkImage)
                self?.svgkImage.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            }
        }
    }
    
    func testSvgkImage(data: Data) {
        DispatchQueue.global().async { [weak self] in
            
            let s = Date()
            let i = SVGKImage(data: data)
            self?.printTime(startTime: s, string: "SVGKit create image by data")
            let uiimage = i?.uiImage
            self?.printTime(startTime: s, string: "SVGKit create UIImage by data")
            
            DispatchQueue.main.async {
                let s1 = Date()
                self?.svgkImage = MySVGKFastImageView(svgkImage: i)
                self?.printTime(startTime: s1, string: "SVGKit create SVGKFastImageView ")
                
                self?.view.addSubview(self!.svgkImage)
                self?.svgkImage.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
                
            }
        }
    }
    
//    func testSwiftSVG(url: URL) {
//        swiftSVGImage = SwiftSVG.SVGView(SVGURL: url)
//        view.addSubview(swiftSVGImage)
//        swiftSVGImage.frame = CGRect(x: 0, y: 400, width: 100, height: 100)
//    }
    
    func testSVGParser(url: URL) {
        svgParserImageView = UIImageView(frame: CGRect(x: 0, y: 600, width: 200, height: 200))
        view.addSubview(svgParserImageView)

        let s = Date()
        SVGParser(contentsOfURL: url).scaledImageWithSize(CGSize(width: 200, height: 200), completion: { [weak self] image in
            if let img = image {
                self?.printTime(startTime: s, string: "SVGParser by url - all work")
                self?.svgParserImageView.image = img
            }
        })
    }
    
    func testSVGParser(data: Data) {
        svgParserImageView = UIImageView(frame: CGRect(x: 0, y: 600, width: 200, height: 200))
        view.addSubview(svgParserImageView)
        
        let s = Date()
        SVGParser(xmlData: data)
            .scaledImageWithSize(CGSize(width: 200, height: 200), completion: { [weak self] image in
                if let img = image {
                    self?.printTime(startTime: s, string: "SVGParser by data - all work")
                    
                    self?.svgParserImageView.image = img
                }
            })
    }
    
    func testPocketSVG() {
        let url = Bundle.main.url(forResource: "small", withExtension: "svg")!
        let svgImageView = SVGImageView.init(contentsOf: url)
        svgImageView.frame = CGRect(x: 0, y: 100, width: 200, height: 200)
        view.addSubview(svgImageView)
    }
}


extension Macaw.SVGView {
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
        UIViewController().printTime(startTime: s, string: "SVGKit drawRect")
    }
}
