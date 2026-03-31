import 'dart:io';
import "package:path/path.dart" show dirname, join, normalize;
import '../lib/json_to_dart.dart';

String _scriptPath() {
  var script = Platform.script.toString();
  if (script.startsWith("file://")) {
    script = script.substring(7);
  } else {
    final idx = script.indexOf("file:/");
    script = script.substring(idx + 5);
  }
  return script;
}

main() {
  //final business = new ModelGenerator('Business').generateDartClasses(new File("model_jsons/business.json").readAsStringSync());
  //final currentDirectory = dirname(_scriptPath());
  //final filePath = normalize(join(currentDirectory, 'sample.json'));
  //final jsonRawData = new File("sample.json").readAsStringSync();
  //business
 // DartCode dartCode = business.generateDartClasses(new File("model_jsons/business.json").readAsStringSync());
  new File('models/business.dart').writeAsString( new ModelGenerator('Business').generateDartClasses(new File("model_jsons/business.json").readAsStringSync()).code);
  //Course
  new File('models/course.dart').writeAsString( new ModelGenerator('Course').generateDartClasses(new File("model_jsons/course.json").readAsStringSync()).code);
     //instructor
   new File('models/instructor.dart').writeAsString( new ModelGenerator('Instructor').generateDartClasses(new File("model_jsons/instructor.json").readAsStringSync()).code);
    //lesson
   new File('models/lesson.dart').writeAsString( new ModelGenerator('Lesson').generateDartClasses(new File("model_jsons/lesson.json").readAsStringSync()).code);
     //module
   new File('models/module.dart').writeAsString( new ModelGenerator('Module').generateDartClasses(new File("model_jsons/module.json").readAsStringSync()).code);
    //userModule
  new File('models/userModule.dart').writeAsString( new ModelGenerator('UserModule').generateDartClasses(new File("model_jsons/user_module.json").readAsStringSync()).code);
    //user
  new File('models/user.dart').writeAsString( new ModelGenerator('User').generateDartClasses(new File("model_jsons/user.json").readAsStringSync()).code);
   //user_media
  new File('models/userMedia.dart').writeAsString( new ModelGenerator('UserMedia').generateDartClasses(new File("model_jsons/user_media.json").readAsStringSync()).code);
    //user_device
  new File('models/userDevice.dart').writeAsString( new ModelGenerator('UserDevice').generateDartClasses(new File("model_jsons/user_device.json").readAsStringSync()).code);
   //legal
  new File('models/legal.dart').writeAsString( new ModelGenerator('Legal').generateDartClasses(new File("model_jsons/legal.json").readAsStringSync()).code);
  //user_preferences
 // new File('models/userPreferences.dart').writeAsString( new ModelGenerator('UserPreferences').generateDartClasses(new File("model_jsons/user_preferance.json").readAsStringSync()).code);
  //invoice
  new File('models/invoice.dart').writeAsString( new ModelGenerator('Invoice').generateDartClasses(new File("model_jsons/invoice.json").readAsStringSync()).code);
  
  
 // print(dartCode.code);
}
