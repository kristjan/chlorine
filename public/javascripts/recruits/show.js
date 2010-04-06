function set_up_recruits_show() {
  $('#datepicker').datepicker();
  $('#datepicker').datepicker('option', 'showAnim', 'slideDown');
  $('#datepicker').datepicker('option', 'defaultDate', DEFAULT_DATE);
  $('#datepicker').datepicker('option', 'dateFormat', 'M d, yy (DD)');
  expandActivity($('.current_activity').find('.tree_expand a'));
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
  $(elem).parent('.short').slideUp(400, function() {
    $(elem).parent('.short').siblings('.long').slideDown();
  });
}

$(document).ready(set_up_recruits_show);
