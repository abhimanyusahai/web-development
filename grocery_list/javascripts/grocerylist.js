$(document).ready(function() {
  $('form').submit(function(e) {
    e.preventDefault();

    var itemName = $('#itemname').val();
    var quantity = $('#quantity').val() || "1";
    var newItem = quantity + ' ' + itemName;
    $('ul').append('<li>' + newItem + '</li>');

    $('form').get()[0].reset();
  });
});
