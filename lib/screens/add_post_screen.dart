import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../l10n/app_localizations.dart';

class AddPostScreen extends StatefulWidget {
  final String? editPostId;
  final String? editCaption;
  final String? editImageUrl;

  const AddPostScreen({
    super.key,
    this.editPostId,
    this.editCaption,
    this.editImageUrl,
  });

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  File? _imageFile;
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    if (widget.editCaption != null) {
      _captionController.text = widget.editCaption!;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // compress image
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadPost() async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please log in first')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl = widget.editImageUrl;
      final postId = widget.editPostId ?? _uuid.v4();

      if (_imageFile != null) {
        // Upload image to Firebase Storage
        final uploadTask = _storage
            .ref()
            .child('post_images')
            .child('$postId.jpg')
            .putFile(_imageFile!);
        final snapshot = await uploadTask.whenComplete(() {});

        // Add retry logic for getting the download URL to account for slight delays
        // in Firebase Storage returning success vs metadata availability
        int retries = 3;
        while (retries > 0) {
          try {
            imageUrl = await snapshot.ref.getDownloadURL();
            break;
          } catch (e) {
            retries--;
            if (retries == 0) {
              rethrow;
            }
            await Future.delayed(const Duration(seconds: 1));
          }
        }
      } else if (imageUrl == null && _captionController.text.trim().isEmpty) {
        // Require either an image or text
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add an image or caption')),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (widget.editPostId != null) {
        // Update existing post
        final updateData = {
          'caption': _captionController.text.trim(),
        };
        if (_imageFile != null) {
          updateData['imageUrl'] = imageUrl as String;
        }
        await _firestore.collection('posts').doc(postId).update(updateData);
      } else {
        // Fetch user data from firestore
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        String username = 'Unknown User';
        if (userDoc.exists && userDoc.data() != null) {
          username =
              userDoc.data()!['fullName'] ?? user.displayName ?? 'Unknown User';
        }

        // Create post document
        await _firestore.collection('posts').doc(postId).set({
          'postId': postId,
          'userId': user.uid,
          'username': username,
          'userProfilePic': user
              .photoURL, // Note: storing photoURL directly from auth might not reflect changes if they uploaded a custom one unless updated in auth profile
          'imageUrl': imageUrl,
          'caption': _captionController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
          'likes': [],
        });
      }

      if (mounted) {
        Navigator.pop(context); // Go back to community screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to post: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Handle case where l10n might be null during hot reload of new strings. It will rebuild.
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.editPostId != null ? 'Edit Post' : l10n.addPost),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _uploadPost,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    widget.editPostId != null ? 'Update' : l10n.post,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imageFile != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _imageFile!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _imageFile = null;
                      });
                    },
                  ),
                ],
              )
            else if (widget.editImageUrl != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.editImageUrl!,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: _pickImage,
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withAlpha(50),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        l10n.selectImage,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              controller: _captionController,
              maxLines: 5,
              minLines: 1,
              decoration: InputDecoration(
                hintText: l10n.writeCaption,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () {
                            setState(() {
                              _imageFile = null;
                              _captionController.clear();
                            });
                          },
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _uploadPost,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload),
                    label: Text(widget.editPostId != null ? 'Update post' : 'Upload post'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
