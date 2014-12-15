var newPictures = false;
var processing = false;
var counter = 0;


var getRandomPicture = function(){
  var rand = Math.floor(Math.random() * $('.seen .image-box').length);
  $('.posts-wrapper .posts').append($('.seen .image-box').eq(rand));
  nextPicture();
}

var nextPicture = function(){
  $('.posts-wrapper .posts .image-box').eq(0).removeClass('hide');
  setHeaderWidth();
  setBackground();
  counter += 1;
}

var checkForNewPictures = function(){
  var last_post = $('.posts-wrapper .posts').attr('data-last-post');
  // do not send another request if the previous one did not finish
  if (processing) {
    return;
  }
  else{
    processing = true;
    $.ajax({
      method: 'GET',
      url: document.URL,
      data: {last_post: last_post, requested: 'new-posts'},
      dataType: 'html',
      success: function(data, textStatus, xhr){
        if (data == 'no new posts') {
          processing = false
        }
        else{
          $('.new-posts').append(data);
          //update last post date
          $('.posts-wrapper .posts').attr('data-last-post', $('.new-posts .posts').data('last-post'));
          newPictures = true;
        }
      }
    })
  }
}

var updatePosts = function(){
  // remove the empty .posts and add the new one
  $('.posts-wrapper .posts').remove();
  $('.posts-wrapper').append($('.new-posts .posts'));
  newPictures = false;
  processing = false;
  nextPicture();
}

var changePicture = function(){
  // after every 5 pictures show get the app banner
  if (counter >= 5) {
    $('.get-the-app').css('display', 'initial');
    counter = 0;
  }
  else {
    $('.get-the-app').css('display', 'none');
    // check if there is a current image
    if ($('.posts-wrapper .posts .image-box').length > 0) {
      // move the current image to .seen
      $('.seen').append($('.posts-wrapper .posts .image-box').eq(0));
      // check if there is a next image
      if ($('.posts-wrapper .posts .image-box').length > 0) {
        nextPicture();
      }
      else {
        checkForNewPictures();
        if (newPictures){
          updatePosts();
        }
        else{
          getRandomPicture();
        }
      }
    }
  }
}

// set the header width equal to the picture width
var setHeaderWidth = function(){
    $('.posts-wrapper .posts .image-box .user').eq(0).width($('.posts-wrapper .posts .image-box .image-wrapper').eq(0).width());
}

// set the current image as blured background
var setBackground = function(){
  $('.background-image').css('background-image', "url(" + $('.posts-wrapper .posts .image-box .post-image').eq(0).attr('src') +")")
}


// wait for first picture to load
setTimeout(function(){
  $(document).ready(function(){
    getRandomPicture();
    //setInterval(changePicture, 10000);
  })
}, 1000)
