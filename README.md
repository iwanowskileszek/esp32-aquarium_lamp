# esp32-aquarium_lamp
ESP32 podłączamy przez USB
Zainstalować Ubuntu na maszynie wirtualnej tak aby mogło uzywać USB
Na Ubuntu zainstalować wymagane do kompilacji oprogramowanie
Skompilować ( w trakcie kompilacji skonfigurować) firmware nodemcu i wgrać go na ESP32
Maszynę Ubunu można wyłączyć.

ESP32 dalej podłączony przez USB
Na Systemie Windows uruchomić serial-port-json-server-1.96_windows_amd64 (odpalamy serial-port-json-server.exe)
Odpalić przeglądarke - używałem Chrome i wejść na stronę: http://chilipeppr.com/esp32
Po prawej stronie zaklikać port
Teraz można wgrywać programy lua. Jeżeli ma się uruchamiać przy starcie, a ma się tak uruchamiać, to wgrać jako init.

Często przy takiej obsłudze przez lokalny server + streona WWW trzeba restartować ESP32 (bywa upierdliwe)



