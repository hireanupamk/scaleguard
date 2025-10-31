/**
 * @description Trigger for Account object that uses ScaleGuard orchestrator
 * @author ScaleGuard Team
 */
trigger AccountTrigger on Account (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    
    // Determine the trigger event type
    String triggerEvent = '';
    if(Trigger.isBefore && Trigger.isInsert) {
        triggerEvent = 'Before Insert';
    } else if(Trigger.isAfter && Trigger.isInsert) {
        triggerEvent = 'After Insert';
    } else if(Trigger.isBefore && Trigger.isUpdate) {
        triggerEvent = 'Before Update';
    } else if(Trigger.isAfter && Trigger.isUpdate) {
        triggerEvent = 'After Update';
    } else if(Trigger.isBefore && Trigger.isDelete) {
        triggerEvent = 'Before Delete';
    } else if(Trigger.isAfter && Trigger.isDelete) {
        triggerEvent = 'After Delete';
    } else if(Trigger.isAfter && Trigger.isUndelete) {
        triggerEvent = 'After Undelete';
    }
    
    // Execute the orchestrator
    ScaleGuard_TriggerOrchestrator.executeTrigger(Trigger.Context, 'Account', triggerEvent);
}
