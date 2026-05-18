import 'package:supabase_flutter/supabase_flutter.dart';

class BaseSupabaseCrud {

  final SupabaseClient _client =
      Supabase.instance.client;

  final String table;

  BaseSupabaseCrud(this.table);

  /// CREATE
  Future<dynamic> insert(
    Map<String, dynamic> data,
  ) async {

    return await _client
        .from(table)
        .insert(data)
        .select();
  }

  /// READ ALL
  Future<List<dynamic>> getAll() async {

    return await _client
        .from(table)
        .select();
  }

  /// READ BY ID
  Future<dynamic> getById(
    dynamic id,
  ) async {

    return await _client
        .from(table)
        .select()
        .eq('id', id)
        .single();
  }

  /// UPDATE
  Future<dynamic> update(
    dynamic id,
    Map<String, dynamic> data,
  ) async {

    return await _client
        .from(table)
        .update(data)
        .eq('id', id)
        .select();
  }

  /// DELETE
  Future<void> delete(
    dynamic id,
  ) async {

    await _client
        .from(table)
        .delete()
        .eq('id', id);
  }
}