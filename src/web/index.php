<?php

// Copy env.php.dist into env.php and change your connection settings.
include '../cfg/env.php';

$pdo = new \PDO(
    "informix:host=$host;" .
    "service=$port;" .
    "database=$db;" .
    "server=$srv;" .
    "protocol=$prt;" .
    "EnableScrollableCursors=$scrolCurs;",
    $user,
    $pwd
);

// Enable exceptions on PDO errors.
$pdo->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);

$sql = <<<SQL
SELECT CURRENT FROM systables WHERE tabid=1;
SQL;

$stm = $pdo->prepare($sql);

$stm->execute();
$results = $stm->fetchAll();

var_dump($results);