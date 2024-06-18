<?php
include ('conn.php');

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $id = $_POST['id'];
    $username = $_POST['username'];
    $email = $_POST['email'];
    $password = ($_POST['password']);
    $password2 = $_POST['password2'];

    // Check if passwords match
    if ($password != $password2) {
        echo "<script>
            alert('Password didn\'t match.');
            setTimeout(function() { window.location.href = 'register.php'; }, 2000);
        </script>";
        exit; // Stop further execution
    }

    // Get database connection
    $conn = connection();

    // Prepare statement to check if email exists
    $query1 = "SELECT * FROM tbl_employees WHERE email = '$email' and id = '$id'";
    $result1 = mysqli_query(connection(), $query1);
    if (mysqli_num_rows($result1) > 0)

        if ($result1->num_rows > 0) {
            // Email exists, insert new account
            $query2 = "INSERT INTO tbl_accounts (id,username,email, password) VALUES ($id,'$username','email','$password')";
            $result = mysqli_query(connection(), $query2);
            if ($result) {
                echo "<script> alert('Account created successfully.');</script>
                <script> setTimeout(function() { window.location.href = 'login.php'; }, 1000);</script>";
                exit;
            } else {
                echo "<script> alert('Failed to create account.');</script>
                <script> setTimeout(function() { window.location.href = 'register.php'; }, 1000);</script>";
                exit;
            }


        } else {
            echo "<script> alert('ID or Email is not registered.');</script>
            <script> setTimeout(function() { window.location.href = 'register.php'; }, 1000);</script>";
            exit;
        }
}
?>




?>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>EMS - Register</title>

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">

</head>

<body class="bg-gradient-primary">

    <div class="container">

        <div class="card o-hidden border-0 shadow-lg my-5">
            <div class="card-body p-0">
                <!-- Nested Row within Card Body -->
                <div class="row">
                    <div class="col-lg-5 d-none d-lg-block bg-register-image">
                        <img src="img/metrodata.jpg" alt="" style="width:400px;height:400px;padding-left: 80px">
                    </div>
                    <div class="col-lg-7">
                        <div class="p-5">
                            <div class="text-center">
                                <h1 class="h4 text-gray-900 mb-4">Create an Account!</h1>
                            </div>
                            <form class="user" action="" method="Post">
                                <div class="form-group"> <input type="text" id="id" name="id" required
                                        placeholder="employee id" class="form-control form-control-user" />
                                </div>
                                <div class="form-group"> <input type="email" id="email" name="email" required
                                        placeholder="email" class="form-control form-control-user" />
                                </div>
                                <div class="form-group"> <input type="text" id="username" name="username" required
                                        placeholder="username" class="form-control form-control-user" />
                                </div>
                                <div class="form-group row">
                                    <div class="col-sm-6 mb-3 mb-sm-0">
                                        <input type="password" id="password" name="password" required
                                            placeholder="password" class="form-control form-control-user" />
                                    </div>
                                    <div class="col-sm-6"><input type="password" id="password2" name="password2"
                                            required placeholder="password2" class="form-control form-control-user" />
                                    </div>

                                </div>
                                <button type="submit" class="btn btn-primary btn-user btn-block">Create
                                    Account</button>
                            </form>
                            <hr>
                            <div class="text-center">
                                <a class="small" href="forgot-password.html">Forgot Password?</a>
                            </div>
                            <div class="text-center">
                                <a class="small" href="login.html">Already have an account? Login!</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="vendor/jquery/jquery.min.js"></script>
    <script src="vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="vendor/jquery-easing/jquery.easing.min.js"></script>

    <!-- Custom scripts for all pages-->
    <script src="js/sb-admin-2.min.js"></script>

</body>

</html>