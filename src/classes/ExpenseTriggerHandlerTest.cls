/**
 * Created by Michael Pugach on 25/10/2023.
 */

@IsTest
private class ExpenseTriggerHandlerTest {
	private static final Integer NUMBER_OF_RECORDS = 50;

	@TestSetup
	static void setup() {
		Accounting_for_Expenses_and_Income__c accountingForExpensesAndIncome = new Accounting_for_Expenses_and_Income__c();
		accountingForExpensesAndIncome.Name = 'October 2023';
		accountingForExpensesAndIncome.All_Income__c = 100;
		accountingForExpensesAndIncome.All_Expenses__c = 20;
		accountingForExpensesAndIncome.CurrencyIsoCode = 'USD';
		accountingForExpensesAndIncome.Date_Period__c = Date.newInstance(2023, 10, 10);
		insert accountingForExpensesAndIncome;

		List<Expense__c> expenses = new List<Expense__c>();
		for (Integer i = 0; i < NUMBER_OF_RECORDS; i++) {
			expenses.add(new Expense__c(
				Accounting_for_Expenses__c = accountingForExpensesAndIncome.Id,
				Amount__c = 1,
				Currency__c = 'USD',
				Category__c = 'Car',
				Date_of_Payment__c = Date.newInstance(2023, 10, 15)
			));
		}
		insert expenses;
	}

	@IsTest
	static void deleteExpense() {
		Expense__c expense = [
			SELECT Id
			FROM Expense__c
			LIMIT 1
		];
		delete expense;

		List<Expense__c> expenses = [
			SELECT Id
			FROM Expense__c
		];

		Assert.areEqual(49, expenses.size());

		undelete expense;

		expenses = [
			SELECT Id
			FROM Expense__c
		];

		Assert.areEqual(50, expenses.size());
	}

	@IsTest
	static void updateExpenses() {
		Expense__c expense = [
			SELECT Category__c, Amount__c
			FROM Expense__c
			LIMIT 1
		];

		expense.Category__c = 'Cat';
		expense.Amount__c = 2;

		update expense;

		Assert.areEqual(2, expense.Amount__c);

		Accounting_for_Expenses_and_Income__c accountingForExpensesAndIncome = [
			SELECT Balance__c
			FROM Accounting_for_Expenses_and_Income__c
			LIMIT 1
		];

		Assert.areEqual(accountingForExpensesAndIncome.Balance__c, 49);
	}
}