## HelloMarket 

![HelloMarket Logo](/resources/logo.jpeg)

**NOTE: This project is currently under development.** 

This repository is part of my course. If you are interested in learning how to build Smart Shop E-Commerce store from scratch then check out my course [Full Stack E-Commerce App Development with SwiftUI, Node.js and Postgres](https://azamsharp.teachable.com/p/full-stack-e-commerce-app-development-with-swiftui-node-js-and-postgres).



HelloMarket, a full-stack e-commerce app using SwiftUI, Node.js, and Postgres. Develop key features such as user authentication, product management, order processing, and seamless Stripe integration for payments.

Technologies and Frameworks
- SwiftUI
- NodeJS (ExpressJS)
- Postgres (Database)
- Sequelize (ORM)

### Setting Up the Backend: 

First, make sure that you have Node.js installed. You can install Node.js by following the instructions at [nodejs.org](https://nodejs.org/en).

Once Node.js is installed, navigate to the `hello-market-server` folder and run:

```
npm install
```

This will install all the required packages and dependencies.

Next, you need to set up your database. For HelloMarket, we use a PostgreSQL database. The easiest way to install PostgreSQL on your machine is by using the [Postgres App](https://postgresapp.com/). Once the Postgres App is installed, open it and initialize the database. You may see a few databases already created. Simply double-click on any of them, and it will open the PostgreSQL command line.

From the command line, you can create a new database by running the following command:

```
CREATE DATABASE hellomarketdb;
```

Press Enter to execute the command. This will create the `hellomarketdb` database on your local machine. There are many tools available to visualize the database; I recommend using [BeeKeeper Community Edition](https://github.com/beekeeper-studio/beekeeper-studio).

After creating the database, you can go inside the hello-market-server folder and run `npm install`. This will install all the required packages for your server. Once, all the packages are installed you need to configure the database using the following settings. This should be in ```config.json``` file, which resides inside the ```config``` folder. 

You can use the following configuration to connect BeeKeeper to the database:

```json
"development": {
    "username": "postgres",
    "password": null,
    "database": "hellomarketdb",
    "host": "127.0.0.1",
    "dialect": "postgres"
}
```

Next, to create all the required tables you can run sequelize db:migrate from the terminal from inside the hello-market-server folder. This will make sure you have all the tables required for the app. 

To run your server, make sure you are inside the `hello-market-server` folder, then run:

```
node app.js
```

Alternatively, if you have [Nodemon](https://www.npmjs.com/package/nodemon) installed, you can run:

```
nodemon app.js
```

Nodemon will restart the server automatically whenever changes are detected.


