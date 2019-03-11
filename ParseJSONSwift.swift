import UIKit
import Foundation

//модель декодирования JSON
struct TestProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}


func jsonMyDecoe() {
    
    //son в виде переменной
    let jsonMyTest = """
{
    "name": "Durian",
    "points": 600,
    "description": "A fruit with a distinctive scent."
}
""".data(using: .utf8)!
    
    
    let decoder = JSONDecoder()
    //let product = try decoder.decode(GroceryProduct.self, from: jsonMyTest)
    do {
        let product = try decoder.decode(TestProduct.self, from: jsonMyTest)
        print(product)
        print(product.name)
    } catch let error {
        print(error)
    }
    
}

jsonMyDecoe()
var fff = TestProduct(name: "DevData", points: 1001000, description: "DevData is a beast")
fff.points



//пример с сериализацией JSON и запроса из вешних данных, ссылка может быть любой только нужно задать модель

func testSession () {
    
    let urlString = "https://jsonplaceholder.typicode.com/todos"
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        //если наша data = data то мы продолжаем работу в противном случае мы завершаем работу метода
        guard let data = data else {return}
        //если наш еrror равен nil то мы продолжаем работу, в противном случае мы завершаем работу метода
        guard error == nil else {return}
        
        //деокдируем наш приходящий JSON, требует проверки через do try, принцип декодирования берем из нашей модели структуры например: TestProduct
        do {
            let myUsers = try JSONDecoder().decode(TestProduct.self, from: data)
        } catch let error {
            print(error)
        }
        }.resume()
    
}

//пример GET запроса и получения ответа
func getForWeb () {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
    let session = URLSession.shared
    session.dataTask(with: url) { (data, response, error) in 
        if let response = response {
            print(response)
        }
        guard let data = data else {return}
        print(data)
        do {
                let json = try JSONSerialization().jsonObject(with: data, options: [])
                print(json)
            } catch  {
                print(error)
            }
    }.resume()   
}


//пример POST запроса 
func postForWeb () {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
    let parameters = ["username": "Kolya", "message": "Hello Ivan"]
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}
    request.httpBody = httpBody
    let session = URLSession.shared
    session.dataTask(with: request) { (data, response, error) } in 
        if let response = response {
            print(response)
        }

        guard let data = data else {return}
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
        } catch {
            print(error)
        }
    }.resume() 
}

