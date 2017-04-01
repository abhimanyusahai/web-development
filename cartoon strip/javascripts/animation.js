$(function() {
  var $blinds = $("[id^=blind]");
  var delay = 1500;
  var speed = 250;

  function startAnimation() {
    $blinds.each(function(i) {
      $blinds.eq(i).delay(i * (delay + speed)).animate({
        top: "+=" + $blinds.eq(i).height(),
        height: 0
      }, speed);
    });
  }

  $("a").on("click", function(e) {
    e.preventDefault();
    $blinds.finish();
    $blinds.removeAttr("style");
    startAnimation();
  });

  startAnimation();
});
