//
//  DebateReplayViewController.swift
//  Riksdagskollen
//
//  Created by Gustav Aaro on 2020-11-18.
//

import UIKit

class DebateReplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    @IBOutlet weak var tableView: UITableView!
    var model: DebateReplayModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView(){
        tableView.register(DebateReplayTableViewCell.outgoingNib(), forCellReuseIdentifier: DebateReplayTableViewCell.outgoingIdentifier)
        tableView.register(DebateReplayTableViewCell.incomingNib(), forCellReuseIdentifier: DebateReplayTableViewCell.incomingIdentifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 700
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setIntiatingDocument(intiatingDocument: PartyDocument){
        self.model = DebateReplayModel(initiatingDocument: intiatingDocument)
        title = intiatingDocument.titel
        model!.getProtocolForDate({protocols in
            if protocols.count == 1 {
                self.model?.protocolId = protocols.first?.id                
                for (index, statement) in intiatingDocument.debatt!.anforande!.enumerated(){
                    self.model?.getSpeech(speechNo: statement.anf_nummer){ fetchedSpeech in
                        statement.speech = fetchedSpeech
                        if(self.tableView.indexPathsForVisibleRows!.contains(IndexPath(row: index, section: 0))) {
                            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                            self.tableView.performBatchUpdates({}, completion: { _ in })
                        }
                    } onError: { error in
                        self.onDebateLoadFail()
                    }
                }
            } else {
                self.onDebateLoadFail()
            }
        }, onError: { error in
            self.onDebateLoadFail()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.initiatingDocument?.debatt!.anforande?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optionalSpech = model?.initiatingDocument?.debatt!.anforande?[indexPath.row].speech
        if let speech = optionalSpech {
            var isOutGoing = false
            if let initiator = model?.debateInitiator {
                isOutGoing = speech.intressent_id == initiator
            } else {
                isOutGoing = indexPath.row % 2 == 0
            }
            var cell: DebateReplayTableViewCell
            
            if isOutGoing {
                cell = tableView.dequeueReusableCell(withIdentifier: DebateReplayTableViewCell.outgoingIdentifier)! as! DebateReplayTableViewCell
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: DebateReplayTableViewCell.incomingIdentifier)! as! DebateReplayTableViewCell
            }
            cell.configure(speech: speech, isOutgoing: isOutGoing)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DebateReplayTableViewCell.incomingIdentifier)! as! DebateReplayTableViewCell
            return cell
        }
    }
    
    func onDebateLoadFail(){
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: {
            Toast.shared.pop(message: "Kunde inte hämta debatt")
        })
    }
    
    



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
