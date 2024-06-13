<?php
include ('conn.php');
$nrp_upd = $_GET['id'];
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (isset($_GET['id'])) {
        //query SQL

        $query = "SELECT * FROM tbl_employees WHERE id = '$nrp_upd'";
        //eksekusi query
        $result = mysqli_query(connection(), $query);
        $employee = mysqli_fetch_assoc($result);

    }
}
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    if (isset($_POST['delete'])) {
        // Prepare the delete query
        $sql = "DELETE FROM tbl_employees WHERE id = '$nrp_upd'";
        $result = mysqli_query(connection(), $sql);
        if ($result) {
            echo "<script> alert('Employee deleted successfully.');</script>
        <script> setTimeout(function() { window.location.href = 'tableEmployees.php'; }, 1000);</script>";
            exit;
        } else {
            echo "<script> alert('Failed to delete employee.');</script>
        <script> setTimeout(function() { window.location.href = 'tableEmployees.php'; }, 1000);</script>";
            exit;
        }
    } else {
        $first = $_POST['first'];
        $last = $_POST['last'];
        $gender = $_POST['gender'];
        $email = $_POST['email'];
        $phone = $_POST['phone'];
        $salary = $_POST['salary'];
        $manager = $_POST['manager'];
        $job = $_POST['job'];
        $department = $_POST['department'];
        $hiredate = $_POST['hiredate'];
        $sql = "UPDATE tbl_employees SET 
        first_name = '$first', 
        last_name = '$last', 
        gender = '$gender', 
        email = '$email', 
        phone = '$phone', 
        salary = '$salary', 
        manager = '$manager', 
        job = '$job', 
        department = '$department', 
        hire_date = '$hiredate' 
        WHERE id = '$nrp_upd'";
        $result = mysqli_query(connection(), $sql);
        if ($result) {
            echo "<script> alert('Employee added successfully.');</script>
        <script> setTimeout(function() { window.location.href = 'tableEmployees.php'; }, 1000);</script>";
            exit;
        } else {
            echo "<script> alert('Failed to add employee.');</script>
        <script> setTimeout(function() { window.location.href = 'addEmployee.php'; }, 1000);</script>";
            exit;
        }


    }
}
?>
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>EMS</title>

    <!-- Custom fonts for this template -->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">

    <!-- Custom styles for this page -->
    <link href="vendor/datatables/dataTables.bootstrap4.min.css" rel="stylesheet">

</head>

