'use strict';

var mapToNative = function(movies) {
  return movies.map(function (movie) {
    return Movie.movieWithTitlePriceImageUrl(movie.title, movie.price, movie.imageUrl);
  });
};
