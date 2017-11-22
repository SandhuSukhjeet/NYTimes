//
//  ArticlesViewController.swift
//  NYTimes
//
//  Created by sukhjeet singh sandhu on 20/11/17.
//  Copyright © 2017 sukhjeet singh sandhu. All rights reserved.
//

import UIKit
import CoreData

class ArticlesViewController: UIViewController {

    var dataModel = ArticlesDataModel()
    var loadMoreDataButton = UIButton()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var articlesTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Articles"
        self.articlesTableView.estimatedRowHeight = 500
        self.articlesTableView.rowHeight = UITableViewAutomaticDimension
        self.configureFooterView()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.startAnimating()
        self.dataModel.articlesFetchedResultsController.delegate = self
        do {
            try self.dataModel.articlesFetchedResultsController.performFetch()
        } catch {
            self.showAlert(with: "Unable to fetch data from Core Data")
        }
        self.loadData()
    }

    fileprivate func configureFooterView() {
        let footerViewFrame = CGRect(x: 0, y: 0, width: self.articlesTableView.frame.width, height: 100)
        self.articlesTableView.tableFooterView = UIView(frame: footerViewFrame)
        loadMoreDataButton = UIButton(frame: CGRect(x: footerViewFrame.midX - 100, y: 0, width: 200, height: 44))
        loadMoreDataButton.isHidden = true
        loadMoreDataButton.setTitle("Click to load more", for: .normal)
        loadMoreDataButton.setTitleColor(.blue, for: .normal)
        loadMoreDataButton.addTarget(self, action: #selector(ArticlesViewController.loadMoreData), for: .touchUpInside)
        self.articlesTableView.tableFooterView?.addSubview(loadMoreDataButton)
    }

    fileprivate func loadData() {
        DispatchQueue.global(qos: .background).async {
            self.dataModel.getArticles(completion: { (error) in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    self.showAlert(with: error)
                }
            })
        }
    }

    fileprivate func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    @objc func loadMoreData() {
        self.dataModel.createArticleObjects { (error) in
            if let error = error {
                self.showAlert(with: error)
            }
        }
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let fetchedObjects = self.dataModel.articlesFetchedResultsController.fetchedObjects {
            if fetchedObjects.count != 0 {
                self.activityIndicator.stopAnimating()
                self.loadMoreDataButton.isHidden = false
            }
        }
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fetchedObjects = self.dataModel.articlesFetchedResultsController.fetchedObjects {
            if fetchedObjects.count != 0 {
                self.activityIndicator.stopAnimating()
            }
            return fetchedObjects.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articles", for: indexPath) as! ArticlesTableViewCell
        if let fetchedObjects = self.dataModel.articlesFetchedResultsController.fetchedObjects {
            cell.selectionStyle = .none
            cell.configureCell(with: fetchedObjects[indexPath.row])
        }
        return cell
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let fetchedObjects = self.dataModel.articlesFetchedResultsController.fetchedObjects {
            let article = fetchedObjects[indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
            viewController.article = article
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = tableView.indexPathsForVisibleRows?.last?.row
        if indexPath.row == row && indexPath.section == 0 {
            
        }
    }
}

extension ArticlesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.articlesTableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.articlesTableView.endUpdates()
        self.activityIndicator.stopAnimating()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                articlesTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            break;
        }
    }
}
