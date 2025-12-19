import 'package:get/get.dart';
import '../../data/models/nook_model.dart';
import '../../data/models/post_model.dart';
import '../../data/repositories/api_repository.dart';

class NookDetailController extends GetxController {
  final ApiRepository _repository = ApiRepository();

  final Rx<NookModel?> nook = Rx<NookModel?>(null);
  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingNook = false.obs;
  final RxString errorMessage = ''.obs;

  String? nookId;

  @override
  void onInit() {
    super.onInit();
    nookId = Get.parameters['id'];
    if (nookId != null) {
      fetchNookDetail();
      fetchPosts();
    }
  }

  Future<void> fetchNookDetail() async {
    if (nookId == null) return;

    try {
      isLoadingNook.value = true;
      errorMessage.value = '';
      final fetchedNook = await _repository.getNookById(nookId!);
      nook.value = fetchedNook;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load nook: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingNook.value = false;
    }
  }

  Future<void> fetchPosts() async {
    if (nookId == null) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedPosts = await _repository.getPostsByNookId(nookId!);
      posts.value = fetchedPosts;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load posts: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshPosts() async {
    await fetchPosts();
  }
}

