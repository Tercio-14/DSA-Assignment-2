// Import necessary Ballerina modules
import ballerina/http;
import ballerina/graphql;
import ballerinax/mongodb;

// Define MongoDB connection configuration
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
    databaseName: "PerformanceManagement" // MongoDB database name
};

// Initialize MongoDB client
mongodb:Client db = check new (mongoConfig);

// Configure collection names
configurable string userCollection = "Users";
configurable string objectiveCollection = "Objectives";

// Define record types for User, Objective, and KPIs
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

type KPIs record {
    int id;
    int userId;
    int objectiveId;
    float value; // Value of the KPIs
    string unit; // Unit of measurement
};

// Set up the GraphQL service configuration
@graphql:ServiceConfig {
    graphiql: {
        enabled: true // Enable GraphiQL for the GraphQL service
    }
}
service /performanceManagement on new graphql:Listener(9090) {

    // Implement remote functions to create User, Objective, and KPIs records in MongoDB
    remote function createUser(User newUser) returns string {
        map<json> doc = <map<json>>newUser.toJson();
        _= check db->insert(doc, "userCollection");
        return string`User created successfully`;
    }

    remote function createObjective(Objective newObjective) returns string {
        map<json> doc2 = <map<json>>newObjectives.toJSON
        _= check db->insert(newObjective, "objectiveCollection");

        return "Objective created successfully";
    }

    remote function createKPI(KPIs newKPI) returns string {
        _= check db->insert(newKPI, "kpiCollection");
        return "KPIs created successfully";
    }

    // Implement resource functions to retrieve all Users, Objectives, and KPIs
    resource function get getAllUsers() returns User[] {
        User[]? result = check db->find("userCollection", "performanceManagement", {}, {});
        if (result != null) {
            return result;
        }
        return [];
    }

    resource function get getAllObjectives() returns Objective[] {
        Objective[]? result = check db->find("objectiveCollection", "PerformanceManagement", {}, {});
        if (result != null) {
            return result;
        }
        return [];
    }

    resource function get getAllKPIs() returns KPIs[] {
        KPIs[]? result = check db->find("kpiCollection", "PerformanceManagement", {}, {});
        if (result != null) {
            return result;
        }
        return [];
    }

    // Implement resource functions to get specific Objectives and KPIs by ID
    resource function get getObjectiveById(int id) returns Objective {
        Objective? result = check db->findOne("objectiveCollection", "PerformanceManagement", {id: id}, {});
        if (result != null) {
            return result;
        }
        return {name: "", weight: 0.0, id: 0};
    }

    resource function get getKPIById(int id) returns KPIs {
        KPIs? result = check db->findOne("kpiCollection", "PerformanceManagement", {id: id}, {});
        if (result != null) {
            return result;
        }
        return {unit: "", objectiveId: 0, id: 0, userId: 0, value: 0.0};
    }

    // Implement resource functions to get KPIs by UserID or Supervisor
    resource function get getKPIsByUserId(int userId) returns KPIs[] {
        KPIs[]? result = check db->findOne("kpiCollection", "online-store", {userId: userId}, {});
        if (result != null) {
            return result;
        }
        return [];
    }

    resource function get getKPIsBySupervisor(string supervisorUsername) returns KPIs[] {
        KPIs[] assignedKPIs = [];
        
        // Retrieve the employees assigned to the supervisor
        User[] employees = select from user in userTable where user.supervisorUsername == supervisorUsername;

        // Iterate through the assigned employees
        foreach var employee in employees {
            // Retrieve KPIs of the employee
            KPIs[] employeeKPIs = select from kp in kpiTable where kp.userId == getUserId(employee.username);
            assignedKPIs = append(assignedKPIs, employeeKPIs);
        }

        return assignedKPIs;
    }
}

// Utility function for appending data to arrays
function append(KPIs[] assignedKPIs, KPIs[] employeeKPIs) returns KPIs[] {
    return [];
}
