import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
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
  var box = GetStorage().read('dataLogin')['user'];

  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController newPhoneController;
  late TextEditingController newEmailController;
  List<PlatformFile>? photoProfileController;

  @override
  void initState() {
    super.initState();
    box = GetStorage().read('dataLogin')['guru'];
    newPhoneController = TextEditingController(text: box['no_hp'].toString());
    newEmailController = TextEditingController(text: box['email'].toString());
    if(box['deskripsi'] != null) descriptionController = TextEditingController(text: box['deskripsi'].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarComponent(),
      drawer: const SideBarComponent(),
      body: ListView(children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 10),
          child: Center(
            child: Card(
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      const Center(
                        child: Text('Photo Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Column(
                        children: [
                          FadeInImage(
                            placeholder: const AssetImage('assets/images/loading.gif'),
                            image: NetworkImage("${GetStorage().read('dataLogin')['guru']['photo_guru']}"),
                            width: 75,
                            height: 75,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              box['nama'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
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
                      FormBuilderTextField(
                        name: 'email',
                        decoration: const InputDecoration(labelText: 'Email'),
                        controller: newEmailController,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(),
                          FormBuilderValidators.email()])
                      ),
                      FormBuilderTextField(
                        name: 'no_hp',
                        decoration: const InputDecoration(labelText: 'Nomor HP (62xxx)'),
                        controller: newPhoneController,
                        validator: (value) {
                          if (!RegExp(r'^62\d+$').hasMatch(value!)) {
                            return "Invalid input. Must start with 62.";
                          }
                        },
                      ),
                      FormBuilderTextField(
                        name: 'description',
                        decoration: const InputDecoration(labelText: 'Deskripsi singkat Anda', floatingLabelBehavior:
                        FloatingLabelBehavior.always),
                        controller: descriptionController,
                        maxLines: 3,
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
                                  newPhoneController.text,
                                  newEmailController.text,
                                  descriptionController.text
                              );
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