<body id="page-top">

    <!-- Page Wrapper -->
    <div id="wrapper">

        <!-- Sidebar -->
        <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

            <!-- Sidebar - Brand -->
            <a class="sidebar-brand d-flex align-items-center justify-content-center" href="index.php">
                <div class="sidebar-brand-icon rotate-n-15">
                    <i class="fas fa-laugh-wink"></i>
                </div>
                <div class="sidebar-brand-text mx-3">EMS</div>
            </a>

            <!-- Divider -->
            <hr class="sidebar-divider my-0">

            <!-- Nav Item - Dashboard -->
            <li class="nav-item active">
                <a class="nav-link" href="index.php">
                    <i class="fas fa-fw fa-tachometer-alt"></i>
                    <span>Dashboard</span></a>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider">

            <!-- Heading -->
            <div class="sidebar-heading">
                Employee
            </div>
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseTwo"
                    aria-expanded="true" aria-controls="collapseTwo">
                    <i class="fas fa-user-alt"></i>
                    <span>Employee Management</span>
                </a>
                <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <a class="collapse-item" href="tableEmployees.php">Employee</a>
                        <a class="collapse-item" href="history.php">History</a>
                    </div>
                </div>
            </li>
            <li class="nav-item">
                <a class="nav-link collapsed" href="#" data-toggle="collapse" data-target="#collapseUtilities"
                    aria-expanded="true" aria-controls="collapseUtilities">
                    <i class="fas fa-fw fa-wrench"></i>
                    <span>Data Management</span>
                </a>
                <div id="collapseUtilities" class="collapse" aria-labelledby="headingUtilities"
                    data-parent="#accordionSidebar">
                    <div class="bg-white py-2 collapse-inner rounded">
                        <a class="collapse-item" href="tableJobs.php">Jobs</a>
                        <a class="collapse-item" href="tableDepartments.php">Departments</a>
                        <a class="collapse-item" href="tableLocations.php">Locations</a>
                        <a class="collapse-item" href="tableCountries.php">Countries</a>
                        <a class="collapse-item" href="tableRegions.php">Regions</a>
                    </div>
                </div>
            </li>

            <!-- Divider -->
            <hr class="sidebar-divider">

            <!-- Divider -->
            <hr class="sidebar-divider d-none d-md-block">

            <!-- Sidebar Toggler (Sidebar) -->
            <div class="text-center d-none d-md-inline">
                <button class="rounded-circle border-0" id="sidebarToggle"></button>
            </div>


        </ul>
        <!-- End of Sidebar -->

        <!-- Content Wrapper -->
        <div id="content-wrapper" class="d-flex flex-column">

            <!-- Main Content -->
            <div id="content">

                <!-- Topbar -->
                <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

                    <!-- Sidebar Toggle (Topbar) -->
                    <form class="form-inline">
                        <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                            <i class="fa fa-bars"></i>
                        </button>
                    </form>

                    <!-- Topbar Search -->
                    <form
                        class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
                        <div class="input-group">
                            <input type="text" class="form-control bg-light border-0 small" placeholder="Search for..."
                                aria-label="Search" aria-describedby="basic-addon2">
                            <div class="input-group-append">
                                <button class="btn btn-primary" type="button">
                                    <i class="fas fa-search fa-sm"></i>
                                </button>
                            </div>
                        </div>
                    </form>

                    <!-- Topbar Navbar -->
                    <ul class="navbar-nav ml-auto">

                        <!-- Nav Item - Search Dropdown (Visible Only XS) -->
                        <li class="nav-item dropdown no-arrow d-sm-none">
                            <a class="nav-link dropdown-toggle" href="#" id="searchDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <i class="fas fa-search fa-fw"></i>
                            </a>
                            <!-- Dropdown - Messages -->
                            <div class="dropdown-menu dropdown-menu-right p-3 shadow animated--grow-in"
                                aria-labelledby="searchDropdown">
                                <form class="form-inline mr-auto w-100 navbar-search">
                                    <div class="input-group">
                                        <input type="text" class="form-control bg-light border-0 small"
                                            placeholder="Search for..." aria-label="Search"
                                            aria-describedby="basic-addon2">
                                        <div class="input-group-append">
                                            <button class="btn btn-primary" type="button">
                                                <i class="fas fa-search fa-sm"></i>
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </li>

                        <div class="topbar-divider d-none d-sm-block"></div>

                        <!-- Nav Item - User Information -->
                        <li class="nav-item dropdown no-arrow">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                <span class="mr-2 d-none d-lg-inline text-gray-600 small">Douglas McGee</span>
                                <img class="img-profile rounded-circle" src="img/undraw_profile.svg">
                            </a>
                            <!-- Dropdown - User Information -->
                            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                                aria-labelledby="userDropdown">
                                <a class="dropdown-item" href="#">
                                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Profile
                                </a>
                                <a class="dropdown-item" href="#">
                                    <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Settings
                                </a>
                                <a class="dropdown-item" href="#">
                                    <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Activity Log
                                </a>
                                <div class="dropdown-divider"></div>
                                <a class="dropdown-item" href="#" data-toggle="modal" data-target="#logoutModal">
                                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                                    Logout
                                </a>
                            </div>
                        </li>

                    </ul>

                </nav>
                <!-- End of Topbar -->

                <!-- Begin Page Content -->
                <div class="container-fluid">
                    <!-- DataTales Example -->
                    <div class="card shadow mb-4">
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Add Employee</h6>
                        </div>
                        <div class="card-body">
                            <class="table-responsive">
                                <?php
                                $sql1 = "SELECT id, name FROM tbl_departments";
                                $result1 = mysqli_query(connection(), $sql1);

                                $departments = [];
                                if ($result1->num_rows > 0) {
                                    while ($row1 = $result1->fetch_assoc()) {
                                        $departments[] = $row1;
                                    }
                                }

                                $sql2 = "SELECT id, title FROM tbl_jobs";
                                $result2 = mysqli_query(connection(), $sql2);
                                $jobs = [];
                                if ($result2->num_rows > 0) {
                                    while ($row2 = $result2->fetch_assoc()) {
                                        $jobs[] = $row2;
                                    }
                                }
                                $sql3 = "SELECT id, first_name, last_name FROM tbl_employees";
                                $result3 = mysqli_query(connection(), $sql3);
                                $managers = [];
                                if ($result3->num_rows > 0) {
                                    while ($row3 = $result3->fetch_assoc()) {
                                        $managers[] = $row3;
                                    }
                                }
                                ?>
                                <form class="user" action="" method="post">
                                    <div class="form-row">
                                        <div class="form-group col-md-6">
                                            <label for="first">First Name</label>
                                            <input type="text" class="form-control" id="first" name="first"
                                                placeholder="First Name"
                                                value="<?= htmlspecialchars($employee['first_name'] ?? '') ?>" required>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label for="last">Last Name</label>
                                            <input type="text" class="form-control" id="last" name="last"
                                                placeholder="Last Name"
                                                value="<?= htmlspecialchars($employee['last_name'] ?? '') ?>" required>
                                        </div>
                                    </div>
                                    <div>
                                        Gender
                                        <label for="male">
                                            <input type="radio" id="male" name="gender" value="male"
                                                <?= (isset($employee['gender']) && $employee['gender'] == 'male') ? 'checked' : '' ?> required>
                                            Male
                                        </label>
                                        <label for="female">
                                            <input type="radio" id="female" name="gender" value="female"
                                                <?= (isset($employee['gender']) && $employee['gender'] == 'female') ? 'checked' : '' ?> required>
                                            Female
                                        </label>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group col-md-6">
                                            <label for="email">Email</label>
                                            <input type="email" id="email" name="email" placeholder="Email"
                                                class="form-control"
                                                value="<?= htmlspecialchars($employee['email'] ?? '') ?>" required>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label for="phone">Phone Number</label>
                                            <input type="text" id="phone" name="phone" placeholder="Phone Number"
                                                class="form-control"
                                                value="<?= htmlspecialchars($employee['phone'] ?? '') ?>" required>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group col-md-6">
                                            <label for="salary">Salary</label>
                                            <input type="number" id="salary" name="salary" placeholder="Salary"
                                                class="form-control"
                                                value="<?= htmlspecialchars($employee['salary'] ?? '') ?>" required>
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label for="hiredate">Hire Date</label>
                                            <input type="date" class="form-control" id="hiredate" name="hiredate"
                                                value="<?= htmlspecialchars($employee['hire_date'] ?? '') ?>" required>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-group col-md-4">
                                            <label for="manager">Manager Name:</label><br>
                                            <select class="btn btn-gray-100 border-dark col-md-12" name="manager"
                                                id="manager">
                                                <?php foreach ($managers as $manager): ?>
                                                    <option value="<?= htmlspecialchars($manager['id']); ?>"
                                                        <?= (isset($employee['manager_id']) && $employee['manager_id'] == $manager['id']) ? 'selected' : '' ?>>
                                                        <?= htmlspecialchars($manager['first_name'] . ' ' . $manager['last_name']); ?>
                                                    </option>
                                                <?php endforeach; ?>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label for="job">Job Name:</label><br>
                                            <select class="btn btn-gray-100 border-dark col-md-12" name="job" id="job">
                                                <?php foreach ($jobs as $job): ?>
                                                    <option value="<?= htmlspecialchars($job['id']); ?>"
                                                        <?= (isset($employee['job_id']) && $employee['job_id'] == $job['id']) ? 'selected' : '' ?>>
                                                        <?= htmlspecialchars($job['title']); ?>
                                                    </option>
                                                <?php endforeach; ?>
                                            </select>
                                        </div>
                                        <div class="form-group col-md-4">
                                            <label for="department">Department Name:</label><br>
                                            <select class="btn btn-gray-100 border-dark col-md-12" name="department"
                                                id="department">
                                                <?php foreach ($departments as $department): ?>
                                                    <option value="<?= htmlspecialchars($department['id']); ?>"
                                                        <?= (isset($employee['department_id']) && $employee['department_id'] == $department['id']) ? 'selected' : '' ?>>
                                                        <?= htmlspecialchars($department['name']); ?>
                                                    </option>
                                                <?php endforeach; ?>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <button type="submit" name="submit"
                                            class="btn btn-primary col-md-9">Update</button>
                                        <button type="submit" name="delete"
                                            class="btn btn-danger col-md-2">Delete</button>
                                    </div>
                                </form>
                        </div>

                        </form>
                    </div>
                </div>
            </div>

        </div>
        <!-- /.container-fluid -->

    </div>
    <!-- End of Main Content -->

    <!-- Footer -->
    <footer class="sticky-footer bg-white">
        <div class="container my-auto">
            <div class="copyright text-center my-auto">
                <span>Copyright &copy; Your Website 2020</span>
            </div>
        </div>
    </footer>
    <!-- End of Footer -->

    </div>
    <!-- End of Content Wrapper -->

    </div>
    <!-- End of Page Wrapper -->

    <!-- Scroll to Top Button-->
    <a class="scroll-to-top rounded" href="#page-top">
        <i class="fas fa-angle-up"></i>
    </a>

    <!-- Logout Modal-->
    <div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
        aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLabel">Ready to Leave?</h5>
                    <button class="close" type="button" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">Select "Logout" below if you are ready to end your current session.</div>
                <div class="modal-footer">
                    <button class="btn btn-secondary" type="button" data-dismiss="modal">Cancel</button>
                    <a class="btn btn-primary" href="login.php">Logout</a>
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

    <!-- Page level plugins -->
    <script src="vendor/datatables/jquery.dataTables.min.js"></script>
    <script src="vendor/datatables/dataTables.bootstrap4.min.js"></script>

    <!-- Page level custom scripts -->
    <script src="js/demo/datatables-demo.js"></script>

</body>

</html>