import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDataService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Fetch all rows from a table
  Future<List<Map<String, dynamic>>> fetchAll(String table) async {
   try{
    return await _client.from(table).select();
    
   }catch(e){
     throw Exception('Failed to fetch data: ${e.toString()}');

   }
    
  }

  /// Fetch a single row by primary key (id)
  Future<Map<String, dynamic>?> fetchById(String table, dynamic id) async {
    try{
      return await _client.from(table).select().eq('id', id).single();
  
    }catch(e){
      throw e;
    }    
  }

  /// Insert a new row
  Future<Map<String, dynamic>?> insert(String table, Map<String, dynamic> values) async {
    return await _client.from(table).insert(values).single();
    
  }

  /// Update a row by primary key (id)
  Future<Map<String, dynamic>?> update(String table, dynamic id, Map<String, dynamic> values) async {
    return await _client.from(table).update(values).eq('id', id).single();
   
  }

  /// Delete a row by primary key (id)
  Future<void> delete(String table, dynamic id) async {
    await _client.from(table).delete().eq('id', id);
    return;
  }
}
