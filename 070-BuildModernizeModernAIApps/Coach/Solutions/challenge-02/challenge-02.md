# Solution for Challenge 02

[Watch the Train the Trainer video for Challenge 2](https://aka.ms/vsaia.hack.ttt.02)
[Deck for the Challenge](Challenge%202.pptx)

1. `CosmosDbService.cs`

The list of monitored containers is provided in configuration and is mapped to `_settings.MonitoredContainers`.

Use `monitoredContainerName` as the name of the iteration variable.

Following the instructions in the note, also add `.WithStartTime(DateTime.MinValue.ToUniversalTime())`.
