// require variables: sessionId, apiKey, token
// require jquery

var session;
var subscribers = {};

if (TB.checkSystemRequirements() != TB.HAS_REQUIREMENTS) {
  alert("You don't have the minimum requirements to run this application."
      + "Please upgrade to the latest version of Flash.");
} else {
  session = TB.initSession(sessionId);

  session.addEventListener('sessionConnected', sessionConnectedHandler);
  session.addEventListener('streamCreated', streamCreatedHandler);
  session.addEventListener('streamDestroyed', streamDestroyedHandler);

  session.connect(apiKey, token);
}

//--------------------------------------
//  OPENTOK EVENT HANDLERS
//--------------------------------------

function sessionConnectedHandler(event) {
  // Subscribe the first streams, actually it is the teacher stream.
  if (event.streams.length > 0) {
    addStream(event.streams[0]);

	$.post(path, { scheduleId: scheduleId,userId: userId, flag: "Start"},
	   function(data) {
	     // alert("Stream Create: " + data);
	   });
  }
}

function streamDestroyedHandler(event) {
  $('#info').show();
	$.post(path, { scheduleId: scheduleId,userId: userId, flag: "End"},
	   function(data) {
	     // alert("Stream Finish: " + data);
	   });
	
}

function streamCreatedHandler(event) {
  $('#info').hide();

  if (event.streams.length > 0) {
    addStream(event.streams[0]);
  }
}

//--------------------------------------
//  HELPER METHODS
//--------------------------------------

function addStream(stream) {
  var subscriberDiv = document.createElement('div'); // Create a div for the subscriber to replace
  subscriberDiv.setAttribute('id', stream.streamId); // Give the replacement div the id of the stream as its id.
  $('#info').hide();
  document.getElementById("subscribers").appendChild(subscriberDiv);
  subscribers[stream.streamId] = session.subscribe(stream, subscriberDiv.id, {width: 200, height: 160});
}
