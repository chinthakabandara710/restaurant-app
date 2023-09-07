import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddMains extends StatelessWidget {
  AddMains({Key? key}) : super(key: key);

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _priority = TextEditingController();
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Menu');

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: _controllerName,
                decoration:
                    InputDecoration(hintText: 'Enter the name of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item name';
                  }

                  return null;
                },
              ),
              TextFormField(
                controller: _priority,
                decoration: InputDecoration(hintText: 'Enter the priority'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the priority';
                  }

                  return null;
                },
              ),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    print('${file?.path}');

                    if (file == null) return;

                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages = referenceRoot.child('mains');

                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);

                    try {
                      await referenceImageToUpload.putFile(File(file!.path));
                      //Success: get the download URL
                      imageUrl = await referenceImageToUpload.getDownloadURL();

                      if (imageUrl.isEmpty) {
                        Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (imageUrl.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Uploaded the image')),
                        );
                      }
                    } catch (error) {}
                  },
                  icon: Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please upload an image')),
                      );

                      return;
                    }

                    String itemName = _controllerName.text;
                    String priority = _priority.text;
                    double itempriority = double.parse(priority);

                    Map<String, dynamic> dataToSend = {
                      'title': itemName,
                      'imgUrl': imageUrl,
                      'priority': itempriority,
                    };

                    _reference.add(dataToSend);

                    Navigator.pop(context);
                  },
                  child: Text('Submit'))
            ],
          ),
        ),
      ),
    );
  }
}
