import Foundation

class Person: Codable {
    let name: String
    let films: [URL]
}


class Film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
}


class SwapiService {
    
    private static let baseURL = URL(string: "https://swapi.co/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let url = baseURL else { return completion(nil)}
        let finalURL = url.appendingPathComponent("people/\(id)")
        print(finalURL)
        // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error", error, error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                return completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error", error, error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil)}
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
    }
}

SwapiService.fetchPerson(id: 10) { person in
    if let person = person {
        print(person.name)
    }
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}

fetchFilm(url: URL(string: "https://swapi.co/api/films/1/")!)
