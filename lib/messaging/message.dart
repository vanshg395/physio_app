import 'package:flutter/material.dart';

import 'package:agora_rtm/agora_rtm.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLogin = false;

  final _userNameController = TextEditingController();
  final _peerUserIdController = TextEditingController();
  final _peerMessageController = TextEditingController();

  final _infoStrings = <String>[];

  AgoraRtmClient _client;

  @override
  void initState() {
    super.initState();
    _createClient();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Agora Real Time Message'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildLogin(),
                _buildQueryOnlineStatus(),
                _buildSendPeerMessage(),
                _buildInfoList(),
              ],
            ),
          )),
    );
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance('82cab24ffd1a4e84b5c676b3552ffc3d');
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) {
      _log("Peer msg: " + peerId + ", msg: " + message.text);
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      _log('Connection state changed: ' +
          state.toString() +
          ', reason: ' +
          reason.toString());
      if (state == 5) {
        _client.logout();
        _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
  }

  static TextStyle textStyle = TextStyle(fontSize: 18, color: Colors.blue);

  Widget _buildLogin() {
    return Row(children: <Widget>[
      _isLogin
          ? new Expanded(
              child: new Text('User Id: ' + _userNameController.text,
                  style: textStyle))
          : new Expanded(
              child: new TextField(
                  controller: _userNameController,
                  decoration: InputDecoration(hintText: 'Input your user id'))),
      new OutlineButton(
        child: Text(_isLogin ? 'Logout' : 'Login', style: textStyle),
        onPressed: _toggleLogin,
      )
    ]);
  }

  Widget _buildQueryOnlineStatus() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _peerUserIdController,
              decoration: InputDecoration(hintText: 'Input peer user id'))),
      new OutlineButton(
        child: Text('Query Online', style: textStyle),
        onPressed: _toggleQuery,
      )
    ]);
  }

  Widget _buildSendPeerMessage() {
    if (!_isLogin) {
      return Container();
    }
    return Row(children: <Widget>[
      new Expanded(
          child: new TextField(
              controller: _peerMessageController,
              decoration: InputDecoration(hintText: 'Input peer message'))),
      new OutlineButton(
        child: Text('Send to Peer', style: textStyle),
        onPressed: _toggleSendPeerMessage,
      )
    ]);
  }

  
  

  Widget _buildInfoList() {
    return Expanded(
        child: Container(
            child: ListView.builder(
      itemExtent: 24,
      itemBuilder: (context, i) {
        return ListTile(
          contentPadding: const EdgeInsets.all(0.0),
          title: Text(_infoStrings[i]),
        );
      },
      itemCount: _infoStrings.length,
    )));
  }

  void _toggleLogin() async {
    if (_isLogin) {
      try {
        await _client.logout();
        _log('Logout success.');

        setState(() {
          _isLogin = false;
        });
      } catch (errorCode) {
        _log('Logout error: ' + errorCode.toString());
      }
    } else {
      String userId = _userNameController.text;
      if (userId.isEmpty) {
        _log('Please input your user id to login.');
        return;
      }

      try {
        await _client.login(null, userId);
        _log('Login success: ' + userId);
        setState(() {
          _isLogin = true;
        });
      } catch (errorCode) {
        _log('Login error: ' + errorCode.toString());
      }
    }
  }

  void _toggleQuery() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to query.');
      return;
    }
    try {
      Map<dynamic, dynamic> result =
          await _client.queryPeersOnlineStatus([peerUid]);
      _log('Query result: ' + result.toString());
    } catch (errorCode) {
      _log('Query error: ' + errorCode.toString());
    }
  }

  void _toggleSendPeerMessage() async {
    String peerUid = _peerUserIdController.text;
    if (peerUid.isEmpty) {
      _log('Please input peer user id to send message.');
      return;
    }

    String text = _peerMessageController.text;
    if (text.isEmpty) {
      _log('Please input text to send.');
      return;
    }

    try {
      AgoraRtmMessage message = AgoraRtmMessage.fromText(text);
      _log(message.text);
      await _client.sendMessageToPeer(peerUid, message, false);
      _log('Send peer message success.');
    } catch (errorCode) {
      _log('Send peer message error: ' + errorCode.toString());
    }
  }

  
  

  

  void _log(String info) {
    print(info);
    setState(() {
      _infoStrings.insert(0, info);
    });
  }
}
