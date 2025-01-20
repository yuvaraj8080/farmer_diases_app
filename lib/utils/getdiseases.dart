
import '../models/diseasemodel.dart';
import 'datagenerator.dart';

List<DiseasesModel> diseaseList = []; // Initialize the list

Future<void> fetchList() async {
  diseaseList = await getDiseases(); // Ensure getDiseases() returns a Future
}