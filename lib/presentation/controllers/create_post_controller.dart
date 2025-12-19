import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/nook_model.dart';
import '../../data/repositories/api_repository.dart';
import '../../core/utils/image_helper.dart';
import '../../core/utils/validators.dart';

class CreatePostController extends GetxController {
  final ApiRepository _repository = ApiRepository();
  final ImagePicker _imagePicker = ImagePicker();

  final RxList<NookModel> nooks = <NookModel>[].obs;
  final RxString selectedNookId = ''.obs;
  final RxString title = ''.obs;
  final RxString content = ''.obs;
  final RxString alias = ''.obs;
  final RxList<File> selectedImages = <File>[].obs;
  final RxBool isUploading = false.obs;
  final RxBool isSubmitting = false.obs;
  final RxString errorMessage = ''.obs;

  String? preFilledNookId;

  @override
  void onInit() {
    super.onInit();
    preFilledNookId = Get.parameters['nookId'];
    fetchNooks();
    if (preFilledNookId != null) {
      selectedNookId.value = preFilledNookId!;
    }
  }

  Future<void> fetchNooks() async {
    try {
      final fetchedNooks = await _repository.getAllNooks();
      nooks.value = fetchedNooks;
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage();
      if (images.isNotEmpty) {
        selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  bool canSubmit() {
    return Validators.canSubmitPost(
      title: title.value,
      attachments: selectedImages,
    );
  }

  Future<void> submitPost() async {
    if (!canSubmit()) {
      Get.snackbar(
        'Error',
        'Either title or images are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (selectedNookId.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a nook',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isSubmitting.value = true;
      errorMessage.value = '';

      List<Map<String, dynamic>> attachments = [];

      if (selectedImages.isNotEmpty) {
        isUploading.value = true;
        final uploadedFilenames = await ImageHelper.uploadMultipleImages(
          selectedImages,
        );
        isUploading.value = false;

        attachments = uploadedFilenames.map((filename) {
          final extension = filename.split('.').last.toLowerCase();
          return {
            'type': 'image',
            'format': extension,
            'content': filename,
          };
        }).toList();
      }

      await _repository.createPost(
        title: title.value,
        content: content.value.isNotEmpty ? content.value : null,
        nookId: selectedNookId.value,
        attachments: attachments.isNotEmpty ? attachments : null,
        alias: alias.value.isNotEmpty ? alias.value : null,
      );

      isSubmitting.value = false;

      Get.back();
      Get.snackbar(
        'Success',
        'Post created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      isSubmitting.value = false;
      isUploading.value = false;
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create post: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

