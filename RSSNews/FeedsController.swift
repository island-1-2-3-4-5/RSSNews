//
//  FeedsController.swift
//  RSSNews
//
//  Created by Roman on 10.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit

class FeedsController: UITableViewController, XMLParserDelegate {

    var myFeed : NSArray = []
    var feedImgs: [AnyObject] = []
    var url: URL!

    // Обновление контента
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        self.tableView.dataSource = self
        self.tableView.delegate = self
        tableView.refreshControl = myRefreshControl
        loadData()
       }
    
    @objc private func refresh(sender: UIRefreshControl){
        reloadData()
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    
    func reloadData() {
        DispatchQueue.global(qos: .background).async { self.loadData()
        }}
    
    func loadData() {
        url = URL(string: "https://www.vesti.ru/vesti.rss")!
        loadRss(url)
        
    }

    func loadRss(_ data: URL) {
        let myParser : ParseManager = ParseManager().initWithURL(data) as! ParseManager

        // Добавляем заголовок и картинку в массив
        feedImgs = myParser.img as [AnyObject]
        myFeed = myParser.feeds
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            let selectedFURL: String = (myFeed[indexPath.row] as AnyObject).object(forKey: "link") as! String

            
            let fivc: WebViewController = segue.destination as! WebViewController
            fivc.selectedFeedURL = selectedFURL as String
        }
    }

    // MARK: - Table view data source.
   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }

    // MARK: Настройка ячейки
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // Загрузка изображения в ячейку
        let url = NSURL(string:feedImgs[indexPath.row] as! String)
        let data = NSData(contentsOf:url! as URL)
        let image = UIImage(data:data! as Data)
        cell.imageOutlet.image = image
        cell.headLabel.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "title") as? String
        cell.dateLabel.text = (myFeed.object(at: indexPath.row) as AnyObject).object(forKey: "pubDate") as? String
     
        // закругляем картинки, отталкиваемся от высоты изображения
        cell.imageOutlet.layer.cornerRadius = cell.imageOutlet.frame.size.height / 2
        // обрезаем изображение
        cell.imageOutlet.clipsToBounds = true
        
        return cell
    }

    
    


}
