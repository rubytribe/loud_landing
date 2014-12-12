var picturePosition = 0;

var increasePicturePosition = function(){
  picturePosition += 1;
  if (picturePosition == $('.posts .image-box').length) {
    picturePosition = 0;
  }
}

var showFirstPicture = function(){
  $('.posts .image-box').eq(0).removeClass('hide');
  // wait for the image to load
  //while ($('.current-image-box .post-image').width() == 0) {
  //  
  //}
  setHeaderWidth();
  setBackground();
}

var getRandomPicture = function(){
  var rand = Math.floor(Math.random() * $('.seen .image-box').length);
  $('.posts').append($('.seen .image-box').eq(rand));
  nextPicture();
}

var nextPicture = function(){
  $('.posts .image-box').eq(0).removeClass('hide');
  setHeaderWidth();
  setBackground();
}

var changePicture = function(){
  // check if there is a current image
  if ($('.posts .image-box').length > 0) {
    $('.seen').append($('.posts .image-box').eq(0));
    //$('.posts .image-box'.length > 0).eq(0).remove();
    // check if there is a next image
    if ($('.posts .image-box').length > 0) {
      nextPicture();
    }
    else {
      getRandomPicture();
    }
  }

}

var setHeaderWidth = function(){
    $('.posts .image-box .user').eq(0).width($('.posts .image-box .image-wrapper').eq(0).width());
}

var setBackground = function(){
  $('.background-image').css('background-image', "url(" + $('.posts .image-box .post-image').eq(0).attr('src') +")")
}


// wait for first picture to load
setTimeout(function(){
  $(document).ready(function(){
    showFirstPicture();
    setInterval(changePicture, 3000);
  })
}, 1000)
