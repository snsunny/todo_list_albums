import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_albums/models/todo_items.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _dio = Dio(BaseOptions(responseType: ResponseType.plain));
  List<TodoItems>? _itemList;
  String? _error;

  void getTodos() async{
    try {
      setState(() {
        _error = null;
      });

      await Future.delayed(Duration(seconds: 3),() {});

      final response = await _dio.get('https://jsonplaceholder.typicode.com/albums');
      debugPrint(response.data.toString());

      List list = jsonDecode(response.data.toString());
      setState(() {
        _itemList = list.map((item) => TodoItems.fromJson(item)).toList();
      });
    }catch (e) {
      setState(() {
        _error = e.toString();
      });
      debugPrint('เกิดข้อผิดพลาด: ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if(_error != null){
      body = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error!),
          const SizedBox(height: 16),
          ElevatedButton(
              onPressed: () {
                getTodos();
              },
              child: Text('RETRY')
          )
        ],
      );
    }else if(_itemList == null){
      body = const Center(child:  CircularProgressIndicator());
    }else{
      body = ListView.builder(
        itemCount: _itemList!.length,
        itemBuilder: (context, index) {
          var todoItem = _itemList![index];

          return Card(
            child: Padding(
              padding: const  EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            todoItem.title,
                            maxLines: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromRGBO(249, 206, 227, 1),
                        ),
                        height: 20,
                        width: 70,
                        child: Center(
                          child: Text(
                            'Album ID: ${todoItem.id}',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(203, 244, 252, 1),
                          ),
                          height: 20,
                          width: 60,
                          child: Center(
                            child: Text(
                              'User ID: ${todoItem.userId}',
                              style: TextStyle(
                                fontSize: 10,
                              ),
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
      );
    }

    return Scaffold(
    appBar: AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Photo Albums',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ],
      ),
    ),
      body: body,
    );
  }
}