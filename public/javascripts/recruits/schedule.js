function set_up_scheduler() {
  $('.selectlist').selectList({
    sort: true,
    onAdd: function(select, value, text) {
      $(select).attr('selectedIndex', 0);
    }
  });
  $('.selectlist').attr('selectedIndex', 0);
}

$(document).ready(function() {
  set_up_scheduler();
});
