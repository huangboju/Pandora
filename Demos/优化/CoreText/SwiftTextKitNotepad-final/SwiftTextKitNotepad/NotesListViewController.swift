//
//  NotesListViewController.swift
//  SwiftTextKitNotepad
//
//  Created by Gabriel Hauber on 18/07/2014.
//  Copyright (c) 2014 Gabriel Hauber. All rights reserved.
//

import UIKit

class NotesListViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(self,
      selector: #selector(NotesListViewController.preferredContentSizeChanged(_:)),
      name: NSNotification.Name.UIContentSizeCategoryDidChange,
      object: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // whenever this view controller appears, reload the table. This allows it to reflect any changes
    // made whilst editing notes
    tableView.reloadData()
  }

  func preferredContentSizeChanged(_ notification: Notification) {
    tableView.reloadData()
  }

  // #pragma mark - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell

    let note = notes[indexPath.row]
    let font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    let textColor = UIColor(red: 0.175, green: 0.458, blue: 0.831, alpha: 1)
    let attributes = [
      NSForegroundColorAttributeName : textColor,
      NSFontAttributeName : font,
      NSTextEffectAttributeName : NSTextEffectLetterpressStyle
    ] as [String : Any]
    let attributedString = NSAttributedString(string: note.title, attributes: attributes)

    cell.textLabel?.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)

    cell.textLabel?.attributedText = attributedString
    
    return cell
  }

  let label: UILabel = {
    let temporaryLabel = UILabel(frame: CGRect(x: 0, y: 0, width: Int.max, height: Int.max))
    temporaryLabel.text = "test"
    return temporaryLabel
    }()

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    label.sizeToFit()
    return label.frame.height * 1.7
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      notes.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }

  // #pragma mark - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
    if let editorVC = segue.destination as? NoteEditorViewController {

      if "CellSelected" == segue.identifier {
        if let path = tableView.indexPathForSelectedRow {
          editorVC.note = notes[path.row]
        }
      } else if "AddNewNote" == segue.identifier {
        let note = Note(text: " ")
        editorVC.note = note
        notes.append(note)
      }
    }
  }

}
