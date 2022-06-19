import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_application_sayi_tahmin/oyunkayip.dart';

var random = new Random();

// Random sayı oluşturma
int randomValue = random.nextInt(11) * 10;

// Kullanıcıdan alacağımız değeri aktaracağımız değişken
int inputValue = 0;

class GetValue {
  String getValue = "";
}

GetValue takeValue = new GetValue();

class InputEkrani extends StatefulWidget {
  @override
  _InputEkraniState createState() => _InputEkraniState();
}

class _InputEkraniState extends State<InputEkrani> {
  // Tahmin doğruluğu hesaplama fonksiyonu

  void tahminDogrulugu() {
    if (inputValue < randomValue) {
      tahminBilgi = "BİLGİ EKRANI\n Daha büyük bir sayı tahmin edin.";
      tahminHak--;
      ;
    } else if (inputValue > randomValue) {
      tahminBilgi = "BİLGİ EKRANI\n Daha küçük bir sayı tahmin edin.";
      tahminHak--;
    }
  }

  // Oyun kaybedildiğinde kaybetme ekranına gitmeyi sağlayan fonksiyon
  void oyunKayipEkran() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => OyunKayipEkran()));

    // TextField'i sıfırladık
    inputController.clear();
  }

  // AlertDialog'u kullanmak için oluşturduğumuz fonksiyon
  Future _alertDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "Lütfen 0 ve 100 dahil olmak üzere bu aralıkta 10'un katlarında bir sayı giriniz!"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // TextField'e girilen değeri almak, temizlemek vb.için TextEditingController tanımlandı
  TextEditingController inputController = new TextEditingController();

  int tahminHak = 4;
  String tahminBilgi = "BİLGİ EKRANI\n Lütfen 0 ve 100 dahil olmak üzere 10'un katlarında bir sayı tahmini yapınız.";
  int sayac = 0;
  int tahminDegeri;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Container(
              color: Colors.black,
              height: 2,
            ),
            preferredSize: Size.fromHeight(4.0)),
        backgroundColor: Colors.white70,
        title: Text(
          "Sayı Tahmin Uygulaması",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold ),

        ),
      ),
      body:
      // Ekran aşım uyarısını almamak için eklenen scroll özelliği
      SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // Kullanıcıdan input alınan ve tahmin bilgisinin olduğu kısım
            Container(
              margin: EdgeInsets.only(top: 60),
              child: Column(
                children: <Widget>[
                  // Tahmin ekranının olduğu kısım
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green,
                          width: 7,
                        ),
                      ),
                      height: 100,
                      width: 300,
                      child: Center(
                        //Bilgi ekranı yazdırma kısmı.
                        child: Text(
                          "${tahminBilgi}",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  // --------------
                  Center(
                    child: Text(
                      "\n Tahmin etmeye başla! \n " ,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, height: 2, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  // Ok ikonu
                  Icon(
                    Icons.arrow_downward_outlined,
                    color: Colors.black,
                    size: 50.0,
                  ),
                  // Kullanıcıdan input alınan kısım
                  Padding(
                    padding: EdgeInsets.only(
                        top: 25, right: 50, left: 50, bottom: 25),
                    child: TextField(
                      // Inputa giriler değeri almak için TextEditingController belirledik.

                      controller: inputController,
                      decoration: InputDecoration(
                          hintText: "Tahmin", border: OutlineInputBorder()),
                    ),
                  ),
                  // Tamam buttonu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            takeValue.getValue =
                                inputController.text.toString();
                            debugPrint("TextField value : " +
                                inputController.text.toString());
                            // AlertDialog sayı mı değil mi kısmı
                            try {
                              inputValue = int.parse(takeValue.getValue);
                            } catch (e) {
                              _alertDialog();
                            }
                            tahminDegeri = int.parse(takeValue.getValue);

                            sayac = 1;
                            // AlertDialog 0-100 aralığında bir sayı mı kısmı
                            for (int i = 0; i <= 100; i = i + 10) {
                              if (tahminDegeri == i) {
                                sayac = 0;
                                break;
                              }
                            }

                            // Tamam'a tıkladığımızda
                            if (sayac == 0) {
                              if (tahminHak != 1) {
                                if (inputValue != randomValue)
                                  tahminDogrulugu();
                                else {
                                  tahminBilgi =
                                  "Tebrikler dogru sayıyı buldunuz! :)";
                                }
                              } else {
                                oyunKayipEkran();
                              }
                            } else {
                              _alertDialog();
                            }
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.white38),
                        ),
                        child: Text(
                          "Tamam",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      // Yeni sayı oluşturma buttonu
                      ElevatedButton(
                        onPressed: () {
                          // Yeni sayı oluştu'a tıkladığımızda
                          setState(() {
                            tahminHak = 4;
                            randomValue = random.nextInt(11) * 10;
                            debugPrint("Random value : $randomValue");
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.white38),
                        ),
                        child: Text(
                          "Yeni Sayı Oluştur",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Kalan tahmin kısmı
                  Center(
                    child: Text(
                      "Kalan tahmin hakkınız : $tahminHak",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, height: 2, fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
