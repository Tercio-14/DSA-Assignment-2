import ballerina/graphql;
import ballerina/io;

type Response record {|
    record {|anydata dt;|} data;
|};

public function main() returns error? {
    graphql:Client graphqlClient = check new ("localhost:27017/performanceManagememnt");

    //CreateUser() call
    string doc = string `
    mutation createUser($usernane:String!,$password:String!,$jobTitle:String!,$position:String!, $role:String!){
        createUser(newUser:{usernane:$usernane,password:$password,jobTitle:$jobTitle,position:$position, role:$role)
    }`;

    Response createUserResponse = check graphqlClient->execute(doc, {"username": "", "password": "", "jobTitle": "", "position": "", "role":""});

    //CreateObjective() call
    string doc1 = string `
    mutation createObjective($id:Int!,$name:String!,$weight:Float!){
        createObjective(newObjective:{id:$id,password:$name,weight:$weight)
    }`;

    Response createObjectiveResponse = check graphqlClient->execute(doc1, {"id": "", "name": "", "weight": ""});

    //CreateKPI() call
    string doc2 = string `
    mutation createKPI($id:Int!,$userId:Int!,$objectiveId:Int!,$value:Float!, $unit:String!){
        createKPI(newKPI:{id:$id,userId:$userId,objectiveId:$objectiveId,value:$value, unit:$unit)
    }`;

    Response createKPIResponse = check graphqlClient->execute(doc2, {"id": "", "userId": "", "objectiveId": "", "value": "", "unit":""});
    

    //GetAllUsers() call
    string query = string 
    `query {
        getAllUsers {
            username
            password
            jobTitle
            position
            role
        }
    }`;

    Response getAllUsersResponse = check graphqlClient->execute(query, {});

    //GetAllObjectives() call
    string query1 = string 
    `query {
        getAllObjectives {
            id
            name
            weight
        }
    }`;

    Response getAllObjectivesResponse = check graphqlClient->execute(query1, {});
    
    //GetAllKPIs() call
    string query2 = string 
    `query {
        getAllKPIs {
            id
            userId
            objectiveId
            value
            unit
        }
    }`;

    Response getAllKPIsResponse = check graphqlClient->execute(query2, {});

    //GetKPIById() call
    string query3 = string 
    `query {
        getKPIById {
            id
            userId
            objectiveId
            value
            unit
        }
    }`;

    Response getKPIByIdResponse = check graphqlClient->execute(query3, {"id":""});

    //GetKPIById() call
    string query4 = string 
    `query {
        getKPIByUserId {
            id
            userId
            objectiveId
            value
            unit
        }
    }`;

    Response getKPIByuserIdResponse = check graphqlClient->execute(query4, {"userId":""});

    //GetKPIBySupervisor() call
    string query5 = string 
    `query {
        getKPIBySupervisor {
            supervisor
            id
            userId
            objectiveId
            value
            unit
        }
    }`;

    Response getKPIBySupervisorResponse = check graphqlClient->execute(query5, {"supervisor":""});





    //runs the mutation codes
    io:println("Response ", createUserResponse);
    io:println("Response ", createObjectiveResponse);
    io:println("Response ", createKPIResponse);

    //runs the first set of queries
    io:println("Response ", getAllUsersResponse);
    io:println("Response ", getAllObjectivesResponse);
    io:println("Response ", getAllKPIsResponse);

    //runs the second set of queries
    io:println("Response ", getKPIByIdResponse);
    io:println("Response ", getKPIByuserIdResponse);
    io:println("Response ", getKPIBySupervisorResponse);
}
