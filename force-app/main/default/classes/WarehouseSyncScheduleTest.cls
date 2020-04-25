@isTest
public class WarehouseSyncScheduleTest {
    @IsTest
    static void testScheduledJob(){
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        Test.startTest();
            String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new WarehouseSyncSchedule());    
        Test.stopTest();   
    }
}