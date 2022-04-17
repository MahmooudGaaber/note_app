import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:note_app/module/archive_screen/archive.dart';
import 'package:note_app/module/done_screen/done.dart';
import 'package:note_app/module/tasks_screen/tasks.dart';
import 'package:note_app/shared/components/components.dart';
import 'package:note_app/shared/components/constant.dart';
import 'package:sqflite/sqflite.dart';
import 'cubit/cubit.dart';
import 'cubit/satet.dart';

class HomeScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => HomeLayoutCubit()..createDB(),
      child: BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) {
          HomeLayoutCubit cubit = HomeLayoutCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.screenTittle[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              elevation: 0.0,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeBottomNaviState(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: "Done",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: "Archived",
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.bottomSheetUp == false) {
                  scaffoldKey.currentState!
                      .showBottomSheet((context) {
                        cubit.trueAndFalse(isShow: true);
                        return Container(
                          color: Colors.grey[100],
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultTextFormField(
                                    label: "Title",
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Title Must not be Empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    prefix: Icons.title,
                                    isPassword: false,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    label: "Date",
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2023),
                                      ).then((value) {
                                        // dateController.text = value.toString();
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Date Must not be Empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    prefix: Icons.calendar_today,
                                    isPassword: false,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  defaultTextFormField(
                                    label: "Time",
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    controller: timeController,
                                    keyboardType: TextInputType.datetime,
                                    validate: (value) {
                                      if (value.isEmpty) {
                                        return 'Date Must not be Empty';
                                      } else {
                                        return null;
                                      }
                                    },
                                    prefix: Icons.watch_later_outlined,
                                    isPassword: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((value) {
                        cubit.trueAndFalse(isShow: false);
                      });
                } else {
                  if (formKey.currentState!.validate()) {
                    cubit
                        .insertIntoDB(
                      title: titleController.text,
                      time: timeController.text,
                      date: dateController.text,
                    )
                        .then((value) {
                      Navigator.pop(context);
                    });
                  }
                }
              },
              elevation: 0.0,
              child:
                  cubit.bottomSheetUp ? const Text("Done") : const Text("Add"),
            ),
            body: HomeLayoutCubit.get(context)
                .screens[HomeLayoutCubit.get(context).currentIndex],
          );
        },
      ),
    );
  }
}
