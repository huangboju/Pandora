//
//  NoteEditorViewController.swift
//  SwiftTextKitNotepad
//
//  Created by Gabriel Hauber on 18/07/2014.
//  Copyright (c) 2014 Gabriel Hauber. All rights reserved.
//

import UIKit

class NoteEditorViewController: UIViewController, UITextViewDelegate {

  var textView: UITextView!
  var textStorage: SyntaxHighlightTextStorage!

  var note: Note!
  var timeView: TimeIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()

    createTextView()
    textView.isScrollEnabled = true

    NotificationCenter.default.addObserver(self,
      selector: #selector(preferredContentSizeChanged),
      name: .UIContentSizeCategoryDidChange,
      object: nil)

    timeView = TimeIndicatorView(date: note.timestamp)
    textView.addSubview(timeView)

    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: .UIKeyboardDidHide, object: nil)
  }

  func preferredContentSizeChanged(_ notification: Notification) {
    textStorage.update()
    updateTimeIndicatorFrame()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    note.contents = textView.text
  }

  override func viewDidLayoutSubviews() {
    updateTimeIndicatorFrame()
    textView.frame = view.bounds
  }

  func updateTimeIndicatorFrame() {
    timeView.updateSize()
    timeView.frame = timeView.frame.offsetBy(dx: textView.frame.width - timeView.frame.width, dy: 0)

    let exclusionPath = timeView.curvePathWithOrigin(timeView.center)
    textView.textContainer.exclusionPaths = [exclusionPath]
  }

  func createTextView() {
    // 1. Create the text storage that backs the editor
    let attrs = [NSFontAttributeName : UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
    let attrString = NSAttributedString(string: note.contents, attributes: attrs)
    textStorage = SyntaxHighlightTextStorage()
    textStorage.append(attrString)

    let newTextViewRect = view.bounds

    // 2. Create the layout manager
    let layoutManager = NSLayoutManager()

    // 3. Create a text container
    let containerSize = CGSize(width: newTextViewRect.width, height: CGFloat.greatestFiniteMagnitude)
    let container = NSTextContainer(size: containerSize)
    container.widthTracksTextView = true
    layoutManager.addTextContainer(container)
    textStorage.addLayoutManager(layoutManager)

    // 4. Create a UITextView
    textView = UITextView(frame: newTextViewRect, textContainer: container)
    textView.delegate = self
    view.addSubview(textView)
  }

  func updateTextViewSizeForKeyboardHeight(_ keyboardHeight: CGFloat) {
    textView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - keyboardHeight)
  }

  func keyboardDidShow(_ notification: Notification) {
    if let rectValue = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
      let keyboardSize = rectValue.cgRectValue.size
      updateTextViewSizeForKeyboardHeight(keyboardSize.height)
    }
  }

  func keyboardDidHide(_ notification: Notification) {
    updateTextViewSizeForKeyboardHeight(0)
  }
}
