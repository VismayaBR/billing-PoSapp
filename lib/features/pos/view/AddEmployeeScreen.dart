

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/helper/app_contants.dart';

import '../../../helper/text_style.dart';
import '../../../helper/ui_helper.dart';
import '../../account/model/login_model.dart';
import '../view_model/pos_screen_view_model.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({Key? key}) : super(key: key);
  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployeeScreen> {
  var _formKey_employee = GlobalKey<FormState>();
  final _prefs = SharedPreferencesRepo.instance;

  var isLoading = false;
  String? isAdmin ="No";
  String? name;
  int? code;
  int? designationId;
  String? designation;
  String? mobile;
  String? dob;
  String? doj;
  String? password;
  int? pin;
  final _dobController =  TextEditingController();
  final _dojController =  TextEditingController();
  bool isPhone =true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)   {
      Provider.of<PosScreenViewModel>(context,listen: false).fetchEmployeeDesignation();
    });
  }

  void _submit(PosScreenViewModel pos) async{
    if (_formKey_employee.currentState!.validate()) {
      _formKey_employee.currentState?.save();

      var employeeData =User(
          name: name,
        designationId: designationId,
        password: password,
        pin: pin,
        adminFlag: isAdmin ,
        code: "$code",
        dob: dob,
        doj: doj,
        mobile: mobile,
        branchId: _prefs!.getInt(AppStrings.branchId)

      );
      var status = await pos.createEmployeeApi(employeeData,context);
      if(status == "success"){
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> designations = [];
    isPhone = MediaQuery.of(context).size.width<800||MediaQuery.of(context).size.height<600;
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child) {

        designations.clear();
        pos.employeeDesignationList?.forEach((element) {
          designations.add(element.name??"");
        });
        return Scaffold(
          //body
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){

                return SingleChildScrollView(
                  child:Padding(
                    padding: const EdgeInsets.all(16.0),
                    //form
                    child: Column(
                      children: [
                        const SizedBox(height: 10,),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 5,top: 10,bottom: 10),
                            child: Row(
                              children: [
                                Icon(Icons.chevron_left,size:isPhone?20: getWidth(context: context)/50 ,),
                                horizontalSpaceSmall,
                                Text('BACK TO HOME',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w700,fontSize: isPhone?14:getWidth(context: context)/80),)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0,right: 10),
                          child: Form(
                            key: _formKey_employee,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  isPhone?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15,),
                                      Text('Employee Form',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                                      const SizedBox(height: 20,),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            labelText: 'Name*', labelStyle: const TextStyle(
                                          fontSize: 16.0,
                                        )),
                                        keyboardType: TextInputType.name,
                                        onSaved: (value) {
                                          name = value;
                                        },

                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9 ]+")
                                                  .hasMatch(value)) {
                                            return 'Enter a valid name!';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10,),
                                      TextFormField(
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),labelText: 'Code',
                                            labelStyle: const TextStyle(
                                              fontSize: 16.0,
                                            )),
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          if(value!.isEmpty){
                                            return;
                                          }
                                          var codeString = int.parse(value);
                                          assert(codeString is int);
                                          code = codeString;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !RegExp(r"^[0-9.]+")
                                                  .hasMatch(value)) {
                                            return 'Enter a valid code!';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10,),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        hint: const Text('Designation*', style: TextStyle(
                                          fontSize: 16.0,
                                        )),
                                        value: designation,
                                        validator: (value) => value == null
                                            ? 'Please select a designation' : null,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            designation = newValue!;
                                          });
                                        },
                                        onSaved:(newValue){
                                          pos.employeeDesignationList?.forEach((element) {
                                            if(element.name == newValue){
                                              designationId =element.id;
                                              return;
                                            }
                                          });
                                        },
                                        items: designations
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 10,),
                                      TextFormField(
                                        decoration:  InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            labelText: 'Mobile', labelStyle: const TextStyle(
                                          fontSize: 16.0,
                                        )),
                                        keyboardType: TextInputType.phone,
                                        onSaved: (value) {
                                          mobile = value;
                                        },
                                        validator: (value) {
                                          if (value!.isNotEmpty &&
                                              !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                                  .hasMatch(value)) {
                                            return 'Enter a valid Mobile number!';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10,),
                                      DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        hint: const Text('Admin', style: TextStyle(
                                          fontSize: 16.0,
                                        )),
                                        value: isAdmin,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            isAdmin = newValue!;
                                          });
                                        },
                                        onSaved: (value){
                                          if(value == null || value.isEmpty){
                                            isAdmin = "No";
                                          } else{
                                            isAdmin = value;
                                          }
                                        },
                                        items: ["Yes","No"]
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                      const SizedBox(height: 10,),
                                      SizedBox(
                                        height: 65,
                                        child: TextFormField(
                                          controller: _dobController,
                                          readOnly: true,
                                          onTap: () {
                                            selectDOBDate(context,"dob");
                                          },
                                          decoration:  InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10.0),
                                                borderSide: const BorderSide(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              suffix: IconButton(
                                                onPressed: () {
                                                  selectDOBDate(context,"dob");
                                                },
                                                icon: const Icon(Icons.calendar_month,size: 24,),
                                              ),
                                              labelText: 'DOB',hintText: "dd/mm/yyyy",
                                              labelStyle: const TextStyle(
                                                fontSize: 16.0,
                                              )),
                                          keyboardType: TextInputType.text,
                                          onSaved: (value) {
                                            dob = value;
                                          },
                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      SizedBox(height: 65,
                                        child: TextFormField(
                                          controller: _dojController,
                                          readOnly: true,
                                          onTap: () {
                                            selectDOBDate(context,"doj");
                                          },
                                          decoration:  InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            suffix: IconButton(
                                              onPressed: () {
                                                selectDOBDate(context,"doj");
                                              },
                                              icon: const Icon(Icons.calendar_month,size: 24,),
                                            ),
                                            labelText: 'DOJ',hintText: "dd/mm/yyyy",
                                            labelStyle: const TextStyle(
                                              fontSize: 16.0,
                                            ),),
                                          keyboardType: TextInputType.text,
                                          onSaved: (value) {
                                            doj = value;
                                          },

                                          validator: (value) {
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 10,),
                                      TextFormField(
                                        decoration:  InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            labelText: 'Password',
                                            labelStyle: const TextStyle(
                                              fontSize: 16.0,
                                            )),
                                        keyboardType: TextInputType.text,
                                        onSaved: (value) {
                                          password = value;
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty ||value.length <5) {
                                            return 'Password must be more than 5 characters!';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10,),
                                      TextFormField(
                                        decoration:  InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            labelText: 'PIN',
                                            labelStyle: const TextStyle(
                                              fontSize: 16.0,
                                            )),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value!.isEmpty ||value.length < 3) {
                                            return 'Invalid PIN!';
                                          }
                                          return null;
                                        },
                                        onSaved: (value){
                                          var pinString = int.parse(value!);
                                          assert(pinString is int);
                                          pin = pinString;},
                                      ),
                                      const SizedBox(height: 20,),

                                      //box styling
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      //text input

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.close),
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(const Color(0xffD3D3D3)),
                                                padding:
                                                MaterialStateProperty.all(const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 15.0,
                                                )),
                                                textStyle: MaterialStateProperty.all(
                                                    const TextStyle(fontSize: 14, color: Colors.white))),
                                            label: const Text(
                                              "Close",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            onPressed: () => _submit(pos),
                                          ),
                                          const SizedBox(width: 20,),
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.check),
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(const Color(0xffD1FFBD)),
                                                padding:
                                                MaterialStateProperty.all(const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 15.0,
                                                )),
                                                textStyle: MaterialStateProperty.all(
                                                    const TextStyle(fontSize: 14, color: Colors.white))),
                                            label: const Text(
                                              "Save",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                              ),
                                            ),
                                            onPressed: () => _submit(pos),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                      :

                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 15,),
                                      Text('Employee Form',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 24),),
                                      const SizedBox(height: 20,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  labelText: 'Name*', labelStyle: const TextStyle(
                                                fontSize: 16.0,
                                              )),
                                              keyboardType: TextInputType.name,
                                              onSaved: (value) {
                                                name = value;
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty ||
                                                    !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9 ]+")
                                                        .hasMatch(value)) {
                                                  return 'Enter a valid name!';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),labelText: 'Code',
                                                  labelStyle: const TextStyle(
                                                    fontSize: 16.0,
                                                  )),
                                              keyboardType: TextInputType.number,
                                              onSaved: (value) {
                                                if(value!.isEmpty){
                                                  return;
                                                }
                                                var codeString = int.parse(value);
                                                assert(codeString is int);
                                                code = codeString;
                                              },
                                              validator: (value) {
                                                /*if (value!.isEmpty ||
                                              !RegExp(r"^[0-9.]+")
                                                  .hasMatch(value)) {
                                            return 'Enter a valid code!';
                                          }*/
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              hint: const Text('Designation*', style: TextStyle(
                                                fontSize: 16.0,
                                              )),
                                              value: designation,
                                              validator: (value) => value == null
                                                  ? 'Please select a designation' : null,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  designation = newValue!;
                                                });
                                              },
                                              onSaved:(newValue){
                                                pos.employeeDesignationList?.forEach((element) {
                                                  if(element.name == newValue){
                                                    designationId =element.id;
                                                    return;
                                                  }
                                                });
                                              },
                                              items: designations
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            child: TextFormField(
                                              decoration:  InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  labelText: 'Mobile', labelStyle: const TextStyle(
                                                fontSize: 16.0,
                                              )),
                                              keyboardType: TextInputType.phone,
                                              onSaved: (value) {
                                                mobile = value;
                                              },
                                              validator: (value) {
                                                if (value!.isNotEmpty &&
                                                    !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                                        .hasMatch(value)) {
                                                  return 'Enter a valid Mobile number!';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: DropdownButtonFormField<String>(
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10.0),
                                                  borderSide: const BorderSide(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ),
                                              hint: const Text('Admin', style: TextStyle(
                                                fontSize: 16.0,
                                              )),
                                              value: isAdmin,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  isAdmin = newValue!;
                                                });
                                              },
                                              onSaved: (value){
                                                if(value == null || value.isEmpty){
                                                  isAdmin = "No";
                                                } else{
                                                  isAdmin = value;
                                                }
                                              },
                                              items: ["Yes","No"]
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            child: SizedBox(
                                              height: 65,
                                              child: TextFormField(
                                                controller: _dobController,
                                                readOnly: true,
                                                onTap: () {
                                                  selectDOBDate(context,"dob");
                                                },
                                                decoration:  InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(10.0),
                                                      borderSide: const BorderSide(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    suffix: IconButton(
                                                      onPressed: () {
                                                        selectDOBDate(context,"dob");
                                                      },
                                                      icon: const Icon(Icons.calendar_month,size: 24,),
                                                    ),
                                                    labelText: 'DOB',hintText: "dd/mm/yyyy",
                                                    labelStyle: const TextStyle(
                                                      fontSize: 16.0,
                                                    )),
                                                keyboardType: TextInputType.text,
                                                onSaved: (value) {
                                                  dob = value;
                                                },
                                                validator: (value) {
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            child: SizedBox(height: 65,
                                              child: TextFormField(
                                                controller: _dojController,
                                                readOnly: true,
                                                onTap: () {
                                                  selectDOBDate(context,"doj");
                                                },
                                                decoration:  InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  suffix: IconButton(
                                                    onPressed: () {
                                                      selectDOBDate(context,"doj");
                                                    },
                                                    icon: const Icon(Icons.calendar_month,size: 24,),
                                                  ),
                                                  labelText: 'DOJ',hintText: "dd/mm/yyyy",
                                                  labelStyle: const TextStyle(
                                                    fontSize: 16.0,
                                                  ),),
                                                keyboardType: TextInputType.text,
                                                onSaved: (value) {
                                                  doj = value;
                                                },

                                                validator: (value) {
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15,),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              decoration:  InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  labelText: 'Password',
                                                  labelStyle: const TextStyle(
                                                    fontSize: 16.0,
                                                  )),
                                              keyboardType: TextInputType.text,
                                              onSaved: (value) {
                                                password = value;
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty ||value.length <5) {
                                                  return 'Password must be more than 5 characters!';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 20,),
                                          Expanded(
                                            child: TextFormField(
                                              decoration:  InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    borderSide: const BorderSide(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  labelText: 'PIN',
                                                  labelStyle: const TextStyle(
                                                    fontSize: 16.0,
                                                  )),
                                              keyboardType: TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty ||value.length < 3) {
                                                  return 'Invalid PIN!';
                                                }
                                                return null;
                                              },
                                              onSaved: (value){
                                                var pinString = int.parse(value!);
                                                assert(pinString is int);
                                                pin = pinString;},
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20,),

                                      //box styling
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      //text input

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.close),
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(const Color(0xffD3D3D3)),
                                                padding:
                                                MaterialStateProperty.all(const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 15.0,
                                                )),
                                                textStyle: MaterialStateProperty.all(
                                                    const TextStyle(fontSize: 14, color: Colors.white))),
                                            label: const Text(
                                              "Close",
                                              style: TextStyle(
                                                fontSize: 24.0,
                                              ),
                                            ),
                                            onPressed: () => _submit(pos),
                                          ),
                                          const SizedBox(width: 20,),
                                          ElevatedButton.icon(
                                            icon: const Icon(Icons.check),
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(const Color(0xffD1FFBD)),
                                                padding:
                                                MaterialStateProperty.all(const EdgeInsets.symmetric(
                                                  vertical: 10.0,
                                                  horizontal: 15.0,
                                                )),
                                                textStyle: MaterialStateProperty.all(
                                                    const TextStyle(fontSize: 14, color: Colors.white))),
                                            label: const Text(
                                              "Save",
                                              style: TextStyle(
                                                fontSize: 24.0,
                                              ),
                                            ),
                                            onPressed: () => _submit(pos),
                                          ),
                                        ],
                                      )
                                    ],
                                  )

                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                  )
                );
              }
          ),
        );
      }
    );
  }

  Future<void> selectDOBDate(BuildContext context,String key) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(2000, 1),
        firstDate: DateTime(1950, 1),
        lastDate: DateTime.now());
    if (picked != null) {
      if(key == "dob"){
        dob = "${picked.day}/${picked.month}/${picked.year}";
         _dobController.text = dob!;
        log("selected date:$dob");
      } else{
        doj = "${picked.day}/${picked.month}/${picked.year}";
        _dojController.text = doj!;
      }
     // fromDate = picked;
     // notifyListeners();
    }
  }
}