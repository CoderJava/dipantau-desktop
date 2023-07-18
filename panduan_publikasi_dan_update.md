[macOS]
* Update version code dan version name didalam pubspec.yaml
* Buat git tag dan push
* Jalankan command `flutter build macos --release`
* Kemudian, code sign manually file *.app yang berhasil dibuild. Langkah ini bertujuan agar ketika si user update app-nya maka, permission-nya yang lama tidak akan hilang.
* Lalu, build file dmg-nya. Masuk ke directory `installers/dmg_creator`. Lalu, jalankan command `appdmg ./config.json ./<nama_file_output>.dmg`. Contoh, `appdmg ./config.json ./dipantau.dmg`.
* Selanjutnya, zip-kan file *.app yang ada didalam directory /build/macos/Build/Products/Release
* Rename file zip di poin sebelumnya sesuai dengan penomoran versinya. Contoh, dipantau_desktop_client-1.0.0+1-macos.zip
* Buat release di github release dan pilih ke tag yang terbaru.
* Isi title dan description-nya di github release.
* Lalu, masukkan file zip dan dmg yang sudah dibuat pada langkah-langkah sebelumnya.
* Kemudian, publish github release-nya.
* Update file appcast.xml
* Yang perlu diubah didalam file appcast.xml ialah tag yang ada didalam tag `<item>`. Berikut ialah tag yang perlu diupdate:
  * `<title>`
  * `<description>`
  * `<sparkle:version>`
  * `<sparkle:shortVersionString>`
  * `<enclosure>` bagian `length`, `url`, dan `sparkle:edSignature`
  * `<pubDate>`
* Selanjutnya, commit file appcast.xml dan push