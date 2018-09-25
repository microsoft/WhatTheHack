using System;

public static void Run(string queueItem, TraceWriter log, out string outputDocument)
{
    log.Info($"C# Queue trigger function processed: {queueItem}");

    outputDocument = queueItem;
}
