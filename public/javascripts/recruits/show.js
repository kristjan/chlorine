function set_up_recruits_show() {
  $('#datepicker').datepicker();
  $('#datepicker').datepicker('option', 'showAnim', 'slideDown');
  $('#datepicker').datepicker('option', 'defaultDate', DEFAULT_DATE);
  $('#datepicker').datepicker('option', 'dateFormat', 'M d, yy (DD)');
}

$(document).ready(set_up_recruits_show);
