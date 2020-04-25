@isTest
public class MaintenanceRequestTest {
    @isTest
    public static void testForSingleUpdate() {
        Vehicle__c v = new Vehicle__c(Name='Some Name');
        insert v;
        
        Product2 p = new Product2(Name='Some Name', Maintenance_Cycle__c=10, Replacement_Part__c=TRUE);
        insert p;
        
        Product2 p1 = new Product2(Name='Some Name', Maintenance_Cycle__c=10, Replacement_Part__c=FALSE);
        insert p1;
        
        Case c = new Case(Vehicle__c=v.Id, Equipment__c=p1.Id, Type='Routine Maintenance', 
                          Subject='Some Subject', Date_Due__c=date.parse('05/06/2020'), 
                          Date_Reported__c=date.parse('04/04/2020'));
        insert c;
        
        Work_Part__c wp = new Work_Part__c(Equipment__c=p.Id, Maintenance_Request__c=c.Id);
        insert wp;
        
        c.Status = 'Closed';
        
        Test.startTest();
        Update c;
        Test.stopTest();
    }
    
    @isTest
    public static void testForBulkUpdate(){
        Vehicle__c v = new Vehicle__c(Name='Some Name');
        insert v;
        
        Product2 p = new Product2(Name='Some Name', Maintenance_Cycle__c=10, Replacement_Part__c=TRUE);
        insert p;
        
        Product2 p1 = new Product2(Name='Some Name', Maintenance_Cycle__c=10, Replacement_Part__c=FALSE);
        insert p1;
        
        List<Case> casesList = new List<Case>();
        
        for (Integer i = 0; i < 300; i++) {
            Case c = new Case(Vehicle__c = v.Id, Equipment__c = p1.Id, Type = 'Routine Maintenance', 
                                  Subject = 'Some Subject '+i, Date_Due__c = date.parse('05/06/2020'), 
                                  Date_Reported__c = date.parse('04/04/2020'));
                casesList.add(c);
        }
        insert casesList;
        
        List<Work_Part__c> workPartsList = new List<Work_Part__c>();
        
        casesList = [SELECT id FROM Case LIMIT 300];
        
        for (Case caseLooper : casesList) {
             Work_Part__c wp = new Work_Part__c(Equipment__c=p.Id, Maintenance_Request__c=caseLooper.Id);
             workPartsList.add(wp);
        }
        insert workPartsList;
        
        for (Case caseLooper : casesList) {
            caseLooper.Status = 'Closed';
        }
        
        Test.startTest();
        Update casesList;
        Test.stopTest();
    }
}