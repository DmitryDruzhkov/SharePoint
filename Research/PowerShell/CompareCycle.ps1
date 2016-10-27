#Задаём пустые массивы для хранения WorkFlows
[array]$wfCollection_ForeachObj = $null;
[array]$wfCollection_Foreach = $null;
[array]$wfCollection_Where_Obj = $null;
[array]$wfCollection_Where = $null;
[array]$wfCollection_For = $null;

#Получаем WorkFlows 
$time_Where_Obj = (Measure-Command {
	$wfCollection_Where_Obj = [Microsoft.SharePoint.Workflow.SpWorkflowCollection]$list | Where-Object {($_.InternalState -band 66) -eq 66};
}).TotalMilliseconds

$time_Where = (Measure-Command {
	$wfCollection_Where = [Microsoft.SharePoint.Workflow.SpWorkflowCollection]$list | Where {($_.InternalState -band 66) -eq 66};
}).TotalMilliseconds

$time_ForeachObj = (Measure-Command {
	[Microsoft.SharePoint.Workflow.SpWorkflowCollection]$list | ForEach-Object {
		if(($_.InternalState -band 66) -eq 66)
		{
			$wfCollection_ForeachObj += $_;
		}
	}
}).TotalMilliseconds

$time_Foreach = (Measure-Command {
	ForEach ($wf in [Microsoft.SharePoint.Workflow.SpWorkflowCollection]$list) 
	{
		if(($wf.InternalState -band 66) -eq 66)
		{
			$wfCollection_Foreach += $wf;
		}
	}
}).TotalMilliseconds

$time_For = (Measure-Command {
	$wfObj = [Microsoft.SharePoint.Workflow.SpWorkflowCollection]$list;
	$wfObjCount = $wfObj.Count;
	
	For ($i = 0; $i -lt $wfObjCount; $i++) 
	{
		if(($wfObj[$i].InternalState -band 66) -eq 66)
		{
			$wfCollection_For += $wfObj[$i];
		}
	}
}).TotalMilliseconds

#Создаём объекты для хранения результатов
$whereObj = [pscustomobject]@{
	Type = 'Where-Object'
	Time_ms = $time_Where_Obj
	Count = $wfCollection_Where_Obj.Count
}

$where = [pscustomobject]@{
	Type = 'Where'
	Time_ms = $time_Where
	Count = $wfCollection_Where.Count
}

$ForeachObj = [pscustomobject]@{
	Type = 'ForEach-Object'
	Time_ms = $time_ForeachObj
	Count = $wfCollection_ForeachObj.Count
}

$forch = [pscustomobject]@{
	Type = 'ForEach'
	Time_ms = $time_Foreach
	Count = $wfCollection_Foreach.Count
}

$for = [pscustomobject]@{
	Type = 'For'
	Time_ms = $time_For
	Count = $wfCollection_For.Count
}

#Выводим результат
Write-Host($whereObj);
Write-Host($where);
Write-Host($ForeachObj);
Write-Host($forch);
write-host($for);
Write-Host("Итог?");