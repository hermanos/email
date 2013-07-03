// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).ready(function() {

  $('a#read-email').click(function(e){
    e.preventDefault();
    e.stopPropagation();
    var old_text = $('a#read-email').text();
    $('a#read-email').text('Waiting...');

    var email_text = "Hi George, I was so happy to hear from you again. I hope you enjoyed the gift " +
      "we've sent you. I can't wait to meet you this summer. Take care, Alice.";

    $.getJSON("http://speech.jtalkplugin.com/api/?callback=?",
      {
        speech: email_text,
        usecache: "false"
      },
      function(json) {
        if (json.success == true){
          // Success - perform your audio operations here
          $('audio#player').attr('src', json.data.url);
          var audioElement = document.getElementById("player");
          audioElement.play();
          $('a#read-email').text(old_text);
        } else {
          // Failure
          $('a#read-email').text('Error.');
        }
    });

  });

});
