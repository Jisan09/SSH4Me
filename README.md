# SSH4Me

SSH4Me is a Docker container that provides secure root access to development environments via an Ngrok tunnel. With configuration for root login and common development ports, SSH4Me makes it easy to access your environment securely from anywhere, including platforms like Railway.

## Requirements

To use SSH4Me, you will need:

- A GitHub account to fork the SSH4Me repository
- An ngrok account to get an authentication token
- Docker installed on your local machine if you want to run SSH4Me locally

## Installation and Setup

- ### Fork the SSH4Me Repository on GitHub

   The first step is to fork the SSH4Me repository on GitHub. To do this  click the "Fork" button in the top-right corner of the page.

- ### Sign up for an ngrok Account and Get Your Authentication Token
   - Sign up for an ngrok account at [https://dashboard.ngrok.com/signup](https://dashboard.ngrok.com/signup).
   - Get your ngrok authentication token from [https://dashboard.ngrok.com/get-started/your-authtoken](https://dashboard.ngrok.com/get-started/your-authtoken).

      <figure><img src="https://graph.org/file/a540090cbde42cb121f81.jpg" alt="ngrok dashboard" width="720"></figure>
    > **You will need this token when you build the Docker container on Railway or locally.**

<details>
  <summary><h3>〣 Deploy on Railway</h3></summary>
   
- Go to [https://railway.app/new](https://railway.app/new) and build the Docker container with the following environment variables:
    - `AUTH_TOKEN`: Your ngrok authentication token.
    - `PASSWORD`: Password for SSH access (optional, default is `rootuser`).

   <figure><img src="https://graph.org/file/e68689ddfbdb12cdc37d8.jpg" alt="Railway app buildL" width="720"></figure>

</details>

<details>
  <summary><h3>〣 Run Locally</h3></summary>

#### Install Docker

First, you need to install Docker on your local machine. You can download the appropriate version of Docker for your operating system from the [Docker website](https://www.docker.com/products/docker-desktop).

#### Clone the SSH4Me Repository

- Open a terminal window on your local machine.

- Clone the SSH4Me repository by running the following command:

   ```
   git clone https://github.com/Jisan09/SSH4Me
   ```

#### Build and Run the Docker Container

- Navigate to the `ssh4me` directory by running the following command:

   ```
   cd ssh4me
   ```

- Build the Docker container by running the following command:

   ```
   docker build -t ssh4me .
   ```

- Run the Docker container by running the following command:

   ```
   docker run -e AUTH_TOKEN=<your-ngrok-auth-token> -e PASSWORD=<your-password> ssh4me
   ```
</details>
   
 > ***Wait for the build to complete. Once it's done, you should see your ssh & password in log.***

## Contributing

We welcome and encourage contributions to SSH4Me. If you find a bug or have an idea for a new feature, please open an issue or a pull request.

If you found SSH4Me useful, please consider giving it a star on GitHub by clicking the ⭐️ button. This helps to increase the visibility of the project and lets us know that you find it valuable.

Thank you for your support!
