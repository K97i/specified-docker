<?php
//This is the Specify interlink handler. Specify POSTs to this file to upload it's data.

$FILES_FOLDER = "files/"; // should end with slash

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    http_response_code(400);
    echo "You must post!";
    return;
}

if ($_SERVER["CONTENT_TYPE"] !== "application/json") {
    http_response_code(400);
    echo "You must use application/json";
    return;
}

// https://stackoverflow.com/a/8945912
$raw_data = file_get_contents("php://input");
$json_data = json_decode($raw_data, true);

// https://stackoverflow.com/a/6041773/11585384
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo "Invalid JSON data!";
    return;
}
//In this upload method, we take two strings from inside the file itself, combine them, hash them into md5 and then trim them to the 8th character to assign a random
//filename to each upload.
$fullhash = md5($json_data["Version"].$json_data["Meta"]["GenerationDate"].$json_data["BasicInfo"]["Hostname"]);
$parthash = substr($fullhash, 0, 8);
$filename = "$parthash.json";
$filepath = "$FILES_FOLDER$filename";

if (!file_exists($FILES_FOLDER)) {
    mkdir($FILES_FOLDER, 0775);
}

file_put_contents($filepath, $raw_data);
http_response_code(201);
header("Location: ".rtrim(dirname($_SERVER["REQUEST_URI"]), "/")."/profile/$parthash");
echo "File successfully created: $filepath";
