
var mySession;
var publisher;
var myArchive;


// TB.setLogLevel(TB.ALL);
TB.addEventListener(TB.EXCEPTION, exceptionHandler);


if (apiKey == "" || sessionId == "") {
	var error_message = "This page cannot connect. Please edit the"
	                   + "apiKey and sessionId values in the source code.";
	window.document.write(error_message);
	return;
}
mySession = TB.initSession(sessionId);
mySession.addEventListener("sessionConnected", sessionConnectedHandler);

connect();


// Connects to the OpenTok session.
function connect() {
	mySession.connect(apiKey, token);
}

// Called when the user clicks the Publish link. Publishes the local webcam's stream to the session.
function publish() {
	$('#info').hide();
	if (!publisher) {
	    var parentDiv = document.getElementById("myCamera");
	    var publisherDiv = document.createElement('div'); // Create a div for the publisher to replace
	    publisherDiv.setAttribute('id', 'opentok_publisher');
	    parentDiv.appendChild(publisherDiv);
	    publisher = mySession.publish(publisherDiv.id, {width: 200, height: 160}); // Pass the replacement div id to the publish method
		$("#createArchive").removeAttr("disabled");
	}
}



/* Called when the session connects. Subscribes existing streams. Adds links in
 * the page to publish. For moderators, adds event listeners for
 * events related to archiving.
 */
function sessionConnectedHandler(event) {

	publish();

	if (mySession.capabilities.record) {
		mySession.addEventListener("sessionRecordingStarted", sessionRecordingStartedHandler);
		mySession.addEventListener("archiveCreated", archiveCreatedHandler);
		// mySession.addEventListener("archiveClosed", archiveClosedHandler);
		mySession.addEventListener("sessionRecordingStopped", sessionRecordingStoppedHandler);
	}
	if (mySession.capabilities.playback) {
		mySession.addEventListener("archiveLoaded", archiveLoadedHandler);
		mySession.addEventListener("playbackStarted", playbackStartedHandler);
		mySession.addEventListener("playbackStopped", playbackStoppedHandler);
	}
	

}




/* Called in response to the moderator clicking the "Create archive" link.
 * Creates an archive and creates a unique name for it (based on a timestamp).
 */
function createArchive() {
	var uniqueTitle = "archive" + new Date().getTime();
	mySession.createArchive(apiKey, "perSession", uniqueTitle);
	$("#createArchive").attr("disabled","disabled");
}

// Called in response to the archiveCreated event. The moderator can now record the session.
function archiveCreatedHandler(event) {
	myArchive = event.archives[0];
	
	// store acchive to this schedule
	
	$.post(path, { scheduleId: scheduleId,archiveId: myArchive.archiveId },
	   function(data) {
	     // alert("Data Loaded: " + data);
	   });
	

	
	$("#startRecording").removeAttr("disabled");
	$("#closeArchive").removeAttr("disabled");
}

function recordSession() {
	mySession.startRecording(myArchive);
	$("#startRecording").attr("disabled","disabled");
}

// Called in response to the sessionRecordingStarted event. The moderator can now stop recording.
function sessionRecordingStartedHandler(event) {
	$("#stopRecording").removeAttr("disabled");
}

/* Called in response to the moderator clicking the "Stop recording" link.
 * Stops the recording.
 */
function stopRecordingSession() {
	mySession.stopRecording(myArchive);
	$("#stopRecording").attr("disabled","disabled");
}

// Called in response to the sessionRecordingStopped event. The moderator can now close the archive.
function sessionRecordingStoppedHandler(event) {
	$("#closeArchive").removeAttr("disabled");
}

/* Called in response to the moderator clicking the "Close archive" link.
 * Closes the archive.
 */
function closeArchive() {
	mySession.closeArchive(myArchive);
	$("#closeArchive").attr("disabled","disabled");
	// $("#createArchive").removeAttr("disabled");
}

// Called in response to the archiveClosed event. The moderator can now load the archive (and play it back).
function archiveClosedHandler(event) {
	
	show("loadArchiveLink");
}

/* Called in response to the moderator clicking the "Load archive" link.
 * Loads the archive that was just recorded.
 */
function loadArchive() {
	mySession.loadArchive(myArchive.archiveId);
	hide("loadArchiveLink");
}

// Called in response to the archiveLoaded event. The moderator can now start playing back the archive.
function archiveLoadedHandler(event) {
	myArchive = event.archives[0];
	show("startPlaybackLink");
}

/* Called in response to the moderator clicking the "Start playback" link.
 * Starts playing back the archive.
 */
function startPlayback() {
	myArchive.startPlayback();
	hide("startPlaybackLink");
}

// Called in response to the playbackStarted event. The moderator can now (optionally) stop playing back the archive.
function playbackStartedHandler(event) {
	show("stopPlaybackLink");
}

/* Called in response to the moderator clicking the "Stop playback" link.
 * Stops playing back the archive.
 */
function stopPlayback() {
	myArchive.stopPlayback();
	hide("stopPlaybackLink");
}

// Called in response to the playbackStopped event. The moderator can now (optionally) play back the archive again.
function playbackStoppedHandler(event) {
	hide("stopPlaybackLink");
	show("startPlaybackLink");
}

function show(id) {
	document.getElementById(id).style.display = "block";
}

function hide(id) {
	document.getElementById(id).style.display = "none";
}

function exceptionHandler(event) {
	alert("Exception! msg: " + event.message + "<br /> title: " + event.title + "<br /> code: " + event.code);
}
