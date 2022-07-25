import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCardWidget extends StatelessWidget {
  final int mockupWidth;
  final double deviceWidth;
  final double textScaleFactor;
  final dynamic task;
  final int index;
  final Future<dynamic> Function(double, double, dynamic, int) editOrDelete;
  const TaskCardWidget(
      {Key? key,
      required this.mockupWidth,
      required this.deviceWidth,
      required this.textScaleFactor,
      this.task,
      required this.index,
      required this.editOrDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.0 / mockupWidth * deviceWidth),
      child: Container(
        height: 140 / mockupWidth * deviceWidth,
        width: 343 / mockupWidth * deviceWidth,
        decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.1),
                  blurRadius: 14 / mockupWidth * deviceWidth,
                  spreadRadius: 0.0 / mockupWidth * deviceWidth,
                  offset: Offset(0.0 / mockupWidth * deviceWidth,
                      4 / mockupWidth * deviceWidth))
            ],
            color: const Color(0xFFF6F7FA),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16 / mockupWidth * deviceWidth,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    task["name"].toString(),
                    textScaleFactor: textScaleFactor,
                    style: const TextStyle(
                        color: Color(0xFF303030),
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      //editOrDelete(textScaleFactor, deviceWidth, task, index);
                      editOrDelete(textScaleFactor, deviceWidth, task, index);
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: 18 / mockupWidth * deviceWidth,
                      color: const Color(0xFFBDC1C4),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10 / mockupWidth * deviceWidth,
              ),
              Text(
                task["description"].toString(),
                textScaleFactor: textScaleFactor,
                style: const TextStyle(
                    color: Color(0xFF8C8C8C),
                    fontWeight: FontWeight.w400,
                    fontSize: 14),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  task["date"] != null
                      ? DateFormat.yMMMMd()
                          .format(DateTime.parse(task["date"]))
                          .toString()
                      : "",
                  textScaleFactor: textScaleFactor,
                  style: const TextStyle(
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
  }
}
