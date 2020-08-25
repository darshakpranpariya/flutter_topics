
import 'dart:math';
import 'package:event_bus/event_bus.dart';
import 'package:eventbus_implimentation/theme_data.dart';
import 'package:eventbus_implimentation/theme_notifire.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => ThemeNotifire(lightTheme), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeData = Provider.of<ThemeNotifire>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter EventBus Demo',
      theme: themeData.getTheme(),
      home: MyHomePage(title: 'EventBus Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  //One event bus can handle all types of different different event...
  //this is default way to make instance of eventbus...
  // EventBus eventBus = EventBus();

  //This is custome type to make instance of eventbus...
  EventBus eventBus = EventBus.customController(ReplaySubject());

  bool val = false;
  // final subject = ReplaySubject<UserLoggedInEvent>();

  void _addUser() {
    List<String> _name = [
      "darshak",
      "aryan",
      "thiren",
      "jigar",
      "mehul",
      "saurabh"
    ];
    final _random = new Random();
    String randomName = _name[_random.nextInt(_name.length)];
    User myUser = User(randomName);
    eventBus.fire(UserLoggedInEvent(myUser));
    // subject.add(UserLoggedInEvent(myUser));
  }

  void _addOrder() {
    List<String> _things = [
      "Almond",
      "fruits",
      "ball",
      "pen",
      "laptop",
      "Books"
    ];
    final _random = new Random();
    String randomName = _things[_random.nextInt(_things.length)];
    Order myOrder = Order(randomName);
    eventBus.fire(NewOrderEvent(myOrder));
  }

  @override
  Widget build(BuildContext context) {
    var notIns = Provider.of<ThemeNotifire>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          CupertinoSwitch(
              value: val,
              onChanged: (value) {
                setState(() {
                  val = value;
                  if(val==true){
                    notIns.setTheme(darkTheme);
                  }
                  else{
                    notIns.setTheme(lightTheme);
                  }
                });
              },
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // StreamBuilder(
            //   stream: subject.stream.map((event) => list.add(event)),
            //   // stream: eventBus.on<UserLoggedInEvent>(),
            //   initialData: UserLoggedInEvent(User("There is no user...")),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     return ListView.builder(
            //       itemCount: snapshot.data.length,
            //       itemBuilder: (BuildContext context, int index) {
            //         return ListTile(
            //           hoverColor: Colors.redAccent,
            //           focusColor: Colors.teal,
            //           title: Center(
            //               child: Text(
            //             snapshot.data[index].user.n.toString(),
            //             style: TextStyle(
            //                 fontSize: 30.0, fontWeight: FontWeight.bold),
            //           )),
            //         );
            //       },
            //     );
            //   },
            // ),
            StreamBuilder(
              // stream: subject.stream,
              stream: eventBus.on<UserLoggedInEvent>(),
              initialData: UserLoggedInEvent(User("There is no user...")),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListTile(
                  hoverColor: Colors.redAccent,
                  focusColor: Colors.teal,
                  title: Center(
                      child: Text(
                    "UserName Stream:\n" + snapshot.data.user.n.toString(),
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  )),
                );
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            StreamBuilder(
              stream: eventBus.on<NewOrderEvent>(),
              initialData: NewOrderEvent(Order("There is no order...")),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListTile(
                  hoverColor: Colors.redAccent,
                  focusColor: Colors.teal,
                  title: Center(
                      child: Text(
                    "OrderItem Stream:\n" +
                        snapshot.data.order.thingsName.toString(),
                    style:
                        TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  )),
                );
              },
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FloatingActionButton(
                        onPressed: _addUser,
                        tooltip: 'addUser',
                        child: Icon(Icons.add),
                      ),
                      FloatingActionButton(
                        onPressed: _addOrder,
                        tooltip: 'addOrder',
                        child: Icon(Icons.shopping_basket),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UserLoggedInEvent {
  User user;

  UserLoggedInEvent(this.user);
}

class User {
  String n;
  User(this.n);
}

class NewOrderEvent {
  Order order;

  NewOrderEvent(this.order);
}

class Order {
  String thingsName;
  Order(this.thingsName);
}
