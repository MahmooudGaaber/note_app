import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/layout/cubit/cubit.dart';
import 'package:note_app/layout/cubit/satet.dart';
import 'package:note_app/shared/components/components.dart';

class NewTasksScreen extends StatelessWidget {
  const NewTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
      builder: (BuildContext context, state) {
        List<Map> tasks = HomeLayoutCubit.get(context).newTasks;
        return ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
            color: Colors.grey[300],
            height: 1.0,
            width: double.infinity,
          ),
          itemCount: tasks.length,
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}
