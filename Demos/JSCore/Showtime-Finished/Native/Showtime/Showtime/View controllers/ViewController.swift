/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import UIKit

let reuseId = "MovieCell"

class ViewController: UIViewController {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  let movieService = MovieService()
  
  var movies: [Movie]? {
    didSet {
      OperationQueue.main.addOperation {
        self.collectionView.reloadData()
      }
    }
  }
}

extension ViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    guard let
      currentMovie = movies?[(indexPath as NSIndexPath).row],
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as? MovieCell else {
        return UICollectionViewCell()
    }
    
    cell.movieCellData = MovieCellData(movieTitle: currentMovie.title, moviePrice: currentMovie.price, movieImageUrl: currentMovie.imageUrl)
    
    return cell
  }
}

extension ViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let priceText = textField.text, let price = Double(priceText) else {
      return
    }
    
    movieService.loadMoviesWith(limit: price) { [weak self] movies in
      self?.movies = movies
    }
  }
}
