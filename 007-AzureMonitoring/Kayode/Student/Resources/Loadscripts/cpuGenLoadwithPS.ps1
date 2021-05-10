$NumberofProcs = (Get-WMIObject win32_processor | Measure-Object NumberofLogicalProcessors -sum).sum
#Updated based on anonymous feedback.
$NumberofProcs= [int]$env:Number_of_Processors
While ($NumberofProcs -ne 0) 
{
    $NumberofProcs--
    Start-Process Powershell.exe -ArgumentList '"foreach ($loopnumber in 1..2147483647) {$result=1;foreach ($number in 1..2147483647) {$result = $result * $number};$result}"'
}