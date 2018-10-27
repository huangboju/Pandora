'use strict';

var resultContainer = {};
var errorLabel = {};

var onload = function() {
  errorLabel = document.getElementById('errorMessage');
  resultContainer = document.querySelector('.results').querySelector('.container');
}

// Return movies, which fit within a given budget limit.
var budgetMoviesWithLimit = function(limit) {

  cleanup();

  var url = 'https://itunes.apple.com/us/rss/topmovies/limit=50/json';

  return new Promise(function(resolve, reject) {
    loadDataAsync(url)
    .then(parseJson)
    .then(function(movies) {
      resolve(filterByLimit(movies, limit));
    })
    .catch(function(error) {
      var errorMessage = document.createTextNode(error);
      errorLabel.appendChild(errorMessage);
    });
  });
};

// Handle input change
var inputChanged = function(field) {

  budgetMoviesWithLimit(Number(field.value)).then(function(limited) {

    var movies = limited;

    var numberOfColumns = 4;
    var numberOfRows = Math.floor(movies.length / numberOfColumns);
    var index = 0;

    for (var row = 0; row < numberOfRows; row++) {
      for (var column = 0; column <numberOfColumns; column++, index++) {
        createMovieColumn(movies[index], resultContainer);
      };
    };

    for (var i = index; i < movies.length; i++) {
      createMovieColumn(movies[i], resultContainer);
    };

  });
}

// Add movie column divs to a given parent node.
var createMovieColumn = function(movie, parent) {

  var columnDiv = document.createElement('columnDiv');
  columnDiv.setAttribute('class', 'column');
  parent.appendChild(columnDiv);

  var movieDiv = document.createElement('div');
  movieDiv.setAttribute('class', 'movieItem');

  var image = document.createElement('img');
  image.setAttribute('src', movie.imageUrl);
  movieDiv.appendChild(image);

  var titleLabel = document.createElement('p');
  titleLabel.setAttribute('id', 'titleLabel');
  var titleText = document.createTextNode(movie.title);
  titleLabel.appendChild(titleText);

  movieDiv.appendChild(titleLabel);

  var priceLabel = document.createElement('p');
  priceLabel.setAttribute('id', 'priceLabel');
  var priceText = document.createTextNode('$' + movie.price);
  priceLabel.appendChild(priceText);
  movieDiv.appendChild(priceLabel);

  columnDiv.appendChild(movieDiv);
}

// Remove child nodes.
var cleanup = function() {

  while(errorLabel.firstChild) {
    errorLabel.removeChild(errorLabel.firstChild);
  }

  while(resultContainer.firstChild) {
    resultContainer.removeChild(resultContainer.firstChild);
  }

}
