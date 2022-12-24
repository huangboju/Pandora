'use strict';

// Fetch the top 50 movies using iTunes API.
var loadDataAsync = function(url) {

  return new Promise(function(resolve, reject) {

    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    request.onload = function() {

      if (request.status == 200) {
        resolve(request.response);
      } else {
        reject(Error(request.status));
      }
    };

    request.send();
  });
};
