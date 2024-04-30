// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:vault_testing/widgets/constants.dart';
//
// class InvoiceScreen extends StatefulWidget {
//   const InvoiceScreen({super.key});
//
//   @override
//   State<InvoiceScreen> createState() => _InvoiceScreenState();
// }
//
// class _InvoiceScreenState extends State<InvoiceScreen> {
//   File? _image;
//   String _extractedText = "";
//   final picker = ImagePicker();
//
//   Future getImageFromGallery() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       _processImage(_image!);
//     }
//   }
//
//   Future getImageFromCamera() async {
//     final pickedFile = await picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       _processImage(_image!);
//     }
//   }
//
//   Future _processImage(File image) async {
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(InputImage.fromFile(image));
//     String text = recognizedText.text;
//     textRecognizer.close();
//     setState(() {
//       _extractedText = text;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Text Recognition'),
//       ),
//       body: Center(
//         child: _image == null
//             ? const Text('No image selected.')
//             : Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         color: kAltBackGroundColor,
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Padding(
//                       padding: EdgeInsets.all(10),
//                       child: Image.file(
//                         _image!,
//                         width: 300,
//                         height: 500,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   SizedBox(
//                     height:
//                         200, // Set a specific height for the scrollable area
//                     child: Container(
//                       width: 400,
//                       decoration: BoxDecoration(
//                           color: kInActiveCardColor,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Padding(
//                         padding: EdgeInsets.only(left: 20),
//                         child: SingleChildScrollView(
//                           child: Text(
//                             _extractedText,
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//       floatingActionButton: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           FloatingActionButton(
//             onPressed: getImageFromGallery,
//             tooltip: 'Pick Image from Gallery',
//             child: const Icon(Icons.image),
//           ),
//           const SizedBox(height: 16),
//           FloatingActionButton(
//             onPressed: getImageFromCamera,
//             tooltip: 'Take Image from Camera',
//             child: const Icon(Icons.camera_alt),
//           ),
//         ],
//       ),
//     );
//   }
// }
