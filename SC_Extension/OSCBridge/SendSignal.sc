OSCBridge{
	var oscDest;

	init {
		oscDest = NetAddr("127.0.0.1", 10000);
	}

	sendSignal {
	arg address = '/test', signal, gate = 1, fps = 60;
	var gatedFPS = gate * fps;
	// osc listener for sendReply
	OSCdef(\listener, {|msg|
		var data = msg[3..];
		oscDest.sendMsg(address, data[0]);
	}, address);
	//create sendreply
	SendReply.kr(Impulse.kr(gatedFPS), address, signal, -1);
	address;
	}
}