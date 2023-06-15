import 'dart:convert';

import 'package:amazy_app/model/CityList.dart';
import 'package:amazy_app/model/CountryList.dart';
import 'package:amazy_app/model/StateList.dart';
import 'package:amazy_app/network/config.dart';
import 'package:amazy_app/model/CustomerAddress.dart';
import 'package:amazy_app/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AddressController extends GetxController {
  // final CheckoutController checkoutController = Get.put(CheckoutController());
  var isLoading = false.obs;
  var address = CustomerAddress().obs;
  var tokenKey = 'token';
  GetStorage userToken = GetStorage();
  var addressCount = 0.obs;
  var billingAddress = Address().obs;
  var shippingAddress = Address().obs;

  Future<CustomerAddress> getAddress() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ADDRESS_LIST);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return CustomerAddress.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<CustomerAddress> getAllAddress() async {
    try {
      isLoading(true);
      var products = await getAddress();
        print("products : ${products}");
      if (products != null) {
        address.value = products;
        addressCount.value = products.addresses.length;
        print("length : ${addressCount.value}");
        billingAddress.value = products.addresses.where((element) => element.isBillingDefault == "1").single;
        shippingAddress.value = products.addresses.where((element) => element.isShippingDefault == "1").toList()[0];
        print("billingAddress.value : ${billingAddress.value}");
        // checkoutController.getCheckoutList();
      } else {
        address.value = CustomerAddress();
      }
      return products;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> setDefaultBilling(int id) async {
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.ADDRESS_SET_DEFAULT_BILLING);
    Map data = {
      "id": id.toString(),
    };
    var body = json.encode(data);
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    // var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await getAllAddress();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setDefaultShipping(int id) async {
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.ADDRESS_SET_DEFAULT_SHIPPING);
    Map data = {"id": id.toString(),
    };
    var body = json.encode(data);
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    // var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await getAllAddress();
      return true;
    } else {
      return false;
    }
  }

  RxBool selectAddress = false.obs;

  Rx<Country> selectedCountry = Country().obs;
  RxList<Country> countryList = <Country>[].obs;
  RxBool countryLoading = false.obs;

  Rx<AllState> selectedState = AllState().obs;
  RxList<AllState> statesList = <AllState>[].obs;
  RxBool stateLoading = false.obs;

  Rx<AllCity> selectedCity = AllCity().obs;
  RxList<AllCity> citiesList = <AllCity>[].obs;
  RxBool cityLoading = false.obs;

  Future getCountries() async {
    try {
      countryLoading(true);
      var response = await http.get(
        Uri.parse(URLs.COUNTRY),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = CountryList.fromJson(jsonString['countries']);

        countryList.value = data.countries;
        selectedCountry.value = countryList.first;

        countryLoading(false);

        await getStates(selectedCountry.value.id);
      } else {
        countryLoading(false);
        SnackBars().snackBarError("Error getting country");
      }
    } finally {
      countryLoading(false);
    }
  }

  Future getStates(countryId) async {
    try {
      stateLoading(true);
      var response = await http.get(
        Uri.parse(URLs.stateByCountry(countryId)),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = StateList.fromJson(jsonString['states']);
        statesList.value = data.states;
        selectedState.value = statesList.first;
        stateLoading(false);
        await getCities(selectedState.value.id);
      } else {
        stateLoading(false);
        SnackBars().snackBarError("Error getting cities");
      }
    } finally {
      stateLoading(false);
    }
  }

  Future getCities(stateId) async {
    try {
      cityLoading(true);
      var response = await http.get(
        Uri.parse(URLs.cityByState(stateId)),
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'success') {
        final data = CityList.fromJson(jsonString['cities']);
        citiesList.value = data.cities;
        selectedCity.value = citiesList.first;
        cityLoading(false);
      } else {
        cityLoading(false);
      }
    } finally {
      cityLoading(false);
    }
  }

  Future<bool> addAddress(Map data) async {
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.ADD_ADDRESS);

    var body = json.encode(data);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    if (response.statusCode == 201) {
      return true;
    } else {
      if (response.statusCode == 401) {
        SnackBars()
            .snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  @override
  void onInit() {
    getAllAddress();
    getCountries();
    super.onInit();
  }
}
