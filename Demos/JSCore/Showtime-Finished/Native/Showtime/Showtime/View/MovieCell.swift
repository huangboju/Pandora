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

class MovieCell: UICollectionViewCell {
  
  @IBOutlet weak var movieImage: UIImageView!
  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var moviePriceLabel: UILabel!
  
  var movieCellData: MovieCellData? {
    didSet {
      
      guard let movieCellData = movieCellData else {
        return
      }
      
      movieTitleLabel.text = movieCellData.movieTitle
      moviePriceLabel.text = "$\(movieCellData.moviePrice)"
      
      let thumbnailUrl = URL(string: movieCellData.movieImageUrl)
      
      loadImageFrom(url:thumbnailUrl)
    }
  }
  
  fileprivate func loadImageFrom(url: URL?) {
    guard let url = url else { return }
    
    URLSession.shared.dataTask(with: url) { data, response, url in
      
      guard let data = data, let image = UIImage(data: data) else {
        return
      }
      
      OperationQueue.main.addOperation {
        self.movieImage.image = image
      }
      
      }.resume()
  }
}
