import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/layout/cubit/cubit.dart';

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String label,
  required dynamic validate,
  required IconData prefix,
  suffix,
  dynamic onTap,
  bool isPassword = false,
}) =>
    TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: keyboardType,
      onTap: onTap,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(label),
          prefixIcon: Icon(prefix),
          suffix: Icon(suffix)),
    );

Widget buildTaskItem( Map tasks , context ) =>
    Dismissible(
      key: Key(tasks['id'].toString()),
      onDismissed: (direction){
        HomeLayoutCubit.get(context).deleteDB(id: tasks['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
             CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.black,
              child: Text(
                '${tasks['time']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  Text(
                    '${tasks['title']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${tasks['date']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            IconButton(
                onPressed: (){
                  HomeLayoutCubit.get(context).updateDB(status: 'done', id: tasks['id']);
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.green,
                ),
            ),
            IconButton(
                onPressed: (){
                  HomeLayoutCubit.get(context).updateDB(status: 'archived', id: tasks['id']);
                },
                icon: const Icon(
                  Icons.archive,
                  color: Colors.black12,
                ),
            ),
          ],
        ),
      ),
    );
