$(document).ready(function() {
  var answer = 1 + Math.floor((99 * Math.random()));

  $('form').submit(function(e) {
    e.preventDefault();
    var userInput = parseInt($('input#guess').val(), 10);
    var message = '';

    if (userInput > answer) {
      message = 'Your guess is higher than the number I\'ve thought of!';
    } else if (userInput < answer) {
      message = 'Your guess is lower than the number I\'ve thought of!';
    } else {
      message = 'You\'ve won!';
    }

    $('p').text(message);
  });

  $('a').click(function(e) {
    e.preventDefault();
    answer = 1 + Math.floor((99 * Math.random()));
    $('input#guess').val('');
    $('p').text('Guess a number from 1 to 100');
  });
});
