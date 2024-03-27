# Challenge 8: OMOP Analytics

[< Previous Challenge](./Challenge07.md) - **[Home](../README.md)**

## Introduction

*This section should provide an overview of the technologies or tasks that will be needed to complete the this challenge.  This includes the technical context for the challenge, as well as any new "lessons" the attendees should learn before completing the challenge.*

*Optionally, the coach or event host is encouraged to present a mini-lesson (with a PPT or video) to set up the context & introduction to each challenge. A summary of the content of that mini-lesson is a good candidate for this Introduction section*

*For example:*

In Healthcare data solutions (preview), the OMOP analytics capability facilitates the deployment of the Observational Medical Outcomes Partnership (OMOP) common data model (CDM) in the Fabric lakehouse environment. This deployment provides researchers within the OMOP community access to OneLake's expansive scale and the AI capabilities of the Fabric platform. The setup enables efficient and reliable execution of standardized analytics for patient and population-level observational studies.  The OMOP analytical capabilities empower researchers to perform comparative analyses, such as evaluating different procedures and drug exposures, or examining correlations between drug exposures and condition occurrences.

Below is the overview of the **[Healthcare data solution architecture](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/solution-architecture)**:
<center><img src="../images/challenge08-architecture.png" width="550"></center>

## Description

*This section should clearly state the goals of the challenge and any high-level instructions you want the students to follow. You may provide a list of specifications required to meet the goals. If this is more than 2-3 paragraphs, it is likely you are not doing it right.*

***NOTE:** Do NOT use ordered lists as that is an indicator of 'step-by-step' instructions. Instead, use bullet lists to list out goals and/or specifications.*

***NOTE:** You may use Markdown sub-headers to organize key sections of your challenge description.*

*Optionally, you may provide resource files such as a sample application, code snippets, or templates as learning aids for the students. These files are stored in the hack's \`Student/Resources\` folder. It is the coach's responsibility to package these resources into a Resources.zip file and provide it to the students at the start of the hack.*

***NOTE:** Do NOT provide direct links to files or folders in the What The Hack repository from the student guide. Instead, you should refer to the Resource.zip file provided by the coach.*

***NOTE:** As an exception, you may provide a GitHub 'raw' link to an individual file such as a PDF or Office document, so long as it does not open the contents of the file in the What The Hack repo on the GitHub website.*

***NOTE:** Any direct links to the What The Hack repo will be flagged for review during the review process by the WTH V-Team, including exception cases.*

*Sample challenge text for the IoT Hack Of The Century:*

In this challenge, you will [deploy]((https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy) your [Healthcare data solutions (preview)](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/overview)to the Fabric workspace and unlock the Healthcare data foundations capability. Once deployed, you can configure the system to align with the Observational Medical Outcomes Partnership (OMOP) community standards.  You'll use prebuilt pipelines to deploy the OMOP CDM to Fabric, and then utilize the provided notebooks to construct statistical models, conduct population distribution studies and utilize Power BI reports to visually compare various interventions and their effects on patient outcomes.

- **[Deploy Healthcare data solutions(preview) in Microsoft Fabric](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy)**

- **Prerequisites:**
- [Set up data connection using FHIR service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#use-fhir-service)
- [Setu up Azure Lanugage Service](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#set-up-azure-language-service)
- [Deploy the Healthcare data solutions in Microsoft Fabric via Azure Marketplace](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy#deploy-azure-marketplace-offer)

- **First, [Deploy Healthcare data foundations](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure#deploy-healthcare-data-foundations)**

- **[Deploy & configure FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure) to bring FHIR data from Azure Health Data Service (AHDS) FHIR service to OneLake.**

- **[Deploy & configure OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure) to prepare data for standardized analytics through Observational Medical Outcomes Partnership (OMOP) open community standards.**
  - [Configure the OMOP silver notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure#configure-the-omop-silver-notebook) to transform resources in the sliver lakehouse into OMOP common data model
  - [Configure the drug exposure era sample notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure#configure-the-drug-exposure-era-sample-notebook) to generate the drug_era table records in OMOP using the PySpark in notebook

  - [Configure the drug exposure insights sample notebook](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure#configure-the-drug-exposure-insights-sample-notebook) to demonstrate an exploratory analysis on the drug_era table using PySpark in notebook

- **[Use the OMOP analytics sample notebooks](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-sample-notebooks) to achieve visualtization after the data pipelines hydrate the FHIR clinical data in the silver and gold lakehouses, respectively.**


You can find a sample \`thingamajig.config\` file in the \`/ChallengeXX\` folder of the Resources.zip file provided by your coach. This is a good starting reference, but you will need to discover how to set exact settings.

Please configure the thingamajig with the following specifications:
- Use dynamic IP addresses
- Only trust the following whitelisted servers: "mothership", "IoTQueenBee" 
- Deny access to "IoTProxyShip"

You can view an architectural diagram of an IoT thingamajig here: [Thingamajig.PDF](/Student/Resources/Architecture.PDF?raw=true).

## Success Criteria
*Success criteria goes here. The success criteria should be a list of checks so a student knows they have completed the challenge successfully. These should be things that can be demonstrated to a coach.* 

*The success criteria should not be a list of instructions.*

*Success criteria should always start with language like: "Validate XXX..." or "Verify YYY..." or "Show ZZZ..." or "Demonstrate you understand VVV..."*

*Sample success criteria for the IoT sample challenge:*

To complete this challenge successfully, you should be able to:
- Verify that the IoT device boots properly after its thingamajig is configured.
- Verify that the thingamajig can connect to the mothership.
- Demonstrate that the thingamajic will not connect to the IoTProxyShip


## Learning Resources

_List of relevant links and online articles that should give the attendees the knowledge needed to complete the challenge._

*Think of this list as giving the students a head start on some easy Internet searches. However, try not to include documentation links that are the literal step-by-step answer of the challenge's scenario.*

***Note:** Use descriptive text for each link instead of just URLs.*

*Sample IoT resource links:*

- [What is Healthcare data solutions](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/overview)
- [Healthcare data soluton architecture overview](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/solution-architecture)
- [Deploy Healthcare data solutions](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/deploy)
- [Deploy and configure Healthcare data foundation](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/healthcare-data-foundations-configure)
- [Deploy and configure FHIR data ingestion](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/fhir-data-ingestion-configure)
- [Overview of OMOP analytics in Healthcare data solutions](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-overview)
- [Deploy and configure OMOP analytics](https://learn.microsoft.com/en-us/industry/healthcare/healthcare-data-solutions/omop-analytics-configure)
- 

## Tips

*This section is optional and may be omitted.*

*Add tips and hints here to give students food for thought. Sample IoT tips:*

- IoTDevices can fail from a broken heart if they are not together with their thingamajig. Your device will display a broken heart emoji on its screen if this happens.
- An IoTDevice can have one or more thingamajigs attached which allow them to connect to multiple networks.

## Advanced Challenges (Optional)

*If you want, you may provide additional goals to this challenge for folks who are eager.*

*This section is optional and may be omitted.*

*Sample IoT advanced challenges:*

Too comfortable?  Eager to do more?  Try these additional challenges!

- Observe what happens if your IoTDevice is separated from its thingamajig.
- Configure your IoTDevice to connect to BOTH the mothership and IoTQueenBee at the same time.
