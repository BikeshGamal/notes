import 'package:flutter/material.dart';
import 'package:note_app/screens/add_to_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<String> note = [];
  List<String> ndt = [];
  void addNote({required item, required dt}) {
    setState(() {});
    note.add(item);
    ndt.add(dt.toString());
    setData();
  }

  void deleteNote(int index) {
    setState(() {});
    note.removeAt(index);
    ndt.removeAt(index);
    setData();
  }

  setData() async {
    final SharedPreferences prefs1 = await SharedPreferences.getInstance();
    await prefs1.setStringList('note', note);
    await prefs1.setStringList('ndt', ndt);
    setState(() {});
  }

  getData() async {
    final SharedPreferences prefs1 = await SharedPreferences.getInstance();
    setState(() {
      note = prefs1.getStringList('note') ?? [];
      ndt = prefs1.getStringList('ndt') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.purple,
              child: Center(
                child: Text(
                  "By Gamalgorithm Technologies PVT. LTD.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse(
                    "https://www.linkedin.com/in/bikesh-gamal-64a25825b/"));
              },
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text("@gamalgorithm"),
              ),
            ),
            GestureDetector(
              onTap: () {
                launchUrl(Uri.parse("tel:9828041305"));
              },
              child: ListTile(
                leading: Icon(Icons.phone),
                title: Text("9828041305"),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Container(
                      padding: MediaQuery.of(context).padding,
                      height: 200,
                      child: AddToList(
                        addNote: addNote,
                      ),
                    ),
                  );
                },
              );
            },
          )
        ],
        centerTitle: true,
        title: Text(
          "Notes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple,
      ),
      body: note.length != 0
          ? ListView.builder(
              itemCount: note.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          height: 150,
                          child: Column(
                            children: [
                              Text("Do you want to delete this note?"),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      deleteNote(index);
                                      setData();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: Text("Yes"))
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) {
                      setState(() {
                        deleteNote(index);
                        setData();
                      });
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(
                          ndt[index],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(note[index]),
                      ),
                    ),
                  ),
                );
              })
          : Center(
              child: Text("No note found"),
            ),
    );
  }
}
