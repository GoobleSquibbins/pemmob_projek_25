import 'package:get/get.dart';
import '../../data/models/nook_model.dart';
import '../../data/repositories/api_repository.dart';

class NooksListController extends GetxController {
  final ApiRepository _repository = ApiRepository();

  final RxList<NookModel> nooks = <NookModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNooks();
  }

  Future<void> fetchNooks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedNooks = await _repository.getAllNooks();
      nooks.value = fetchedNooks;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load nooks: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNooks() async {
    await fetchNooks();
  }
}

