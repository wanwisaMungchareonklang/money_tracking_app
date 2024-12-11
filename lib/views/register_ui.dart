// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monney_tracking_project/models/money.dart';
import 'package:monney_tracking_project/models/user.dart';
import 'package:monney_tracking_project/services/call_api.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  File? _imageSelected;
  String? _imageBase64Selected;
  TextEditingController _fullnameController = TextEditingController(text: "");
  TextEditingController _birthdayController = TextEditingController(text: "");
  TextEditingController _usernameController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");
  DateTime initDate = DateTime(1900);
  DateTime lastDate = DateTime(2100);
  DateTime defaultDate = DateTime.now();
  bool _passwordShow = true;

  Future<void> _openCamera() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _imageBase64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

  Future<void> _openGallery() async {
    final XFile? _picker = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (_picker != null) {
      setState(() {
        _imageSelected = File(_picker.path);
        _imageBase64Selected = base64Encode(_imageSelected!.readAsBytesSync());
      });
    }
  }

  Future displayCalendar(BuildContext context) async {
    return await showDatePicker(
      context: context,
      firstDate: initDate,
      lastDate: lastDate,
      initialDate: defaultDate,
    );
  }

  Future<void> showDialogMassage(context, titleText, msg) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            titleText,
          ),
        ),
        content: Text(
          msg,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ตกลง',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 8, 3, 74),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 8, 3, 74),
        toolbarHeight: MediaQuery.of(context).size.height * 0.15,
        title: Text(
          'ลงทะเบียน',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.03,
            //fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            //size: MediaQuery.of(context).size.height * 0.04,
          ),
          onPressed: () {
            // กลับไปหน้าก่อนหน้า
            Navigator.pop(context);
          },
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        child: Container(
          height: double.infinity, // ยึดพื้นที่แนวตั้งทั้งหมด
          width: double.infinity, // ยึดพื้นที่แนวนอนทั้งหมด
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
          ),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ข้อมูลผู้ใช้งาน',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        //fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 8, 3, 74)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.height * 0.1,
                    backgroundColor: Colors.transparent, // พื้นหลังโปร่งใส
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromARGB(
                              255, 8, 3, 74), // สีของเส้นขอบ
                          width: 3, // ความหนาของเส้นขอบ
                        ),
                      ),
                      child: Stack(
                        children: [
                          _imageSelected != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      100), // ให้ภาพเป็นวงกลม
                                  child: Image.file(
                                    _imageSelected!,
                                    width: MediaQuery.of(context).size.height *
                                        0.2,
                                    height: MediaQuery.of(context).size.height *
                                        0.2,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.person_outline,
                                    size: MediaQuery.of(context).size.height *
                                        0.1,
                                    color: const Color.fromARGB(255, 8, 3, 74),
                                  ),
                                ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              width: MediaQuery.of(context).size.height * 0.06,
                              height: MediaQuery.of(context).size.height * 0.05,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                    255, 8, 3, 74), // พื้นหลังของไอคอนกล้อง
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white, // เส้นขอบรอบไอคอนกล้อง
                                  width: 2,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          onTap: () {
                                            _openCamera().then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          leading: Icon(
                                            Icons.camera_alt,
                                            color: const Color.fromARGB(
                                                255, 8, 3, 74),
                                          ),
                                          title: Text(
                                            'Open Camera...',
                                          ),
                                        ),
                                        Divider(
                                          color: const Color.fromARGB(
                                              255, 8, 3, 74),
                                          height: 5.0,
                                        ),
                                        ListTile(
                                          onTap: () {
                                            _openGallery().then((value) {
                                              Navigator.pop(context);
                                            });
                                          },
                                          leading: Icon(
                                            Icons.browse_gallery,
                                            color: const Color.fromARGB(
                                                255, 8, 3, 74),
                                          ),
                                          title: Text(
                                            'Open Gallery...',
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size:
                                      MediaQuery.of(context).size.height * 0.03,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  TextField(
                    controller: _fullnameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อ - สกุล',
                      floatingLabelStyle: TextStyle(
                        color: const Color.fromARGB(255, 8, 3, 74),
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                      hintText: "Userfullname",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 8, 3, 74)),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextField(
                    controller: _birthdayController,
                    decoration: InputDecoration(
                      labelText: 'ปี - เดือน - วัน ที่เกิด',
                      floatingLabelStyle: TextStyle(
                        color: const Color.fromARGB(255, 8, 3, 74),
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                      hintText: "Birthday Date",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.calendar_month,
                          color: const Color.fromARGB(255, 8, 3, 74),
                        ),
                        onPressed: () {
                          displayCalendar(context).then((value) {
                            setState(() {
                              if (value != null) {
                                _birthdayController.text =
                                    value.toString().substring(0, 10);
                              }
                            });
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 8, 3, 74)),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'ชื่อผู้ใช้',
                      floatingLabelStyle: TextStyle(
                        color: const Color.fromARGB(255, 8, 3, 74),
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                      hintText: "Username",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 8, 3, 74)),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextField(
                    controller: _passwordController,
                    obscureText: _passwordShow,
                    decoration: InputDecoration(
                      labelText: 'รหัสผ่าน',
                      floatingLabelStyle: TextStyle(
                        color: const Color.fromARGB(255, 8, 3, 74),
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                      ),
                      hintText: "Password",
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordShow
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: const Color.fromARGB(255, 8, 3, 74),
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordShow = !_passwordShow;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: const Color.fromARGB(255, 8, 3, 74)),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ElevatedButton(
                    onPressed: () {
                      if (_usernameController.text.isEmpty ||
                          _passwordController.text.isEmpty ||
                          _fullnameController.text.isEmpty ||
                          _birthdayController.text.isEmpty) {
                        showDialogMassage(context, 'แจ้งเตือน',
                            'กรุณาป้อนข้อมูลให้ครบทุกช่อง');
                      } else {
                        User user = User(
                          userFullname: _fullnameController.text,
                          userBirthDate: _birthdayController.text,
                          userName: _usernameController.text,
                          userPassword: _passwordController.text,
                          userImage: _imageBase64Selected,
                        );
                        CallApi.AddMoneyApi(user as Money).then(
                          (value) => {
                            if (value[0].message == "1")
                              {
                                showDialogMassage(context, 'แจ้งเตือน',
                                    "บันทึกข้อมูลเรียบร้อย"),
                                _fullnameController =
                                    TextEditingController(text: ''),
                                _birthdayController =
                                    TextEditingController(text: ''),
                                _usernameController =
                                    TextEditingController(text: ''),
                                _passwordController =
                                    TextEditingController(text: ''),
                                _imageBase64Selected = '',
                                _imageSelected = null,
                              }
                            else
                              {
                                showDialogMassage(context, 'แจ้งเตือน',
                                    "ไม่สามารถบันทึกข้อมูลได้"),
                              }
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 12, 5, 119),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      fixedSize: Size(
                        MediaQuery.of(context).size.width * 0.80,
                        MediaQuery.of(context).size.height * 0.070,
                      ),
                    ),
                    child: Text(
                      'บันทึกการลงทะเบียน',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height *
                            0.02, // ขนาดฟอนต์
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.025,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
