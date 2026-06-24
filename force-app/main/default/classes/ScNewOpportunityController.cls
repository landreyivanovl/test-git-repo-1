public class ScNewOpportunityController {
  @AuraEnabled
  public static void createOpportunity(String oppName, String oppAmount) {
    try {
      Decimal decimalAmount = Decimal.valueOf(oppAmount);
      String orderNumber = String.valueOf(
        ScNewOpportunityController.getRanodomNumber()
      );
      String trackNumber = String.valueOf(
        ScNewOpportunityController.getRanodomNumber()
      );

      Opportunity opp = new Opportunity(
        Name = oppName,
        Amount = decimalAmount,
        Type = 'New Customer',
        LeadSource = 'Partner Referral',
        OrderNumber__c = orderNumber,
        TrackingNumber__c = trackNumber,
        CloseDate = Date.today().addMonths(1),
        StageName = 'Prospecting',
        DeliveryInstallationStatus__c = 'In progress',
        OwnerId = UserInfo.getUserId()
      );

      insert opp;
    } catch (Exception insertEx) {
      throw new AuraHandledException('Internal server error');
    }
  }

  private static Integer getRanodomNumber() {
    return Math.round((Math.random() * (900000) + 100000));
  }
}