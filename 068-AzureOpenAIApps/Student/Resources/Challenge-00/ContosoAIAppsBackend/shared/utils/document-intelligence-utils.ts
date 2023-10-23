import { AzureKeyCredential } from '@azure/core-auth';
import {
  AnalyzedDocument,
  AnalyzeDocumentOptions,
  AnalyzeResult,
  DocumentAnalysisClient,
  DocumentAnalysisPollOperationState,
  DocumentField,
  DocumentStringField,
  FormRecognizerRequestBody,
} from '@azure/ai-form-recognizer';
import { PollerLike } from '@azure/keyvault-secrets';

export interface DocumentClassificationResult {
  docType: string;
  pageNumbers: string;
  classificationConfidence: number;
}

export interface FormDocumentFields {
  [field: string]: DocumentField;
}
export interface FormRecognitionResultRecord {
  ResultId?: number;
  DocumentId: number;
  ModelId: string;
  ModelDocumentType: string;
  Confidence: number;
  ApiVersion: string;
  RawResults: string;
  Contents: string;
  FieldNames: string;
  RawFields: string;
  ExtractedFields: string;
  TargetPages?: string;
  ClassificationDocType?: string;
  ClassificationConfidence?: number;
}

export interface FormRecognitionResult {
  ModelId: string;
  ModelDocumentType: string;
  Confidence: number;
  ApiVersion: string;
  RawResults: { [p: string]: any };
  Contents: string;
  FieldNames: string[];
  RawFields: { [p: string]: any };
  ExtractedFields: { [p: string]: string };
  ClassificationDocType?: string;
  ClassificationConfidence?: number;
  TargetPages?: string;
}

export interface ExtractionMetadata {
  extractionList: object[];
}

export class FormRecognizerUtils {
  private readonly documentAnalysisClient: DocumentAnalysisClient;

  private azureRecognizerEndpoint: string;

  private azureFormRecognizerKey: string;

  public constructor(azureRecognizerEndpoint: string, azureFormRecognizerKey: string) {
    // Retrieve the Form Recognizer Endpoint
    this.azureRecognizerEndpoint = azureRecognizerEndpoint;

    // Retrieve the Form Recognizer Keys
    this.azureFormRecognizerKey = azureFormRecognizerKey;

    // Set up the Credential object
    const credential: AzureKeyCredential = new AzureKeyCredential(azureFormRecognizerKey);

    // Initialize the DocumentAnalysisClient
    this.documentAnalysisClient = new DocumentAnalysisClient(azureRecognizerEndpoint, credential);
  }

  /**
   * Extract Document Fields
   *
   * It accepts a string representing the model identifier as well as the contents of the file we are analyzer.
   *
   * The file is a request input that can be uploaded as binary data to the Form Recognizer service.
   *
   * Form Recognizer treats string inputs as URLs, so to send a string as a binary input, first convert the string to one of the following input types:
   *  - NodeJS.ReadableStream
   *  - Blob
   *  - ArrayBuffer
   *  - ArrayBufferView
   *
   * The file needs to be one of the following formats:
   * - pdf
   * - jpeg
   * - png
   * - tiff
   *
   * @param azureFormRecognizerModelIdentifier - the model id
   * @param file - the content of the file
   * @param pagesToConsider - the pages to extract
   */
  public async extractDocument(
    azureFormRecognizerModelIdentifier: string,
    file: FormRecognizerRequestBody,
    pagesToConsider: string,
    classificationDocType?: string,
    classificationConfidence?: number
  ) {
    const options: AnalyzeDocumentOptions = { pages: pagesToConsider };
    // Create a poller instance
    const poller: PollerLike<DocumentAnalysisPollOperationState<AnalyzeResult<AnalyzedDocument>>, AnalyzeResult<AnalyzedDocument>> = await this.documentAnalysisClient.beginAnalyzeDocument(
      azureFormRecognizerModelIdentifier,
      file,
      options
    );

    // Retrieve the analyzed results
    const analyzedDocument: AnalyzeResult<AnalyzedDocument> = await poller.pollUntilDone();

    const result = analyzedDocument;

    const extractedFields = this.getExtractedFields(result);
    const fieldNames = this.getFieldNames(result);
    const rawFields = this.getRawFields(result);
    const document = this.getFirstDocument(result);

    const finalResult: FormRecognitionResult = {
      ApiVersion: analyzedDocument.apiVersion,
      Contents: analyzedDocument.content,
      ExtractedFields: extractedFields,
      FieldNames: fieldNames,
      ModelId: analyzedDocument.modelId,
      RawFields: rawFields,
      RawResults: result,
      Confidence: document.confidence,
      ModelDocumentType: document.docType,
      ClassificationDocType: classificationDocType,
      ClassificationConfidence: classificationConfidence,
      TargetPages: pagesToConsider,
    };

    return finalResult;
  }

  protected getExtractedFields(rawResults: AnalyzeResult<AnalyzedDocument>) {
    const fieldNames = this.getFieldNames(rawResults);
    let i = 0;

    const extractedFields: { [p: string]: string } = {};
    const rawFields = this.getRawFields(rawResults);

    for (i = 0; i < fieldNames.length; i++) {
      const currentFieldName = fieldNames[i];
      const currentRawField = rawFields[currentFieldName];
      const currentFieldValue = this.extractFieldContent(currentRawField);
      extractedFields[currentFieldName] = currentFieldValue;
    }

    return extractedFields;
  }

  protected getFirstDocument(rawResults: AnalyzeResult<AnalyzedDocument>) {
    return rawResults.documents[0];
  }

  protected getFieldNames(rawResults: AnalyzeResult<AnalyzedDocument>) {
    const fields = rawResults.documents[0].fields;
    return Object.keys(fields);
  }

  protected getRawFields(rawResults: AnalyzeResult<AnalyzedDocument>) {
    return rawResults.documents[0].fields;
  }

  protected extractFieldContent(field: DocumentField) {
    const fieldItem = field as DocumentStringField;

    if (fieldItem.value) {
      return fieldItem.value;
    } else if (fieldItem.content) {
      return fieldItem.content;
    } else {
      return null;
    }
  }

  public async classifyBuffer(classifierIdentifier: string, file: FormRecognizerRequestBody) {
    const poller = await this.documentAnalysisClient.beginClassifyDocument(classifierIdentifier, file);

    const result = await poller.pollUntilDone();

    const classificationResults: DocumentClassificationResult[] = [];
    const docs = result.documents;
    const numberOfDocuments = docs.length;
    let i = 0;
    let j = 0;

    for (i = 0; i < numberOfDocuments; i++) {
      const currentDocumentResult: AnalyzedDocument = docs[i];
      const documentType = currentDocumentResult.docType;
      const confidenceScore: number = currentDocumentResult.confidence;
      const resultPageNumbers: number[] = [];

      for (j = 0; j < currentDocumentResult.boundingRegions.length; j++) {
        const boundingRegion = currentDocumentResult.boundingRegions[j];
        const pageNumber = boundingRegion.pageNumber;
        resultPageNumbers.push(pageNumber);
      }

      const finalPageNumbers = resultPageNumbers.join(',');
      // Current Result Set
      const currentResult: DocumentClassificationResult = { docType: documentType, pageNumbers: finalPageNumbers, classificationConfidence: confidenceScore };

      // Append to the List of Results
      classificationResults.push(currentResult);
    }

    return classificationResults;
  }
}
