One day I realized that I was spending a lot of money without any purpose. I started studying financial literacy and the first step was keeping records of expenses and income. I tried maintaining an Excel spreadsheet and using thematic applications from the AppStore. But the best solution was to write your own architecture using Salesforce.
The application implements the logic for accounting expenses and income using SFDC trigger framework.

**Overview**

Triggers should (IMO) be logicless. Putting logic into your triggers creates un-testable, difficult-to-maintain code. It's widely accepted that a best-practice is to move trigger logic into a handler class.

This trigger framework bundles a single TriggerHandler base class that you can inherit from in all of your trigger handlers. The base class includes context-specific methods that are automatically called when a trigger is executed.

The base class also provides a secondary role as a supervisor for Trigger execution. It acts like a watchdog, monitoring trigger activity and providing an api for controlling certain aspects of execution and control flow.

But the most important part of this framework is that it's minimal and simple to use.
