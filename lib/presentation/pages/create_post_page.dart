import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/create_post_controller.dart';
import '../../core/constants/app_constants.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreatePostController());

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Create Post',
          style: TextStyle(color: AppConstants.textPrimaryColor),
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        actions: [
          Obx(() => TextButton(
                onPressed: controller.canSubmit() && !controller.isSubmitting.value
                    ? controller.submitPost
                    : null,
                child: controller.isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppConstants.primaryColor,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Post',
                        style: TextStyle(color: AppConstants.primaryColor),
                      ),
              )),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.preFilledNookId == null) ...[
                  const Text(
                    'Select Nook',
                    style: TextStyle(
                      color: AppConstants.textPrimaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Obx(() => DropdownButtonFormField<String>(
                        value: controller.selectedNookId.value.isEmpty
                            ? null
                            : controller.selectedNookId.value,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppConstants.surfaceColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall,
                            ),
                            borderSide: const BorderSide(
                              color: AppConstants.primaryColor,
                            ),
                          ),
                        ),
                        dropdownColor: AppConstants.surfaceColor,
                        style: const TextStyle(
                          color: AppConstants.textPrimaryColor,
                        ),
                        items: controller.nooks.map((nook) {
                          return DropdownMenuItem<String>(
                            value: nook.id,
                            child: Text(nook.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedNookId.value = value;
                          }
                        },
                      )),
                  const SizedBox(height: AppConstants.spacingLarge),
                ],
                const Text(
                  'Title',
                  style: TextStyle(
                    color: AppConstants.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                TextField(
                  onChanged: (value) => controller.title.value = value,
                  style: const TextStyle(color: AppConstants.textPrimaryColor),
                  decoration: InputDecoration(
                    hintText: 'Enter post title',
                    hintStyle: const TextStyle(
                      color: AppConstants.textSecondaryColor,
                    ),
                    filled: true,
                    fillColor: AppConstants.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                      borderSide: const BorderSide(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                const Text(
                  'Content (Optional)',
                  style: TextStyle(
                    color: AppConstants.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                TextField(
                  onChanged: (value) => controller.content.value = value,
                  style: const TextStyle(color: AppConstants.textPrimaryColor),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter post content',
                    hintStyle: const TextStyle(
                      color: AppConstants.textSecondaryColor,
                    ),
                    filled: true,
                    fillColor: AppConstants.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                      borderSide: const BorderSide(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                const Text(
                  'Alias (Optional)',
                  style: TextStyle(
                    color: AppConstants.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                TextField(
                  onChanged: (value) => controller.alias.value = value,
                  style: const TextStyle(color: AppConstants.textPrimaryColor),
                  decoration: InputDecoration(
                    hintText: 'Enter alias (leave empty for anonymous)',
                    hintStyle: const TextStyle(
                      color: AppConstants.textSecondaryColor,
                    ),
                    filled: true,
                    fillColor: AppConstants.surfaceColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall,
                      ),
                      borderSide: const BorderSide(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.spacingLarge),
                const Text(
                  'Images (Optional)',
                  style: TextStyle(
                    color: AppConstants.textPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                ElevatedButton.icon(
                  onPressed: controller.pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text('Pick Images'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                if (controller.isUploading.value) ...[
                  const SizedBox(height: AppConstants.spacingMedium),
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ],
                if (controller.selectedImages.isNotEmpty) ...[
                  const SizedBox(height: AppConstants.spacingMedium),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: AppConstants.spacingSmall,
                      mainAxisSpacing: AppConstants.spacingSmall,
                    ),
                    itemCount: controller.selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusSmall,
                            ),
                            child: Image.file(
                              controller.selectedImages[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ],
            ),
          )),
    );
  }
}

