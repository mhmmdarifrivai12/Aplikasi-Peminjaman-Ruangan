import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pinjam_ruang/app/modules/tambahruang/views/list_peminjaman_view.dart';
import 'package:flutter_pinjam_ruang/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../daftarruang/controllers/daftarruang_controller.dart';
import '../../daftarruang/views/daftarruang_view.dart';
import '../controllers/home_controller.dart';
import '../../tambahruang/views/tambahruang_view.dart';

class HomeView extends GetView<HomeController> {
  final cAuth = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return DashboardHome();
  }
}

class DashboardHome extends StatefulWidget {
  const DashboardHome({super.key});

  @override
  State<DashboardHome> createState() => _DashboardHomeState();
}

class _DashboardHomeState extends State<DashboardHome> {
  int _selectedIndex = 0;
  final cAuth = Get.find<AuthController>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 100.0,
                    height: 100.0,
                    child: ClipOval(
                      child: Image(
                        image: NetworkImage(
                          "https://i.ibb.co/YDY6gWG/profile.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => cAuth.logout(),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.logout,
                                size: 20.0,
                                color: Colors.black,
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20, bottom: 15, right: 50, left: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: ClipOval(
                    child: Image.network(
                      "https://i.ibb.co/k34YnYr/uti.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 25, left: 15, right: 15),
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(246, 247, 248, 1),
                  border:
                      Border.all(color: const Color.fromRGBO(246, 247, 248, 1)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Color.fromRGBO(120, 124, 1132, 1),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari Ruangan',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                SizedBox(
                  height: 140,
                  child: ListView(
                    children: [
                      CarouselSlider(
                        items: [
                          SlideItem('https://i.ibb.co/KydvbGg/uti2.jpg'),
                          SlideItem('https://i.ibb.co/QD7DWnZ/uti1.jpg'),
                          SlideItem('https://i.ibb.co/D41KGw4/uti3.png'),
                        ],
                        options: CarouselOptions(
                          height: 140.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1000),
                          viewportFraction: 0.8,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Rekomendasi Ruangan',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Get.put(DaftarruangController())
                      .streamDataByNamaRuang('Lab Bisnis Digital'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var listAllDocs = snapshot.data?.docs ?? [];
                      if (listAllDocs.length > 0) {
                        // Ambil data pertama untuk menampilkan dalam Container
                        var docData =
                            listAllDocs[0].data() as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.DESKRIPSIRUANG,
                              arguments: {
                                'id': listAllDocs[0].id,
                                'namaruangan': docData["namaruangan"],
                                'gedung': docData["gedung"],
                                'kapasitas': docData["kapasitas"],
                                'deskripsi': docData["deskripsi"],
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 241, 241, 241)
                                      .withOpacity(0.8),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: 20, left: 15, right: 15),
                            height: 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    height: 110,
                                    width: 110,
                                    image: NetworkImage(
                                        'https://i.ibb.co/3y5wj0N/labdigital.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${docData["namaruangan"]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${docData["gedung"]}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Kapasitas ${docData["kapasitas"]} Kursi",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Data Kosong"),
                        );
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Get.put(DaftarruangController())
                      .streamDataByNamaRuang('Lab 1 GSG'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var listAllDocs = snapshot.data?.docs ?? [];
                      if (listAllDocs.length > 0) {
                        // Ambil data pertama untuk menampilkan dalam Container
                        var docData =
                            listAllDocs[0].data() as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.DESKRIPSIRUANG,
                              arguments: {
                                'id': listAllDocs[0].id,
                                'namaruangan': docData["namaruangan"],
                                'gedung': docData["gedung"],
                                'kapasitas': docData["kapasitas"],
                                'deskripsi': docData["deskripsi"],
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 241, 241, 241)
                                      .withOpacity(0.8),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: 20, left: 15, right: 15),
                            height: 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    height: 110,
                                    width: 110,
                                    image: NetworkImage(
                                        'https://i.ibb.co/1Mb4hfC/lab1gsg.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${docData["namaruangan"]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${docData["gedung"]}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Kapasitas ${docData["kapasitas"]} Kursi",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Data Kosong"),
                        );
                      }
                    }
                    return Center(
                      child: SizedBox(
                        width: 5,
                      ),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Get.put(DaftarruangController())
                      .streamDataByNamaRuang('Lab 1 ICT'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var listAllDocs = snapshot.data?.docs ?? [];
                      if (listAllDocs.length > 0) {
                        // Ambil data pertama untuk menampilkan dalam Container
                        var docData =
                            listAllDocs[0].data() as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.DESKRIPSIRUANG,
                              arguments: {
                                'id': listAllDocs[0].id,
                                'namaruangan': docData["namaruangan"],
                                'gedung': docData["gedung"],
                                'kapasitas': docData["kapasitas"],
                                'deskripsi': docData["deskripsi"],
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 241, 241, 241)
                                      .withOpacity(0.8),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: 20, left: 15, right: 15),
                            height: 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    height: 110,
                                    width: 110,
                                    image: NetworkImage(
                                        'https://i.ibb.co/vqzxHct/labict.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${docData["namaruangan"]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${docData["gedung"]}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Kapasitas ${docData["kapasitas"]} Kursi",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Data Kosong"),
                        );
                      }
                    }
                    return Center(
                      child: SizedBox(
                        width: 5,
                      ),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: Get.put(DaftarruangController())
                      .streamDataByNamaRuang('Ruang 201 B'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      var listAllDocs = snapshot.data?.docs ?? [];
                      if (listAllDocs.length > 0) {
                        // Ambil data pertama untuk menampilkan dalam Container
                        var docData =
                            listAllDocs[0].data() as Map<String, dynamic>;

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.DESKRIPSIRUANG,
                              arguments: {
                                'id': listAllDocs[0].id,
                                'namaruangan': docData["namaruangan"],
                                'gedung': docData["gedung"],
                                'kapasitas': docData["kapasitas"],
                                'deskripsi': docData["deskripsi"],
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color.fromARGB(255, 241, 241, 241)
                                      .withOpacity(0.8),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                                bottom: 20, left: 15, right: 15),
                            height: 110,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image(
                                    height: 110,
                                    width: 110,
                                    image: NetworkImage(
                                        'https://i.ibb.co/TH3RTSR/302b.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "${docData["namaruangan"]}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${docData["gedung"]}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Kapasitas ${docData["kapasitas"]} Kursi",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w100,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Data Kosong"),
                        );
                      }
                    }
                    return Center(
                      child: SizedBox(
                        width: 5,
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        color: Color.fromRGBO(246, 247, 248, 1),
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              color: _selectedIndex == 0
                  ? Colors.black
                  : Color.fromRGBO(152, 155, 161, 1),
              onPressed: () {
                _onItemTapped(0);
              },
            ),
            IconButton(
              icon: Icon(Icons.view_list_outlined),
              color: _selectedIndex == 1
                  ? Colors.black
                  : Color.fromRGBO(152, 155, 161, 1),
              onPressed: () {
                _onItemTapped(1);
              },
            ),
            SizedBox(), // Spacer
            IconButton(
              icon: Icon(Icons.archive),
              color: _selectedIndex == 2
                  ? Colors.black
                  : Color.fromRGBO(152, 155, 161, 1),
              onPressed: () {
                _onItemTapped(2);
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              color: _selectedIndex == 3
                  ? Colors.black
                  : Color.fromRGBO(152, 155, 161, 1),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahruangView()),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        shape: CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    } else if (index == 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DaftarruangView()),
      );
    } else if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ListPeminjamanView()),
      );
    }
  }

  void showOption(id) async {
    var result = await Get.dialog(
      SimpleDialog(
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TambahruangView()),
              );
            },
            title: Text('Pinjam'),
          ),
          ListTile(
            onTap: () => Get.back(),
            title: Text('Close'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}

class SlideItem extends StatelessWidget {
  final String img;

  SlideItem(this.img);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300)),
      child: Image(
          image: NetworkImage(
            img,
          ),
          fit: BoxFit.cover),
    );
  }
}
