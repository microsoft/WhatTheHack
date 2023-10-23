import { app, InvocationContext } from '@azure/functions';
import { Document } from 'langchain/document';
import { RecursiveCharacterTextSplitter } from 'langchain/text_splitter';
import { v4 as uuidv4 } from 'uuid';

export async function azureBlobStoreMonitor(blob: Buffer, context: InvocationContext): Promise<void> {
  context.log(`Storage blob function processed blob "${context.triggerMetadata.documentFileName}" with size ${blob.length} bytes`);

  const blobAsString = blob.toString();

  console.log('blob Contents:');
  console.log(blobAsString);

  const splitter = new RecursiveCharacterTextSplitter({
    separators: ['\n\n'],
    chunkSize: 512,
    chunkOverlap: 0,
  });

  const documentMetadata = { filename: context.triggerMetadata.documentFileName };

  const document = new Document({ pageContent: blobAsString, metadata: documentMetadata });

  // Chunks of docs after splitting the blob chunks into reasonable chunks of smaller size
  const docOutput = await splitter.splitDocuments([document]);

  console.log('Displaying a total of ' + docOutput.length + ' chunks');

  for await (const currentDoc of docOutput) {
    // Dynamically generated guid that can be used to uniquely identify a document chunk
    const documentId = uuidv4();

    console.log(documentId);
    console.log(currentDoc);
    console.log(JSON.stringify(currentDoc));
  }
}

app.storageBlob('azure-blob-store-monitor', {
  path: 'contosodocuments/{documentFileName}',
  connection: 'CONTOSO_APP_STORAGE',
  handler: azureBlobStoreMonitor,
});
