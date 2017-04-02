$(document).ready(function() {
  var result = 0;

  $('form').submit(function(e) {
    e.preventDefault();
    var num1 = parseInt($('#number1').val(), 10);
    var num2 = parseInt($('#number2').val(), 10);
    var op = $('select').val();

    switch (op) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case '*':
        result = num1 * num2;
        break;
      case '/':
        result = num1 / num2;
        break;
    }

    $('#result').text(result);
  });
});
