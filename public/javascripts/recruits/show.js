function set_up_recruits_show() {
  set_up_tabs();
  set_up_datepicker();
}

function set_up_tabs() {
  $('#activity_tabs').tabs();
  $('#activity_tabs').tabs('select', SELECTED_TAB);
}

function set_up_datepicker() {
  $('.datepicker').datepicker();
  $('.datepicker').datepicker('option', 'showAnim', 'slideDown');
  $('.datepicker').each(function() {
    var default_date = new Date($(this).attr('default'));
    $(this).datepicker('option', 'defaultDate', default_date);
  });
  $('.datepicker').datepicker('option', 'dateFormat', 'M d, yy (DD)');
}

function expandActivity(elem, callback) {
  $(elem).parents('.activity').children('ul').
          slideToggle(400, callback);
  var cur = $(elem).html();
  if (cur == '+') {
    $(elem).html('-');
  } else {
    $(elem).html('+');
  }
}

function expandToFeedback(activity_id, anchor) {
  var activity = $('#activity_'+activity_id);
  var feedback = activity.find('ul');

  var scrollToAnchor = function() {
    $('html, body').animate({
      scrollTop: $('[name='+anchor+']').offset().top
    }, 500);
  };

  if (feedback.css('display') == 'none') {
    expandActivity(activity.find('.tree_expand a'), scrollToAnchor);
  } else {
    scrollToAnchor();
  }
}

function expandFeedback(elem) {
  $(elem).parent('h3').siblings('.body').slideDown();
  $(elem).hide();
}

$(document).ready(set_up_recruits_show);
