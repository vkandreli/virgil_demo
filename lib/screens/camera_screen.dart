// import 'dart:async';
// import 'dart:convert';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';

// final log = Logger();

// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key, required this.camera});

//   final CameraDescription camera;

//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   final TextRecognizer _textRecognizer =
//       TextRecognizer(script: TextRecognitionScript.latin);
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//   String? _text;
//   List<dynamic> _bookResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.medium);
//     _initializeControllerFuture = _controller.initialize();
//   }

//   @override
//   void dispose() {
//     _textRecognizer.close();
//     _controller.dispose();
//     super.dispose();
//   }

//   // Function to search for books using Google Books API
//   Future<void> _searchBooks(String query) async {
//     final response = await http.get(Uri.parse(
//         'https://www.googleapis.com/books/v1/volumes?q=$query&key=YOUR_GOOGLE_BOOKS_API_KEY'));

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() {
//         _bookResults = data['items'];
//       });
//     } else {
//       log.e('Failed to load books');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Take a picture')),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           FutureBuilder<void>(
//             future: _initializeControllerFuture,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 return CameraPreview(_controller);
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           if (_text != null) 
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text('Recognized Text: $_text'),
//             ),
//           if (_bookResults.isNotEmpty) 
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _bookResults.length,
//                 itemBuilder: (context, index) {
//                   var book = _bookResults[index]['volumeInfo'];
//                   return ListTile(
//                     title: Text(book['title'] ?? 'No title available'),
//                     subtitle: Text(book['authors']?.join(', ') ?? 'No authors available'),
//                     onTap: () {
//                       // Handle book tap (for example, show book details)
//                     },
//                   );
//                 },
//               ),
//             ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           try {
//             await _initializeControllerFuture;
//             final image = await _controller.takePicture();
//             log.i('image acquired');
            
//             final recognizedText = await _textRecognizer
//                 .processImage(InputImage.fromFilePath(image.path));

//             log.i('recognized text: ${recognizedText.text}');
            
//             setState(() {
//               _text = recognizedText.text;
//             });

//             // Search for books using the recognized text
//             if (_text != null && _text!.isNotEmpty) {
//               _searchBooks(_text!);
//             }

//             if (!mounted) return;
//           } catch (e) {
//             log.e('Error during capture: ${e.toString()}');
//           }
//         },
//         child: const Icon(Icons.camera_alt),
//       ),
//     );
//   }
// }