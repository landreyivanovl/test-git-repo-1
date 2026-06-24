public with sharing class OpportunityEmailService implements Messaging.InboundEmailHandler {
  public class opportunityNotFoundException extends Exception {
  }

  public Messaging.InboundEmailResult handleInboundEmail(
    Messaging.inboundEmail email,
    Messaging.InboundEnvelope env
  ) {
    Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
    try {
      String subject = email.subject.replace('Re: ', '');
      String body = email.plainTextBody;
      Opportunity opp = [
        SELECT StageName
        FROM Opportunity
        WHERE Invoice_Number__c = :subject
      ];

      if (body.containsIgnoreCase('Approved')) {
        opp.StageName = DefineStage(opp.StageName);
      }

      if (body.containsIgnoreCase('Rejected')) {
        opp.StageName = 'Closed Lost';
      }

      update opp;
      result.success = true;
      return result;
    } catch (Exception noOpportunityEx) {
      result.success = false;
      result.message = 'Error parsing email: ' + noOpportunityEx.getMessage();
      return result;
    }
  }

  private static String DefineStage(String stage) {
    List<String> stages = new List<String>();

    Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

    for (Schema.PicklistEntry entry : ple) {
      stages.add(entry.getLabel());
    }

    Integer currntIndex = stages.indexOf(stage);

    if (currntIndex == stages.size() - 1) {
      return 'Closed Lost';
    } else {
      return stages[currntIndex + 1];
    }
  }
}