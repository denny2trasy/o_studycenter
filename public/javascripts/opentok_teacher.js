// require variables: sessionId, apiKey, token
// require jquery

var session;
var publisher;

if (TB.checkSystemRequirements() != TB.HAS_REQUIREMENTS) {
  alert("You don't have the minimum requirements to run this application."
      + "Please upgrade to the latest version of Flash.");
} else {
  session = TB.initSession(sessionId);

  session.addEventListener('sessionConnected', sessionConnectedHandler);

  var properties = function(){
	this.connectionData = "";
	this.detectConnectionQuality = 1;
};

  session.connect(apiKey, token, properties);
}

function startPublishing() {
  if (!publisher) {
    var parentDiv = document.getElementById("myCamera");
    var publisherDiv = document.createElement('div'); // Create a div for the publisher to replace
    publisherDiv.setAttribute('id', 'opentok_publisher');
    parentDiv.appendChild(publisherDiv);
    publisher = session.publish(publisherDiv.id, {width: 200, height: 160}); // Pass the replacement div id to the publish method
  }
}

//--------------------------------------
//  OPENTOK EVENT HANDLERS
//--------------------------------------

function sessionConnectedHandler(event) {
  $('#info').hide();

  startPublishing();
}
