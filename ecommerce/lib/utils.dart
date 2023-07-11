import 'package:flutter/material.dart';


class Cart  {
  static List list=List.empty(growable: true);

  addCart(int pos)
  {
    list.add(pos);

  }

  List getList()
  {
    return list;

  }

  removeItem(index)
  {
    list.removeAt(index);

  }
}
