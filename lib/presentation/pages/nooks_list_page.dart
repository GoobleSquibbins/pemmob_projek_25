import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/nooks_list_controller.dart';
import '../widgets/nook_card.dart';
import '../../core/constants/app_constants.dart';

class NooksListPage extends StatelessWidget {
  const NooksListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NooksListController());

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Nooks',
          style: TextStyle(color: AppConstants.textPrimaryColor),
        ),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.nooks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppConstants.primaryColor,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.nooks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(
                    color: AppConstants.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingMedium),
                ElevatedButton(
                  onPressed: controller.fetchNooks,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (controller.nooks.isEmpty) {
          return const Center(
            child: Text(
              'No nooks available',
              style: TextStyle(color: AppConstants.textSecondaryColor),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNooks,
          color: AppConstants.primaryColor,
          child: GridView.builder(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppConstants.spacingMedium,
              mainAxisSpacing: AppConstants.spacingMedium,
              childAspectRatio: 0.8,
            ),
            itemCount: controller.nooks.length,
            itemBuilder: (context, index) {
              final nook = controller.nooks[index];
              return NookCard(
                nook: nook,
                onTap: () {
                  Get.toNamed('/nooks/${nook.id}');
                },
              );
            },
          ),
        );
      }),
    );
  }
}

