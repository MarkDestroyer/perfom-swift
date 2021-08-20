//
//  NewsPresenter.swift
//  VK
//
//  Created by Дмитрий Константинов on 24.02.2020.
//  Copyright © 2020 Дмитрий Константинов. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import KeychainAccess

protocol NewsPresenter {
    func viewDidAppear()
    func refreshTable()
    func uploadContent()
    func filterContent(searchText: String)
    
    func getNumberOfSections() -> Int
    func getNumberOfRowsInSection(section: Int) -> Int
    func getModelAtIndex(indexPath: IndexPath) -> NewsCellModel?
    
    init(view: NewsTableViewControllerUpdater)
}

class NewsPresenterImplementation: NewsPresenter {
    
    private var vkApi: VKApi
    private var database: NewsSource
    private weak var view: NewsTableViewControllerUpdater?
    private var newsResult: Results<NewsRealm>!
    private var token: NotificationToken?
    private var nextFrom = ""
    private var requestCompleted = false
    private let formatter = DateFormatter()
    
    required init(view: NewsTableViewControllerUpdater) {
        vkApi = VKApi()
        database = NewsRepository()
        self.view = view
    }
    
    deinit {
        token?.invalidate()
        do {
            try database.saveLastNews()
        } catch {
            print(error)
        }
    }
    
    func viewDidAppear() {
        getNewsFromApi()
    }
    
    func refreshTable() {
        getNewsFromApi()
    }
    
    func uploadContent() {
        if requestCompleted {
            requestCompleted = false
            getNewsFromApi(from: nextFrom)
        }
    }
    
    func filterContent(searchText: String) {
        do {
            newsResult = searchText.isEmpty ? try database.getAllNews() : try database.searchNews(text: searchText)
            tokenInitializaion()
        } catch {
            print(error)
        }
    }
    
    private func getNewsFromApi(from: String? = nil) {
        
        vkApi.getNewsList(token: Session.instance.token, userId: Session.instance.userId, from: from, version: Session.instance.version) { [weak self] result in
            switch result {
            case .success(let result):
                let posts = result.items.compactMap {
                    self?.postCreation(news: $0, profiles: result.profiles, groups: result.groups)
                }
                self?.database.addNews(posts: posts)
                self?.getNewsFromDatabase()
                if let nextFrom = result.nextFrom {
                    self?.nextFrom = nextFrom
                }
            case .failure(let error):
                self?.view?.endRefreshing()
                self?.view?.showConnectionAlert()
                print("[Logging] Error retrieving the value: \(error)")
            }
        }
        requestCompleted = true
    }
    
    private func getNextFrom() -> String? {
        return nextFrom
    }
    
    private func getNewsFromDatabase() {
        do {
            newsResult = try database.getAllNews()
            self.view?.endRefreshing()
            tokenInitializaion()
        } catch {
            self.view?.endRefreshing()
            print(error)
        }
    }
    
    private func tokenInitializaion() {
        
        token = newsResult?.observe { [weak self] results in
            switch results {
            case .error(let error):
                print(error)
            case .initial:
                self?.view?.reloadTable()
            case let .update(_, deletions, insertions, modifications):
                self?.view?.updateTable(forDel: deletions, forIns: insertions, forMod: modifications)
            }
        }
    }
    
    private func postCreation(news: NewsVK, profiles: [UserVK], groups: [GroupVK]) -> PostVK? {
        
        var post = PostVK(text: "", likes: 0, userLikes: 0, views: 0, comments: 0, reposts: 0, date: 0, authorImagePath: "", authorName: "", photos: [])
        
        post.text = news.text
        post.likes = news.likes.count ?? 0
        post.userLikes = news.likes.userLikes ?? 0
        if let views = news.views?.count {
            post.views = views
        } else {
            post.views = 0
        }
        post.comments = news.comments.count
        post.reposts = news.reposts.count ?? 0
        post.date = news.date
        
        getPostAuthor(news: news, profiles: profiles, groups: groups, post: &post)
        getPostPhotos(news: news, post: &post)
        
        if post.text == "", post.photos == [] { return nil }
        return post
    }
    
    private func getPostAuthor(news: NewsVK, profiles: [UserVK], groups: [GroupVK], post: inout PostVK) {
        
        if let source = news.sourceId {
            if source > 0 {
                profiles.forEach { if $0.id == source {
                    post.authorName = $0.fullname
                    post.authorImagePath = $0.photo100
                    }
                }
            }
            if source < 0 {
                groups.forEach { if $0.id == -source {
                    post.authorName = $0.name
                    post.authorImagePath = $0.photo100
                    }
                }
            }
        }
    }
    
