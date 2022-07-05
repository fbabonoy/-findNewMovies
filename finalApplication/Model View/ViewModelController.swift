//
//  ViewModelController.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/10/22.
//

import Foundation
import Combine

protocol ViewModelProtocal {
    var totalRows: Int { get }
    var publisherStories: Published<[Results]>.Publisher { get }
    var publisherCache: Published<[Int: Data]>.Publisher { get }
    func getStories()
    func getTitle(by row: Int) -> String?
    func getOverview(by row: Int) -> String?
    func getId(by row: Int) -> Int?
    func getCount() -> Int?
    func forceUpdate()
    func getImageData(by row: Int) -> Data?
}

class ViewModelController: ViewModelProtocal {

    var totalRows: Int { stories.count }
    var publisherStories: Published<[Results]>.Publisher { $stories }
    var publisherCache: Published<[Int: Data]>.Publisher { $cache }

    
    private let networkManager: NetworkManager
    private var subscribers = Set<AnyCancellable>()
    @Published private(set) var stories = [Results]()
    private var afterKey = ""
    private var isLoading = false
    @Published private var cache: [Int: Data] = [:]

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func getStories() {
        getStories(from: NetworkURL.url)
    }

    func forceUpdate() {
        stories = []
        cache = [:]
        getStories(from: NetworkURL.url, forceUpdate: true)
    }

    private func getStories(from url: String, forceUpdate: Bool = false) {
        guard !isLoading else { return }
        isLoading = true
        networkManager
            .getModel(Root.self, from: url)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in

                let temp = response.results
                if forceUpdate {
                    self?.stories = temp
                } else {
                    self?.stories.append(contentsOf: temp)
                }
                self?.downloadImages()
                self?.isLoading = false
            }
            .store(in: &subscribers)
    }
    
    private func getproduces(from url: String) {
        guard !isLoading else { return }
        isLoading = true
        networkManager
            .getModel(Root.self, from: url)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in

                let temp = response.results
                
                self?.stories.append(contentsOf: temp)
                
                self?.downloadImages()
                self?.isLoading = false
            }
            .store(in: &subscribers)
    }

    private func downloadImages() {
        var temp = [Int: Data]()

        let group = DispatchGroup()
        for (index, story) in stories.enumerated() {
            if let jpeg = story.posterPath {
                group.enter()
                let thumbnail = NetworkURL.image + jpeg
                networkManager.getData(from: thumbnail) { data in
                    if let data = data {
                        temp[index] = data
                    }
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.cache = temp
        }
    }

    func getImageData(by row: Int) -> Data? {
        return cache[row]
    }

    func getTitle(by row: Int) -> String? {
        guard row < stories.count else { return nil }
        let story = stories[row]
        return story.originalTitle
    }
    
    func getOverview(by row: Int) -> String? {
        guard row < stories.count else { return nil}
        let story = stories[row]
        return story.overview
    }
    
    func getId(by row: Int) -> Int? {
        guard row < stories.count else { return nil}
        let story = stories[row]
        return story.id
    }
    
    func getCount() -> Int? {
        let story = stories.count
        return story
    }


}
