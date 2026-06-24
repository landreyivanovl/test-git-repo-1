public class DailyBirthdayEmailBatch implements Database.Batchable<SObject> {
  public DailyBirthdayEmailBatch() {
  }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    Date today = Date.today();
    Integer currentMonth = today.month();
    Integer currentDay = today.day();
    Integer currentYear = today.year();

    if (Date.isLeapYear(currentYear) && currentMonth == 2 && currentDay == 28) {
      return Database.getQueryLocator(
        [
          SELECT Id, Name, Email, Phone, Birthdate
          FROM Contact
          WHERE
            (CALENDAR_MONTH(Birthdate) = :currentMonth
            AND DAY_IN_MONTH(Birthdate) = :currentDay)
            OR (CALENDAR_MONTH(Birthdate) = 2
            AND DAY_IN_MONTH(Birthdate) = 29)
        ]
      );
    }

    return Database.getQueryLocator(
      [
        SELECT Id, Name, Email, Phone
        FROM Contact
        WHERE
          CALENDAR_MONTH(Birthdate) = :currentMonth
          AND DAY_IN_MONTH(Birthdate) = :currentDay
      ]
    );
  }

  public void execute(Database.BatchableContext bc, List<Contact> scope) {
    DailyBirthdayEmailService.sendEmail(scope);
  }

  public void finish(Database.BatchableContext bc) {
  }
}