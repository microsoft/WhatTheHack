<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Sample container</title>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="Description" lang="en" content="Azure VM Info Page">
        <meta name="author" content="Jose Moreno">
        <meta name="robots" content="index, follow">
        <!-- icons -->
        <link rel="apple-touch-icon" href="apple-touch-icon.png">
        <link rel="shortcut icon" href="favicon.ico">
        <!-- CSS file -->
        <link rel="stylesheet" href="styles.css">
    </head>
    <body>
        <div class="header">
			<div class="container">
				<h1 class="header-heading">Welcome to <?php $hostname = exec('hostname'); print($hostname); ?></h1>
			</div>
		</div>
		<div class="nav-bar">
			<div class="container">
				<ul class="nav">
                    <li><a href="/">Home</a></li>
					<li><a href="healthcheck.html">Healthcheck</a></li>
					<li><a href="healthcheck.php">PHPinfo</a></li>
					<li><a href="https://github.com/erjosito/whoami/blob/master/api/README.md">SQL API docs</a></li>
					<li><a href="https://github.com/erjosito/whoami/blob/master/web/README.md">SQL Web docs</a></li>
                    <li>             </li>
                    <li>             </li>
                    <li>             </li>
                    <li style="color:LightGray;"><?php
                        $jwt = $_SERVER['HTTP_AUTHORIZATION'];
                        if (empty($jwt)) {
                            print ("Not authenticated");
                        } else {
                            list($header, $payload, $signature) = explode(".", $jwt);
                            $plainPayload = base64_decode($payload);
                            $jsonPayload = json_decode($plainPayload, true);
                            print("Hello, ".$jsonPayload["given_name"]); 
                        }
                    ?></li>
				</ul>
			</div>
		</div>

		<div class="content">
			<div class="container">
				<div class="main">
					<h1><?php echo exec('hostname'); ?></h1>
					<h3>Local information</h3>
                    <p>Some info about me:</p>
                    <ul>
                    <?php
                        $hostname = exec('hostname');
                        echo "         <li>Name: " . $hostname . "</li>\n";
                        echo "         <li>Software: " . $_SERVER['SERVER_SOFTWARE'] . "</li>\n";
                        $uname = exec('uname -a');
                        echo "         <li>Kernel info: " . $uname . "</li>\n";
                        $ip = exec('hostname -i');
                        echo "         <li>Private IP address: " . $ip . "</li>\n";
                        $pip = exec('curl ifconfig.co');
                        echo "         <li>Public IP address: " . $pip . "</li>\n";
                        ?>
                    </ul>
                    <br>

                    <h3>Information from PHP $_SERVER variable</h3>
                    <p>What I see about you:</p>
                    <ul>
                        <?php
                            echo "         <li>Client IP: " . $_SERVER['HTTP_CLIENT_IP'] . "</li>\n";
                            echo "         <li>Remote address: " . $_SERVER['REMOTE_ADDR'] . "</li>\n";
                            echo "         <li>X-Forwarded-For: " . $_SERVER['HTTP_X_FORWARDED_FOR'] . "</li>\n";
                        ?>
                    </ul>
                    <br>

                    <h3>Geolocation information</h3>
                    <p>Information retrieved from <a href='https://freegeoip.app'>freegeoip.app</a>:</p>
                    <?php
                            $cmd = "curl https://freegeoip.app/json/" . $pip;
                            $locationInfo = shell_exec($cmd);
                            $location = json_decode($locationInfo, true);
                            $country = $location["country_name"];
                            $region = $location["region_name"];
                            $city = $location["city"];
                    ?>
                    <ul>
                        <li>Country: <?php print ($country); ?></li>
                        <li>Region: <?php print ($region); ?></li>
                        <li>City: <?php print ($city); ?></li>
                    </ul>
                    <br>

                    <h3>Azure instance metadata</h3>
                    <?php
                        # Example output: lab-user@myvm:~$ curl -H Metadata:true http://169.254.169.254/metadata/instance?api-version=2017-08-01
                        # {"compute":{"location":"westeurope","name":"myvm-az-1","offer":"UbuntuServer","osType":"Linux","placementGroupId":"",
                        #  "platformFaultDomain":"0","platformUpdateDomain":"0","publisher":"Canonical","resourceGroupName":"iaclab",
                        #  "sku":"16.04.0-LTS","subscriptionId":"e7da9914-9b05-4891-893c-546cb7b0422e","tags":"","version":"16.04.201611150",
                        #   "vmId":"8b9edb1b-ed22-4e0f-bee3-9e880e46258e","vmSize":"Standard_D2_v2"},
                        # "network":{"interface":[{"ipv4":{"ipAddress":[{"privateIpAddress":"10.1.1.5","publicIpAddress":""}],
                        #  "subnet":[{"address":"10.1.1.0","prefix":"24"}]},"ipv6":{"ipAddress":[]},"macAddress":"000D3A2589D0"}]}}
                        $cmd = "curl -H Metadata:true http://169.254.169.254/metadata/instance?api-version=2017-08-01";
                        $metadataJson = shell_exec($cmd);
                        ?>
                    <p>Azure instance metadata: <?php print($metadataJson); ?> </p>
                    <br>

                </div>
            </div>
        </div>
        <div class="footer">
            <div class="container">
                &copy; Copyleft 2020
            </div>
        </div>
    </body>
</html>
