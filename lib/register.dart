import 'dart:io';
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as imglib;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'utils.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class PickImage extends StatefulWidget {
  const PickImage({super.key});

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  final TextEditingController _nameController = TextEditingController();
  dynamic data;
  tfl.Interpreter? interpreter;
  Uint8List? _image;
  List? e1;
  File? selectedIMage;
  @override
  void initState() {
    super.initState();
    loadModel().then((_) {
      print(
          "hiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii modellllllllllllllllllllllllllllllllllllllll");
    });
  }

  // Future<void> loadModel() async {
  //   try {
  //     final gpuDelegateV2 = tfl.GpuDelegateV2(
  //         options: tfl.GpuDelegateOptionsV2(
  //       false,
  //       tfl.TfLiteGpuInferenceUsage.fastSingleAnswer,
  //       tfl.TfLiteGpuInferencePriority.minLatency,
  //       tfl.TfLiteGpuInferencePriority.auto,
  //       tfl.TfLiteGpuInferencePriority.auto,
  //     ));

  //     var interpreterOptions = tfl.InterpreterOptions()
  //       ..addDelegate(gpuDelegateV2);
  //     interpreter = await tfl.Interpreter.fromAsset('mobilefacenet.tflite',
  //         options: interpreterOptions);
  //     print(
  //         "Model loaded successfully=======================================================================================================.");
  //   } on Exception catch (e) {
  //     print('Failed to load model: $e');
  //     throw e; // Rethrow the exception to handle it outside
  //   }
  // }
  Future loadModel() async {
    try {
      this.interpreter =
          await tfl.Interpreter.fromAsset('mobilefacenet.tflite');

      print(
          '**********\n Loaded successfully model mobilefacenet.tflite \n*********\n');
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, bottom: 50.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Name',
              ),
            ),
            SizedBox(
              width: 20,
            ),
            _image != null
                ? CircleAvatar(
                    radius: 100, backgroundImage: MemoryImage(_image!))
                : const CircleAvatar(
                    radius: 100,
                    backgroundImage: NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
                  ),
            Positioned(
                bottom: -0,
                left: 140,
                child: IconButton(
                    onPressed: () {
                      showImagePickerOption(context);
                    },
                    icon: const Icon(Icons.add_a_photo))),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: () {
                String userName = _nameController.text.trim();
                if (userName.isEmpty) {
                  print("User name is required.");
                  return;
                }
                if (e1 != null) {
                  _writeUserDataToJson(userName, e1!);
                } else {
                  print("No face embedding available.");
                }
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.blue[100],
        context: context,
        builder: (builder) {
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4.5,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//Gallery
  Future _pickImageFromGallery() async {
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;

    // Use decodeImageFromList with a callback to handle the decoded image
    ui.decodeImageFromList(await returnImage.readAsBytes(),
        (ui.Image decodedImage) {
      if (decodedImage != null) {
        // Now you have the image dimensions
        final width = decodedImage.width;
        final height = decodedImage.height;

        // Update the state with the image bytes and dimensions
        setState(() {
          selectedIMage = File(returnImage.path);
          _image = File(returnImage.path)
              .readAsBytesSync(); // You already have the bytes, so no need to read them again
          // Optionally, you can use width and height here if needed
        });
      }
    });

    Navigator.of(context).pop(); // Close the modal sheet
  }

//Camera
  // Future _pickImageFromCamera() async {
  //   final returnImage =
  //       await ImagePicker().pickImage(source: ImageSource.camera);
  //   if (returnImage == null) return;
  //   setState(() {
  //     selectedIMage = File(returnImage.path);
  //     _image = File(returnImage.path).readAsBytesSync();
  //   });
  //   print(
  //       "hi======================================================================================,${_image.runtimeType}");
  //   Navigator.of(context).pop();
  // }
  Future _pickImageFromCamera() async {
    await loadModel();
    final returnImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    setState(() {
      selectedIMage = File(returnImage.path);
      _image = File(returnImage.path).readAsBytesSync();
    });

    // Convert Uint8List to imglib.Image
    imglib.Image? decodedImage = imglib.decodeImage(_image!);
    if (decodedImage != null) {
      // Now you have an imglib.Image object that you can manipulate or display
      print("Image successfully decoded into imglib.Image object.");
      await _processImage(decodedImage);
    } else {
      print("Failed to decode image.");
    }

    Navigator.of(context).pop();
  }

  Future<void> _processImage(imglib.Image image) async {
    // Convert the image to the format expected by your model
    // This might involve resizing, normalizing, etc.
    // The exact steps depend on your model's requirements
    print(
        "hiiiiiiiiiiiiiiiiiiiiiiiiiii--------------------COMINGGGGG--------------------");
    List input = imageToByteListFloat32(image, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.generate(1, (index) => List.filled(192, 0));
    // Run the model
    if (interpreter == null) {
      throw Exception('Interpreter is not initialized.');
    }
    interpreter?.run(input, output);

    output = output.reshape([192]);

    // Process the output to get the embeddings
    // This might involve additional processing steps
    // For example, you might want to normalize the embeddings
    List e = List.from(output);
    e1 = e;
    // print("Face Embedding: $e");
    // String userName = _nameController.text.trim();
    // if (userName.isEmpty) {
    //   print("User name is required.");
    //   return;
    // }
    // data[userName] = e;
    // await _writeUserDataToJson(data);
  }

  Future<void> _writeUserDataToJson(String userName, List embedding) async {
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final File file = File('$dir/savedFaces.json');

    // Load existing data if the file exists
    Map<String, dynamic> data = {};
    if (await file.exists()) {
      data = json.decode(await file.readAsString());
    }

    // Add the new user data
    data[userName] = embedding;

    // Write the updated data back to the file
    await file.writeAsString(json.encode(data));
    print('User data saved successfully.');
  }
}
