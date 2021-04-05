OSCBridge{
	var oscDest;

	*new {
		arg ip="127.0.0.1", port=10000;
		^super.new.init(ip, port)
	}

	init {
		arg ip, port;
		oscDest = NetAddr(ip, port);
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


MyClass {
	var message;
	*method {
		arg argument;
		this.message = argument;
		"Test".postln;
		argument.postln;
	}
	*print {
		arg argument;
		this.message.postln;
	}
}
