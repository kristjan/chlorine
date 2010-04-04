function doThings() {
  setTimeout(showFlash, 1000);
  setTimeout(hideFlash, 10000);
}

function showFlash() {
  $('.flash_container').slideDown(600);
}

function hideFlash() {
  $('.flash').effect('puff', {}, 400);
  $('.flash_container').slideUp(600);
}

$(document).ready(doThings)
