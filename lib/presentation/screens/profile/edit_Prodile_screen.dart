import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:restaurant/domain/bloc/blocs.dart';
import 'package:restaurant/presentation/components/components.dart';
import 'package:restaurant/presentation/helpers/helpers.dart';
import 'package:restaurant/presentation/themes/colors_frave.dart';

class EditProfileScreen extends StatefulWidget {

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}


class _EditProfileScreenState extends State<EditProfileScreen> {

  late TextEditingController _nameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  final _keyForm = GlobalKey<FormState>();

  Future<void> getPersonalInformation() async {

    final userBloc = BlocProvider.of<UserBloc>(context).state.user!;

      _nameController = TextEditingController(text: userBloc.firstName);
      _lastNameController = TextEditingController(text: userBloc.lastName);
      _phoneController = TextEditingController(text: userBloc.phone);
      _emailController = TextEditingController(text: userBloc.email);


  }


  @override
  void initState() {
    super.initState();    
    getPersonalInformation();
  }

  @override
  void dispose() { 
    _nameController.clear();
    _lastNameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final userBloc = BlocProvider.of<UserBloc>(context);

    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        
        if( state is LoadingUserState ){
           
           modalLoading(context);
        
        } else if ( state is SuccessUserState ){

          Navigator.pop(context);         
          modalSuccess(context, 'User updated', () => Navigator.pop(context));
        
        } else if ( state is FailureUserState ){

          Navigator.pop(context);
          errorMessageSnack(context, state.error);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 80,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Row(
              children: const [
                SizedBox(width: 10.0),
                Icon(Icons.arrow_back_ios_new_rounded, color: ColorsFrave.primaryColor, size: 17),
                TextCustom(text: 'Back', fontSize: 17, color: ColorsFrave.primaryColor )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                if( _keyForm.currentState!.validate()){
                  userBloc.add( OnEditUserEvent( _nameController.text, _lastNameController.text, _phoneController.text ));
                }
              }, 
              child: TextCustom(text: 'Update account', fontSize: 16, color: Colors.amber[900]!)
            )
          ],
        ),
        body: SafeArea(
          child: Form(
            key: _keyForm,
            child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              children: [
                const TextCustom(text: 'Name', color: ColorsFrave.secundaryColor),
                const SizedBox(height: 5.0),
                FormFieldFrave(
                  controller: _nameController,
                  validator: RequiredValidator(errorText: 'Name is required')
                ),
                const SizedBox(height: 20.0),
                const TextCustom(text: 'Lastname', color: ColorsFrave.secundaryColor),
                const SizedBox(height: 5.0),
                FormFieldFrave(
                  controller: _lastNameController,
                  hintText: 'lastname',
                  validator: RequiredValidator(errorText: 'Lastname is required'),
                ),
                const SizedBox(height: 20.0),
                const TextCustom(text: 'Phone', color: ColorsFrave.secundaryColor),
                const SizedBox(height: 5.0),
                FormFieldFrave(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  hintText: '000-000-000',
                  validator: validatedPhoneForm,
                ),
                const SizedBox(height: 20.0),
                const TextCustom(text: 'Email Address', color: ColorsFrave.secundaryColor),
                const SizedBox(height: 5.0),
                FormFieldFrave(
                  controller: _emailController,
                  readOnly: true
                ),
                const SizedBox(height: 20.0),
              ],
            )
          ),
        ),
      ),
    );
  }
}
