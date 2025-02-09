//
//  DiseaseDataViewModel.swift
//  DI
//
//  Created by Rehnuma Reza(Deepty) on 6/2/25.
//

class DiseaseDataViewModel {
    var diseaseFetchable: DiseaseDataFetchable!
    var diseaseCases: [String: Int] = [:]
    var yearToCasesMap: [String: Int] = [:]
    
    func prepareData() async {
        await diseaseFetchable.fetchDiseaseData { [weak self] cases in
            guard let self else { return }
            
            DispatchQueue.main.async {
                self.diseaseCases = cases
                self.mapCasesToYears()
                print(cases.keys.count)
            }
        }
    }
    
    func mapCasesToYears() {
        diseaseCases.forEach { key, value in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/YY"

            if let date = dateFormatter.date(from: key) {
                let dateComponents = Calendar.current.dateComponents([.year], from: date)
                if let year = dateComponents.year {
                    if let val = yearToCasesMap[String(year)] {
                        yearToCasesMap[String(year)] = val + value
                    } else {
                        yearToCasesMap[String(year)] = value;
                    }
                }
            }
        }
        
        print("MapTo year: \(yearToCasesMap)")
    }
}
