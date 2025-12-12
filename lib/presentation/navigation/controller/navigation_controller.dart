import '../../../utils/exported_path.dart';

@lazySingleton
class NavigationController extends GetxController {
  final currentIndex = 0.obs;
  final topTabIndex = 1.obs; // default Explorer
  final isTopTabSelected = false.obs;
  final RxBool isSubPageOpen = false.obs;

  // 🔹 Stack of pages
  final RxList<Widget> _pageStack = <Widget>[const HomeScreen()].obs;

  // 🔹 Public getter
  List<Widget> get pageStack => _pageStack;



  static final List<Widget> widgetOptions = <Widget>[
    const HomeScreen(),
    const InboxList(),
    const BusinessPartner(),
    const SpecialOffer(),
  ];

  // 🔹 Bottom nav handling
  void updateBottomIndex(int index) {
    currentIndex.value = index;
    isTopTabSelected.value = false;
    isSubPageOpen.value = false;
    _pageStack.clear();

    switch (index) {
      case 0:
        _pageStack.add(const HomeScreen());
        // topTabIndex.value = 1;
        // isTopTabSelected.value = true;
        break;
      case 1:
        _pageStack.add(const InboxList());
        break;
      case 2:
        _pageStack.add(const BusinessPartner());
        break;
      case 3:
        _pageStack.add(const SpecialOffer());
        break;
    }
  }

  // 🔹 Top tab selection
  void updateTopTab(int index) {
    topTabIndex.value = index;
    isTopTabSelected.value = true;
    isSubPageOpen.value = false;

    switch (index) {
      case 0:
        _pageStack
          ..clear()
          ..add(const Explorer());
        break;
      case 1:
        _pageStack
          ..clear()
          ..add(const NewFeed());
        break;
      case 2:
        _pageStack
          ..clear()
          ..add(const LboScreen());
        break;
    }
  }

  // 🔹 Open any subpage (like chat detail)
  void openSubPage(Widget page) {
    isSubPageOpen.value = true;
    _pageStack.add(page);
  }

  // 🔹 Go back to previous screen
  void goBack() {
    if (_pageStack.length > 1) {
      _pageStack.removeLast();
      if (_pageStack.length == 1) {
        isSubPageOpen.value = false;
      }
    } else {
      Get.back();
    }
  }

  // 🔹 Back to home tab (Explorer)
  void backToHome() {
    _pageStack
      ..clear()
      ..add(const NewFeed());
    isSubPageOpen.value = false;
    topTabIndex.value = 1; // default Explorer
    isTopTabSelected.value = true;
  }
}
