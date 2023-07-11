import 'package:ecommerce/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ecommerce/cart_page.dart';
import 'package:badges/badges.dart' as badges;


class ListPage extends StatefulWidget {


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    var response = await http.get(Uri.parse('https://fakestoreapi.com/products'));
    if (response.statusCode == 200) {
      setState(() {
        products = jsonDecode(response.body);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length : 2 ,
     // children: [
        child: Scaffold(
          backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.1,
              backgroundColor: Colors.blue,
              title: Center(child: Text('Home')),
            ),

          body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),

                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(
                          productId: products[index]['id'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.network(
                          products[index]['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                products[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '\$${products[index]['price'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            notchMargin: 4.0,
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              /*  IconButton(icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => CartPage(),
                      builder: (context) => CartPage(),
                    ),
                  );
                },
                ),*/
                badges.Badge(
                  badgeContent: Text('1'),
                  child: Icon(Icons.shopping_cart),
                ),
                IconButton(icon: Icon(Icons.logout), onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      //builder: (context) => ProductCatalogPage(),
                      builder: (context) => LoginPage(),
                    ),
                  );
                },),
              ],
            ),
          ),
        ),
    );
  }

}

class ProductDetailsPage extends StatefulWidget {
  final int productId;

  ProductDetailsPage({required this.productId});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Product> _productFuture;
  int _cartBadgeAmount =0;
  late bool _showCartBadge;
  Color color = Colors.red;

  @override
  void initState() {
    super.initState();
    _productFuture = fetchProduct(widget.productId);
  }

  Future<Product> fetchProduct(int productId) async {
    final response = await http.get(Uri.parse('https://fakestoreapi.com/products/$productId'));
    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load product');
    }
  }



  @override
  Widget build(BuildContext context) {
    _showCartBadge = _cartBadgeAmount > 0;
    return DefaultTabController(
      length: 2,
      //children: [
        child: Scaffold(
            appBar: AppBar(
              actions: <Widget>[
                _shoppingCartBadge(),
              ],
            title: Text('Product Details'),
        centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: FutureBuilder<Product>(
          future: _productFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
                final product = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Image.network(
        product.image,
        width: 500,
        height: 370,
        ),
        SizedBox(height: 20),
        Text(
        product.title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text('Price: \$${product.price.toStringAsFixed(2)}',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
        product.description,
        style: TextStyle(fontSize: 20, ),
        ),
        SizedBox(height: 20),
          _addRemoveCartButtons(),
        ],
        );
        } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
        } else {
        return CircularProgressIndicator();
        }
        },
        ),
        ),
        ),
    );
}
  Widget _shoppingCartBadge() {
    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: 0, end: 3),
      badgeAnimation: badges.BadgeAnimation.slide(
      ),
      showBadge: _showCartBadge,
      badgeStyle: badges.BadgeStyle(
        badgeColor: color,
      ),
      badgeContent: Text(
        _cartBadgeAmount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
    );
  }

  Widget _addRemoveCartButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ElevatedButton.icon(
              onPressed: () => setState(() {
                _cartBadgeAmount++;
                if (color == Colors.blue) {
                  color = Colors.red;
                }
              }),
              icon: Icon(Icons.add),
              label: Text('Add to cart')),
          ElevatedButton.icon(
              onPressed: _showCartBadge
                  ? () => setState(() {
                _cartBadgeAmount--;
                color = Colors.blue;
              })
                  : null,
              icon: Icon(Icons.remove),
              label: Text('Remove from cart')),
        ],
      ),
    );
  }
}

class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String image;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: json['price'].toDouble(),
      image: json['image'],
    );
  }
}



