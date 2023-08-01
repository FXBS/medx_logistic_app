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

  List<String> states = ['State A', 'State B', 'State C']; // Replace with actual state data.
  List<String> districts = ['District X', 'District Y', 'District Z']; // Replace with actual district data.
  List<String> selectedPincodes = [];

  String selectedState = '';
  String selectedDistrict = '';

  final _keyForm = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastnameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
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
          modalSuccess(context, 'Delivery Successfully Registered',
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
                onChanged: (value) {
                  setState(() {
                    selectedState = value!;
                    selectedDistrict = '';
                    selectedPincodes.clear();
                  });
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
                onChanged: (value) {
                  setState(() {
                    selectedDistrict = value!;
                    selectedPincodes.clear();
                  });
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
              const TextCustom(text: 'Pincodes'),
              const SizedBox(height: 5.0),
              // Step 2: Create a multi-select dropdown for pincodes.
              MultiSelectFormField(
                dataSource: _getPincodesForSelectedDistrict(), // Implement this function to get the pincodes based on the selected district.
                textField: 'pincode',
                valueField: 'pincode',
                okButtonLabel: 'OK',
                cancelButtonLabel: 'CANCEL',
                hintText: 'Select pincodes',
                initialValue: selectedPincodes,
                onSaved: (value) {
                  if (value != null) {
                    setState(() {
                      selectedPincodes = value.cast<String>();
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
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

  List<Map<String, dynamic>> _getPincodesForSelectedDistrict() {
    // Implement this function to get pincodes based on the selected district.
    // For example, you can use a map or a database to store the pincodes for each district.
    // Return a list of maps, each containing the 'pincode' as the key and the pincode value.
    // For example: return [{'pincode': '123456'}, {'pincode': '789012'}, ...];
    return [{'pincode': '123456'}, {'pincode': '789012'},];
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