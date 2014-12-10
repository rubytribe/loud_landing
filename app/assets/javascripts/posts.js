var picturePosition = 0;

var increasePicturePosition = function(){
  picturePosition += 1;
  if (picturePosition == $('.posts .image-box').length) {
    picturePosition = 0;
  }
}

var showFirstPicture = function(){
  $('.posts .image-box').eq(0).removeClass('hide');
}

var nextPicture = function(){
  $('.posts .image-box').eq(picturePosition).addClass('hide');
  increasePicturePosition();
  $('.posts .image-box').eq(picturePosition).removeClass('hide');
}


$(document).ready(function(){
  showFirstPicture();
  setInterval(nextPicture, 20000);
})