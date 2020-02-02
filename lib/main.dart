import 'package:flutter/material.dart';
import 'package:speech_recognition/speech_recognition.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    intiSpeechRecognizer();
  }

  void intiSpeechRecognizer() {
    _speechRecognition = SpeechRecognition();
    _speechRecognition.setAvailabilityHandler((bool result) {
      setState(() {
        _isAvailable = result;
      });
    });
    _speechRecognition.setRecognitionStartedHandler(() {
      setState(() {
        _isListening = true;
      });
    });
    _speechRecognition.setRecognitionResultHandler((String speech) {
      setState(() {
        resultText = speech;
      });
    });
    _speechRecognition.setRecognitionCompleteHandler(() {
      setState(() {
        _isListening = false;
      });
    });
    _speechRecognition.activate().then((result) {
      setState(() {
        _isAvailable = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Speech Recognition'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.cancel),
                  backgroundColor: Colors.deepOrange,
                  onPressed: () {
                    if(_isListening){
                      _speechRecognition.cancel().then((result){
                        setState(() {
                         _isListening = result;
                         resultText = '';
                        });
                      });
                    }
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.pink,
                  onPressed: () {
                    print('clicked start');
                    if(_isAvailable && !_isListening){
                      _speechRecognition.listen(locale: 'en_US').then((result){
                        print('$result');
                      });
                    }
                  },
                ),
                FloatingActionButton(
                  mini: true,
                  child: Icon(Icons.stop),
                  backgroundColor: Colors.deepPurple,
                  onPressed: () {
                    print('clicked stop');
                    if(_isListening){
                      _speechRecognition.stop().then((result){
                        setState(() {
                         _isListening = result; 
                        });
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Converted Speech Result : ',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(resultText),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(6.0),
              ),
              padding: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
