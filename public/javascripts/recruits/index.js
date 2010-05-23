function initRecruitsIndex() {
  $('table.recruits').tablesorter({
    sortList: [[4,0]]
  });
  $('table tr').click(function(event) {
    document.location = $(this).find('a').attr('href');
  });
  $('table td').hover(
    function() {
      $(this).parent().children('td').addClass('hover');
    },
    function() {
      $(this).parent().children('td').removeClass('hover');
    }
  );

}

$(document).ready(initRecruitsIndex);
