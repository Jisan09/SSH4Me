# SSH4Me
SSH4Me is a Docker container for secure root access to development environments via an Ngrok tunnel. With configuration for root login and common development ports, SSH4Me makes it easy to access your environment securely from anywhere, including platforms like Railway.

## Usage

### _For now only tested in railway.app_

- Fork the repo
- Sign up for an ngrok account at <https://dashboard.ngrok.com/signup>.
- Go to <https://dashboard.ngrok.com/get-started/your-authtoken> to get your ngrok authentication token.

  <figure><img src="https://graph.org/file/a540090cbde42cb121f81.jpg" alt="Cat Logo" width="660"></figure>
- Go to <https://railway.app/new> and build the docker with these env vars.

  - **AUTH_TOKEN :** Ngrok authentication token.
  - **PASSWORD :** Password for ssh (if not added it will be **rootuser**)
  <figure><img src="https://graph.org/file/e68689ddfbdb12cdc37d8.jpg" alt="Cat Logo" width="660"></figure>
  
- After build complete go to <https://dashboard.ngrok.com/cloud-edge/endpoints> and copy the tcp url.

  <figure><img src="https://graph.org/file/7ce318fc4dc19f83f5571.jpg" alt="Cat Logo" width="660"></figure>
- Format your tcp url this way to get SSH -->
  - **Tcp URL :** tcp://8.tcp.ngrok.io:13644
  - **SSH :** ssh root@8.tcp.ngrok.io -p 13644

- Connect to the ssh with your password and Viola 🎉

  <figure><img src="https://graph.org/file/7ce6294bddd644cd462c2.jpg" alt="Cat Logo" width="660"></figure>

## Contributing

Contributions are welcome! Currecntly I have tested on railway only. If you find a bug or have an idea for a new platform, please open an issue or a pull request.
