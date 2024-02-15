import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pkl_smkn1mejayan_guru/modules/views/component/side_bar_component.dart';

import '../../model/edit_profile_model.dart';
import 'component/app_bar_component.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  static const String routeName = '/edit-profile';

  @override
  State<EditProfilePage> createState() => _EditProfileView();
}

class _EditProfileView extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final TextEditingController newPhoneController = TextEditingController(text: GetStorage().read('dataLogin')
  ['guru']['no_hp'].toString());
  List<PlatformFile>? photoProfileController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Column(
                    children: [
                      const Center(
                        child: Text('Photo Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Column(
                        children: [
                          Image.network(
                            "${GetStorage().read('dataLogin')['guru']['photo_guru']}",
                            width: 75,
                            height: 75,
                          ),
                          FormBuilderFilePicker(
                            withData: true,
                            name: "images",
                            allowMultiple: false,
                            maxFiles: 1,
                            decoration: const InputDecoration(labelText: "Photo"),
                            allowedExtensions: const ['png', 'jpg', 'jpeg', 'pdf'],
                            previewImages: true,
                            onChanged: (value) {
                              photoProfileController = value;
                            },
                            typeSelectors: const [
                              TypeSelector(
                                type: FileType.custom,
                                selector: Row(
                                  children: <Widget>[
                                    Icon(Icons.file_upload_outlined),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text("Photo Baru"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text('Ubah Nomor HP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'no_hp',
                        decoration: const InputDecoration(labelText: 'Nomor HP (62xxx)'),
                        controller: newPhoneController,
                        validator: (value) {
                          if(!RegExp(r'^62\d+$').hasMatch(value!)){
                            return "Invalid input. Must start with 62.";
                          }
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Center(
                          child: Text('Ubah Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      FormBuilderTextField(
                        name: 'oldPass',
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password Lama'),
                        controller: oldPassController,
                      ),
                      FormBuilderTextField(
                        name: 'newPass',
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password Baru'),
                        controller: newPassController,
                      ),
                      FormBuilderTextField(
                        name: 'confirmPass',
                        obscureText: true,
                        controller: confirmPassController,
                        decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
                      ),
                      Card(
                        margin: const EdgeInsets.only(top: 20),
                        color: Colors.green,
                        child: InkWell(
                          onTap: () async {
                            if (_formKey.currentState?.saveAndValidate() ?? false) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text('Processing Data'),
                                backgroundColor: Colors.green.shade300,
                              ));
                              var response = await EditProfileModel.sendPost(
                                  oldPassController.text,
                                  confirmPassController.text,
                                  newPassController.text,
                                  photoProfileController,
                                  newPhoneController.text);
                              if (response['success']) {
                                if (context.mounted) {
                                  ArtSweetAlert.show(
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.success,
                                      title: "Berhasil mengubah profile!",
                                      text: response['message'],
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  ArtSweetAlert.show(
                                    context: context,
                                    artDialogArgs: ArtDialogArgs(
                                      type: ArtSweetAlertType.danger,
                                      title: "Gagal mengubah profile!",
                                      text: response['message'],
                                    ),
                                  );
                                }
                              }
                              _formKey.currentState?.reset();
                            }
                          },
                          child: const SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Update Profile",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.send,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
