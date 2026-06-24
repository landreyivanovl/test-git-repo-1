@IsTest
private class PaymentTriggerHandlerTest {
  @IsTest
  static void updateOpportunityStatusSuccessFullyTest() {
    Account acc = new Account(Name = 'Test');
    insert acc;

    Contact contact = new Contact(
      LastName = 'Test',
      AccountId = acc.Id,
      Email = 'test@gmail.com'
    );
    insert contact;

    Opportunity opp = new Opportunity(
      Name = 'Test Opp',
      StageName = 'Prospecting',
      CloseDate = Date.today(),
      Amount = 100
    );
    insert opp;

    OpportunityContactRole ocr = new OpportunityContactRole(
      OpportunityId = opp.Id,
      ContactId = contact.Id,
      Role = 'Decision Maker',
      IsPrimary = true
    );
    insert ocr;

    Payment__c payment = new Payment__c(
      Amount__c = 100,
      OpportunityName__c = 'Test Opp'
    );

    Test.startTest();
    insert payment;
    Test.stopTest();

    Opportunity udpOpp = [
      SELECT Payment_Status__c
      FROM Opportunity
      WHERE Name = 'Test Opp'
    ];
    System.Assert.areEqual('Fully Paid', udpOpp.Payment_Status__c);

    List<Task> tasks = [SELECT OwnerId FROM Task WHERE WhatId = :opp.Id];
    System.Assert.areEqual(1, tasks.size());
  }

  @IsTest
  static void updateOpportunityStatusSuccessPartTest() {
    Opportunity opp = new Opportunity(
      Name = 'Test Opp',
      StageName = 'Prospecting',
      CloseDate = Date.today(),
      Amount = 100
    );
    insert opp;

    Payment__c payment = new Payment__c(
      Amount__c = 50,
      OpportunityName__c = 'Test Opp'
    );

    Test.startTest();
    insert payment;
    Test.stopTest();

    Opportunity udpOpp = [
      SELECT Payment_Status__c
      FROM Opportunity
      WHERE Name = 'Test Opp'
    ];
    System.Assert.areEqual('Partially Paid', udpOpp.Payment_Status__c);
  }

  @IsTest
  static void updateOpportunityStatusFailTest() {
    try {
      Test.startTest();
      PaymentTriggerHandler.updateOpportunityStatus(null);
      Test.stopTest();
    } catch (Exception ex) {
      System.Assert.areNotEqual(null, ex.getMessage());
    }
  }
}