import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService {

final supabase = Supabase.instance.client;


  Future<dynamic> getAllProducts() async {

    
    
    final products = await supabase.from('products').select();
    
    return products;

  }



}