//
//  APIService.swift
//  DI
//
//  Created by Rehnuma Reza(Deepty) on 6/2/25.
//

public struct Disease: Codable {
    var cases: [String: Int]
}

public class APIService {
    public static let shared = APIService()

    public func fetchDiseaseData(completion: @escaping ([String: Int])-> Void) async {
        let urlString = "https://disease.sh/v3/covid-19/historical/all?lastdays=all"
        
        guard let url = URL(string: urlString) else {
            completion([:])
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let diseaseData = try JSONDecoder().decode(Disease.self, from: data).cases
            completion(diseaseData)
        } catch {
            completion([:])
            print("Error fetching data: \(error.localizedDescription)")
        }

    }
}
 
