<html>

<head>
  Hello World!
</head>

<body>
  <?php
  $hostname = getenv('HOSTNAME');
  echo "Container hostname is: $hostname";
  ?>


  <?php
  $servername = 'database:3306';
  $username = 'myuser';
  $password = 'test1234@pl';

  try {
    // Create connection
    $conn = new mysqli($servername, $username, $password);
    if ($conn->connect_error) {
      die("Connection failed: " . $conn->connect_error);
    }
    echo "Connected successfully";
  } catch (Exception $e) {
    echo 'Caught exception: ',  $e->getMessage(), "\n";
  }
  ?>


</body>

</html>