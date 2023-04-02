import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/Arguments/ScreenArguments.dart';
import 'package:project/class/bloc/ClassBloc.dart';
import 'package:project/class/bloc/ClassEvent.dart';
import 'package:project/class/bloc/ClassState.dart';
import 'package:project/routes.dart';

class ShowClasses extends StatefulWidget {
  final String teacherName;
  final String teacherPassword;

  const ShowClasses(
      {Key? key, required this.teacherName, required this.teacherPassword})
      : super(key: key);
  @override
  _ShowClassesState createState() => _ShowClassesState(
      teacherName: teacherName, teacherPassword: teacherPassword);
}

class _ShowClassesState extends State {
  final String teacherName;
  final String teacherPassword;

  _ShowClassesState({required this.teacherName, required this.teacherPassword});

  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Show Classes"),
          leading: IconButton(
            padding: EdgeInsets.only(top: 5),
            alignment: Alignment.topLeft,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: BlocBuilder<ClassBloc, ClassState>(builder: (context, state) {
          if (state is ClassEmpty) {
            BlocProvider.of<ClassBloc>(context).add(FetchAllClasses(
                teacherName: teacherName, teacherPassword: teacherPassword));
            return Center(child: CircularProgressIndicator());
          }
          if (state is OneClassLoaded) {
            BlocProvider.of<ClassBloc>(context).add(FetchAllClasses(
                teacherName: teacherName, teacherPassword: teacherPassword));
            return Center(child: CircularProgressIndicator());
          }
          if (state is ClassError) {
            return Center(
              child: Text("Error finding class"),
            );
          }
          if (state is AllClassesLoaded) {
            final allclassNames = state.classNames.toList();
            if (state.classNames.length > 0) {
              return Scaffold(
                body: ListView.builder(
                    itemCount: allclassNames.length,
                    itemBuilder: (c, index) {
                      return ListTile(
                        title: Text(allclassNames.elementAt(index).name),
                        onTap: () {
                          Navigator.of(buildContext).popAndPushNamed(
                              RouteGenerator.classDetail,
                              arguments: ScreenArguments(
                                  classId: allclassNames
                                      .elementAt(index)
                                      .classNameId,
                                  className: "className",
                                  name: this.teacherName,
                                  password: this.teacherPassword));
                        },
                        trailing: TextButton(
                          onPressed: () => {
                            BlocProvider.of<ClassBloc>(context).add(DeleteClass(
                                id: allclassNames.elementAt(index).classNameId,
                                teacherName: teacherName,
                                teacherPassword: teacherPassword)),
                            Navigator.of(buildContext).pop()
                          },
                          child: Icon(Icons.delete),
                        ),
                      );
                    }),
                floatingActionButton: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        heroTag: "class",
                        onPressed: () => {
                          Navigator.of(buildContext).popAndPushNamed(
                              RouteGenerator.createClass,
                              arguments: ScreenArguments(
                                  classId: 0,
                                  className: "",
                                  name: this.teacherName,
                                  password: this.teacherPassword))
                        },
                        label: Text("Class"),
                        icon: Icon(Icons.add),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: FloatingActionButton.extended(
                          heroTag: "student",
                          onPressed: () => {
                            Navigator.of(buildContext)
                                .popAndPushNamed(RouteGenerator.createStudent)
                          },
                          label: Text("Create Student"),
                          icon: Icon(Icons.add),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () => {
                    Navigator.of(buildContext).popAndPushNamed(
                        RouteGenerator.createClass,
                        arguments: ScreenArguments(
                            classId: 0,
                            className: "",
                            name: this.teacherName,
                            password: this.teacherPassword))
                  },
                  child: Icon(Icons.add),
                ),
              );
            }
          }
          return Center(child: CircularProgressIndicator());
        }),
      ),
    );
  }
}
