<?php
function calculateCompositeScore($attendance, $kpi, $overtime, $maxDaysAbsent, $maxLateArrivals, $maxKPI, $maxOvertime)
{
    if ($maxDaysAbsent == 0 || $maxLateArrivals == 0 || $maxKPI == 0 || $maxOvertime == 0) {
        throw new Exception("Normalization maximum values must be greater than zero");
    }

    $normalizedAttendance = (($maxDaysAbsent - $attendance['daysAbsent']) / $maxDaysAbsent) * 0.5 + (($maxLateArrivals - $attendance['lateArrivals']) / $maxLateArrivals) * 0.5;
    $normalizedKPI = $kpi / $maxKPI;
    $normalizedOvertime = $overtime / $maxOvertime;

    $compositeScore = (0.3 * $normalizedAttendance) + (0.5 * $normalizedKPI) + (0.2 * $normalizedOvertime);
    return $compositeScore;
}
function makeTerminationDecision($compositeScore)
{
    if ($compositeScore < 0.65) {
        return "High risk of termination";
    } elseif ($compositeScore >= 0.65 && $compositeScore <= 0.80) {
        return "Review required";
    } else {
        return "Satisfactory performance";
    }
}
function getColor($decision)
{
    if ($decision == "High risk of termination") {
        return "red";
    } elseif ($decision == "Review required") {
        return "yellow";
    } else {
        return "green";
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

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link
        href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
        rel="stylesheet">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin-2.min.css" rel="stylesheet">

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
            <li class="nav-item">
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
                        <a class="collapse-item" href="tablePayslip.php">Payslip</a>
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
            <div class="sidebar-heading">
                Utilities
            </div>
            <li class="nav-item active">
                <a class="nav-link" href="performance.php">
                    <i class="fas fa-fw fa-chart-area"></i>
                    <span>Performance Calculator</span></a>
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
                    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
                        <i class="fa fa-bars"></i>
                    </button>

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
                                <span
                                    class="mr-2 d-none d-lg-inline text-gray-600 small"><?php echo $row['first_name'] . " " . $row['last_name'] ?></span>
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
                            <h6 class="m-0 font-weight-bold text-primary">Performance Calculator</h6>
                        </div>
                        <div class="card-body">
                            <class="table-responsive">
                                <form class="user" action="" method="Post">
                                    <div class="form-group">
                                        <label for="KPI">KPI Score</label>
                                        <input type="number" class="form-control" id="kpi" name="kpi"
                                            placeholder="KPI Score" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="Late Code">Total Late Arrival</label>
                                        <input type="number" class="form-control" id="late" name="late"
                                            placeholder="Total Late Arrival" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="Absent">Total Absent Day</label>
                                        <input type="number" class="form-control" id="absent" name="absent"
                                            placeholder="Total Absent Day" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="Overtime">Total Work Overtime </label>
                                        <input type="number" class="form-control" id="overtime" name="overtime"
                                            placeholder="Total Work Overtime" required>
                                    </div>
                                    <div class="form-group"> <button type="submit"
                                            class="btn btn-primary ">Submit</button>
                                    </div>
                                    <?php
                                    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
                                        $kpi = $_POST['kpi'];
                                        $late = $_POST['late'];
                                        $absent = $_POST['absent'];
                                        $overtime = $_POST['overtime'];

                                        $maxDaysAbsent = 3;
                                        $maxLateArrivals = 5;
                                        $maxKPI = 100;
                                        $maxOvertime = 40;

                                        $attendance = [
                                            'daysAbsent' => $absent,
                                            'lateArrivals' => $late
                                        ];
                                        try {
                                            $compositeScore = calculateCompositeScore($attendance, $kpi, $overtime, $maxDaysAbsent, $maxLateArrivals, $maxKPI, $maxOvertime);
                                            $decision = makeTerminationDecision($compositeScore);
                                            $color = getColor($decision);
                                            echo "<h4 class='font-weight-bold text-primary'>Employee Performance Evaluation Result</h4>";
                                            echo "Composite Score: " . $compositeScore * 100 . "<br>";
                                            echo "<span style='color: $color;'>Decision: " . $decision . "</span><br>";
                                        } catch (Exception $e) {
                                            echo 'Error: ' . $e->getMessage();
                                        }

                                    }

                                    ?>
                        </div>

                        </form>


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
                    <a class="btn btn-primary" href="login.html">Logout</a>
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
    <script src="vendor/chart.js/Chart.min.js"></script>

    <!-- Page level custom scripts -->
    <script src="js/demo/chart-area-demo.js"></script>
    <script src="js/demo/chart-pie-demo.js"></script>
    <script src="js/demo/chart-bar-demo.js"></script>

</body>

</html>