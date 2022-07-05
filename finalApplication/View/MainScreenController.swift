//
//  MainScreen.swift
//  finalApplication
//
//  Created by fernando babonoyaba on 4/6/22.
//

import UIKit
import Combine
import CoreData

class MainScreenController: UIViewController {
    
    var userName = ""
    var hello = "Hello: "
    private var viewModel: ViewModelProtocal?
    private var subscribers = Set<AnyCancellable>()
    private var allMovies: [Int: (title: String?, overview: String?, imageData: Data?)] = [:]
    private var cellView = 0
    private var searchTextToLoadCell = ""
    private var favorite: [Int] = []
    private var searchArray: [(id: Int?, title: String?, overview: String?, imageData: Data?)] = []

    private var userNameData = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data: [UserCoreData]?

    
    private var userLabel: UILabel = {
        let lable = UILabel()
        lable.translatesAutoresizingMaskIntoConstraints = false
        lable.text = ""
        lable.textColor = .black
        lable.font = UIFont(name: lable.font.familyName, size: 20)
        lable.font = UIFont.boldSystemFont(ofSize: 20)
        return lable
    }()
    
    private lazy var editAction = UIAction { _ in
        self.setUserExistance()
    }
    
    func setUserExistance(){
        let userScreen = UserNameController()
        userScreen.userNameDelegate = self
        userScreen.userExist = 1
        self.present(userScreen, animated: true)
    }
    
    private lazy var editUserButton: UIButton = {
        let button = UIButton(frame: .zero, primaryAction: editAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private lazy var segmentContol: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.insertSegment(withTitle: "Movie List", at: 0, animated: true)
        segment.insertSegment(withTitle: "Favorites", at: 1, animated: true)
        segment.selectedSegmentIndex = 0
        segment.addAction(segmentAction, for: .valueChanged)
        return segment
    }()
    
    private lazy var segmentAction = UIAction { action in
        self.searchBar.text = nil
        self.searchTextToLoadCell = ""
        self.searchArray = []
        self.cellView = self.segmentContol.selectedSegmentIndex
        self.tableView.reloadData()
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .white
        searchBar.delegate = self
        return searchBar
    }()
    
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PreviewCell.self, forCellReuseIdentifier: PreviewCell.identifier)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private var NavigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        bar.setTitleVerticalPositionAdjustment(.greatestFiniteMagnitude, for: .compactPrompt)
        bar.topItem?.title = "this"
        bar.translatesAutoresizingMaskIntoConstraints = false
        let navVontroller = UINavigationItem(title: "main")
        bar.setItems([navVontroller], animated: true)
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Movies"
        view.backgroundColor = .white
        fetchData()
        assemblingMVVM()
        setUp()
        setUpBinding()
        getData()
        
    }
    
    func getData() {

        for i in 0 ..< ((self.data?.count)!) {
            let id = self.data![i].id
            favorite.append(Int(id))
        }
   
    }
    
    func removeAllStories() {
        let request: NSFetchRequest = UserCoreData.fetchRequest()
        do {
            let stories = try context.fetch(request)
            for story in stories {
                context.delete(story)
            }
            try context.save()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
    private func fetchData() {
        do {
            self.data = try context.fetch(UserCoreData.fetchRequest())
        } catch  {

        }

   }
    
    func addData(id: Int){
        
        let userSavedData = UserCoreData(context: context)
        userSavedData.id = Int64(id)
                
        do {
            try context.save()
        } catch {
        }
        
        fetchData()
    }
    
    private func assemblingMVVM() {
        // create mvvm
        let mainNetworkManager = MainNetworkManager()
        viewModel = ViewModelController(networkManager: mainNetworkManager)
    }
    
    private func setUpBinding() {
        
        viewModel?
            .publisherStories
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscribers)
        
        viewModel?
            .publisherCache
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscribers)
        
        viewModel?.getStories()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         self.navigationController?.navigationBar.isHidden = true
     }
    

    func setUp(){
        
//        view.addSubview(NavigationBar)
        view.addSubview(userLabel)
        view.addSubview(editUserButton)
        view.addSubview(segmentContol)
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        let layout = view.safeAreaLayoutGuide
        
        userLabel.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
        userLabel.leftAnchor.constraint(equalTo: layout.leftAnchor, constant: 20).isActive = true
        userLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        editUserButton.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
        editUserButton.rightAnchor.constraint(equalTo: layout.rightAnchor, constant: -20).isActive = true
        editUserButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        segmentContol.topAnchor.constraint(equalTo: userLabel.bottomAnchor).isActive = true
        segmentContol.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
        segmentContol.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        
        searchBar.topAnchor.constraint(equalTo: segmentContol.bottomAnchor, constant: 10).isActive = true
        searchBar.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalToConstant: view.frame.width - 20).isActive = true
        
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
        tableView.rowHeight = 125
        
        saveUser(name: userName)

        userLabel.text = hello + userName
        
    }

}

