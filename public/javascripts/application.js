function doThings() {
  setNotab();
  setTimeout(showFlash, 1000);
  setTimeout(hideFlash, 10000);
}

function setNotab(){
  $('a').attr('tabindex', -1);
  $('.notab').attr('tabindex', -1);
}

function showFlash() {
  $('.flash_container').slideDown(600);
}

function hideFlash() {
  $('.flash').effect('puff', {}, 400);
  $('.flash_container').slideUp(600);
}

$(document).ready(doThings)
