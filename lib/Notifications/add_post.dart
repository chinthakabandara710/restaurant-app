// import 'dart:html';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String imageUrl = '';

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('posts');
  TextEditingController _controllerPost = TextEditingController();
  bool showLoader = false;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Post'),
        ),
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add your banner',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      ImagePicker imagePicker = ImagePicker();
                      XFile? file = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      print('${file?.path}');

                      if (file == null) return;

                      String uniqueFileName =
                          DateTime.now().millisecondsSinceEpoch.toString();

                      Reference referenceRoot = FirebaseStorage.instance.ref();
                      Reference referenceDirImages =
                          referenceRoot.child('posts');

                      Reference referenceImageToUpload =
                          referenceDirImages.child(uniqueFileName);

                      try {
                        await referenceImageToUpload.putFile(File(file!.path));
                        //Success: get the download URL
                        imageUrl =
                            await referenceImageToUpload.getDownloadURL();

                        if (imageUrl.isEmpty) {
                          Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (imageUrl.isNotEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Uploaded the image')),
                          );
                          setState(() {
                            showSpinner = false;
                          });
                        }
                      } catch (error) {}
                    },
                    icon: Icon(Icons.camera_alt)),
                TextFormField(
                  controller: _controllerPost,
                ),
                showLoader
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (_controllerPost.text.isNotEmpty &&
                              imageUrl != '') {
                            var time = DateTime.now();
                            Map<String, String> _dataToAdd = {
                              'title': _controllerPost.text,
                              'dateTime': time.toString(),
                              'imgUrl': imageUrl,
                            };

                            setState(() {
                              showLoader = true;
                            });

                            _reference.add(_dataToAdd);

                            setState(() {
                              showLoader = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text('Save'))
              ],
            ),
          ),
        ));
  }
}
