function doThings() {
  setNotab();
  runFlash();
}

function setNotab(){
  $('a').attr('tabindex', -1);
  $('.notab').attr('tabindex', -1);
}

FLASH_DESTROYED = false;

function runFlash() {
  if ($('#flash').size() > 0) {
    setTimeout(showFlash, 500);
    setTimeout(hideFlash, 10500);
    $('#flash_content').click(function() {
        hideFlash();
        FLASH_DESTROYED = true;
    });
  }
}

function showFlash() {
  $('#header_content').animate({opacity: 0.1}, 400);
  $('#flash').effect('puff', {mode: 'show'}, 400);
}

function hideFlash() {
  if (!FLASH_DESTROYED) {
    $('#flash').effect('puff', {mode: 'hide'}, 400);
  }
  $('#header_content').animate({opacity: 1}, 400);
}

$(document).ready(doThings)
