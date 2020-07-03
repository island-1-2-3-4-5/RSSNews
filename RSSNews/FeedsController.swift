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
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    // основной массив с новостями
    var myFeed = [Feed]()
    var feeds = [Feed]() // дублирующий для фильтрации
    var url = URL(string: "https://www.vesti.ru/vesti.rss")!
    var categoryArray = ["Культура", "Спорт", "Общество", "Экономика",
                         "Медицина", "Происшествия", "Авто", "В мире",
                         "Оборона и безопасность", "Политика", "Наука",
                         "75 лет Победы", "Hi-Tech"]
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.dataSource = self
        self.tableView.delegate = self
        loadData()
        tableView.refreshControl = myRefreshControl
        choiceCategory()
       }
    
    
    //MARK: Обновление контента
       let myRefreshControl: UIRefreshControl = {
           let refreshControl = UIRefreshControl()
           refreshControl.addTarget(self,
                                    action: #selector(refresh(sender:)),
                                    for: .valueChanged)
           return refreshControl
       }()
    
    // Для снятия фильтра нужно сделать pull to refresh
    @objc private func refresh(sender: UIRefreshControl){
        // пока данные грузятся из интернета, очищаем основной массив
        myFeed.removeAll()
        // добавляем данные из второстепенного (чтобы снять фильтр)
        myFeed = feeds
        tableView.reloadData()
        reloadData()
        sender.endRefreshing()
    }
    
    
    func reloadData() {
        DispatchQueue.global(qos: .default).async {
            let myParser : ParseManager = ParseManager().initWithURL(self.url) as! ParseManager
            self.myFeed = myParser.feeds
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        categoryTextField.text = ""
    }
    
    // загрузка данных с сайта
    func loadData() {
        let myParser : ParseManager = ParseManager().initWithURL(url) as! ParseManager
        // Добавляем заголовок и картинку в массив
        myFeed = myParser.feeds
        // этот массив нужен при фильтрации
        feeds = myParser.feeds
        tableView.reloadData()
    }
    
    
    // MARK: Sorting
    // создаем Picker для выбора категорий
    func choiceCategory() {
           let elementPicker = UIPickerView()
           elementPicker.delegate = self
           categoryTextField.inputView = elementPicker
           createToolbar()
       }
       
    // создаем Toolbar
       func createToolbar() {
           let toolbar = UIToolbar()
           toolbar.sizeToFit()
           
           let doneButton = UIBarButtonItem(title: "Готово",
                                            style: .plain,
                                            target: self,
                                            action: #selector(dismissKeyboard))
           toolbar.setItems([doneButton], animated: true)
           toolbar.isUserInteractionEnabled = true
           categoryTextField.inputAccessoryView = toolbar
       }
    
    // убираем Пикер
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openPage" {
            let fivc: FullTextViewController = segue.destination as! FullTextViewController
            let indexPath: IndexPath = self.tableView.indexPathForSelectedRow!
            // передаем на второй экран информацию об выбранной ности
            fivc.fullText = myFeed[indexPath.row].yandexFullText!
            fivc.header = myFeed[indexPath.row].ftitle!
            fivc.imageNews = UIImage(data: myFeed[indexPath.row].img!)!
        }
    }

    
    // MARK: - Table view data source.
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myFeed.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
       }

    
    // MARK: Настройка ячейки
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        // устанавливаем значения outlets для ячейки
        cell.imageOutlet.image = UIImage(data: myFeed[indexPath.row].img!)!
        cell.headLabel.text = myFeed[indexPath.row].ftitle
        cell.dateLabel.text = myFeed[indexPath.row].fdate
        cell.categoryLabel.text = myFeed[indexPath.row].category
     
        // закругляем картинки, отталкиваемся от высоты изображения
        cell.imageOutlet.layer.cornerRadius = cell.imageOutlet.frame.size.height / 2
        cell.imageOutlet.layer.borderColor = UIColor.gray.cgColor //Рамочка для фото серая
        cell.imageOutlet.layer.borderWidth = 3.0 //толщина рамочки
        cell.imageOutlet.clipsToBounds = true // обрезаем изображение
        
        return cell
    }
}


// MARK: Extensions
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
        // очищаем основной массив, что добавлять в него отфильтрованные новости
        myFeed.removeAll()
        // присваиваем текстовому полю значение выбранной категории
        categoryTextField.text = categoryArray[row]
        // перебираем дублирующий массив и добавляем в основной нужные новости
        for i in feeds {
            if i.category == categoryTextField.text{
                myFeed.append(i)
                tableView.reloadData()
            }
        }
    }
}
    
    
    

