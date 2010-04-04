function doThings() {
  setNotab();
  runFlash();
}

function setNotab(){
  $('a').attr('tabindex', -1);
  $('.notab').attr('tabindex', -1);
}

function runFlash() {
  if ($('#flash').size() > 0) {
    setTimeout(showFlash, 500);
    setTimeout(hideFlash, 10500);
  }
}

function showFlash() {
  $('#header_content').animate({opacity: 0.1}, 400);
  $('#flash').effect('puff', {mode: 'show'}, 400);
}

function hideFlash() {
  $('#flash').effect('puff', {mode: 'hide'}, 400);
  $('#header_content').animate({opacity: 1}, 400);
}

$(document).ready(doThings)