    private func getPostPhotos(news: NewsVK, post: inout PostVK) {
        
        if let attachments = news.attachments {
            for attachment in attachments {
                if attachment.type == "photo" {
                    attachment.photo?.sizes?.forEach {
                        if $0.type == "r" {
                            post.photos.append($0.url)
                        }
                    }
                }
            }
        }
    }
}

extension NewsPresenterImplementation {
    
    func getNumberOfSections() -> Int {
        return 1
    }
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        return newsResult?.count ?? 0
    }
    
}

extension NewsPresenterImplementation {
    
    func getModelAtIndex(indexPath: IndexPath) -> NewsCellModel? {
        return renderWallRealmToNewsCell(news: newsResult?[indexPath.row])
    }
    
    private func renderWallRealmToNewsCell(news: NewsRealm?) -> NewsCellModel? {
        
        guard let news = news else { return nil }
        
        var photoCollection = [URL]()
        news.photos.forEach { if let url = URL(string: $0) { photoCollection.append(url)}}
        
        let cellModel = NewsCellModel(mainAuthorImage: news.authorImagePath,
                                      mainAuthorName: news.authorName,
                                      publicationDate: prepareDate(modelDate: news.date),
                                      publicationText: news.text,
                                      publicationLikeButtonStatus: news.userLikes == 1 ? true : false,
                                      publicationLikeButtonCount: news.likes,
                                      publicationCommentButton: prepareCount(modelCount: news.comments),
                                      publicationForwardButton: prepareCount(modelCount: news.reposts),
                                      publicationNumberOfViews: prepareCount(modelCount: news.views),
                                      photoCollection: photoCollection,
                                      newsCollectionViewIsEmpty: news.photos.isEmpty)
        
        return cellModel
    }
    
    private func prepareDate(modelDate: Int) -> String {
        formatter.dateFormat = "d MMMM в HH:mm"
        formatter.locale = Locale(identifier: "ru")
        let date = Date(timeIntervalSince1970: Double(modelDate))
        return formatter.string(from: date)
    }
    
    private func prepareCount(modelCount: Int) -> String {
        let count = modelCount
        if count < 1000 {
            return "\(modelCount)"
        } else if count < 10000 {
            return String(format: "%.1fK", Float(count) / 1000)
        } else {
            return String(format: "%.0fK", floorf(Float(count) / 1000))
        }
    }
}


enum RequestError: Error {
    case failedRequest(message: String)
    case decodableError
}

class VKApi {
    
    private let vkURL = "https://api.vk.com/method/"
    
    func getNewsList(token: String, userId:String, from: String?, version: String, completion: @escaping (Swift.Result<ResponseNews, Error>) -> Void ) {
        let requestURL = vkURL + "newsfeed.get"
        var params: [String : String]
        var news:[CommonResponseNews] = []
        var dispatchGroup = DispatchGroup()
        if let myFrom = from {
            params = ["access_token": token,
                      "user_id": userId,
                      "source_ids": "friends,groups,pages",
                      "filters": "post",
                      "count": "20",
                      "fields": "first_name,last_name,name,photo_100,online",
                      "start_from": myFrom,
                      "v": version]
            
        } else {
            params = ["access_token": token,
                      "user_id": userId,
                      "source_ids": "friends,groups,pages",
                      "filters": "post",
                      "count": "20",
                      "fields": "first_name,last_name,name,photo_100,online",
                      "v": version]
        }
        //Делаем остановку на дозагрузку, как в нативном VK-клиенте. Защита при одновременном срабатывании методов дозагрузки и обновления.
        Alamofire.Session.default.session.getAllTasks { tasks in tasks.forEach{ $0.cancel()} }
        
        for index in news.enumerated() {
            DispatchQueue.global().async(group: dispatchGroup) {
                Alamofire.Session.default.session.getAllTasks { tasks in tasks.forEach{ $0.cancel()} }
                
                AF.request(requestURL,
                           method: .post,
                           parameters: params as Parameters)
                    .responseData { (result) in
                        guard let data = result.value else { return }
                        do {
                            let result = try JSONDecoder().decode(CommonResponseNews.self, from: data)
                            news.append(result)
                            completion(.success(result.response))
                        } catch {
                            
                            //Пример обработки определенной ошибки (5: токен привязан к другому IP адресу)
                            do {
                                let result = try JSONDecoder().decode(ResponseErrorVK.self, from: data)
                                if result.error.errorCode == 5 {
                                    let keychain = Keychain(service: "UserSecrets")
                                    keychain["token"] = nil
                                    keychain["userId"] = nil
                                    print("[Logging] Your data is cleared, please restart the application")
                                }
                                completion(.failure(error))
                            } catch {
                                completion(.failure(error))
                            }
                            completion(.failure(error))
                        }
                    }
            }
        
        
            dispatchGroup.notify(queue: DispatchQueue.main) {
                completion(.success(news))
            }
        }
    }
}

