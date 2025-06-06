@IsTest
public with sharing class CascadeforceTest {

    @TestSetup
    static void makeData(){
        // Create accounts to be parent of other accounts
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }

        insert accounts;

        List<Account> childAccounts = new List<Account>();
        for(Account acc : accounts) {
            for(Integer j = 0; j < 3; j++) {
                childAccounts.add(new Account(Name = 'Child Account ' + j + ' of ' + acc.Name, ParentId = acc.Id));
            }
        }

        insert childAccounts;
    }

    @IsTest
    static void testGetRelatedRecordsEmptyInput() {
        Test.startTest();
        List<Id> relatedRecords = Cascadeforce.getRelatedRecords(new List<Id>());
        Test.stopTest();
        System.assertEquals(0, relatedRecords.size(), 'Expected no related records for empty input');
    }

    @IsTest
    static void testGetRelatedRecords() {
        Test.startTest();
        List<Id> accountIds = new List<Id>();
        Integer childAccounts = 0;

        for(Account acc : [SELECT Id, ParentId FROM Account]) {
            if(acc.ParentId != null) {
                childAccounts++;
            }else{
                accountIds.add(acc.Id);
            }
        }

        System.assertNotEquals(0, accountIds.size(), 'Expected some parent accounts to be present');

        List<Id> relatedRecords = Cascadeforce.getRelatedRecords(accountIds);
        Test.stopTest();
        System.assertEquals(childAccounts, relatedRecords.size(), 'Expected some related records to be returned');
    }

    @IsTest
    static void testGetRelatedRecordsAccessLevel() {
        Test.startTest();
        List<Id> accountIds = new List<Id>();
        Integer childAccounts = 0;

        for(Account acc : [SELECT Id, ParentId FROM Account]) {
            if(acc.ParentId != null) {
                childAccounts++;
            }else{
                accountIds.add(acc.Id);
            }
        }

        System.assertNotEquals(0, accountIds.size(), 'Expected some parent accounts to be present');

        List<Id> relatedRecords = Cascadeforce.getRelatedRecords(accountIds, AccessLevel.SYSTEM_MODE);
        Test.stopTest();
        System.assertEquals(childAccounts, relatedRecords.size(), 'Expected some related records to be returned');
    }

        

    @IsTest
    static void testDeleteRelatedRecordsBasic() {
        Test.startTest();
        List<Id> accountIds = new List<Id>();
        List<Id> relatedRecords = new List<Id>();


        for(Account acc : [SELECT Id, ParentId FROM Account]) {
            if(acc.ParentId != null) {
                relatedRecords.add(acc.Id);
            }else{
                accountIds.add(acc.Id);
            }
        }

        System.assertNotEquals(0, relatedRecords.size(), 'Expected some parent accounts to be present');

        Cascadeforce.deleteRelatedRecords(accountIds);
        List<SObject> deletedRecords = [SELECT Id FROM Account WHERE Id IN :relatedRecords];

        Test.stopTest();
        System.assertEquals(0, deletedRecords.size(), 'Expected all related records to be deleted');
    }

    @IsTest
    static void testDeleteRelatedRecordsEmptyInput() {
        Test.startTest();
        List<Database.DeleteResult> relatedRecords = Cascadeforce.deleteRelatedRecords(new List<Id>());
        Test.stopTest();
        System.assertEquals(0, relatedRecords.size(), 'Expected no records to be deleted for empty input');
    }

    @IsTest
    static void testDeleteRElatedRecordsAllOrNone() {
        Test.startTest();
        List<Id> accountIds = new List<Id>();
        List<Id> relatedRecords = new List<Id>();

        for(Account acc : [SELECT Id, ParentId FROM Account]) {
            if(acc.ParentId != null) {
                relatedRecords.add(acc.Id);
            }else{
                accountIds.add(acc.Id);
            }
        }

        System.assertNotEquals(0, relatedRecords.size(), 'Expected some parent accounts to be present');
        // Delete related records with allOrNone set to false

        Cascadeforce.deleteRelatedRecords(accountIds, false);
        List<SObject> deletedRecords = [SELECT Id FROM Account WHERE Id IN :relatedRecords];
        Test.stopTest();

        System.assertEquals(0, deletedRecords.size(), 'Expected all related records to be deleted');
    }

    @IsTest
    static void testDeleteRelatedRecordsAccessLevel() {
        Test.startTest();
        List<Id> accountIds = new List<Id>();
        List<Id> relatedRecords = new List<Id>();

        for(Account acc : [SELECT Id, ParentId FROM Account]) {
            if(acc.ParentId != null) {
                relatedRecords.add(acc.Id);
            }else{
                accountIds.add(acc.Id);
            }
        }

        System.assertNotEquals(0, relatedRecords.size(), 'Expected some parent accounts to be present');
        
        // Delete related records with access level set to SYSTEM_MODE
        List<Database.DeleteResult> deleteResults = Cascadeforce.deleteRelatedRecords(accountIds, AccessLevel.SYSTEM_MODE);
        Test.stopTest();
        System.assertNotEquals(0, deleteResults.size(), 'Expected some delete results to be returned');
        List<SObject> deletedRecords = [SELECT Id FROM Account WHERE Id IN :relatedRecords];
        System.assertEquals(0, deletedRecords.size(), 'Expected all related records to be deleted');
    }
}