//
//  ParseManager.swift
//  RSSNews
//
//  Created by Roman on 10.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit

struct Feed{
    var img : UIImage?
    var element : String?
    var ftitle : String?
    var yandexFullText : String?
    var fdate : String?
    var category : String?
}



class ParseManager: UIViewController, XMLParserDelegate {
    
    var parser = XMLParser()
    var feeds : [Feed] = []
    
    // свойства
    var img = UIImage()
    var element = String()
    var ftitle = String()
    var yandexFullText = String()
    var fdate = String()
    var category = String()
    
    
    var elementName: String = String()
    

   
    func initWithURL(_ url :URL) -> AnyObject {
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.parse()
        return self
    }
    
  
    
    

    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if elementName == "item" {
            element = String()
            ftitle = String()
            yandexFullText = String()
            fdate = String()
            category = String()
            
        }
        else if elementName == "enclosure" {
            let urlString = URL(string: attributeDict["url"]!)
               
            if let data = try? Data(contentsOf: urlString!)
            {
                img = UIImage(data: data)!
            }
            
        }
        self.elementName = elementName
        
    }
        
    
    
    
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

        if elementName == "item" {
         let elements = Feed(img: img, element: element, ftitle: ftitle, yandexFullText: yandexFullText, fdate: fdate, category: category)
            feeds.append(elements)
        }
        
        }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if (!data.isEmpty) {
            if self.elementName == "title" {
                ftitle += data
            }
            else if self.elementName == "yandex:full-text" {
                yandexFullText += data
            } else if self.elementName == "pubDate" {
                fdate += data
            } else if self.elementName == "category" {
                category += data
            }
        }
        
        }
}

