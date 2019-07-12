<?php

// Copy env.php.dist into env.php and change your connection settings.
include '../cfg/env.php';

$pdo = new PDO(
    "informix:host=$host;" .
    "service=$port;" .
    "database=$db;" .
    "server=$srv;" .
    "protocol=$prt;" .
    "EnableScrollableCursors=$scrolCurs;",
    $user,
    $pwd
);

if (array_key_exists('query', $_GET)) {
    $sql = $_GET['query'];
} else {
    $sql = 'SELECT CURRENT FROM systables WHERE tabid=1';
}

// Enable exceptions on PDO errors.
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$stm = $pdo->query($sql);
$results = $stm->fetchAll();
$response = json_encode($results, JSON_INVALID_UTF8_IGNORE);
$json_error = json_last_error() . ' ' . json_last_error_msg();

header('Content-Type: application/json');
echo $response;