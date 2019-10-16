$(function() {
// Set the date we're counting down to
// e.g. "Oct 12, 2018 24:00:00"
var countDownDate = new Date(document.getElementById("countdown").getAttribute("data-date")).getTime();

// Update the count down every 1 second
var x = setInterval(function() {

  // Get todays date and time
  var now = new Date().getTime();

  // Find the distance between now and the count down date
  var distance = countDownDate - now;

  // Time calculations for days, hours, minutes and seconds
  var days = Math.floor(distance / (1000 * 60 * 60 * 24));
  var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
  var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
  var seconds = Math.floor((distance % (1000 * 60)) / 1000);

  if (document.getElementById("countdown") != null) {
    // Display the result in the element with id="demo"
    document.getElementById("countdown").innerHTML = "Hacking Begins In: " + hours + "h "
    + minutes + "m " + seconds + "s ";

    // If the count down is finished, write some text
    if (distance < 0) {
      clearInterval(x);
      document.getElementById("countdown").innerHTML = "0h 0m 0s... Let the hacking begin!";
    }
  } else {
    clearInterval(x);
  }
}, 1000);
});