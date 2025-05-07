import 'package:flutter/material.dart';

// Fungsi utama yang menjalankan aplikasi
void main() {
  runApp(KulinerApp());
}

// Widget utama aplikasi menggunakan StatelessWidget
class KulinerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kulinernusantara',
      home: HomePage(), // Menampilkan halaman utama
      debugShowCheckedModeBanner: false, // menyembunyikan label "DEBUG" merah 
    );
  }
}

// Halaman utama aplikasi
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

// State dari halaman utama
class _HomePageState extends State<HomePage> {
  bool showForm = false; // Apakah form pemesanan sedang ditampilkan
  String selectedFood = ""; // Makanan yang dipilih

  // Control untuk input form pemesanan
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController waController = TextEditingController();

  // Set untuk menyimpan makanan favorit
  Set<String> favoriteFoods = {};

  // Fungsi untuk menyukai atau menghapus like dari makanan
  void _likeFood(String foodName) {
    setState(() {
      if (favoriteFoods.contains(foodName)) {
        favoriteFoods.remove(foodName);
      } else {
        favoriteFoods.add(foodName);
      }
    });
  }

  // Fungsi untuk memilih makanan dan menampilkan form pemesanan
  void _orderFood(String foodName) {
    setState(() {
      selectedFood = foodName;
      showForm = true;
    });
  }

  // Fungsi untuk submit pemesanan
  void _submitOrder() {
    String nama = nameController.text;
    String alamat = addressController.text;
    String wa = waController.text;

    // Validasi input form pesanan
    if (nama.isNotEmpty && alamat.isNotEmpty && wa.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Pesanan '$selectedFood' untuk $nama telah dikirim!"),
        ),
      );
      // Mengosongkan form dan menyembunyikan form
      nameController.clear();
      addressController.clear();
      waController.clear();
      setState(() {
        showForm = false;
      });
    } else {
      // Tampilkan peringatan jika ada data yang belum diisi
      // semua data harus diisi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Semua data harus diisi!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      //membuat app bar dengan judul dan warna latar.
      appBar: AppBar(
        title: Text('Kuliner Nusantara'), 
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: isLandscape
              // Jika orientasi landscape, gunakan Row
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _leftColumn()),
                    SizedBox(width: 16),
                    Expanded(child: _rightColumn()),
                  ],
                )
              // Jika portrait, gunakan Column
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _leftColumn(),
                    SizedBox(height: 16),
                    _rightColumn(),
                  ],
                ),
        ),
      ),
    );
  }

  // Kolom kiri berisi daftar makanan
  Widget _leftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Rekomendasi Makanan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        // Beberapa card makanan yang ditampilkan
        _foodCard(
          "Sate Klathak", 
          "assets/sateklathak.jpeg", 
          "Sate klathak adalah sate kambing asal Kapanéwon Pleret, Kabupaten Bantul."
          ),
        _foodCard(
          "Rendang", 
          "assets/rendang.jpg", 
          "Masakan daging berbumbu khas Sumatera Barat."
          ),
        _foodCard(
          "Pempek Palembang", 
          "assets/pempek.jpg", 
          "Olahan ikan tenggiri dengan kuah cuka khas."
          ),
        _foodCard(
          "Gudeg Jogja", 
          "assets/gudegjogja.jpg", 
          "Olahan khas Yogyakarta berbahan nangka muda."
          ),
        _foodCard(
          "Soto Klaten", 
          "assets/sotoklaten.jpg", 
          "Soto khas Klaten dengan cita rasa gurih."
          ),
        _foodCard(
          "Rawon", 
          "assets/rawon.jpeg", 
          "Sup daging dengan kuah hitam khas Jawa Timur."
          ),
        _foodCard(
          "Rujak Cingur", 
          "assets/rujakcingur.jpeg", 
          "Rujak khas Surabaya dengan irisan cingur sapi."
          ),
      ],
    );
  }

  // Kolom kanan berisi form pemesanan
  Widget _rightColumn() {
    if (!showForm) {
      return Center(child: Text("Klik 'Pesan Sekarang' untuk memesan makanan"));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Formulir Pemesanan untuk: $selectedFood", style: TextStyle(fontSize: 18)),
        SizedBox(height: 10),
        // Input nama
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Nama Pemesan'),
        ),
        // Input alamat
        TextField(
          controller: addressController,
          decoration: InputDecoration(labelText: 'Alamat'),
        ),
        // Input nomor WA
        TextField(
          controller: waController,
          decoration: InputDecoration(labelText: 'No. WhatsApp'),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 12),
        // Tombol submit
        ElevatedButton.icon(
          onPressed: _submitOrder,
          icon: Icon(Icons.send),
          label: Text("Pesan"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
        ),
      ],
    );
  }

  // Widget untuk menampilkan setiap makanan
  Widget _foodCard(String title, String imageUrl, String description) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar makanan
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 6),
                Text(description),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Tombol Pesan Sekarang
                    ElevatedButton.icon(
                      onPressed: () => _orderFood(title),
                      icon: Icon(Icons.shopping_cart),
                      label: Text("Pesan Sekarang"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                    ),
                    // Tombol favorit love berwarna merah
                    IconButton(
                      icon: Icon(
                        favoriteFoods.contains(title) ? Icons.favorite : Icons.favorite_border,
                        color: favoriteFoods.contains(title) ? Colors.red : null,
                      ),
                      onPressed: () => _likeFood(title),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
