/**
 * Created by Michael on 20/10/2023.
 */

public class ExpenseTriggerHelper {
	public void setAccounting(List<Expense__c> newExpenses) {
		List<Expense__c> expenses = newExpenses;
		List<Expense__c> expensesToUpdate = new List<Expense__c>();

		for (Expense__c expense : expenses) {
			expense.Amount__c = expense.Amount__c;
			if (expense.Accounting_for_Expenses__c == null) {
				expensesToUpdate.add(expense);
			}
		}

		Date startRangeDate;
		Date endRangeDate;
		Integer startDate = Date.today().day();
		if (startDate >= 10) {
			startRangeDate = Date.newInstance(Date.today().year(), Date.today().month(), 10);
			endRangeDate = startRangeDate.addMonths(1);
		} else {
			startRangeDate = Date.newInstance(Date.today().year(), Date.today().month() - 1, 10);
			endRangeDate = startRangeDate.addMonths(1);
		}

		List<Accounting_for_Expenses_and_Income__c> accountingForExpensesAndIncomes = [
			SELECT Id
			FROM Accounting_for_Expenses_and_Income__c
			WHERE Date_Period__c >= :startRangeDate
			AND Date_Period__c <= :endRangeDate
			ORDER BY Date_Period__c DESC
			LIMIT 1
		];

		if (!accountingForExpensesAndIncomes.isEmpty()) {
			for (Expense__c expense : expensesToUpdate) {
				expense.Accounting_for_Expenses__c = accountingForExpensesAndIncomes[0].Id;
			}
		}
	}

	public void recalculateExpenses(List<Expense__c> oldExpenses, List<Expense__c> newExpenses, Map<Id, SObject> oldExpenseMap, Map<Id, SObject> newExpenseMap) {
		Set<Id> accountingToRecalculate = new Set<Id>();
		List<Expense__c> expenses = Trigger.isDelete ? oldExpenses : newExpenses;

		for (Expense__c expense : expenses) {
			Expense__c oldExpense = ((Expense__c)oldExpenseMap?.get(expense.Id));

			accountingToRecalculate.add(expense.Accounting_for_Expenses__c);
			if (oldExpense != null) {
				accountingToRecalculate.add(oldExpense.Accounting_for_Expenses__c);
			}
		}

		List<Accounting_for_Expenses_and_Income__c>  accountingForExpensesAndIncomes = [
			SELECT All_Expenses__c,
			(
				SELECT convertCurrency(Amount__c), Currency__c
				FROM Expenses__r
			)
			FROM Accounting_for_Expenses_and_Income__c
			WHERE Id IN :accountingToRecalculate
		];

		for (Accounting_for_Expenses_and_Income__c accountingForExpensesAndIncome : accountingForExpensesAndIncomes) {
			Decimal sumOfExpenses = 0;
			for (Expense__c expense : accountingForExpensesAndIncome.Expenses__r) {
				sumOfExpenses += expense.Amount__c;
			}
			accountingForExpensesAndIncome.All_Expenses__c = sumOfExpenses;
		}

		update accountingForExpensesAndIncomes;
	}
}