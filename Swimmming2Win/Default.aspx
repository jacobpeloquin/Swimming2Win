<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Swimmming2Win._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">




    <!DOCTYPE html>
    <html>
    <head>
        <meta charset="utf-8" />
        <title>Swimming2Win</title>
        <link rel="import" href="head.html">
         <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    </head>

    <style>
        .titleText {
            color: dodgerblue;
            text-decoration: underline;
            font-size: 7em;
            font-family: 'Courier New';
            padding-top: 50px;
            position: relative;
        }

        .subText {
            color: dodgerblue;
            text-decoration: underline;
            font-size: 1em;
            font-family: 'Courier New';
            padding-right: 30px;
        }

        .footer {
            background-color: dodgerblue;
            width: 100%;
            height: 5%;
            position: fixed;
            left: 0;
            bottom: 0;
            font-size: 1em;
            font-family: 'Courier New';
        }
    </style>

    <body>


       
         <div class="row" style="padding-top:20px; ">
            <p href="Default.aspx" style="text-align:center; color:dodgerblue; font-family:'Courier New'; font-size:3.5em; text-decoration:underline" >
                Swimming2Win
            </p>
        </div>

        <div style="margin-left:0px; margin-top: 20px;" class="row" >
            <span id="btnGetUserList" class="btn btn-primary"  style="float:left;" onclick="showNav()">Our Users</span>
            <span id="btnPreviousPage" class="btn btn-primary" style="display: none;  width: 100px; float:left;">Previous</span>
            <span id="btnNextPage" class="btn btn-primary" style="display: none; width: 100px;float:left;">Next</span>

            <div style="padding-top:15px;" >
                <div id="UserList" class="col-lg-12" style="margin-top: 30px; float: left; display: none;"></div>
                <div id="workoutDetails"  class="col-lg-12" style="margin-top: 16px; margin-left: 16px; float: left; display: none;"></div>
                <div id="SearchList" class="col-lg-12" style="margin-top: 30px; float: left; display: none;"></div>
            </div>
        </div>

        <div style="margin-top:40px; padding-bottom:10px; padding-left:10px;" class="row" >
         <form  style="align-content:center; float:left; margin-bottom:10px;" >
            <i onsubmit="getSearch()" class="col-sm-12">
             <input id="search" type="text" placeholder=" Search Users By Email..."  onsubmit="getSearch()"  style="border-radius: 5px; border: 2px solid dodgerblue; display: none;" >
               <i id="glass" class="material-icons" onclick="getSearch()" style="display: none;">search</i>
            </form>
        </div>


        <div style="margin-right:18px; margin-bottom: 20px;" class="row">

            <span id="getLocationsBtn" class="btn btn-primary" style="float:left;" onclick="showCitySearch()"> Locations </span>

        </div>
        
         <div class="row" style="padding:20px;">
                <input id="searchCity" type="text" placeholder=" Search Cities..."  onsubmit="getLocationsByCity()"  style="border-radius: 5px; border: 2px solid dodgerblue; display: none;" >
                 <i id="glassCity" class="material-icons" onclick="getLocationsByCity()" style="float:left; display: none;">search</i>
               </input>
         </div>

        <div style="padding-top:15px;" >
                <div id="LocationList" class="col-lg-12" style="margin-top: 30px; float: left; display: none;">

                </div>
        </div>


        <div class="container">


            <!-- Modal -->
            <div class="modal fade" id="myModal" role="dialog">
                <div class="modal-dialog">

                    <!-- Modal content-->
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Login </h4>
                        </div>
                        <form>
                            <div class="form-group" style="padding-left: 10px;">
                                <label for="usr">User Name:</label>
                                <input type="text" id="loginBox" class="form-control" id="usr">
                            </div>
                            <div class="form-group" style="padding-left: 10px;">
                                <label for="pwd">Password:</label>
                                <input type="password" id="passwordBox" class="form-control" id="pwd">
                            </div>
                        </form>

                        <div style="padding-left: 10px;">
                            <button id="btnLogin" class="btn btn-success" onclick="submit()">Submit </button>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        </div>
                    </div>

                </div>
            </div>

        </div>


        <div class="container">

            <div id="myCarousel" class="carousel slide" data-ride="carousel">
                <!-- Indicators -->
                <ol class="carousel-indicators">
                    <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                    <li data-target="#myCarousel" data-slide-to="1"></li>
                    <li data-target="#myCarousel" data-slide-to="2"></li>
                </ol>

                <!-- Wrapper for slides -->
                <div class="carousel-inner">
                    <div class="item active">
                        <img src="muAquatics.png" alt="logo" style="width: 100%;">
                    </div>

                    <div class="item">
                        <img src="muPool.jpg" alt="pool" style="width: 100%;">
                    </div>

                    <div class="item">
                        <img src="muSwimComp.jpeg" alt="race" style="width: 100%;">
                    </div>
                </div>

                <!-- Left and right controls -->
                <a class="left carousel-control" href="#myCarousel" data-slide="prev">
                    <span class="glyphicon glyphicon-chevron-left"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#myCarousel" data-slide="next">
                    <span class="glyphicon glyphicon-chevron-right"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
        </div>


        <div class="footer">
            <p style="color: white; padding: 10px;">
                Devs... Matt Dunn, Jacob Peoquin, Brian Roders Vargo, Nick Ward
            </p>
        </div>

        <script>

            var totalNumberOfPages = 0;
            var currentPage = 0;
            var userLName;
            var userIDFromLName;

            function checkEnter(event) {
                var x = event.keyCode;
                if (x == 13) {
                    getSearch();
                }

                var users = document.getElementById("searchList");
                if (users.style.display === "none") {
                    users.style.display = "block";
                }


            }


            function getSearch() {
      
                var search = document.getElementById("search").value;       
                userEmail = search;
             
                service("getUserIdByEmail", "{email:'" + userEmail + "'}",
                    function (response) {     
                        $.each(response, function (index, value) {
                            userIDFromLName = value.userID;          
                            showWorkouts(userIDFromLName);
                        }); 
                         $("#workoutDetails").html(d + "</table>");
                    }, function (response) {
                       alert("Error...");
                        console.log(response);
                    });
            }


            


            function showNav() {
                var prev = document.getElementById("btnPreviousPage");
                var next = document.getElementById("btnNextPage");
                var users = document.getElementById("UserList");
                var workouts = document.getElementById("workoutDetails");
                var searchBar = document.getElementById("search");
                var magnifyingGlass = document.getElementById("glass");


                if (searchBar.style.display=== "none") {
                    searchBar.style.display = "block";
                }
                else {
                    searchBar.style.display = "none";
                }

                 if (magnifyingGlass.style.display=== "none") {
                    magnifyingGlass.style.display = "block";
                }
                else {
                    magnifyingGlass.style.display = "none";
                }

                 if (next.style.display === "none") {
                    next.style.display = "block";
                  } else {
                    next.style.display = "none";
                }

                 if (prev.style.display === "none") {
                    prev.style.display = "block";
                  } else {
                    prev.style.display = "none";
                }

                if (users.style.display === "none") {
                    users.style.display = "block";
                  } else {
                    users.style.display = "none";
                }

                if (workouts.style.display === "none") {
                    workouts.style.display = "block";
                  } else {
                    workouts.style.display = "none";
                }


            }

            function listUsers() {
                var d = "<table class='table table-striped table-bordered' style='max-width:700px;'>";
                service("getUserList", "{page: " + currentPage + "}",
                    function (response) {
                        $.each(response, function (index, value) {
                            d += "<tr>" +
                                "<td>" + value.fName + "</td>" +
                                "<td>" + value.lName + "</td>" +
                                "<td>" + value.email + "</td>" +
                                "<td>" + value.userName + "</td>" +
                                "<td>" + value.gender + "</td>" +
                                "<td><img src='image/swimmer.png' width='42' style='cursor:pointer;' onclick='showWorkouts(" + value.userID + ");'/></td>" +
                                "</tr>";

                            var numberOfPages = Math.ceil(50 / 5);
                            totalNumberOfPages = numberOfPages;
                        });
                        $("#UserList").html(d + "</table>");


                    }, function (response) {
                        alert("Error...");
                        console.log(response); 

                    });
            }

            
            

            $("#btnNextPage").click(function (index, value) {         
               
                if (currentPage < totalNumberOfPages) {
                    currentPage++;
                    listUsers();
                }
                
            });

             $("#btnPreviousPage").click(function (index, value) {         
               
                if (currentPage > 0) {
                    currentPage--;
                    listUsers();
                }
                
            });

           

            $("#btnGetUserList").click(function () {
                currentPage = 1;
                listUsers();
            });




            function showWorkouts(id) {
                selectedUser = id;
                service("getWorkoutDetails", "{uid:" + id + "}",
                    function (response) {
                        var users = response[0];
                        var workouts = users.Workouts;

                        var d = "<h1>" + users.User + "</h1>" +
                            "<table class='table table-striped table-bordered'>" +
                            "<tr><th>Workout ID</th><th>workout Date</th><th>Workout Title</th></tr>";

                        for (var i = 0; i < workouts.length; i++) {
                            d += "<tr>" +
                                "<td>" + workouts[i].workoutID + "</td>" +
                                "<td>" + workouts[i].workoutDate + "</td>" +
                                "<td>" + workouts[i].workoutTitle + "</td>" +
                                "</tr>";

                        }

                        $("#workoutDetails").html(d + "</table>");
                    }, function (response) {
                        alert("Error. Check log");
                        console.log(response);
                    });
            }

            function submit() {
                var userName = document.getElementById("loginBox").value;
                var password = document.getElementById("passwordBox").value;
                alert(userName + " " + password);
            }


            function getLocationsByCity() {

                var locations = document.getElementById("LocationList");

                var city = document.getElementById("searchCity").value;

                var list = document.getElementById("LocationList");

                if (list.style.display === "none") {
                    list.style.display = "block";
                }
               


                var d = "<table class='table table-striped table-bordered' style='max-width:700px;'>";
                d += "<tr>" +
                                "<td>" +"Pool Name" + "</td>" +
                                "<td>" + "Pool Type" + "</td>" +
                                "<td>" + "Address" + "</td>" +
                                "</tr>";

                service("getLocationsByCity", "{city:'" + city + "'}",
                    function (response) {


                        $.each(response, function (index, value) {
                            d += "<tr>" +
                                "<td>" + value.Name + "</td>" +
                                "<td>" + value.Pool + "</td>" +
                                "<td>" + value.Address + "</td>" +
                                "</tr>";

                            
                        });
                        $("#LocationList").html(d + "</table>");


                    }, function (response) {
                        alert("Error...");
                        console.log(response); 

                    });

            }
     


            

            function showCitySearch() {
                var searchBar = document.getElementById("searchCity");
                var glass = document.getElementById("glassCity");
                var list = document.getElementById("LocationList");

                if (searchBar.style.display === "none") {
                    searchBar.style.display = "block";
                }
                else {
                    searchBar.style.display = "none";
                }

                 if (glass.style.display === "none") {
                    glass.style.display = "block";
                }
                else {
                    glass.style.display = "none";
                }
              
                if (list.style.display === "block") {
                    list.style.display = "none";
                }
            }





        </script>
    </body>
    </html>



</asp:Content>
