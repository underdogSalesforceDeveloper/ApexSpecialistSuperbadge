// Process designed to work for both single maintenance requests and bulk requests

public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> casesListToProcess) {
        
        // Apply criterias to the list received and get a reduced list 
        List<Case> casesFilteredList = [SELECT Id, Vehicle__c, Equipment__c 
                                        FROM Case 
                                        WHERE Id IN :casesListToProcess
                                        AND Status = 'Closed' AND (Type = 'Repair' OR Type = 'Routine Maintenance')];
        
        // For each Maintenance Request, get only the Work Part with the lowest Maintenance Cycle (Decimal)
        // Maintenance Request 1----∞ Work Part
        AggregateResult[] workPartsList = [SELECT Maintenance_Request__c, MIN(Equipment__r.Maintenance_Cycle__c)min
                                            FROM Work_Part__c 
                                            WHERE Maintenance_Request__c IN :casesFilteredList
                                            GROUP BY Maintenance_Request__c];
        
        // Put the results of the list into a map with the Maintenance Request as the map key
        Map<Id,Decimal> workPartsMap = new Map<Id,Decimal>();
        
        for (AggregateResult ar : workPartsList){
            workPartsMap.put((Id)ar.get('Maintenance_Request__c'),(Decimal)ar.get('min'));
        }
        
        List<Case> casesInsertList = new List<Case>();
        
        if(casesFilteredList.size() > 0){
            // Loop through the reduced list, and create a Maintenance Request (Case) for each list member
            for (Case cLooper : casesFilteredList){
                Integer daysInCycle = 0;
				
                if(workPartsMap.containsKey(cLooper.Id)){
                    daysInCycle = workPartsMap.get(cLooper.Id).intValue();
                }
                 
                Case c = new Case();
				Date dateToday = System.today();
                c.Vehicle__c = cLooper.Vehicle__c;
                c.Equipment__c = cLooper.Equipment__c;
                c.Type = 'Routine Maintenance';
                c.Subject = 'Some Subject';
                c.Date_Due__c = dateToday.AddDays(daysInCycle);
                c.Date_Reported__c = dateToday;
                
                casesInsertList.add(c);
            }
            
            if (casesInsertList.size() > 0) {
                insert casesInsertList;
            } 
        }
    }          
}