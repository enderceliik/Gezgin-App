import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods{
  final FirebaseStorage _storage = FirebaseStorage.instance; // FirebaseStorage nesnesi oluşturduk
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Firebase depolama alanına bir resim dosyası yüklemek için:
  Future <String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async
  {
    if(file !=  null)
    {
      Reference ref = _storage.ref().child(childName).child(_auth.currentUser!.uid);
      if(isPost)
      {
        String id = const Uuid().v1();
        ref = ref.child(id);
      }
      UploadTask uploadTask = ref.putData(file);

      TaskSnapshot snap = await uploadTask; 
      String downloadURL = await snap.ref.getDownloadURL(); // Firestore'a yüklediğimiz resim dosyasında 
      // daha sonra firebase'den erişebilmek için bir URL döndürüyoruz.
      // Bunu kullanıcının bilgileri arasına yazarak daha sonra o URL
      // vasıtasıyla buraya yüklemiş olduğumuz resim dosyasına erieşebileceğiz.
      
      return downloadURL; // URL'i string olarak döndürüyoruz.
    }
    else{
      print('We have a big problem here!');
      return 'Access denieded';
    }
  }
}
