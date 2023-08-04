import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant/domain/bloc/blocs.dart';
import 'package:restaurant/presentation/components/components.dart';
import 'package:restaurant/presentation/helpers/helpers.dart';
import 'package:restaurant/presentation/screens/admin/admin_home_screen.dart';
import 'package:restaurant/presentation/themes/colors_frave.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../domain/services/pincode_services.dart';

class AddNewDeliveryPartnerScreen extends StatefulWidget {



  @override
  _AddNewDeliveryPartnerScreenState createState() => _AddNewDeliveryPartnerScreenState();
}


class _AddNewDeliveryPartnerScreenState extends State<AddNewDeliveryPartnerScreen> {

  late TextEditingController _nameController;
  late TextEditingController _lastnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;


  List<String> states = []; // To store the list of states fetched from the backend.
  List<String> districts = []; // To store the list of districts fetched from the backend.
  Map<String, List<String>> taluksMap = {}; // To store taluks mapped to districts fetched from the backend.
  Map<String, List<MultiSelectItem<String>>> pincodesMap = {}; // To store pincodes mapped to taluks fetched from the backend.



  String selectedState = '';
  String selectedDistrict = '';
  String selectedTaluk = '';
  List<String> selectedPincodes = [];

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();


    fetchStates();

  }

  Future<void> fetchStates() async {
    try {
      List<String> fetchedStates = await pincodeServices.fetchStates();
      print('Fetched States: $fetchedStates');
      setState(() {
        states = fetchedStates;
        selectedState = states.isNotEmpty ? states[0] : '';
        selectedDistrict = '';
        selectedTaluk = '';
        selectedPincodes.clear();
      });
    } catch (e) {
      print('Error fetching states: $e');
    }
  }


  Future<void> fetchDistrictsForSelectedState(String selectedState) async {
    try {
      List<String> fetchedDistricts = await pincodeServices.fetchDistricts(selectedState);
      setState(() {
        districts = fetchedDistricts;
        selectedDistrict = districts.isNotEmpty ? districts[0] : '';
        selectedTaluk = '';
        selectedPincodes.clear();
      });
    } catch (e) {
      // Handle the error here
    }
  }

  Future<void> fetchTaluksForSelectedDistrict(String selectedDistrict) async {
    try {
      List<String> fetchedTaluks = await pincodeServices.fetchTaluks(selectedDistrict);
      setState(() {
        taluksMap[selectedDistrict] = fetchedTaluks;
        selectedTaluk = taluksMap[selectedDistrict]!.isNotEmpty ? taluksMap[selectedDistrict]![0] : '';
        selectedPincodes.clear();
      });
    } catch (e) {
      // Handle the error here
    }
  }

  Future<void> fetchPincodesForSelectedTaluk(String selectedTaluk) async {
    try {
      List<String> fetchedPincodes = await pincodeServices.fetchPincodesForSelectedTaluk(selectedTaluk);
      setState(() {
        pincodesMap[selectedTaluk] = fetchedPincodes
            .map((pincode) => MultiSelectItem(pincode, pincode))
            .toList();
        selectedPincodes.clear();
      });
    } catch (e) {
      // Handle the error here
    }
  }

  @override
  void dispose() {
    clearTextEditingController();
    _nameController.dispose();
    _lastnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearTextEditingController(){
    _nameController.clear();
    _lastnameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if( state is LoadingUserState ){
          modalLoading(context);
        }
        if(state is SuccessUserState ){

          Navigator.pop(context);
          modalSuccess(context, 'Delivery Partner Successfully Registered',
                  () => Navigator.pushAndRemoveUntil(context, routeFrave(page: AdminHomeScreen()), (route) => false));
          userBloc.add( OnClearPicturePathEvent());
        }
        if( state is FailureUserState ){
          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const TextCustom(text: 'Add New Delivery Partner'),
          centerTitle: true,
          leadingWidth: 80,
          leading: TextButton(
            child: const TextCustom(text: 'Cancel', color: ColorsFrave.primaryColor, fontSize: 17 ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  if( _keyForm.currentState!.validate() ){
                    userBloc.add( OnRegisterDeliveryEvent(
                        _nameController.text,
                        _lastnameController.text,
                        _phoneController.text,
                        _emailController.text,
                        _passwordController.text,
                        userBloc.state.pictureProfilePath
                    ));

                  }
                },
                child: const TextCustom(text: ' Save ', color: ColorsFrave.primaryColor )
            )
          ],
        ),
        body: Form(
          key: _keyForm,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            children: [
              const SizedBox(height: 20.0),
              Align(
                  alignment: Alignment.center,
                  child: _PictureRegistre()
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Name'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                hintText: 'name',
                controller: _nameController,
                validator: RequiredValidator(errorText: 'Name is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Lastname'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _lastnameController,
                hintText: 'lastname',
                validator: RequiredValidator(errorText: 'Lastname is required'),
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Phone'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _phoneController,
                hintText: '---.---.---',
                keyboardType: TextInputType.number,
                validator: RequiredValidator(errorText: 'Lastname is required'),
              ),
              const SizedBox(height: 15.0),
              const TextCustom(text: 'Email'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                  controller: _emailController,
                  hintText: 'email@frave.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: validatedEmail
              ),

                    //selecting pin code
              const SizedBox(height: 20.0),
              const TextCustom(text: 'State'),
              const SizedBox(height: 5.0),
              DropdownButtonFormField<String>(
                value: selectedState,
                onChanged: (value) async {
                  setState(() {
                    selectedState = value!;
                    selectedDistrict = '';
                    selectedTaluk = '';
                    selectedPincodes.clear();
                  });
                  await fetchDistrictsForSelectedState(selectedState);
                },
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a state';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'District'),
              const SizedBox(height: 5.0),
              DropdownButtonFormField<String>(
                value: selectedDistrict,
                onChanged: (value) async {
                  setState(() {
                    selectedDistrict = value!;
                    selectedTaluk = '';
                    selectedPincodes.clear();
                  });
                  await fetchTaluksForSelectedDistrict(selectedDistrict);
                },
                items: districts.map((district) {
                  return DropdownMenuItem<String>(
                    value: district,
                    child: Text(district),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a district';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Taluk'),
              const SizedBox(height: 5.0),
              DropdownButtonFormField<String>(
                value: selectedTaluk,
                onChanged: (value) {
                  setState(() {
                    selectedTaluk = value!;
                    selectedPincodes.clear();
                  });
                },
                items: _getTaluksForSelectedDistrict(selectedDistrict ).map((taluk) {
                  return DropdownMenuItem<String>(
                    value: taluk,
                    child: Text(taluk),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a taluk';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              const TextCustom(text: 'Pincodes'),
              const SizedBox(height: 5.0),
              // Step 2: Create a multi-select dropdown for pincodes.
              MultiSelectDialogField<String>(
                items: _getPincodesForSelectedTaluk(),
                listType: MultiSelectListType.CHIP,
                initialValue: selectedPincodes,
                title: const Text('Pincodes'),
                cancelText: Text('CANCEL'),
                confirmText: Text('OK'),
                searchable: true,
                selectedColor: Colors.blue,
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(() {
                      selectedPincodes.remove(value);
                    });
                  },
                ),
                onConfirm: (values) {
                  setState(() {
                    selectedPincodes = List<String>.from(values);
                  });
                },
                validator: (values) {
                  if (values == null || values.isEmpty) {
                    return 'Please select at least one pincode';
                  }
                  return null;
                },
              ),




              const SizedBox(height: 15.0),
              const TextCustom(text: 'Password'),
              const SizedBox(height: 5.0),
              FormFieldFrave(
                controller: _passwordController,
                hintText: '********',
                isPassword: true,
                validator: passwordValidator,
              ),
            ],
          ),
        ),
      ),
    );
  }





  List<String> _getTaluksForSelectedDistrict(String selectedDistrict) {
    return taluksMap[selectedDistrict] ?? [];
  }

  List<MultiSelectItem<String>> _getPincodesForSelectedTaluk() {
    return pincodesMap[selectedTaluk] ?? [];
  }



}

class _PictureRegistre extends StatelessWidget {

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.solid, color: Colors.grey[300]!),
          shape: BoxShape.circle
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () => modalPictureRegister(
            ctx: context,
            onPressedChange: () async {

              Navigator.pop(context);
              final XFile? imagePath = await _picker.pickImage(source: ImageSource.gallery);
              if( imagePath != null ) userBloc.add( OnSelectPictureEvent(imagePath.path));

            },
            onPressedTake: () async {

              Navigator.pop(context);
              final XFile? photoPath = await _picker.pickImage(source: ImageSource.camera);
              userBloc.add( OnSelectPictureEvent(photoPath!.path));

            }
        ),
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state)
          => state.pictureProfilePath == ''
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.wallpaper_rounded, size: 60, color: ColorsFrave.primaryColor ),
              SizedBox(height: 10.0),
              TextCustom(text: 'Picture', color: Colors.black45 )
            ],
          )
              : Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(File(state.pictureProfilePath))
                )
            ),
          ),
        ),

      ),
    );
  }
}