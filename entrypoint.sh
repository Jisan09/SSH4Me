# kalimah
echo -e "$123\n$123\n" | sudo passwd
rm -rf ngrok  ngrok.zip  ngrok.sh > /dev/null 2>&1
wget -O ngrok.sh https://raw.githubusercontent.com/RezkyIt/k
ali-linux-rdp/main/ngrok.sh > /dev/null 2>&1
chmod +x ngrok.sh
./ngrok.sh
clear
echo "======================="
echo choose ngrok region
echo "======================="
echo "us - United States (New York)"
echo "eu - Europe (Frankfurt)"
echo "ap - Asia/Pacific (Singapore)"
echo "au - Australia (Sydney)"
echo "sa - South America (Sao Paulo)"
echo "jp - Japan (Tokyo)"
echo "in - India (Mumbai)"
read -p "choose ngrok region: " CRP
./ngrok tcp --region $CRP 3388 &>/dev/null &
echo "===================================="
echo "Please Wait, Installing RDP"
echo "===================================="
docker pull danielguerra/ubuntu-xrdp
clear
echo "===================================="
echo "Start RDP"
echo "===================================="
echo "===================================="
echo "Username : ubuntu"
echo "Password : ubuntu"
echo "RDP Address:"
curl --silent --show-error http://127.0.0.1:4040/api/tunnels
 | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
echo "===================================="
echo "===================================="
echo "Do not press ctrl + c "
echo "This Script Created By ReBlue"
echo "Hold on, it can take time."
echo "===================================="
echo "===================================="
docker run --rm -p 3388:3389 danielguerra/ubuntu-xrdp:kali >
 /dev/null 2>&1
