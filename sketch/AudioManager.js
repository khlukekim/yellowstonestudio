
  var analyser;

  function accessMic() {
  	console.log("accessMic");
      var context = new AudioContext();
      navigator.mediaDevices.getUserMedia({audio: true, video: false}).then(function(stream) {
	      var mic = context.createMediaStreamSource(stream);
	      var filter = context.createBiquadFilter();
	      filter.type = 'lowpass';
	      mic.connect(filter);
	      analyser = context.createAnalyser();
	      // default analyser.fftSize is 2048
	      mic.connect(analyser);
	    }).catch(function(err) {
	      console.log(err);
	      alert("It looks like your browser doesn't support Microphone Input. Please use Chrome browser.");
	    });
    }

  function getDataArray() {
      var tmpDataArray = null;
      if(analyser){
        tmpDataArray = new Uint8Array(analyser.frequencyBinCount);
        analyser.getByteFrequencyData(tmpDataArray);
      }
      return tmpDataArray;
  }

   function getMeter() {
      var tmpDataArray = new Uint8Array(analyser.frequencyBinCount);
      analyser.getByteTimeDomainData(tmpDataArray);

      var bufferLength = analyser.frequencyBinCount;

      var ssum = tmpDataArray.reduce(function(pv, cv) {
        return pv + (cv-128) * (cv-128);
      }, 0);
      return Math.log(1 + Math.sqrt(ssum / analyser.fftSize)/128);
    }
