import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Hello Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<File> downloadImage() async {
    String filename = "download.png";
    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = path.join(dir.path, filename);

    var url =
        'https://bengalfish.com.bd/resources/assets/images/user_profile/1619413655.adnan.jpg';
    // var url = usermodel.pictureURL;
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    File file = new File(pathName);
    file.writeAsBytesSync(response.bodyBytes);

    return file;
  }

  void _updateProfile() {
    var url = Uri.parse('https://bengalfish.com.bd/api/user/profile/update');
    var headers = {
      'Accept': 'application/json',
      'Auth': 'PWoiU7akC7HuzUIsN3UO7DYopJ81XxaBnbG4auNUup68C1REZ8RXP0AUTjYs'
    };
    var body = {'user_id': '2', 'first_name': 'Adnan', 'last_name': 'Miah'};
    var request = new http.MultipartRequest("POST", url);
    request.headers.addAll(headers);
    request.fields.addAll(body);

    // For asset image
    // rootBundle.load('upload/rose.jpg').then((file) {
    //   var uint8 = file.buffer.asUint8List();
    //   var multipartFile = http.MultipartFile.fromBytes('picture', uint8,
    //       filename: 'profile.jpg');
    //   request.files.add(multipartFile);
    // });

    // For network image
    downloadImage().then((file) {
      var multipartFile = http.MultipartFile.fromBytes(
          'picture', file.readAsBytesSync(),
          filename: 'profile.jpg');

      request.files.add(multipartFile);
    });

    request.send().then((response) {
      print(response.statusCode.toString());
    }).catchError((onError) {
      print(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Image(
              image: AssetImage('upload/rose.jpg'),
            ),
            ElevatedButton(onPressed: _updateProfile, child: Text('Update'))
          ],
        ),
      ),
    );
  }
}
