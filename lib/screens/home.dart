import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:task/widgets/task_card_widget.dart';

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
  List textItems = ["Name", "Description", "Due Date"];

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
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
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
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36.67 / mockupWidth * deviceWidth,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 87 / mockupWidth * deviceWidth),
                    child: SizedBox(
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
                        fillColor: const Color(0xFFF6F7FA),
                        hintText: 'Search',
                        hintStyle: const TextStyle(
                          color: Color(0xFF9D9FA0),
                          fontSize: 16,
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF6F7FA), width: 0.0),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFF6F7FA), width: 0.0),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(
                              right: 6.0 / mockupWidth * deviceWidth,
                              top: 6.0 / mockupWidth * deviceWidth,
                              bottom: 6.0 / mockupWidth * deviceWidth),
                          child: SizedBox(
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
                    style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 16 / mockupWidth * deviceWidth,
                  ),

                  //List
                  Visibility(
                    visible: isLoaded == true,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          var jsonString = jsonEncode(items[index]);
                          final task = json.decode(jsonString);

                          return TaskCardWidget(
                            mockupWidth: mockupWidth,
                            deviceWidth: deviceWidth,
                            textScaleFactor: textScaleFactor,
                            task: task,
                            index: index,
                            editOrDelete: editOrDelete,
                          );
                        }),
                  ),
                ],
              ),
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
                          MaterialStateProperty.all(const Color(0xFFEC5F5F)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      taskAddorEdit(
                          textScaleFactor, deviceWidth, "Add", "", "", "", "");
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add,
                            color: Color(0xFFFFFFFF),
                          ),
                          Text(
                            "Add Task",
                            textScaleFactor: textScaleFactor,
                            style: const TextStyle(
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

  Future taskAddorEdit(
          double textScaleFactor,
          double deviceWidth,
          String operation,
          String id,
          String name,
          String description,
          String date) =>
      showDialog(
          context: context,
          builder: (context) {
            if (operation == "Edit") {
              nameController.text = name;
              descriptionController.text = description;
              dateController.text = date;
            }

            return Padding(
              //119.33
              padding: EdgeInsets.symmetric(
                  vertical: 16 / mockupWidth * deviceWidth),
              child: AlertDialog(
                scrollable: true,
                insetPadding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0))),
                title: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 18.0 / mockupWidth * deviceWidth),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        operation == "Edit" ? "Edit Task" : "Add Task",
                        textScaleFactor: textScaleFactor,
                        style: const TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.close,
                          color: Color(0xFF8C8C8C),
                        ),
                      )
                    ],
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
                        for (var textItem in textItems) ...[
                          Text(
                            "$textItem",
                            textScaleFactor: textScaleFactor,
                            style: const TextStyle(
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
                              controller: textItem == "Name"
                                  ? nameController
                                  : textItem == "Description"
                                      ? descriptionController
                                      : dateController,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                suffixIcon: textItem == "Due Date"
                                    ? InkWell(
                                        onTap: () {
                                          selectedTaskDate(context);
                                        },
                                        child: const Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFFEC5F5F),
                                        ),
                                      )
                                    : null,
                                filled: true,
                                fillColor: const Color(0xFFF6F7FA),
                                hintText: textItem == "Due Date"
                                    ? DateFormat.yMMMMd()
                                        .format(DateTime.now())
                                        .toString()
                                    : '$textItem',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF9D9FA0),
                                  fontSize: 16,
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFF6F7FA), width: 0.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                enabledBorder: const OutlineInputBorder(
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
                        ],

                        SizedBox(
                          height: 32 / mockupWidth * deviceWidth,
                        ),

                        //save/update button
                        SizedBox(
                          width: 343 / mockupWidth * deviceWidth,
                          height: 56 / mockupWidth * deviceWidth,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color(0xFFEC5F5F)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              bool response = false;

                              if (DateTime.tryParse(
                                      dateController.text.toString()) !=
                                  null) {
                                if (operation == "Add") {
                                  response = await rs.createTask(
                                      nameController.text.toString(),
                                      descriptionController.text.toString(),
                                      dateController.text.toString());
                                } else if (operation == "Edit") {
                                  response = await rs.updateTask(
                                      id,
                                      nameController.text.toString(),
                                      descriptionController.text.toString(),
                                      dateController.text.toString());
                                }

                                if (response) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.playlist_add_check,
                                          color: Colors.greenAccent,
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                            child: Text(operation == "Edit"
                                                ? 'Task Updated Successfully!'
                                                : 'Task Added Successfully!')),
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
                                      Expanded(
                                          child: Text('Enter a valid date')),
                                    ],
                                  ),
                                ));
                              }
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                      maintainState: true),
                                  (Route<dynamic> route) => false);
                            },
                            child: Center(
                              child: Text(
                                operation == "Edit" ? "Update" : "Save",
                                textScaleFactor: textScaleFactor,
                                style: const TextStyle(
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
            );
          });

  //editordeleteDialog
  Future editOrDelete(double textScaleFactor, double deviceWidth, dynamic task,
          int index) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24.0))),
                title: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 18.0 / mockupWidth * deviceWidth),
                  child: Text(
                    "Edit/Delete",
                    textScaleFactor: textScaleFactor,
                    style: const TextStyle(
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
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                        maintainState: true),
                                    (Route<dynamic> route) => false);
                                taskAddorEdit(
                                    textScaleFactor,
                                    deviceWidth,
                                    "Edit",
                                    task["id"],
                                    task["name"],
                                    task["description"],
                                    task["date"]);
                              },
                              child: Icon(Icons.edit_note_sharp,
                                  color: Colors.blue,
                                  size: 40 / mockupWidth * deviceWidth),
                            ),
                            Text(
                              "Edit",
                              textScaleFactor: textScaleFactor,
                              style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                rs
                                    .deleteTask(task["id"].toString())
                                    .whenComplete(() {
                                  setState(() {
                                    items.removeAt(index);
                                  });
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
                                            child: Text(
                                                "Task Deleted Successfully!")),
                                      ],
                                    ),
                                  ));
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(),
                                          maintainState: true),
                                      (Route<dynamic> route) => false);
                                });
                              },
                              child: Icon(Icons.delete_forever,
                                  color: Colors.red,
                                  size: 40 / mockupWidth * deviceWidth),
                            ),
                            Text(
                              "Delete",
                              textScaleFactor: textScaleFactor,
                              style: const TextStyle(
                                  color: Color(0xFF303030),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
}
