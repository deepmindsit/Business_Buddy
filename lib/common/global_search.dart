import 'package:businessbuddy/utils/exported_path.dart';

class GlobalSearch extends StatefulWidget {
  const GlobalSearch({super.key});

  @override
  State<GlobalSearch> createState() => _GlobalSearchState();
}

class _GlobalSearchState extends State<GlobalSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarPlain(title: "Search"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: Column(children: [_buildSearchField(), _buildCategorySection()]),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: TextEditingController(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        contentPadding: EdgeInsets.all(15),
        suffixIcon: Icon(Icons.search, color: Colors.grey),
        prefixIconConstraints: BoxConstraints(maxWidth: Get.width * 0.1),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(Images.appIcon, width: 30, height: 30),
        ),
        hintText: 'Search Offer, Interest, etc.',
        hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey.shade500),
      ),
    );
  }

  Widget _buildCategorySection() {
    return SectionContainer(
      title: 'Categories',
      actionText: 'View More',
      onActionTap: () {},
      child: Container(),
      // Obx(
      //       () => _homeController.isLoading.isTrue
      //       ? buildCategoryLoader()
      //       : GridView.builder(
      //     padding: EdgeInsets.only(top: 8.h, left: 8.w, right: 8.w),
      //     shrinkWrap: true,
      //     physics: const NeverScrollableScrollPhysics(),
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //       crossAxisCount: 4,
      //       crossAxisSpacing: 12.w,
      //       mainAxisSpacing: 0.h,
      //       childAspectRatio: 0.7,
      //     ),
      //     itemCount: _homeController.categoryList.length,
      //     itemBuilder: (context, index) {
      //       final category = _homeController.categoryList[index];
      //       return GestureDetector(
      //         onTap: () {
      //           _navigationController.openSubPage(
      //             CategoryList(
      //               categoryId: category['id'].toString(),
      //               categoryName: category['name'].toString(),
      //             ),
      //           );
      //         },
      //         child: CategoryCard(
      //           image: category['image'].toString(),
      //           name: category['name'].toString(),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;
  final Widget child;

  const SectionContainer({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: buildHeadingWithButton(
            title: title,
            rightText: actionText,
            onTap: onActionTap,
          ),
        ),
        child,
      ],
    );
  }
}
