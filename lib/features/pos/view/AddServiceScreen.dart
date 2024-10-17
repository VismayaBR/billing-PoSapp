
// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saloon_pos/app_config/shared_preferences_config.dart';
import 'package:saloon_pos/helper/app_contants.dart';

import '../../../helper/text_style.dart';
import '../../../helper/themes.dart';
import '../../../helper/ui_helper.dart';
import '../model/service_response_model.dart';
import '../view_model/pos_screen_view_model.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({Key? key}) : super(key: key);
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddServiceScreen> {
  final formKeyService = GlobalKey<FormState>();
  var isLoading = false;
  final _prefs = SharedPreferencesRepo.instance;

  File? galleryFile;
  // final picker = ImagePicker();
  String? selectedServiceGroup;
  String? name;
  int? serviceGroupId;
  String? price;
  String? description;
  bool isPhone =true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)   {

      Provider.of<PosScreenViewModel>(context,listen: false).fetchServicesCategories();
    });
  }

  void _submit(PosScreenViewModel pos, BuildContext context) async{
     if (formKeyService.currentState!.validate()) {
       formKeyService.currentState?.save();

         var priceString = int.parse(price!);
         assert(priceString is int);
         var serviceData =ServiceData(
             name: name,
             description: description,
             price: priceString,
             groupId: serviceGroupId,
           branchId: _prefs!.getInt(AppStrings.branchId)

         );
         var status = await pos.createServiceApi(serviceData,context);
         if(status == "success"){
           Navigator.pop(context);
         } else{
           Themes.showSnackBar(
               context: context,
               msg: 'failed');
         }
     }



  }

  @override
  Widget build(BuildContext context) {
    isPhone = MediaQuery.of(context).size.width<800||MediaQuery.of(context).size.height<600;
    List<String> serviceGroup = [];
    return Consumer<PosScreenViewModel>(
      builder: (context,pos,child) {
        serviceGroup.clear();
        pos.serviceCategories?.forEach((element) {
          serviceGroup.add(element.name??"");
        });
        return Scaffold(
          //body
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                return SingleChildScrollView(
                  child: isPhone?Padding(
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
                            key: formKeyService,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 15,),
                                Text('Service Form',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 20),),
                                const SizedBox(height: 20,),
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),labelText: 'Name*', labelStyle: const TextStyle(
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
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  hint: const Text('Service group*', style: TextStyle(
                                    fontSize: 16.0,
                                  )),
                                  value: selectedServiceGroup,
                                  validator: (value) => value == null
                                      ? 'Please select a service group' : null,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedServiceGroup = newValue!;

                                    });
                                  },
                                  onSaved:(newValue){
                                    pos.serviceCategories?.forEach((element) {
                                      if(element.name == newValue){
                                        serviceGroupId =element.id;
                                        return;
                                      }
                                    });
                                  },
                                  items: serviceGroup
                                      .map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 10,),
                                TextFormField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),labelText: 'Price*',
                                      labelStyle: const TextStyle(
                                        fontSize: 16.0,
                                      )),
                                  keyboardType: TextInputType.number,
                                  onSaved: (value) {
                                    if(value!= null && value.isNotEmpty){ price = value;}else {price ="0";}

                                  },
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r"^[0-9.]+")
                                            .hasMatch(value)) {
                                      return 'Enter a valid price!';
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
                                      ),labelText: 'Description',
                                      labelStyle: const TextStyle(
                                        fontSize: 16.0,
                                      )),
                                  keyboardType: TextInputType.text,
                                  onSaved: (value) {
                                    description = value;
                                  },
                                  validator: (value) {
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10,),

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
                                      onPressed: () => Navigator.pop(context),
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
                                      onPressed: () => _submit(pos,context),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  :Padding(
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
                          padding: const EdgeInsets.only(left: 15.0,right: 15),
                          child: Form(
                            key: formKeyService,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const SizedBox(height: 15,),
                                Text('Service Form',style: mainSubHeadingStyle().copyWith(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 24),),
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
                                            ),labelText: 'Name*', labelStyle: const TextStyle(
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
                                      child: DropdownButtonFormField<String>(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                        hint: const Text('Service group*', style: TextStyle(
                                          fontSize: 16.0,
                                        )),
                                        value: selectedServiceGroup,
                                        validator: (value) => value == null
                                            ? 'Please select a service group' : null,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedServiceGroup = newValue!;

                                          });
                                        },
                                        onSaved:(newValue){
                                          pos.serviceCategories?.forEach((element) {
                                            if(element.name == newValue){
                                              serviceGroupId =element.id;
                                              return;
                                            }
                                          });
                                        },
                                        items: serviceGroup
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
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
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey,
                                              ),
                                            ),labelText: 'Price*',
                                            labelStyle: const TextStyle(
                                              fontSize: 16.0,
                                            )),
                                        keyboardType: TextInputType.number,
                                        onSaved: (value) {
                                          if(value!= null && value.isNotEmpty){ price = value;}else {price ="0";}

                                        },
                                        validator: (value) {
                                          if (value!.isEmpty ||
                                              !RegExp(r"^[0-9.]+")
                                                  .hasMatch(value)) {
                                            return 'Enter a valid price!';
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
                                            ),labelText: 'Description',
                                            labelStyle: const TextStyle(
                                              fontSize: 16.0,
                                            )),
                                        keyboardType: TextInputType.text,
                                        onSaved: (value) {
                                          description = value;
                                        },
                                        validator: (value) {
                                          return null;
                                        },
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
                                      onPressed: () => Navigator.pop(context),
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
                                      onPressed: () => _submit(pos,context),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
          ),
        );
      }
    );
  }

/*void _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
      ImageSource img,
      ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
          () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }*/
}