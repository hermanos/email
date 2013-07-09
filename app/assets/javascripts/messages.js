$(document).ready(function(){

	$('#list_mails ul li').eq(0).addClass('active');
	readElement($(this));

	$('#list_mails ul li').click(function(){
		$('#list_mails ul li').removeClass('active')
		$(this).addClass('active');

		readElement($(this));

    var messageId = $(this).attr('data-message');
    var url = "http://localhost:3000/messages/" + messageId + ".json";

    $.ajax({
      url: url,
    }).done(function(data) {
      $('#from_to').html(data['content']);
    });

	});

	$(document).keypress(function(param) {
  	email_activ = $('#list_mails ul li.active');

	  if (param.which == 106) { // j = jos
			if (email_activ.next().size() > 0){
				next_email = email_activ.next();
				$('#list_mails ul li').removeClass('active')
				next_email.addClass('active');
				readElement(next_email);
			}
	  };

	  if (param.which == 107) { // k = sus
			if (email_activ.prev().size() > 0){
				prev_email = email_activ.prev();
				$('#list_mails ul li').removeClass('active')
				prev_email.addClass('active');
				readElement(prev_email);
			}
	  };

	  console.log(param.which);

	  if (param.which == 109){ // m = read message
	  		mail_to_read = $('#from_to').text();
	  		readText(mail_to_read);
	  };
	});

	function readElement(liElement){
		var spans = liElement.find('a span');
    var textToRead = spans.eq(0).text().replace(/[\n\r]/g, '') + ', ' + spans.eq(1).text().replace(/[\n\r]/g, '');

    $.getJSON("http://speech.jtalkplugin.com/api/?callback=?",
      {
        speech: textToRead,
        usecache: "false"
      },
      function(json) {
        if (json.success == true){
          // Success - perform your audio operations here
          $('audio#player').attr('src', json.data.url);
          var audioElement = document.getElementById("player");
          audioElement.play();
        } else {
          // Failure
        }
    });
	}


  function readText(textToRead){
    $.getJSON("http://speech.jtalkplugin.com/api/?callback=?",
      {
        speech: textToRead,
        usecache: "false"
      },
      function(json) {
        if (json.success == true){
          // Success - perform your audio operations here
          $('audio#player').attr('src', json.data.url);
          var audioElement = document.getElementById("player");
          audioElement.play();
        } else {
          // Failure
        }
    });
  }


});
