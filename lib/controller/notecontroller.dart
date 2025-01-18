import 'package:get/get.dart';
import 'package:mercury/model/note.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotesController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final RxList<Note> notes = <Note>[].obs;

  // Cria uma nova nota
  Future<void> createNote(Note note) async {
    final response = await _supabase.from('notes').insert(note.toJson());
    if (response.error != null) {
      throw Exception('Erro ao criar nota: ${response.error!.message}');
    }
    notes.add(note);
  }

  // Edita uma nota existente
  Future<void> updateNote(String id, Note updatedNote) async {
    final response = await _supabase
        .from('notes')
        .update(updatedNote.toJson())
        .eq('id', id);
    if (response.error != null) {
      throw Exception('Erro ao atualizar nota: ${response.error!.message}');
    }

    final index = notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      notes[index] = updatedNote;
    }
  }

  // Busca uma nota por shortId
  Future<Note?> fetchNoteByShortId(String shortId) async {
    final response = await _supabase
        .from('notes')
        .select()
        .eq('short_id', shortId)
        .single();
    if (response.error != null) {
      throw Exception('Erro ao buscar nota: ${response.error!.message}');
    }

    if (response.data == null) {
      return null; // Nota não encontrada
    }

    return Note.fromJson(response.data);
  }
}