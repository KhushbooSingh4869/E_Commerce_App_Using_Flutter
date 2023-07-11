import 'package:flutter/material.dart';
import 'package:ecommerce/utils.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CartPage extends StatefulWidget{
  @override
  State createState() {
    // TODO: implement createState
    return CartPageState();
  }

}

class CartPageState extends State{

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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Cart Items"),backgroundColor: Colors.blue,),
      body:( Cart().getList().length>0) ?GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: Cart().getList().length,
          itemBuilder: (context,index){
            return Container(
              width: 200,
              child: Card(
                child: Stack(
                  children: [
                Image.network(
                products[index]['image'],
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          //Text("Product Name",style: TextStyle(color: Colors.green,fontWeight:  FontWeight.bold,fontSize: 20),),
                          MaterialButton(onPressed: (){
                            setState(() {
                              print(Cart().getList().length);
                              Cart().getList().removeAt(index);
                            });

                          }, child: Text("Remove",style: TextStyle(color: Colors.white),),color: Colors.green,)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }):Center(child: Text("No Items found in Cart", style: TextStyle(color: Colors.red,fontSize: 20),),),
    );
  }

}