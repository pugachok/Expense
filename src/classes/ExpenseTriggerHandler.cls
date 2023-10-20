/**
 * Created by Michael on 18.02.2023.
 */
public class ExpenseTriggerHandler implements TriggerHandler {

    private final Boolean triggerIsExecuting;
    private final Integer triggerSize;
    public ExpenseTriggerHelper helper;

    public ExpenseTriggerHandler(Boolean triggerIsExecuting, Integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
        this.helper = new ExpenseTriggerHelper();
    }

    public void beforeInsert(List<Expense__c> newExpenses) {
        helper.setAccounting(newExpenses);
    }

    public void beforeUpdate(List<Expense__c> oldExpenses, List<Expense__c> newExpenses, Map<Id, SObject> oldExpenseMap, Map<Id, SObject> newExpenseMap) {
    }

    public void beforeDelete(List<Expense__c> oldExpenses, Map<Id, SObject> oldExpenseMap) {
    }

    public void afterInsert(List<Expense__c> newExpenses, Map<Id, SObject> newExpenseMap) {
        helper.recalculateExpenses(null, newExpenses, null, newExpenseMap);
    }

    public void afterUpdate(List<Expense__c> oldExpenses, List<Expense__c> newExpenses, Map<Id, SObject> oldExpenseMap, Map<Id, SObject> newExpenseMap) {
        helper.recalculateExpenses(oldExpenses, newExpenses, oldExpenseMap, newExpenseMap);
    }

    public void afterDelete(List<Expense__c> oldExpenses, Map<Id, SObject> oldExpenseMap) {
        helper.recalculateExpenses(oldExpenses, null, oldExpenseMap, null);
    }

    public void afterUndelete(List<Expense__c> newExpenses, Map<Id, SObject> newExpenseMap) {
        helper.recalculateExpenses(null, newExpenses, null, newExpenseMap);
    }
}