extension MainScreenController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !searchTextToLoadCell.isEmpty {
            print(searchTextToLoadCell)
            return searchArray.count
        }
        if cellView == 0 {
            return viewModel?.totalRows ?? 0
        } else {
            return favorite.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: PreviewCell.identifier, for: indexPath) as? PreviewCell else { return PreviewCell() }
        cell.delegate = self
        
        let row = indexPath.row
        var id = viewModel?.getId(by: row)
        var color: UIColor?
        if row == 0 {
            setMoviewData()
        }

        if cellView == 1 {
            id = favorite[row]
        }
        
        var title = allMovies[id!]?.title
        var data = allMovies[id!]?.imageData
        var overview = allMovies[id!]?.overview
        
        if searchTextToLoadCell.count > 0 {
            id = searchArray[row].id
            title = searchArray[row].title
            data = searchArray[row].imageData
            overview = searchArray[row].overview
        }
        
        if favorite.contains(id!){
            color = UIColor.green
        }
        
        cell.configureCell(title: title, imageData: data, overview: overview, row: id!, favColor: color)

        return cell
    }
    
    private func setMoviewData() {
        for row in 0 ..< viewModel!.getCount()! {
            let id = viewModel?.getId(by: row)
            let title = viewModel?.getTitle(by: row)
            let data = viewModel?.getImageData(by: row)
            let overview = viewModel?.getOverview(by: row)
            
            allMovies[id!] = (title, overview, data)
        }
    
    }
    
}

extension MainScreenController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let row = indexPath.row
        if cellView == 0 {
            if !searchTextToLoadCell.isEmpty {
                manageArray(id: searchArray[row].id!)
            } else {
                manageArray(id: (viewModel?.getId(by: row))!)
            }
        } else {
            if !searchTextToLoadCell.isEmpty {
                manageArray(id: searchArray[row].id!)
            } else {
                manageArray(id: favorite[row])
            }
        }
        tableView.reloadData()
    }

    func manageArray(id: Int){
        var x = 0
        for i in favorite {

            if i == id {
                removeFavoricteObject(id: id)
                favorite.remove(at: x)
                return
            }
            x += 1
        }
        addData(id: id)
        favorite.append(id)

    }
    
    func removeFavoricteObject(id: Int) {
        let request: NSFetchRequest = UserCoreData.fetchRequest()
        do {
            let stories = try context.fetch(request)
            for story in stories {
                if id == story.id {
                    context.delete(story)
                }
            }
            try context.save()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
    
}

extension MainScreenController: ModeDetails {
    
    func modeDetailsButtonAction(row: Int) {
        let detailView = DetailViewController()
        detailView.modalPresentationStyle = .fullScreen
        
        let title = allMovies[row]?.title
        let data = allMovies[row]?.imageData
        let overview = allMovies[row]?.overview
        
        detailView.title = title
        
        detailView.configureDetailView(title: title, imageData: data, overview: overview)
        navigationController?.pushViewController(detailView, animated: false)
    }
}

extension MainScreenController: SetUserName {
    
    func setUserName(name: String) {
        userLabel.text = hello + name
    }
    
    func saveUser(name: String) {
        userNameData.set(name, forKey: "userDefaultsName")
    }

}

extension MainScreenController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchArray = []
        searchTextToLoadCell = searchText.lowercased()
        if cellView == 0 {
            let total = viewModel?.getCount()
            
            for row in 0 ..< total! {
                let id = viewModel?.getId(by: row)
                let title = viewModel?.getTitle(by: row)
                let overview = viewModel?.getOverview(by: row)
                let image = viewModel?.getImageData(by: row)
                
                var movieInfo = title! + overview!
                movieInfo = movieInfo.lowercased()
                
                if movieInfo.contains(searchTextToLoadCell) {
                    searchArray.append((id, title, overview, image))
                }
                
            }
        } else {
            let total = favorite.count
            
            for row in 0 ..< total {
                let id = favorite[row]
                let title = allMovies[id]?.title
                let overview = allMovies[id]?.overview
                let image = allMovies[id]?.imageData
                
                var movieInfo = title! + overview!
                movieInfo = movieInfo.lowercased()
                if movieInfo.contains(searchTextToLoadCell) {
                    searchArray.append((id, title, overview, image))
                }
            }
        }
             
        tableView.reloadData()

    }
    
}
