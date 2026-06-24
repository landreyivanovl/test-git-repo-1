public without sharing class ScLoginController {
  public class UserIsNotFoundException extends Exception {
  }

  @AuraEnabled
  public static Map<String, Object> checkCreds(
    String username,
    String password,
    String startUrl
  ) {
    Map<String, Object> loginResult = new Map<String, Object>();

    try {
      List<User> users = [
        SELECT Id, Username
        FROM User
        WHERE Username = :username
      ];

      if (users.isEmpty()) {
        throw new UserIsNotFoundException('user is not found');
      }

      PageReference res = Site.login(username, password, startUrl);

      loginResult.put('status', 'success');
      loginResult.put('pageRef', res.getUrl());
    } catch (Exception loginEx) {
      String errorMessage;
      if (loginEx instanceof UserIsNotFoundException) {
        errorMessage = loginEx.getMessage();
      } else if (loginEx instanceof SecurityException) {
        errorMessage = 'Invalid creeds. Check password';
      }
      loginResult.put('status', 'error');
      loginResult.put('errorMessage', errorMessage);
    }
    return loginResult;
  }
}