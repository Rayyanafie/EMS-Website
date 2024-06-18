<?php
// remove all session variables
session_unset();

// destroy the session
session_destroy();
if (isset($_SERVER['HTTP_COOKIE'])) {
    $cookies = explode(';', $_SERVER['HTTP_COOKIE']);
    foreach ($cookies as $cookie) {
        $parts = explode('=', $cookie);
        $name = trim($parts[0]);
        // Set the cookie expiration date to a past date to delete it
        setcookie($name, '', time() - 3600, '/');
        setcookie($name, '', time() - 3600, '/', $_SERVER['SERVER_NAME'], isset($_SERVER['HTTPS']), true);
    }
}

header("Location: login.php");
exit;
?>