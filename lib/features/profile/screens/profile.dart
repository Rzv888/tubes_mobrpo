import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/auth_service.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  String _namalengkap = 'John Doe';
  String _password = 'password123';
  String _address = 'Sukabirus';
  String _phoneNumber = '081888888888';

  final TextEditingController _namalengkapController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  Future<void> refreshDataUser(context) async {
    final user = await UserService().getCurrentUser();
    print(("cek" + user.toString()));
    _namalengkap = user["nama_lengkap"];
    _address = user['alamat'];
    _phoneNumber = user['no_wa'];

    setState(() {});
  }

  Future<void> _showPicker(context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _imgFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _imgFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  void _editUsername() {
    _namalengkapController.text = _namalengkap;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Username'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _namalengkapController,
                  decoration:
                      const InputDecoration(hintText: "Enter new username"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                setState(() {
                  _namalengkap = _namalengkapController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editProfile() {
    _passwordController.text = _password;
    _addressController.text = _address;
    _phoneNumberController.text = _phoneNumber;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration:
                      const InputDecoration(hintText: "Enter new password"),
                ),
                TextField(
                  controller: _addressController,
                  decoration:
                      const InputDecoration(hintText: "Enter new address"),
                ),
                TextField(
                  controller: _phoneNumberController,
                  decoration:
                      const InputDecoration(hintText: "Enter new phone number"),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SAVE'),
              onPressed: () {
                setState(() {
                  _password = _passwordController.text;
                  _address = _addressController.text;
                  _phoneNumber = _phoneNumberController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // Handle logout functionality
    AuthService().logout(
        context); // For example, you can navigate to the login screen or clear user session
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  void initState() {
    // TODO: implement initState
    refreshDataUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFF80DEEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[200],
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.file(
                            _image!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(50),
                          ),
                          width: 100,
                          height: 100,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _namalengkap,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: _editUsername,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'User Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        leading:
                            const Icon(Icons.location_on, color: Colors.grey),
                        title: Text(_address),
                      ),
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.grey),
                        title: Text(_phoneNumber),
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock, color: Colors.grey),
                        title: const Text('*********'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _editProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Edit Profile',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Logout', style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
