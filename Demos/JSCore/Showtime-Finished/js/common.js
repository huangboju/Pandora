'use strict';

// Parse a given JSON data into an array of movie objects.
var parseJson = function(json) {

  var data = JSON.parse(json);
  var movies = data['feed']['entry'];

  return movies.map(function(movie) {
    return {
      title: movie['im:name']['label'],
      price: Number(movie['im:price']['attributes']['amount']).toFixed(2),
      imageUrl: movie['im:image'].reverse()[0]['label']
    };
  });
};

// Filter for movies below a given limit.
var filterByLimit = function(movies, limit) {

  if (isNaN(limit) || limit <= 0) {
    throw Error("Please enter a valid price.");
  };

  var limited = movies.filter(function(movie) {
    return (movie.price <= limit);
  });

  return limited
};
