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
import JavaScriptCore

let movieUrl = "https://itunes.apple.com/us/rss/topmovies/limit=50/json"

class MovieService {
  
  lazy var context: JSContext? = {
    let context = JSContext()
    
    guard let
      commonJSPath = Bundle.main.path(forResource: "common", ofType: "js"),
      let additionsJSPath = Bundle.main.path(forResource: "additions", ofType: "js") else {
        print("Unable to read resource files.")
        return nil
    }
    
    do {
      let common = try String(contentsOfFile: commonJSPath, encoding: .utf8)
      let additions = try String(contentsOfFile: additionsJSPath, encoding: .utf8)
      
        context?.setObject(Movie.self, forKeyedSubscript: "Movie" as (NSCopying & NSObjectProtocol)?)
      _ = context?.evaluateScript(common)
      _ = context?.evaluateScript(additions)
    } catch (let error) {
      print("Error while processing script file: \(error)")
    }
    
    return context
  }()

  func loadMoviesWith(limit: Double, onComplete complete: @escaping ([Movie]) -> ()) {
    guard let url = URL(string: movieUrl) else {
      print("Invalid url format: \(movieUrl)")
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data, let jsonString = String(data: data, encoding: String.Encoding.utf8) else {
        print("Error while parsing the response data.")
        return
      }
      
      let movies = self.parse(response: jsonString, withLimit: limit)
      complete(movies)
    }.resume()
  }

  func parse(response: String, withLimit limit: Double) -> [Movie] {
    guard let context = context else {
      print("JSContext not found.")
      return []
    }
    
    let parseFunction = context.objectForKeyedSubscript("parseJson")
    guard let parsed = parseFunction?.call(withArguments: [response]).toArray() else {
      print("Unable to parse JSON")
      return []
    }
    
    let filterFunction = context.objectForKeyedSubscript("filterByLimit")
    let filtered = filterFunction?.call(withArguments: [parsed, limit]).toArray()
    
    let mapFunction = context.objectForKeyedSubscript("mapToNative")
    guard let unwrappedFiltered = filtered,
      let movies = mapFunction?.call(withArguments: [unwrappedFiltered]).toArray() as? [Movie] else {
      return []
    }
    
    return movies
  }
}
