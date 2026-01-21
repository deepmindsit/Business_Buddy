import 'package:businessbuddy/utils/exported_path.dart';

class ExploreFilter extends StatefulWidget {
  const ExploreFilter({super.key});

  @override
  State<ExploreFilter> createState() => _ExploreFilterState();
}

class _ExploreFilterState extends State<ExploreFilter> {
  final _explorerController = getIt<ExplorerController>();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      maxChildSize: 0.85.h,
      minChildSize: 0.5.h,
      builder: (_, scroll) {
        return SafeArea(child: _buildMainContent(scroll));
      },
    );
  }

  Widget _buildMainContent(ScrollController scroll) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDragHandle(),
          _buildTitle(),
          const SizedBox(height: 16),
          _buildFilterContent(scroll),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 5.h,
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Filters",
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: primaryBlack,
      ),
    );
  }

  Widget _buildFilterContent(ScrollController scroll) {
    return Expanded(
      child: SingleChildScrollView(
        controller: scroll,
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(),
            _buildLocationSearch(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextFormField(
      controller: _explorerController.searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        focusedBorder: buildOutlineInputBorder(),
        enabledBorder: buildOutlineInputBorder(),
        contentPadding: EdgeInsets.all(15),
        suffixIcon: Obx(
          () => _explorerController.searchText.value.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _explorerController.searchController.clear();
                    // _explorerController.businessList.value = [];
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : Icon(Icons.search, color: mainTextGrey),
        ),
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

  Widget _buildLocationSearch() {
    return LocationSearchField(
      controller: _explorerController.addressController,
      results: _explorerController.addressList,
      onSearch: (query) => getPlaces(query),
      onSelected: (place) {
        _explorerController.addressController.text = place['description'];
        _explorerController.lat.value = place['lat'];
        _explorerController.lng.value = place['lng'];
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              _explorerController.addressController.clear();
              _explorerController.addressList.value = [];
              _explorerController.lat.value = '';
              _explorerController.lng.value = '';
              Get.back();
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.red),
            ),
            child: Text("Reset", style: TextStyle(color: Colors.red)),
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              surfaceTintColor: Colors.white,
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text("Apply", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  // CUSTOM UI COMPONENTS
  Widget dropList(
    List items,
    String? selected,
    Function(String) onSelect,
    String title,
    bool isDynamic,
  ) {
    return AppDropdownField(
      isDynamic: isDynamic,
      title: title,
      value: selected,
      items: items,
      hintText: 'Select your $title',
      validator: (value) => value == null ? 'Please select $title' : null,
      onChanged: (v) => onSelect(v!),
    );
  }

  BoxDecoration get box => BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(10.r),
    border: Border.all(color: Colors.grey, width: 0.2),
  );
}
