//
//  docsTableView.swift
//  Documents
//
//  Created by Jacob Paul Hassler on 9/21/18.
//  Copyright © 2018 jphyr4. All rights reserved.
//

import UIKit

class docsTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var docsView: UITableView!
    
    var docs = [docStruct]()
    let date = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"

        date.dateStyle = .medium
        date.timeStyle = .medium
    }
    
    override func viewWillAppear(_ animated: Bool) {
        docs = Documents.get()
        docsView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return docs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "documentCell", for: indexPath)
        
        if let cell = cell as? DocumentTableViewCell {
            let doc = docs[indexPath.row]
            cell.nameLabel.text = doc.name
            cell.sizeLabel.text = String(doc.size) + " bytes"
            cell.dateLabel.text = date.string(from: doc.modificationDate)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            let doc = self.docs[indexPath.row]
            Documents.remove(url: doc.url)
            self.docs = Documents.get()
            self.docsView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [remove]
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectedDocument" {
            if let destination = segue.destination as? docsInputView,
                let row = docsView.indexPathForSelectedRow?.row {
                destination.document = docs[row]
            }
        }
    }

}
