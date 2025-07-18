import 'dart:io';

void main() {
  final directory = Directory('lib');
  final outputFile = File('lib_structure.txt');
  final buffer = StringBuffer();

  void traverse(Directory dir, String indent) {
    final entries = dir.listSync();
    for (final entity in entries) {
      if (entity is Directory) {
        buffer.writeln('$indent📁 ${entity.path.split('/').last}');
        traverse(entity, '$indent  ');
      } else if (entity is File && entity.path.endsWith('.dart')) {
        buffer.writeln('$indent📄 ${entity.path.split('/').last}');
      }
    }
  }

  if (directory.existsSync()) {
    buffer.writeln('lib/');
    traverse(directory, '  ');
    outputFile.writeAsStringSync(buffer.toString());
    print('✅ Structure written to lib_structure.txt');
  } else {
    print('❌ lib/ directory not found.');
  }
}
