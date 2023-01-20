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
                <li><a href="index.php">Home</a></li>
                    <li><a href="info.php">Info</a></li>
					<li><a href="healthcheck.html">Healthcheck</a></li>
					<li><a href="healthcheck.php">PHPinfo</a></li>
					<li><a href="https://github.com/erjosito/whoami/blob/master/api/README.md">API docs</a></li>
					<li><a href="https://github.com/erjosito/whoami/blob/master/web/README.md">Web docs</a></li>
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

                    <h3>Information retrieved from API <?php print(getenv("API_URL")); ?>:</h3>
                    <p>These links will only work if the environment variable API_URL is set to the correct instance of an instance of the <a href="https://github.com/erjosito/whoami/blob/master/web/README.md">SQL API</a>:</p>
                    <ul>
                    <?php
                        $cmd = "curl " . getenv("API_URL") . "/api/healthcheck";
                        $result_json = shell_exec($cmd);
                        $result = json_decode($result_json, true);
                        $healthcheck = $result["health"];
                    ?>
                        <li>Healthcheck: <?php print ($healthcheck); ?></li>
                    <?php
                        $cmd = "curl " . getenv("API_URL") . "/api/sqlversion";
                        $result_json = shell_exec($cmd);
                        $result = json_decode($result_json, true);
                        $sql_output = $result["sql_output"];
                    ?>
                        <li>SQL Server version: <?php print($sql_output); ?></li>
                    <?php
                        $cmd = "curl " . getenv("API_URL") . "/api/ip";
                        $result_json = shell_exec($cmd);
                        $result = json_decode($result_json, true);
                    ?>
                        <li>Connectivity info for SQL API pod:
                            <ul>
                            <li>Private IP address: <?php print($result["my_private_ip"]); ?></li>
                            <li>Public (egress) IP address: <?php print($result["my_public_ip"]); ?></li>
                            <li>Default gateway: <?php print($result["my_default_gateway"]); ?></li>
                            <li>HTTP request source IP address: <?php print($result["your_address"]); ?></li>
                            <li>HTTP request X-Forwarded-For header: <?php print($result["x-forwarded-for"]); ?></li>
                            <li>HTTP request Host header: <?php print($result["host"]); ?></li>
                            <li>HTTP requested path: <?php print($result["path_accessed"]); ?></li>
                            </ul>
                        </li>
                    </ul>
                    <br>
                    <h3>Direct access to API</h3>
                    <p>Note that these links will only work if used with a reverse-proxy, such an ingress controller in Kubernetes or an Azure Application Gateway</p>
                    <ul>
                        <li><a href='/api/healthcheck'>API health status</a></li>
                        <li><a href='/api/sqlversion'>SQL Server version</a></li>
                        <li><a href='/api/ip'>API connectivity information</a></li>
                    </ul>
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
