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

function showAllRows() {
  $('tr.rejected').show();
  $('.tablecontrols .showall').hide();
  $('.tablecontrols .showinprocess').show();
}

function showInProcessRows() {
  $('tr.rejected').hide();
  $('.tablecontrols .showinprocess').hide();
  $('.tablecontrols .showall').show();
}

$(document).ready(initRecruitsIndex);
