#Выборка рабочих процессов по всем элементам списка 
Foreach($item In $itemListColletcion)
{
	Foreach($workflow in $item.Workflows)
	{
	…
}
}

#Получение рабочих процессов через класс SpWorkflowCollection
function GetWorkflow ($list, $wfItemID, $wfInstanceID) {
$object = $list;
 	$item = GetSPListItem -list $list -itemId $wfItemID;
if($item -ne $null)
{
$object = $item
}
$workflow = GetWorkflowByInstanceID -object $object -instanceId $wfInstanceID;
return $workflow
}
function GetWorkflowByInstanceID ($object, $instanceId) {
	$workflow = $null;	
	$workflowCollections = [Microsoft.SharePoint.Workflow.SpWorkflowCollection]$object;
	$workflow = $workflowCollections[$instanceId];
    return $workflow;
}

#Отмена рабочего процесса через класс SpWorkflowManager, метод CancelWorkflow()
[Microsoft.SharePoint.Workflow.SpWorkflowManager]::CancelWorkflow($workflow)

#Запуск рабочего процесса через класс SpWorkflowManager, метод StartWorkflow()
$wfAssociation = $item.ContentType.WorkflowAssociations | Where-Object{$_.Name -eq $wfParamsBefore.ParentAssociationName };
$newWF = $site.WorkflowManager.StartWorkflow($item, $wfAssociation, $wfAssociation.AssociationData, $true);


