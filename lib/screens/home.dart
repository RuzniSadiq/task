import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';
import '../services/remote_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  bool isLoaded = false;
  TextEditingController toSearch = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  RemoteServices rs = RemoteServices();
  List items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  // //wait for the response
  getData() async {
    //tasks = await rs.getTasks();
    items = await rs.getTasks();
    if (items != []) {
      setState(() {
        isLoaded = true;
      });
    }
    setState(() {
      // tasks;
      items;
    });
    return items;
  }

  void filterSearch(String query) async {
    tasks = await rs.getTasks();
    Task xy = Task();
    var dummySearchList = jsonDecode(xy.taskToJson(tasks));

    if (query.isNotEmpty) {
      var dummyListData = [];
      dummySearchList.forEach((item) {
        var task = Task.fromJson(item);
        if (task.name!.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      //set the state
      setState(() {
        items = [];
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items = [];
        items = tasks;
      });
    }
  }

  selectedTaskDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (_pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }

  static const mockupWidth = 375;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    var textScaleFactor = deviceWidth / mockupWidth;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 16.0 / mockupWidth * deviceWidth),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 36.67 / mockupWidth * deviceWidth,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 87 / mockupWidth * deviceWidth),
                  child: Container(
                    width: 169 / mockupWidth * deviceWidth,
                    height: 44 / mockupWidth * deviceWidth,
                    child: SvgPicture.asset('assets/images/Aputure_Logo.svg'),
                  ),
                ),
                SizedBox(
                  height: 28 / mockupWidth * deviceWidth,
                ),
                //TextField
                SizedBox(
                  height: 56 / mockupWidth * deviceWidth,
                  width: 343 / mockupWidth * deviceWidth,
                  child: TextField(
                    onChanged: filterSearch,
                    controller: toSearch,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF6F7FA),
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Color(0xFF9D9FA0),
                        fontSize: 16,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFF6F7FA), width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xFFF6F7FA), width: 0.0),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(
                            right: 6.0 / mockupWidth * deviceWidth,
                            top: 6.0 / mockupWidth * deviceWidth,
                            bottom: 6.0 / mockupWidth * deviceWidth),
                        child: Container(
                          height: 44 / mockupWidth * deviceWidth,
                          width: 44 / mockupWidth * deviceWidth,
                          child: SvgPicture.string(
                            '''<svg width="44" height="44" viewBox="0 0 44 44" fill="none" xmlns="http://www.w3.org/2000/svg">
                          <rect width="44" height="44" rx="12" fill="#EC5F5F"/>
                  <path fill-rule="evenodd" clip-rule="evenodd" d="M24.3764 22.4769C26.0463 20.1337 25.8301 16.8596 23.7279 14.7574C21.3848 12.4142 17.5858 12.4142 15.2426 14.7574C12.8995 17.1005 12.8995 20.8995 15.2426 23.2426C17.3449 25.3449 20.6189 25.561 22.9621 23.8911L28.6777 29.6066L30.0919 28.1924L24.3764 22.4769ZM22.3137 16.1716C23.8758 17.7337 23.8758 20.2663 22.3137 21.8284C20.7516 23.3905 18.2189 23.3905 16.6568 21.8284C15.0948 20.2663 15.0948 17.7337 16.6568 16.1716C18.2189 14.6095 20.7516 14.6095 22.3137 16.1716Z" fill="white"/>
                  </svg>

''',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 18 / mockupWidth * deviceWidth,
                ),
                Text(
                  "All Tasks",
                  textScaleFactor: textScaleFactor,
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 16 / mockupWidth * deviceWidth,
                ),

                //List
                Expanded(
                  child: Visibility(
                    visible: isLoaded == true,
                    child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var jsonString = jsonEncode(items[index]);
                          final task = json.decode(jsonString);

                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: 16.0 / mockupWidth * deviceWidth),
                            child: Container(
                              height: 140 / mockupWidth * deviceWidth,
                              width: 343 / mockupWidth * deviceWidth,
                              decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: const Color(0xFF000000)
                                            .withOpacity(0.1),
                                        blurRadius:
                                            14 / mockupWidth * deviceWidth,
                                        spreadRadius:
                                            0.0 / mockupWidth * deviceWidth,
                                        offset: Offset(
                                            0.0 / mockupWidth * deviceWidth,
                                            4 / mockupWidth * deviceWidth))
                                  ],
                                  color: Color(0xFFF6F7FA),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16 / mockupWidth * deviceWidth,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${task["name"].toString()}",
                                          textScaleFactor: textScaleFactor,
                                          style: TextStyle(
                                              color: Color(0xFF303030),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16),
                                        ),
                                        Container(
                                          height:
                                              16 / mockupWidth * deviceWidth,
                                          width:
                                              3.96 / mockupWidth * deviceWidth,
                                          child: SvgPicture.string(
                                            '''<svg width="5" height="16" viewBox="0 0 5 16" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <path d="M2.8674 4C3.95524 4 4.8453 3.1 4.8453 2C4.8453 0.9 3.95524 0 2.8674 0C1.77955 0 0.889496 0.9 0.889496 2C0.889496 3.1 1.77955 4 2.8674 4ZM2.8674 6C1.77955 6 0.889496 6.9 0.889496 8C0.889496 9.1 1.77955 10 2.8674 10C3.95524 10 4.8453 9.1 4.8453 8C4.8453 6.9 3.95524 6 2.8674 6ZM2.8674 12C1.77955 12 0.889496 12.9 0.889496 14C0.889496 15.1 1.77955 16 2.8674 16C3.95524 16 4.8453 15.1 4.8453 14C4.8453 12.9 3.95524 12 2.8674 12Z" fill="#BDC1C4"/>
                            </svg>

''',
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10 / mockupWidth * deviceWidth,
                                    ),
                                    Text(
                                      "${task["description"].toString()}",
                                      textScaleFactor: textScaleFactor,
                                      style: TextStyle(
                                          color: Color(0xFF8C8C8C),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        task["date"] != null
                                            ? "${DateFormat.yMMMMd().format(DateTime.parse(task["date"])).toString()}"
                                            : "",
                                        textScaleFactor: textScaleFactor,
                                        style: TextStyle(
                                            color: Color(0xFFC7C9D9),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                    replacement: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(bottom: 18.0 / mockupWidth * deviceWidth),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  width: 133 / mockupWidth * deviceWidth,
                  height: 56 / mockupWidth * deviceWidth,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xFFEC5F5F)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      taskAdd(textScaleFactor, deviceWidth);
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: Color(0xFFFFFFFF),
                          ),
                          Text(
                            "Add Task",
                            textScaleFactor: textScaleFactor,
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future taskAdd(double textScaleFactor, double deviceWidth) => showDialog(
      context: context,
      builder: (context) => Padding(
            padding: EdgeInsets.symmetric(
                vertical: 119.33 / mockupWidth * deviceWidth),
            child: AlertDialog(
              scrollable: true,
              insetPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24.0))),
              title: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18.0 / mockupWidth * deviceWidth),
                child: Text(
                  "Add Task",
                  textScaleFactor: textScaleFactor,
                  style: TextStyle(
                      color: Color(0xFF333333),
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
              ),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.0 / mockupWidth * deviceWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        textScaleFactor: textScaleFactor,
                        style: TextStyle(
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 4 / mockupWidth * deviceWidth,
                      ),
                      SizedBox(
                        height: 56 / mockupWidth * deviceWidth,
                        width: 343 / mockupWidth * deviceWidth,
                        child: TextField(
                          controller: nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF6F7FA),
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              color: Color(0xFF9D9FA0),
                              fontSize: 16,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF6F7FA), width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF6F7FA), width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 16 / mockupWidth * deviceWidth,
                      ),

                      Text(
                        "Description",
                        textScaleFactor: textScaleFactor,
                        style: TextStyle(
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 4 / mockupWidth * deviceWidth,
                      ),
                      SizedBox(
                        height: 56 / mockupWidth * deviceWidth,
                        width: 343 / mockupWidth * deviceWidth,
                        child: TextField(
                          controller: descriptionController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF6F7FA),
                            hintText: 'Description',
                            hintStyle: TextStyle(
                              color: Color(0xFF9D9FA0),
                              fontSize: 16,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF6F7FA), width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF6F7FA), width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 16 / mockupWidth * deviceWidth,
                      ),
                      Text(
                        "Due Date",
                        textScaleFactor: textScaleFactor,
                        style: TextStyle(
                            color: Color(0xFF303030),
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      SizedBox(
                        height: 4 / mockupWidth * deviceWidth,
                      ),
                      SizedBox(
                        height: 56 / mockupWidth * deviceWidth,
                        width: 343 / mockupWidth * deviceWidth,
                        child: TextField(
                          controller: dateController,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                selectedTaskDate(context);
                              },
                              child: Icon(
                                Icons.calendar_today,
                                color: Color(0xFFEC5F5F),
                              ),
                            ),
                            filled: true,
                            fillColor: Color(0xFFF6F7FA),
                            hintText:
                                '${DateFormat.yMMMMd().format(DateTime.now()).toString()}',
                            hintStyle: TextStyle(
                              color: Color(0xFF9D9FA0),
                              fontSize: 16,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF6F7FA), width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFF6F7FA), width: 0.0),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 32 / mockupWidth * deviceWidth,
                      ),
                      //save button
                      SizedBox(
                        width: 343 / mockupWidth * deviceWidth,
                        height: 56 / mockupWidth * deviceWidth,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFFEC5F5F)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            RemoteServices rs = RemoteServices();

                            if (DateTime.tryParse(
                                    dateController.text.toString()) !=
                                null) {
                              bool response = await rs.createTask(
                                  nameController.text.toString(),
                                  descriptionController.text.toString(),
                                  dateController.text.toString());
                              if (response) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Row(
                                    children: const [
                                      Icon(
                                        Icons.playlist_add_check,
                                        color: Colors.greenAccent,
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                          child:
                                              Text('Task Added Successfully!')),
                                    ],
                                  ),
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Row(
                                    children: const [
                                      Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(child: Text('Error')),
                                    ],
                                  ),
                                ));
                              }
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(child: Text('Enter a valid date')),
                                  ],
                                ),
                              ));
                            }
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                    maintainState: true),
                                (Route<dynamic> route) => false);
                          },
                          child: Center(
                            child: Text(
                              "Save",
                              textScaleFactor: textScaleFactor,
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
}
