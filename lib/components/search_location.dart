import 'package:businessbuddy/utils/exported_path.dart';

class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final controller = getIt<SearchNewController>();

  @override
  void initState() {
    controller.addressList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 8),
          width: 40.w,
          height: 4.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            minLines: 1,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            controller: controller.addressController,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffixIcon: controller.address.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        controller.addressController.clear();
                      },
                      child: const Icon(Icons.close, size: 20),
                    )
                  : const Icon(Icons.search),
              prefixIcon: Icon(Icons.search, color: mainTextGrey),
              labelText: 'Search for your location',
              labelStyle: TextStyle(color: mainTextGrey),
              contentPadding: const EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: lightGrey),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: lightGrey),
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                value!.isEmpty ? 'Please search your location' : null,
            onChanged: (str) {
              getPlaces(controller.addressController.text.trim()).then((data) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  controller.addressList.value = data;
                });
              });
            },
          ),
        ),

        GestureDetector(
          onTap: () {
            controller.getLiveLocation();
            Navigator.of(context).pop(); // Close after selection
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: lightGrey),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.my_location_outlined,
                    color: primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Use current location',
                    style: TextStyle(color: primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
        Obx(
          () => controller.addressList.isNotEmpty
              ? ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (_, index) =>
                      const Divider(endIndent: 20, indent: 20),
                  itemCount: controller.addressList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.location_on_outlined),
                      title: Text(
                        controller.addressList[index]['description'] ?? '',
                      ),
                      onTap: () {
                        final searchPlace = controller.addressList[index];
                        controller.addressController.text =
                            searchPlace['description'];
                        controller.address.value = searchPlace['description'];
                        // Get.find<HomeControllerC>().area.value =
                        //     searchPlace['area'];
                        // Get.find<HomeControllerC>().city.value =
                        //     searchPlace['city'];
                        // Get.find<HomeControllerC>().state.value =
                        //     searchPlace['state'];
                        // Get.find<HomeControllerC>().country.value =
                        //     searchPlace['country'];
                        // controller.lat.value = searchPlace['lat'];
                        // controller.lng.value = searchPlace['lng'];

                        print('searchPlace');
                        print(searchPlace['description']);
                        print(searchPlace['lat']);
                        print(searchPlace['lng']);
                        controller.addressList.value = [];
                        Get.back();
                      },
                    );
                  },
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
