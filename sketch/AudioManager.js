
  var micOn = false;

  var contextMic;
  var contextAudioFile;

  var analyserMic;
  var analyserLeft;
  var analyserRight;

  var audioBuffer;
  var sourceNode;
  var javascriptNode;

  function accessMic() {
  	console.log("accessMic");
    contextMic = new AudioContext();
    navigator.mediaDevices.getUserMedia({audio: true, video: false}).then(function(stream) {
      var mic = contextMic.createMediaStreamSource(stream);
      var filter = contextMic.createBiquadFilter();
      filter.type = 'lowpass';
      mic.connect(filter);
      if(!analyserMic){
        analyserMic = contextMic.createAnalyser();
      }
      // default analyser.fftSize is 2048
      mic.connect(analyserMic);
    }).catch(function(err) {
      console.log(err);
      alert("It looks like your browser doesn't support Microphone Input. Please use Chrome browser.");
    });
  }

  function toggleMic(){
    micOn = !micOn;
    if(!micOn){
      loadSound("data/01_reason_to_sing.mp3");
    }else{
      sourceNode.stop();
    }
  }

  function accessAudioFile() {
    console.log("accessAudioFile");
    if(!micOn){
      loadSound("data/01_reason_to_sing.mp3");
    }
  }

  // load the specified sound
  function loadSound(url) {
    // init the audio nodes first for sound analysis
    setupAudioNodes();

    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    request.responseType = 'arraybuffer';

    // When loaded decode the data
    request.onload = function() {
      // decode the data
      contextAudioFile.decodeAudioData(request.response, function(buffer) {
        // when the audio is decoded play the sound
        playSound(buffer);
      }, function onError(e){
        console.log("load sound ERROR: " + e);
      });
    }
    request.send();
  }

  function playSound(buffer) {
    sourceNode.buffer = buffer;
    sourceNode.start(0);
  }

  function setupAudioNodes() {
    console.log("setupAudioNodes")
    contextAudioFile = new AudioContext();
    // setup a javascript node
    javascriptNode = contextAudioFile.createScriptProcessor(2048, 1, 1);
    // connect to destination, else it isn't called
    javascriptNode.connect(contextAudioFile.destination);

    // setup a analyzer
    analyserLeft = contextAudioFile.createAnalyser();
    analyserLeft.smoothingTimeConstant = 0.3;
    analyserLeft.fftSize = 1024;

    analyserRight = contextAudioFile.createAnalyser();
    analyserRight.smoothingTimeConstant = 0.0;
    analyserRight.fftSize = 1024;

    // create a buffer source node
    sourceNode = contextAudioFile.createBufferSource();
    splitter = contextAudioFile.createChannelSplitter();

    // connect the source to the analyser and the splitter
    sourceNode.connect(splitter);

    // connect one of the outputs from the splitter to
    // the analyser
    splitter.connect(analyserLeft, 0, 0);
    splitter.connect(analyserRight, 1, 0);

    // we use the javascript node to draw at a
    // specific interval.
    analyserLeft.connect(javascriptNode);

    // and connect to destination
    sourceNode.connect(contextAudioFile.destination);
  }

  function getFreqArray() {
      var tmpDataArray = null;
      var tmpAnalyser = micOn ? analyserMic : analyserLeft;
      if(tmpAnalyser){
        tmpDataArray = new Uint8Array(tmpAnalyser.frequencyBinCount);
        tmpAnalyser.getByteFrequencyData(tmpDataArray);
      }
      return tmpDataArray;
  }

 function getMeter() {
    var meter = 0;
    var tmpAnalyser = micOn ? analyserMic : analyserLeft;
    if(tmpAnalyser){
      var tmpDataArray = new Uint8Array(tmpAnalyser.frequencyBinCount);
      tmpAnalyser.getByteTimeDomainData(tmpDataArray);

      var bufferLength = tmpAnalyser.frequencyBinCount;
      var ssum = tmpDataArray.reduce(function(pv, cv) {
        return pv + (cv-128) * (cv-128);
      }, 0);
      meter = Math.log(1 + Math.sqrt(ssum / tmpAnalyser.fftSize)/128);
    }
    return meter;
  }
