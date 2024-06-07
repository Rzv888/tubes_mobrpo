import 'package:flutter/material.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/auth_service.dart';
import 'package:flutter_tubes_galon/features/authentication/controllers/user_service.dart';
import 'package:flutter_tubes_galon/features/authentication/screens/login/login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  String _namalengkap = '';
  String _password = '';
  String _address = '';
  String _phoneNumber = '';
  String _email = '';

  final TextEditingController _namalengkapController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    refreshDataUser();
  }

  Future<void> refreshDataUser() async {
    try {
      final user = await UserService().getCurrentUser();
      if (user != null) {
        setState(() {
          _namalengkap = user['nama_lengkap'] as String? ?? '';
          _address = user['alamat'] as String? ?? '';
          _phoneNumber = user['no_wa'] as String? ?? '';
          _email = user['email'] as String? ?? '';
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _showPicker(BuildContext context) async {
    double screenHeight = MediaQuery.of(context).size.height;
    double sheetHeight = screenHeight * 0.5;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: sheetHeight,
          child: SafeArea(
            child: SingleChildScrollView(
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
            ),
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

  void _editField(String field) {
    TextEditingController controller;
    String currentValue;
    String hintText;

    switch (field) {
      case 'Username':
        controller = _namalengkapController;
        currentValue = _namalengkap;
        hintText = "Enter new username";
        break;
      case 'Email':
        controller = _emailController;
        currentValue = _email;
        hintText = "Enter new email";
        break;
      case 'Password':
        controller = _passwordController;
        currentValue = _password;
        hintText = "Enter new password";
        break;
      case 'Phone Number':
        controller = _phoneNumberController;
        currentValue = _phoneNumber;
        hintText = "Enter new phone number";
        break;
      case 'Address':
        controller = _addressController;
        currentValue = _address;
        hintText = "Enter new address";
        break;
      default:
        return;
    }

    controller.text = currentValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $field'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: controller,
                  obscureText: field == 'Password',
                  decoration: InputDecoration(hintText: hintText),
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
                  switch (field) {
                    case 'Username':
                      _namalengkap = controller.text;
                      AuthService().editName(context, _namalengkap);
                      break;
                    case 'Email':
                      _email = controller.text;
                      AuthService().editEmail(context, _email);
                      break;
                    case 'Password':
                      _password = controller.text;
                      AuthService().editPassword(context, _password);
                      break;
                    case 'Phone Number':
                      _phoneNumber = controller.text;
                      AuthService().editWa(context, _phoneNumber);
                      break;
                    case 'Address':
                      _address = controller.text;
                      AuthService().editAlamat(context, _address);
                      break;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    await AuthService().logout(context);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE0F7FA), Color(0xFF80DEEA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
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
                      onPressed: () => _editField('Username'),
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
                          leading: const Icon(Icons.email, color: Colors.grey),
                          title: Text(_email),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editField('Email'),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.lock, color: Colors.grey),
                          title: const Text('*********'),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editField('Password'),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.grey),
                          title: Text(_phoneNumber),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editField('Phone Number'),
                          ),
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.location_on, color: Colors.grey),
                          title: Text(_address),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editField('Address'),
                          ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
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
      ),
    );
  }
}
