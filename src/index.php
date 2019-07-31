<?php

const FETCH_STYLE = 'fetch_style';
const QUERY = 'query';

$host = getenv('INFORMIX_HOST');
$port = getenv('INFORMIX_PORT');
$db = getenv('INFORMIX_DB');
$srv = getenv('INFORMIX_SERVER');
$prt = getenv('INFORMIX_PROTOCOL');
$scrolCurs = getenv('INFORMIX_SCROLCURS');
$user = getenv('INFORMIX_USER');
$pwd = getenv('INFORMIX_PASSWORD');

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

if (array_key_exists(QUERY, $_GET)) {
    $sql = $_GET[QUERY];
} else {
    $sql = 'SELECT CURRENT FROM systables WHERE tabid=1';
}

if (array_key_exists(FETCH_STYLE, $_GET)) {
    $fetch_style = $_GET[FETCH_STYLE];
} else {
    $fetch_style = PDO::FETCH_ASSOC;
}

// Enable exceptions on PDO errors.
$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

$stm = $pdo->query($sql);
$results = $stm->fetchAll($fetch_style);
$response = json_encode($results, JSON_INVALID_UTF8_IGNORE);
$json_error = json_last_error() . ' ' . json_last_error_msg();

header('Content-Type: application/json');
echo $response;