struct ResponseErrorVK: Codable {
    let error: ErrorVK
}

struct ErrorVK: Codable {
    let errorCode: Int
    let errorMessage: String
    let requestParams: [RequestParam]

    enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case errorMessage = "error_msg"
        case requestParams = "request_params"
    }
}

struct RequestParam: Codable {
    let key, value: String
}



class NewsRealm: Object {
    
    @objc dynamic var text = ""
    @objc dynamic var likes = 0
    @objc dynamic var userLikes = 0
    @objc dynamic var views = 0
    @objc dynamic var comments = 0
    @objc dynamic var reposts = 0
    @objc dynamic var date = 0
    @objc dynamic var authorImagePath = ""
    @objc dynamic var authorName = ""
    
    override static func primaryKey() -> String? {
        return "date"
    }
    
    var photos = List<String>()
    
    func toModel() -> PostVK {
        
        var photosToModel = [String]()
        photos.forEach { photosToModel.append($0) }
    
        return PostVK(text: text, likes: likes, userLikes: userLikes, views: views, comments: comments, reposts: reposts, date: date, authorImagePath: authorImagePath, authorName: authorName, photos: photosToModel)
    }
}


struct PostVK {
    
    //TODO: (id, ownerId, fromId) -> enum PostType { case news , case wall }
    
    var id: Int?
    var ownerId: Int?
    var fromId: Int?
    var text: String
    var likes: Int
    var userLikes: Int
    var views: Int
    var comments: Int
    var reposts: Int
    var date: Int
    var authorImagePath: String
    var authorName: String
    var photos: [String]
}



protocol NewsSource {
    func getAllNews() throws -> Results<NewsRealm>
    func addNews(posts: [PostVK])
    func searchNews(text: String) throws -> Results<NewsRealm>
    func saveLastNews() throws
}

class NewsRepository: NewsSource {
    
    func getAllNews() throws -> Results<NewsRealm> {
        do {
            let realm = try Realm()
            return realm.objects(NewsRealm.self).sorted(byKeyPath: "date", ascending: false)
        } catch {
            throw error
        }
    }
    
    func addNews(posts: [PostVK]) {
        do {
            let realm = try Realm()
            try realm.write {
                var newsToAdd = [NewsRealm]()
                posts.forEach { post in
                    let postRealm = NewsRealm()
                    postRealm.text = post.text
                    postRealm.likes = post.likes
                    postRealm.userLikes = post.userLikes
                    postRealm.views = post.views
                    postRealm.comments = post.comments
                    postRealm.reposts = post.reposts
                    postRealm.date = post.date
                    postRealm.authorImagePath = post.authorImagePath
                    postRealm.authorName = post.authorName
                    post.photos.forEach { postRealm.photos.append($0)  }
                    newsToAdd.append(postRealm)
                }
                realm.add(newsToAdd, update: .modified)
                print("[Logging] NewsRealm get entities - \(newsToAdd.count)")
            }
        } catch {
            print(error)
        }
    }
    
    func searchNews(text: String) throws -> Results<NewsRealm> {
        do {
            let realm = try Realm()
            return realm.objects(NewsRealm.self).filter("text CONTAINS[c] %@", text)
        } catch {
            throw error
        }
    }
    
    func saveLastNews() throws {
        print("[Logging] SAVE NEWS")
        do {
            let realm = try Realm()
            let news = realm.objects(NewsRealm.self).sorted(byKeyPath: "date")
        
            if news.count > 20 {
                var newsToSave = [NewsRealm]()
                for i in 1...20 {
                    newsToSave.append(news[news.count - i])
                }
                try realm.write {
                    realm.delete(realm.objects(NewsRealm.self))
                    realm.add(newsToSave, update: .modified)
                }
            }
        } catch {
            throw error
        }
    }
}
