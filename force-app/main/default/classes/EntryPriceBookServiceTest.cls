@isTest
private class EntryPriceBookServiceTest {
  @IsTest
  static void testEntryPriceBookServiceSuccess() {
    Product2 product = new Product2(Name = 'Test Product', IsActive = true);
    insert product;

    Id stdPricebookId = Test.getStandardPricebookId();
    Pricebook2 standardPb = new Pricebook2(
      Id = stdPricebookId,
      IsActive = true
    );
    update standardPb;

    Test.startTest();
    EntryPriceBookService.EntryPriceBookService();
    Test.stopTest();

    List<PricebookEntry> createdEntries = [
      SELECT Id
      FROM PricebookEntry
      WHERE Pricebook2Id = :stdPricebookId
    ];
    Assert.areEqual(1, createdEntries.size());
  }

  @IsTest
  static void testEntryPriceBookServiceFail() {
    Test.startTest();
    try {
      EntryPriceBookService.EntryPriceBookService();
    } catch (Exception failCreateEx) {
      Assert.areNotEqual(null, failCreateEx.getMessage());
    }
    Test.stopTest();
  }
}