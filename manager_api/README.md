# TIME MANAGER API

The Time Manager API, built using the Elixir programming language and the Phoenix framework, offers a robust and efficient solution for managing
time-related data within an application. This API provides 
endpoints for creating, updating, retrieving, and deleting time-related records, making it an essential component for any time management application.
Below are some key features and endpoints of the Time Manager API

**Note**: This project's focus is on developing an API only, without any front-end/


## CRUD Endpoints
Here is a list of required endpoints for CRUD operations on the Time Manager API:

### USER
- **GET method:** Retrieve user(s) based on email and/or username
    - *Endpoint:* `http://localhost:4000/api/users`
- **GET method:** Retrieve a specific user by its userID
    - *Endpoint:* `http://localhost:4000/api/users/:userID`
- **POST method:** Create a new user
    - *Endpoint:* `http://localhost:4000/api/users`
- **PUT method:** Update an existing user by their userID
    - *Endpoint:* `http://localhost:4000/api/users/:userID`
- **DELETE method:** Delete a user by their userID
    - *Endpoint:* `http://localhost:4000/api/users/:userID`

### WORKING TIME
- **GET (ALL) method:** Retrieve all working times for a specific user
    - *Endpoint:* `http://localhost:4000/api/workingtimes/:userId`
- **GET (ONE) method:** Retrieve a specific working time entry by its ID for a specific user
    - *Endpoint:* `http://localhost:4000/api/workingtimes/:userID/:id`
- **POST method:** Create a new working time entry for a user
    - *Endpoint:* `http://localhost:4000/api/workingtimes/:userID`
- **PUT method:** Update an existing working time entry by its ID
    - *Endpoint:* `http://localhost:4000/api/workingtimes/:id`
- **DELETE method:** Delete a working time entry by its ID
    - *Endpoint:* `http://localhost:4000/api/workingtimes/:id`

### CLOCKING
- **GET method:** Retrieve clocking information for a specific user
    - *Endpoint:* `http://localhost:4000/api/clocks/:userID`
- **POST method:** Record clocking events for users, handling both departures and arrivals
    - *Endpoint:* `http://localhost:4000/api/clocks/:userID`

### DEPLOYMENT

To deploy the database, navigate to the manager_api directory and execute this command.

  ```bash
  git subtree push --prefix manager_api origin deploy_back  
  ```
