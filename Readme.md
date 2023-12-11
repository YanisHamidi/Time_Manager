# TimeManager app

[![Netlify Status](https://api.netlify.com/api/v1/badges/df76ac9b-af4d-4637-98c9-c778d87c9c20/deploy-status/?branch=main)](https://app.netlify.com/sites/timemanagermsc/deploys)

This project is a full-stack web application developed with Vue.js for the front-end and Elixir Phoenix for the back-end, containerized with Docker to facilitate deployment and management.

## Prerequisites

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/EpitechMscProPromo2025/T-POO-700-MPL_6.git
2. Navigate to each project directory and copy example .env file:

    ```bash
   cp .env.example .env
   ```
   
   Eixir Phoenix project:

    ```bash
   cd manager-api
   cp .env.example .env
   ````
      VueJs project:

    ```bash
   cd timeManager-vue
   cp .env.example .env
   ```
   

3. Build and start Docker containers using Docker Compose:

     ```bash
    docker compose up --build

4. Access the Vue.js front-end application in your browser at: http://localhost:8080

5. Access the Elixir Phoenix API at: http://localhost:4000

## Stopping and Cleanup


6. To stop Docker containers and remove associated resources, use the following command:

      ```bash
      docker compose down