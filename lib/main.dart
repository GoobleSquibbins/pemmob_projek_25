import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_constants.dart';
import 'routes/app_routes.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/nooks_list_page.dart';
import 'presentation/pages/nook_detail_page.dart';
import 'presentation/pages/post_detail_page.dart';
import 'presentation/pages/create_post_page.dart';

void main() {
  runApp(const FesnukApp());
}

class FesnukApp extends StatelessWidget {
  const FesnukApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Fesnuk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: AppConstants.primaryColor,
        scaffoldBackgroundColor: AppConstants.backgroundColor,
        cardColor: AppConstants.surfaceColor,
        colorScheme: const ColorScheme.dark(
          primary: AppConstants.primaryColor,
          surface: AppConstants.surfaceColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppConstants.backgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: AppConstants.textPrimaryColor),
          titleTextStyle: TextStyle(
            color: AppConstants.textPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppConstants.surfaceColor,
          selectedItemColor: AppConstants.primaryColor,
          unselectedItemColor: AppConstants.textSecondaryColor,
        ),
      ),
      initialRoute: AppRoutes.home,
      getPages: [
        GetPage(
          name: AppRoutes.home,
          page: () => const MainNavigationWrapper(initialIndex: 0),
        ),
        GetPage(
          name: AppRoutes.nooksList,
          page: () => const MainNavigationWrapper(initialIndex: 1),
        ),
        GetPage(
          name: AppRoutes.nookDetail,
          page: () => const NookDetailPage(),
        ),
        GetPage(
          name: AppRoutes.postDetail,
          page: () => const PostDetailPage(),
        ),
        GetPage(
          name: AppRoutes.createPost,
          page: () => const CreatePostPage(),
        ),
      ],
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  final int initialIndex;

  const MainNavigationWrapper({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Get.offNamed(AppRoutes.home);
    } else if (index == 1) {
      Get.offNamed(AppRoutes.nooksList);
    } else if (index == 2) {
      Get.toNamed(AppRoutes.createPost);
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomePage(),
          NooksListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Nooks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Create',
          ),
        ],
      ),
    );
  }
}
