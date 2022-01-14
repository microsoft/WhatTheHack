using System;
using FineCollectionService.Models;

namespace FineCollectionService.Helpers
{
    public class EmailUtils
    {
        public static string CreateEmailBody(
            SpeedingViolation speedingViolation, 
            VehicleInfo vehicleInfo, 
            string fine)
        {
            return $@"
                <html>
                    <head>
                        <style>
                            body {{
                                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                            }}
                            table {{ 
								text-align: left;
								padding-top: 10px;
                            }}
                            th {{
								width: 200px;
								padding-left: 10px;
								background-clip: content-box;
                                background-color: #EEEEEE;
								font-weight: normal;
                            }}
							td {{
								padding: 5px;
								width: 300px;
                                border: 1px solid black;
							}}
							.fine {{
								font-weight: bold;
								color: #FF0000;
							}}
							.logo {{
								float: left;
								display: block;
								margin-top: -15px;
							}}
							.title {{
								display: block;
							}}
							.logo-name {{
								color: #FFFFFF;
								background-color: #2AA3D9;
								vertical-align: middle;
								padding: 10px;
								margin-top: 20px;
								height: 20px;
								width: 400px;
							}}
							.logo-bar {{
								background-color: #005D91;
								width: 420px;
								height: 20px;
								margin-top: -22px;
								margin-bottom: 30px;
							}}
                        </style>
                    </head>
                    <body>
						<div class='logo'>
							<svg version='1.1' width='105px' height='85px' viewBox='-0.5 -0.5 105 85'><defs/><g><path d='M 25.51 71.39 L 45.51 31.2 L 97.04 31.2 L 77.04 71.39 Z' fill='#000000' stroke='none' transform='translate(2,3)rotate(-15,61.27,51.29)' opacity='0.25'/><path d='M 25.51 71.39 L 45.51 31.2 L 97.04 31.2 L 77.04 71.39 Z' fill='#e6e6e6' stroke='none' transform='rotate(-15,61.27,51.29)' pointer-events='all'/><path d='M 15.51 60.24 L 35.51 20.05 L 87.04 20.05 L 67.04 60.24 Z' fill='#000000' stroke='none' transform='translate(2,3)rotate(-15,51.27,40.14)' opacity='0.25'/><path d='M 15.51 60.24 L 35.51 20.05 L 87.04 20.05 L 67.04 60.24 Z' fill='#2aa3d9' stroke='none' transform='rotate(-15,51.27,40.14)' pointer-events='all'/><path d='M 4.39 49.08 L 24.39 8.89 L 75.92 8.89 L 55.92 49.08 Z' fill='#000000' stroke='none' transform='translate(2,3)rotate(-15,40.16,28.99)' opacity='0.25'/><path d='M 4.39 49.08 L 24.39 8.89 L 75.92 8.89 L 55.92 49.08 Z' fill='#005d91' stroke='none' transform='rotate(-15,40.16,28.99)' pointer-events='all'/></g></svg>
						</div>
						<div class='title'>
							<h4 class='logo-name'>Central Fine Collection Agency</h4>
							<div class='logo-bar'>&nbsp;</div>
						</div>
                        <p>The Hague, {DateTime.Now.ToLongDateString()}</p>
                        
                        <p>Dear Mr. / Miss / Mrs. {vehicleInfo.OwnerName},</p>
                        
                        <p>We hereby inform you of the fact that a speeding violation was detected with a 
                        vehicle that is registered to you.</p>
						
						<p>The violation was detected by a speeding camera. We have a digital image of your 
                        vehicle committing the violation on record in our system. If requested by your 
                        solicitor, we will provide this image to you.</p>

						<hr/>
						
						<p>Below you can find all the details of the violation.</p>

                        <p>
                            <b>Vehicle information:</b>
                            <table>
                                <tr><th>License number</th><td>{vehicleInfo.VehicleId}</td></tr>
                                <tr><th>Brand</th><td>{vehicleInfo.Brand}</td></tr>
                                <tr><th>Model</th><td>{vehicleInfo.Model}</td></tr>
                            </table>
                        </p>

                        <p>
                            <b>Conditions during the violation:</b>
                            <table>
                                <tr><th>Road</th><td>{speedingViolation.RoadId}</td></tr>
                                <tr><th>Date</th><td>{speedingViolation.Timestamp.ToString("dd-MM-yyyy")}</td></tr>
                                <tr><th>Time of day</th><td>{speedingViolation.Timestamp.ToString("hh:mm:ss")}</td></tr>
                            </table>							
                        </p>
						
                        <p>
                            <b>Sanction:</b>
                            <table>
                                <tr><th>Maxiumum speed violation</th><td>{speedingViolation.ViolationInKmh} KMh</td></tr>
                                <tr><th>Sanction amount</th><td><div class='fine'>{fine}</div></td></tr>
                            </table>							
                        </p>		

						<hr/>
							
						<p><b>Sanction handling:</b></p>
							
						<p>If the amount of the fine is to be determined by the prosecutor, you will receive a notice 
                        to appear in court shortly.</p>
						
                        <p>Otherwise, you must pay the sanctioned fine <b>within 8 weeks</b> after the date of this 
                        email. If you fail to pay within 8 weeks, you will receive a first reminder email and <b>the 
                        fine will be increased to 1.5x the original fine amount</b>. If you fail to pay within 8 weeks 
                        after the first reminder, you will receive a second and last reminder email and <b>the fine 
                        will be increased to 3x the original fine amount</b>. If you fail to pay within 8 weeks 
                        after the second reminder, the case is turned over to the prosecutor and you will receive a 
                        notice to appear in court.</p>

						<hr/>
									
						<p>
						Yours sincerely,<br/>
						The Central Fine Collection Agency
						</p>
                    </body>
                </html>
            ";
        }        
    }
}