
struct User {
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
    init(_ dictionary: [String: Any]) {
        self.userId = dictionary["userId"] as? Int ?? 0
        self.id = dictionary["id"] as? Int ?? 0
        self.title = dictionary["title"] as? String ?? ""
        self.completed = dictionary["completed"] as? Bool ?? false
    }
}



func userAPI () {
    //var userApiArray: [String: Any] = [:]
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
        do{
            //here dataResponse received from a network request
            let jsonResponse = try JSONSerialization.jsonObject(with:
                dataResponse, options: [])
            //print(jsonResponse) //Response result
            //print(type(of: jsonResponse))
            //userApiArray.append(jsonResponse)
            guard let jsonArray = jsonResponse as? [[String: Any]] else {
                return
            }
            print(jsonArray[0])
            
            //Now get title value
            guard let title = jsonArray[0]["title"] as? String else { return }
            print(title) // delectus aut autem
            
//            Currently, our JSON response is Array of Dictionary ([[String: Any]]). So we are taking Dictionary from every index of Array with the help of for loop. After getting Dictionary accessing values with the keys.
            for dic in jsonArray{
                guard let title = dic["title"] as? String else { return }
               // print(title) //Output
            }
            
            //add to model array
            var model = [User]() //Initialising Model Array
            for dic in jsonArray{
                model.append(User(dic)) // adding now value in Model array
            }
            print("------model-------")
            print(model[0].title) // 1211
            
            
            //flatmap
            var model2 = [User]()
            model2 = jsonArray.flatMap{ (dictionary) in
                return User(dictionary)
            }
            print("------model2-------")
            print(model2[0].title)
            
            var model3 = [User]()
            model3 = jsonArray.flatMap{ return User($0)}
            print("------model3-------")
            print(model3[0].title)
            
            //One more time
            var model4 = [User]()
            model4 = jsonArray.flatMap{User($0)}
            print("------model4-------")
            print(model4[0].title)
            
            //Or
            var model5 = [User]()
            model5 = jsonArray.compactMap(User.init)
            print("------model5-------")
            print(model5[0].title)

         
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    task.resume()
}

userAPI()


struct UserApiJsonCodable: Codable{
    var userId: Int
    var id: Int
    var title: String
    var completed: Bool
}

func userApiJsonCodable () {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos") else {return}
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
    guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
    
        do {
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            let model = try decoder.decode([UserApiJsonCodable].self, from: dataResponse) //Decode JSON Response Data
            print("---------Codable---------")
            print(model[0].title)
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    task.resume()
}

userApiJsonCodable()



struct Welcome: Codable {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

struct Geo: Codable {
    let lat, lng: String
}

struct Company: Codable {
    let name, catchPhrase, bs: String
}


func userApiJsonCodableClass () {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {return}
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let dataResponse = data,
            error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                return }
        
        do {
            //here dataResponse received from a network request
            let decoder = JSONDecoder()
            let model = try decoder.decode([Welcome].self, from:
                dataResponse) //Decode JSON Response Data
            print("---------CodableClass---------")
            print(model[0].website) //Output - 1221
        } catch let parsingError {
            print("Error", parsingError)
        }
    }
    task.resume()
}

userApiJsonCodableClass()
