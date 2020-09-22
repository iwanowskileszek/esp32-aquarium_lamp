# esp32-aquarium_lamp
1. ESP32 podłączamy przez USB
2. Zainstalować Ubuntu na maszynie wirtualnej tak aby mogło uzywać USB
3. Na Ubuntu zainstalować wymagane do kompilacji oprogramowanie
4. Skompilować ( w trakcie kompilacji skonfigurować) firmware nodemcu i wgrać go na ESP32
5. Maszynę Ubunu można wyłączyć.

6. ESP32 dalej podłączony przez USB
7. Na Systemie Windows uruchomić serial-port-json-server-1.96_windows_amd64 (odpalamy serial-port-json-server.exe)
8. Odpalić przeglądarke - używałem Chrome i wejść na stronę: http://chilipeppr.com/esp32
9. Po prawej stronie zaklikać port
10. Teraz można wgrywać programy lua. Jeżeli ma się uruchamiać przy starcie, a ma się tak uruchamiać, to wgrać jako init.

Uwagi:
Często przy takiej obsłudze przez lokalny server + streona WWW trzeba restartować ESP32 (bywa upierdliwe)



