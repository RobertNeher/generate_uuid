import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'fetch_uuid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UUID Generator',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const UUIDGeneratorPage(title: 'Flutter UUID Generator'),
    );
  }
}

class UUIDGeneratorPage extends StatefulWidget {
  const UUIDGeneratorPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<UUIDGeneratorPage> createState() => _UUIDGeneratorPageState();
}

class _UUIDGeneratorPageState extends State<UUIDGeneratorPage> {
  List<String>? uuid = [];

  TextEditingController tec = TextEditingController();

  @override
  @override
  void initState() {
    tec.text = '1';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Row(children: <Widget>[
            Expanded(child: Container()),
            Expanded(
                flex: 8,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'How many UUIDs do you need?'),
                  validator: (value) {
                    int? count = int.tryParse(value!);
                    if (count! < 1 || count > 99) {
                      return 'Please enter a number between 1 and 99';
                    }
                  },
                  controller: tec,
                )),
            const SizedBox(width: 30),
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text('New UUID(s)')),
            Expanded(child: Container()),
          ]),
          const SizedBox(height: 30),
          const Text('Generated UUIDs',
              style: TextStyle(
                fontSize: 14,
              )),
          const Text('(press item to copy to clipboard)',
              style: TextStyle(
                fontSize: 10,
              )),
          SizedBox(
            height: 300,
            child: FutureBuilder<List<String>>(
                future: fetchUUID(int.tryParse(tec.text)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error fetching UUID'));
                    } else if (snapshot.hasData) {
                      uuid = snapshot.data;

                      return Scrollbar(
                        isAlwaysShown: true,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: snapshot.data![index]));
                                    SnackBar snackBar = SnackBar(
                                      content: Text(
                                          'UUID "${snapshot.data![index]}" copied to clipboard!'),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  },
                                  child: Text(snapshot.data![index])),
                              const SizedBox(height: 5),
                            ]);
                          },
                        ),
                      );
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          )
        ]));
  }
}
