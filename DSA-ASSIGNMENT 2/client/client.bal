import ballerina/graphql;
import ballerina/io;

type ProductResponse record {|
    record {|anydata dt;|} data;
|};

public function main() returns error? {
    graphql:Client graphqlClient = check new ("localhost:2120/onlineOrdering");

    string doc = string `
    mutation addProduct($id:String!,$name:String!,$price:Float!,$quantity:Int!){
        addProduct(newproduct:{id:$id,name:$name,price:$price,quantity:$quantity})
    }`;

    ProductResponse addProductResponse = check graphqlClient->execute(doc, {"id": "isaac", "name": "Isaacmakosa", "price": 20.21, "quantity": 21});

    io:println("Response ", addProductResponse);
}