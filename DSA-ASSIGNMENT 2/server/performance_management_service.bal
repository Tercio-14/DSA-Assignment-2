import ballerina/http;
import ballerina/graphql;
import ballerinax/mongodb;

mongodb:ConnectionConfig mongoConfig = {
    connection: {
        host: "localhost",
        port: 27017,
        auth: {
            username: "",
            password: ""
        },
        options: {
            sslEnabled: false,
            serverSelectionTimeout: 5000
        }
    },
    databaseName: "PerformanceManagement"
};


mongodb:Client db = check new (mongoConfig);

type User record {
    string supervisor;
    string username;
    string password;
    string jobTitle;
    string position;
    string role;
};

type Objective record {
    int id;
    string name;
    float weight;
};

type KPI record {
    int id;
    int userId;
    int objectiveId;
    float value; // Value of the KPI
    string unit; // Unit of measurement
};

type UserDetails record {
    
};

type LoggedUserDetails record {|
    
|};

type login record {|
    
|};



@graphql:ServiceConfig {
    graphiql: {
        enabled: true
    }
}
service /performanceManagement on new graphql:Listener(9090) {

    remote function createUser(User newUser) returns string {
    var result = db->insert(<map<json>>newUser.toJson(), "userCollection");
    if (result is error) {
        // Handle the error
        return "Error creating user: " + result.message();
    }
    return "User created successfully";
}
    remote function createObjective(Objective newObjective) returns string {
        _= check db->insert(<map<json>>newObjective.toJson(), "objectiveCollection");
        return "Objective created successfully";
    }

    remote function createKPI(KPI newKPI) returns string {
        _= check db->insert(<map<json>>newKPI.toJson(), "kpiCollection");
        return "KPI created successfully";
    }

    resource function get getAllUsers() returns User[] {
        stream<User, error?> usersDetails = check db->find("userCollection", "PerformanceManagement", {}, {});
        if (usersDetails is stream<User, error?>) {
            User[] result = [];
            error? e = usersDetails.forEach(function (User user) {
                result = append(result, user);
            });
            if (e != null) {
                // Handle the error
                return [];
            }
            return result;
        }
        return [];
    }
resource function get getAllObjectives() returns Objective[] {
    stream<Objective, error?> objectiveDescription = check db->find("objectiveCollection", "PerformanceManagement", {}, {});
    if (objectiveDescription is stream<Objective, error?>) {
        Objective[] result = [];
        error? e = objectiveDescription.forEach(function (Objective objective) {
            result = [objective];
        });
        if (e != null) {
            // Handle the error
            // You might want to log it or return an error message
            // Example: log:printError("Error retrieving objectives: " + e.message());
            return [];
        }
        return result;
    }
    return [];
}


  resource function get getAllKPIs() returns KPI[] {
    stream<KPI, error?> kpiStream = check db->find("kpiCollection", "PerformanceManagement", {}, {});
    if (kpiStream is stream<KPI, error?>) {
        KPI[] result = [];
        error? e = kpiStream.forEach(function (KPI kpi) {
            result = from var item in append2(result, kpi)
                select {id: 0, userId: 0, objectiveId: 0, value: 0.0, unit: ""};
        });
        
        if (e != null) {
            // Handle the error
            // You might want to log it or return an error message
            // Example: log:printError("Error retrieving KPIs: " + e.message());
            return [];
        }
        return result;
    }
    return [];
}


resource function get getObjectiveById(int id) returns Objective {
    map<json>? filter = { "id": id };
    stream<Objective, error?> objectiveDescription = check db->find("objectiveCollection", "PerformanceManagement", filter, {});

    if (objectiveDescription is stream<Objective, error?>) {
        Objective[] result = [];
        error? e = objectiveDescription.forEach(function (Objective objective) {
            result = from var item in append1(result, objective)
                select {id: 0, name: "", weight: 0.0};
        });
        if (e != null) {
            // Handle the error
            return {name: "", weight: 0.0, id: 0};
        }
        return result[0];
    }
    return {name: "", weight: 0.0, id: 0};
}


    resource function get getKPIById(int id) returns KPI {
        KPI? result = check db->find("kpiCollection", "PerformanceManagement", {id: id}, {});
        if (result != null) {
            return result;
        }
        return {unit: "", objectiveId: 0, id: 0, userId: 0, value: 0.0};
    }


    resource function get getKPIsByUserId(int userId) returns KPI[] {
        KPI[]? result = check db->find("kpiCollection", "PerformanceManagement", {userId: userId}, {});
        if (result != null) {
            return result;
        }
        return [];
    }
// Define a function to verify user credentials
function verifyUserCredentials(string username, string password) returns boolean {
    // Query the database to check if the provided username and password match
    stream<UserDetails, error?> userDetails = check db->find("userCollection", "PerformanceManagement", {username: username, password: password}, {});

    // Check if any user details were returned
    UserDetails[] users = check from var userInfo in userDetails select userInfo;

    return users.length() > 0;
}

// Define the login resource function
remote function login(User user) returns LoggedUserDetails|error {
    // Verify user credentials
    boolean isValidUser = verifyUserCredentials(user.username, user.password);

    if (isValidUser) {
        // If user credentials are valid, return user details
        return {username: user.username, isAdmin: false}; // Assuming isAdmin is false for regular users
    } else {
        // If user credentials are not valid, return an error
        return error("Invalid username or password");
    }
}

    resource function get getKPIsBySupervisor(string supervisorUsername) returns KPI[] {
        // Implement the logic to get KPIs by supervisor here.
        KPI[] assignedKPIs = [];
        // ... (Add your logic here)
        return assignedKPIs;
    }
}

function verifyUserCredentials(string s, string s1) returns boolean {
    return false;
}

function append(User[] users, User user) returns User[] {
    User[] newUserArray = users;
    newUserArray.push(user);
    return newUserArray;
}


function append1(Objective[] objectives, Objective objective) returns Objective[] {
    Objective[] newObjectiveArray = objectives;
    newObjectiveArray.push(objective);
    return newObjectiveArray;
}

function append2(KPI[] kpis, KPI kpi) returns KPI[] {
    KPI[] newKPIArray = kpis;
    newKPIArray.push(kpi);
    return newKPIArray;
}