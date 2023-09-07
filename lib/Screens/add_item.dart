import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddItem extends StatelessWidget {
  String id = '';
  AddItem(this.id, {Key? key}) : super(key: key) {
    _documentReference = FirebaseFirestore.instance.collection('Menu').doc(id);
    _reference = _documentReference.collection('subMenu');
  }
  late DocumentReference _documentReference;
  late CollectionReference _reference;

  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerQuantity = TextEditingController();

  String imageUrl = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                controller: _controllerQuantity,
                decoration:
                    InputDecoration(hintText: 'Enter the price of the item'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the item quantity';
                  }

                  return null;
                },
              ),
              IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    XFile? file = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (file == null) return;
                    String uniqueFileName =
                        DateTime.now().millisecondsSinceEpoch.toString();

                    Reference referenceRoot = FirebaseStorage.instance.ref();
                    Reference referenceDirImages =
                        referenceRoot.child('subMenu');

                    Reference referenceImageToUpload =
                        referenceDirImages.child(uniqueFileName);

                    try {
                      await referenceImageToUpload.putFile(File(file!.path));

                      imageUrl = await referenceImageToUpload.getDownloadURL();
                      if (imageUrl.isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('uploaded the image')));

                        return;
                      }
                    } catch (error) {}
                  },
                  icon: Icon(Icons.camera_alt)),
              ElevatedButton(
                  onPressed: () async {
                    if (imageUrl.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please upload an image')));

                      return;
                    }

                    // if (key.currentState!.validate()) {
                    String itemName = _controllerName.text;
                    String itemQuantity = _controllerQuantity.text;

                    //Create a Map of data
                    Map<String, String> dataToSend = {
                      'name': itemName,
                      'price': itemQuantity,
                      'image': imageUrl,
                    };

                    //Add a new item
                    _reference.add(dataToSend);
                    // }
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
