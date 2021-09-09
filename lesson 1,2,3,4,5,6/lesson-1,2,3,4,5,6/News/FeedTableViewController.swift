//  FeedTableViewController.swift
//  client-server-1347
//
//  Created by Марк Киричко on 25.08.2021.
//

import UIKit
import Alamofire

class FeedTableViewController: UITableViewController {
    
    var nextFrom = ""
    var isLoading = false
    
    var feedItems: [Item] = []
    var feedProfiles: [Profile] = []
    var feedGroups: [Group] = []
    
    let feedAPI = FeedAPI()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        
        tableView.register(FeedItemFooter.self, forHeaderFooterViewReuseIdentifier: "sectionFooter")
        tableView.sectionFooterHeight = 50
        tableView.separatorStyle = .singleLine
        // refresh(sender: self)
        
        feedAPI.get() { [weak self] feed in
            guard let self = self else { return }
            
            //guard feed.count > 0 else { return }
            
            self.nextFrom = feed?.response.nextFrom ?? ""
            print(self.nextFrom)
            
            self.feedItems = feed!.response.items
            self.feedProfiles = feed!.response.profiles
            self.feedGroups = feed!.response.groups
            
            self.tableView.reloadData()
            
        }
    }
    
    
    @objc func refresh(sender:AnyObject)
    {
        self.refreshControl?.beginRefreshing()
        
        let mostFreshNewsDate = self.feedItems.first?.date ?? Date().timeIntervalSince1970
        print(mostFreshNewsDate)
        print(Date().timeIntervalSince1970)
        
        feedAPI.get(startTime: mostFreshNewsDate + 1) { [weak self] feed in
            guard let self = self else { return }
            
            self.refreshControl?.endRefreshing()
            
            guard let items = feed?.response.items else {return}
            guard let profiles = feed?.response.profiles else {return}
            guard let groups = feed?.response.groups else {return}
            
            self.feedItems = items + self.feedItems
            self.feedProfiles = profiles + self.feedProfiles
            self.feedGroups = groups + self.feedGroups
            
            let indexSet = IndexSet(integersIn: 0..<items.count)
            self.tableView.insertSections(indexSet, with: .automatic)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return feedItems.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let currentFeedItem = feedItems[section]
        
        if currentFeedItem.hasText && currentFeedItem.hasPhoto604 {
            return 3
        } else if !currentFeedItem.hasText && !currentFeedItem.hasPhoto604 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentFeedItem = feedItems[indexPath.section]
        
        switch indexPath.row {
        
        case 0:
            return feedInfoCell(indexPath: indexPath)
            
        case 1:
            if !currentFeedItem.hasText {
                return feedPhotoCell(indexPath: indexPath)
            } else {
                return feedTextCell(indexPath: indexPath)
            }
            
        case 2:
            return feedPhotoCell(indexPath: indexPath)
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionFooter") as! FeedItemFooter
        let currentFeedItem = feedItems[section]
        
        view.likes.text = "♥ \(currentFeedItem.likes?.count ?? 0)   |   ⚑ \(currentFeedItem.views?.count ?? 0)   |   💬 \(currentFeedItem.comments?.count ?? 0)"
        
        return view
    }
    
    // MARK: - Create & configure cells.
    
    // MARK: - Feed item author, date & image.
    func feedInfoCell(indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItemInfoCell", for: indexPath) as! FeedItemInfoTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        let currentFeedItem = feedItems[indexPath.section]
        
        switch feedItems[indexPath.section].sourceID!.signum() {
        
        case 1: // Пост пользователя
            let currentFeedItemProfile = feedProfiles.filter{ $0.id == currentFeedItem.sourceID }[0]
            cell.configure(profile: currentFeedItemProfile, postDate: currentFeedItem.date!)
            
        case -1: // Пост группы
            let currentFeedItemGroup = feedGroups.filter{ $0.id == abs(currentFeedItem.sourceID!) }[0]
            cell.configure(group: currentFeedItemGroup, postDate: currentFeedItem.date!)
            
        default: break
        }
        
        return cell
    }
    
    // MARK: - Feed item text.
    func feedTextCell(indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItemTextCell", for: indexPath) as! FeedItemTextTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        let currentFeedItem = feedItems[indexPath.section]
        
        if currentFeedItem.hasText {
            
            cell.configure(text: currentFeedItem.text)
            return cell
            
        } else { return UITableViewCell() }
    }
    
    // MARK: - Feed item photo.
    func feedPhotoCell(indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItemPhotoCell", for: indexPath) as! FeedItemPhotoTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        let currentFeedItem = feedItems[indexPath.section]
        
        if currentFeedItem.hasPhoto604 {
            
            cell.configure(url: currentFeedItem.attachments![0].photo!.photo604!)
            
            return cell
            
        } else {
            
            return UITableViewCell()
            
        }
    }
}

extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: date)
    }
}

extension FeedTableViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        // Выбираем максимальный номер секции, которую нужно будет отобразить в ближайшее время
        guard let maxSection = indexPaths.map({ $0.section }).max() else { return }
        print(maxSection)
        //       // Проверяем,является ли эта секция одной из трех ближайших к концу
        if maxSection > feedItems.count - 3, !isLoading {
            //           // Убеждаемся, что мы уже не в процессе загрузки данных
            
            //           // Начинаем загрузку данных и меняем флаг isLoading
            isLoading = true
            
            feedAPI.get(nextFrom: nextFrom) { [weak self] feed in
                guard let self = self else { return }
                // Прикрепляем новости к cуществующим новостям
                
                guard let nextFrom = feed?.response.nextFrom else {return}
                self.nextFrom = nextFrom
                
                guard let newItems = feed?.response.items else {return}
                guard let newProfiles = feed?.response.profiles else {return}
                guard let newGroups = feed?.response.groups else {return}
                
                let indexSet = IndexSet(integersIn: self.feedItems.count ..< self.feedItems.count + newItems.count)
                
                self.feedItems.append(contentsOf: newItems)
                self.feedProfiles.append(contentsOf: newProfiles)
                self.feedGroups.append(contentsOf: newGroups)
                
                // Обновляем таблицу
                self.tableView.insertSections(indexSet, with: .automatic)
                // Выключаем статус isLoading
                self.isLoading = false
            }
        }
    }
}

