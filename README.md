# SSH4Me

SSH4Me is a Docker container that provides secure root access to development environments via an Ngrok tunnel. With configuration for root login and common development ports, SSH4Me makes it easy to access your environment securely from anywhere, including platforms like Railway.

## Usage

### _For now only tested in railway.app_

### To use SSH4Me, you'll need to follow these steps:

1. Fork the SSH4Me repository on GitHub.
2. Sign up for an ngrok account at [https://dashboard.ngrok.com/signup](https://dashboard.ngrok.com/signup).
3. Get your ngrok authentication token from [https://dashboard.ngrok.com/get-started/your-authtoken](https://dashboard.ngrok.com/get-started/your-authtoken).

   <figure><img src="https://graph.org/file/a540090cbde42cb121f81.jpg" alt="ngrok dashboard" width="720"></figure>

4. Go to [https://railway.app/new](https://railway.app/new) and build the Docker container with the following environment variables:
    * `AUTH_TOKEN`: Your ngrok authentication token.
    * `PASSWORD`: Password for SSH access (optional, default is `rootuser`).

   <figure><img src="https://graph.org/file/e68689ddfbdb12cdc37d8.jpg" alt="Railway app buildL" width="720"></figure>


5. After the build is complete, go to [https://dashboard.ngrok.com/cloud-edge/endpoints](https://dashboard.ngrok.com/cloud-edge/endpoints) and copy the TCP URL.

   <figure><img src="https://graph.org/file/7ce318fc4dc19f83f5571.jpg" alt="ngrok TCP URL" width="720"></figure>

6. Format the TCP URL to get the SSH URL:
    * TCP URL: `tcp://8.tcp.ngrok.io:13644`
    * SSH URL: `ssh root@8.tcp.ngrok.io -p 13644`
7. Connect to the SSH URL using your password (if set) and access your development environment.

   <figure><img src="https://graph.org/file/7ce6294bddd644cd462c2.jpg" alt="SSH connection" width="720"></figure>

## Contributing

We welcome and encourage contributions to SSH4Me. If you find a bug or have an idea for a new feature, please open an issue or a pull request.

If you found SSH4Me useful, please consider giving it a star on GitHub by clicking the ⭐️ button. This helps to increase the visibility of the project and lets us know that you find it valuable.

Thank you for your support!
