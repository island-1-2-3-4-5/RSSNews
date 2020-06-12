//
//  FeedsController.swift
//  RSSNews
//
//  Created by Roman on 10.06.2020.
//  Copyright © 2020 Roman Monakhov. All rights reserved.
//

import UIKit

class FeedsController: UIViewController, XMLParserDelegate {

    @IBOutlet weak var tableView: UITableView!
    var myFeed = [Feed]()
  
    var url: URL!
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    var categoryArray = ["Культура", "Спорт", "Общество", "Экономика", "Медицина",
    "Происшествия", "Авто", "В мире", "Оборона и безопасность", "Политика", "Наука",
    "75 лет Победы", "Hi-Tech"]
    
    var selectedElement: String?
    
   
    
    
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
        loadData()
        tableView.refreshControl = myRefreshControl
        
        choiceCategory()
        
        
       }
    
    @objc private func refresh(sender: UIRefreshControl){
        reloadData()
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    
    func reloadData() {
        DispatchQueue.global(qos: .default).async {
            self.url = URL(string: "https://www.vesti.ru/vesti.rss")!
        
           
                let myParser : ParseManager = ParseManager().initWithURL(self.url) as! ParseManager

                // Добавляем заголовок и картинку в массив
              
                self.myFeed = myParser.feeds
                
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func loadData() {
        url = URL(string: "https://www.vesti.ru/vesti.rss")!
        loadRss(url)
        
    }

    func loadRss(_ data: URL) {
      
        let myParser : ParseManager = ParseManager().initWithURL(data) as! ParseManager

        // Добавляем заголовок и картинку в массив
       myFeed = myParser.feeds
       tableView.reloadData()
        
        
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!

            let fullText: String = myFeed[indexPath.row].yandexFullText!
            let header: String = myFeed[indexPath.row].ftitle!
            let image: UIImage = myFeed[indexPath.row].img!


            let fivc: FullTextViewController = segue.destination as! FullTextViewController
            fivc.fullText = fullText
            fivc.header = header
            fivc.imageNews = image

        }
    }

    // MARK: - Table view data source.
   

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }

    // MARK: Настройка ячейки
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        cell.imageOutlet.image = myFeed[indexPath.row].img
        cell.headLabel.text = myFeed[indexPath.row].ftitle
        cell.dateLabel.text = myFeed[indexPath.row].fdate
        
     
        // закругляем картинки, отталкиваемся от высоты изображения
        cell.imageOutlet.layer.cornerRadius = cell.imageOutlet.frame.size.height / 2
        // обрезаем изображение
        cell.imageOutlet.clipsToBounds = true
        
      
        return cell
    }
    
    func choiceCategory() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        categoryTextField.inputView = elementPicker
        
    }
}




extension FeedsController: UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        selectedElement = categoryArray[row]
        categoryTextField.text = selectedElement
      



        }
    }
    
    
    

