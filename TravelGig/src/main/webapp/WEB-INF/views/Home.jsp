<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Home Page of Travel Gig</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="home.css">
<script>

	 function saveEditedGuest() {
	    var guests = [];
		var noGuests = $('#noGuests').val()
	     
	     for (var i = 0; i < noGuests; i++) {
	        var guest = {
	            firstName: $('[id^=editGuestFirstName]').eq(i).val(),
	            lastName: $('[id^=editGuestLastName]').eq(i).val(),
	            age: $('[id^=editGuestAge]').eq(i).val(),
	            gender: $('[id^=editGuestGender]').eq(i).val(),
	        };
	
	        guests.push(guest);
	    }
		

    	console.log(guests);
	    // Use AJAX to send the array of guest objects to the server
	    $.ajax({
	        type: "POST",
	        url: "http://localhost:8484/saveGuest",
	        contentType: "application/json",
	        data: JSON.stringify(guests),
	        success: function(response) {
	            // Handle success, e.g., close the modal
	            $("#editGuestModal").modal("hide");
	            // You may also update the UI with the new guest details if needed
	        },
	        error: function(error) {
	            // Handle error
	            console.error("Error updating guest details:", error);
	        }
	    });
	}
	  
	var discount;
	var price;
	var totalPrice;
	$(document).ready(function() {
	    $("#searchBtn").click(function() {
	        console.log("clicked");
	        var searchString = $('#searchLocation').val();
	        $.get("/searchHotel/"+searchString, {
	            "searchString": searchString
	        }, function(responseText) {
	        	console.log(responseText);
	            $.each(responseText, function(index, val) {
	                console.log("index" + index, val);
	                $("#tblHotel").append("<tr><td>" + val.hotelName + "</td><td>" + val.address + "</td>" +
			        "<td>" + val.averagePrice + "</td><td><img class='hotel-image' length=300 width=200 src='" + val.imageURL + "' data-hotelname='" + val.hotelName + "'>" +
			        "</img></td><td>" + val.starRating + "</td>" +
			        "<td><button class='btn btn-primary btn-show-details' data-hotelname='" + val.hotelName + "' data-hotelid='" + val.hotelId + "'>Show Details</button></td></tr>");
	            });
	        });
	    });
	    
	    var selectedRoomType;
	
	    
	    function fetchRoomTypes() {
		    $.ajax({
		        url: 'http://localhost:8383/getRoomTypes', 
		        method: 'GET',
		        success: function(data) {
		        	console.log(data);
		            $('#select_roomTypes').empty();
		
		            $.each(data, function(index, roomType) {
		                $('#select_roomTypes').append($('<option>', {
		                    value: roomType.typeId, 
		                    text: roomType.name
		                }));
		            });
		            
		            selectedRoomType = $('#select_roomTypes').val();
		  			var defaultRoomTypeId = selectedRoomType;
		  			
			        var defaultRoomTypeName = data.find(roomType => roomType.typeId === parseInt(defaultRoomTypeId));
			        $('#booking_roomType').val(defaultRoomTypeName);
				    console.log("SELECTED", defaultRoomTypeName);
				    updateDiscountAndPrice(selectedRoomType);
		        },
		        error: function(err) {
		            console.error('Error fetching room types:', err);
		        }
		    });
		}
		fetchRoomTypes();
		
		 $("#editGuestModalButton").click(function(){
		    console.log("noGuests", $('#noGuests').val());
		    showGuestModal($('#noGuests').val());
		});
	
	 	 function showGuestModal(noGuests) {
		    // Clear any existing modal content
		    $('#editGuestModalBody').empty();
		
		    // Create form fields for each guest
		    for (var i = 1; i <= noGuests; i++) {
		        $('#editGuestModalBody').append(`
		            <div class="form-group">
		                <label for="editGuestFirstName${i}">First Name:</label>
		                <input type="text" class="form-control" id="editGuestFirstName${i}" name="editGuestFirstName${i}" required>
		            </div>
		            <div class="form-group">
		                <label for="editGuestLastName${i}">Last Name:</label>
		                <input type="text" class="form-control" id="editGuestLastName${i}" name="editGuestLastName${i}" required>
		            </div>
		            <div class="form-group">
		                <label for="editGuestAge${i}">Age:</label>
		                <input type="number" class="form-control" id="editGuestAge${i}" name="editGuestAge${i}" required>
		            </div>
		            <div class="form-group">
		                <label for="editGuestGender${i}">Gender:</label>
		                <select class="form-control" id="editGuestGender${i}" name="editGuestGender${i}" required>
		                    <option value="Male">Male</option>
		                    <option value="Female">Female</option>
		                    <option value="Others">Others</option>
		                </select>
		            </div>
		            <hr>
		        `);
		    }
			
		
		    // Show the guest information modal
		    $('#editGuestModal').modal('show');
		}
		
	    let currentHotelId; 
	    
	    $("#tblHotel").on('click', '.btn-show-details, .hotel-image', function(){
		    let hotelName = $(this).data('hotelname');
		    currentHotelId = $(this).data('hotelid');
		    console.log("THISDATA", hotelName);
		    processHotelDetails(hotelName);
		    processBookingDetails(hotelName);
		    
		    $("#edit").click( function(){
				console.log('edit');
				$("#bookingHotelRoomModal").hide();
			});
			
		    return false;
		});
		
		
		function updateDiscountAndPrice(selectedRoomType){
			$.ajax({
		            url: 'http://localhost:8383/getHotelRoomDetails',
		            method: 'GET',
		            success: function(roomTypeDetails) {
		            	console.log(roomTypeDetails);
		            	roomTypeDetails.forEach(function(roomTypeDetail) {
						    var hotelRoomId = roomTypeDetail.hotelRoomId;
						    if (hotelRoomId == selectedRoomType){
						    	discount = roomTypeDetail.discount;
						    	price = roomTypeDetail.price;
						    	totalPrice = roomTypeDetail.price * ((100 - discount)/100);
						    	console.log("discount", discount);
					            console.log("price", totalPrice);
					            $('#booking_discount').text(discount);
					            $('#booking_price').text(price);
					            $('#booking_totalPrice').text(totalPrice);
						    }
						});
		            	
		            },
		            error: function(error) {
		                console.error('Error fetching room type details:', error);
		            }
		        });
		}
		
		
		function processHotelDetails(hotelName) {
		    var noGuests = $('#noGuests').val();
		    var noRooms = $('#noRooms').val();
		    var checkInDate = $('#checkInDate').val();
		    var checkOutDate = $('#checkOutDate').val();
		    
		    var defaultRoomType = "Single Room";
    		$('#booking_roomType').val(defaultRoomType);
		    
		    $('#select_roomTypes').change(function() {
		        selectedRoomType = $(this).val();
		        $('#booking_roomType').val($('#select_roomTypes option:selected').text());
		        updateDiscountAndPrice(selectedRoomType);
				console.log("selectedRoomTypeHotel", selectedRoomType)	     
		    });
		    $('#modal_hotelName').val(hotelName);
		    $('#modal_noGuests').val(noGuests);
		    $('#modal_noRooms').val(noRooms);
		    $('#modal_checkInDate').val(checkInDate);
		    $('#modal_checkOutDate').val(checkOutDate);
		    $("#myModal").toggle();
		}
		
		function processBookingDetails(hotelName) {
		    var noGuests = $('#noGuests').val();
		    var noRooms = $('#noRooms').val();
		    var checkInDate = $('#checkInDate').val();
		    var checkOutDate = $('#checkOutDate').val();
		   
		    
		    $('#booking_hotelName').val(hotelName);
		    $('#booking_customerMobile').val("");
		    $('#booking_userEmail').val("");
		    $('#booking_noGuests').val(noGuests);
		    $('#booking_noRooms').val(noRooms);
		    $('#booking_checkInDate').val(checkInDate);
		    $('#booking_checkOutDate').val(checkOutDate);
		    
		}
		
		$("#myModal").on('click', '.btn-searchHotelRooms, .btn-show-details', function(){
		    $("#bookingHotelRoomModal").toggle();
		    
		});
		

		
		$("#clsModal").click(function(){
		    console.log('hide');
			$("#bookingHotelRoomModal").hide();
			$("#myModal").hide();
		});
		
		$("#closeModal").click(function(){
		    console.log('hide');
			$("#myModal").hide();
		});
	    
	    $("#confirmBookingBtn").on('click', function(){
	    	let hotelId = currentHotelId
		    console.log("htoelID" + hotelId);
	    	var bookingData = getBookingDetails(hotelId);
	    	console.log("bookingDetails" + bookingData);
	    	
	    	$.ajax({
	    		type:"POST",
	    		url:"http://localhost:8484/saveBooking",
	    		contentType: "application/json",
	    		data: JSON.stringify(bookingData),
	    		success: function(response){
	    		var bookingId = response.bookingId;
	    			console.log("bookingData" + JSON.stringify(bookingData));
	    			alert("Booking confirmed!");
	    			saveGuestWithBookingId(bookingId);
	    			
	    			 // Nested AJAX call to /bookHotel within the success callback
		            $.ajax({
		                type: "POST",
		                url: "http://localhost:8484/bookHotel",
		                contentType: "application/json",
		                data: JSON.stringify(bookingData),
		                success: function (response) {
		                    alert("Email Sent!");
		                    // Rest of your success handling code
		                },
		                error: function (error) {
		                    alert("Error sending email: " + error.responseText);
		                }
		            });
	    		},
	    		error: function(error)
	    		{
	    			alert("error confirming booking: " + error.responseText);
	    		}
	    	
	    	});
	    });
	    
	    function saveGuestWithBookingId(bookingId) {
		    var editedGuests = [];
		    var noGuests = $('#noGuests').val();
		
		    for (var i = 0; i < noGuests; i++) {
		        var guest = {
		            firstName: $('[id^=editGuestFirstName]').eq(i).val(),
		            lastName: $('[id^=editGuestLastName]').eq(i).val(),
		            age: $('[id^=editGuestAge]').eq(i).val(),
		            gender: $('[id^=editGuestGender]').eq(i).val(),
		            bookingId: bookingId  // Include the bookingId in each guest object
		        };
		
		        editedGuests.push(guest);
		    }
		
		    console.log("editedGuests" + editedGuests);
		
		    $.ajax({
		        type: "POST",
		        url: "http://localhost:8484/editGuest",
		        contentType: "application/json",
		        data: JSON.stringify(editedGuests),
		        success: function (response) {
		            alert("Guest details saved!");
					
		         
		        },
		        error: function (error) {
		            alert("Error saving guest details: " + error.responseText);
		        }
		    });
		}
		
	
	    
	    function getBookingDetails(hotelId){
	   		var guests = [];
			var noGuests = $('#noGuests').val()
		     
		     for (var i = 0; i < noGuests; i++) {
		        var guest = {
		            firstName: $('[id^=editGuestFirstName]').eq(i).val(),
		            lastName: $('[id^=editGuestLastName]').eq(i).val(),
		            age: $('[id^=editGuestAge]').eq(i).val(),
		            gender: $('[id^=editGuestGender]').eq(i).val(),
		        };
		
		        guests.push(guest);
		    }
		    
	    	var bookingDetails = 
	    	{
	    		bookingId:$("#bookingId").val(), 
	    		hotelId:hotelId,
	    		hotelName: $("#booking_hotelName").val(),
	    		customerMobile: $("#booking_customerMobile").val(),
	    		userEmail: $("#booking_userEmail").val(),
	    		noGuests: $("#booking_noGuests").val(),
	    		guests: guests,
	    		noRooms: $('#noRooms').val(),
	    		checkInDate: $("#booking_checkInDate").val(),
	    		checkOutDate: $("#booking_checkOutDate").val(),
	    		roomType: $("#booking_roomType").val(),
	    		price: totalPrice,
	    		discount: discount
	    	
	    	};
	    	
	    	return bookingDetails;
	    	
	    }
	    
	    $("#filterBtn").click(function() {
        $("#tblHotel tr").not(":first").show();
        var selectedPrice = parseInt($('#priceValue').text());
        var selectedStarRating = $(".star_rating:checked").map(function() {
            return parseInt($(this).val());
        }).get();

        $("#tblHotel tr").not(":first").each(function(index, val) {
            var price = $(this).children("td").eq("2").text();
            var starRating = parseInt($(this).children("td").eq("4").text());

            if (price > selectedPrice || (selectedStarRating.length > 0 && selectedStarRating.indexOf(starRating) === -1)) {
                $(this).hide();
            }
        });
    });
});
	    
	
</script>
</head>
<body>
<div class="container" style="margin-left:100px">
<h1>Welcome to Travel Gig</h1>
<h2>Search your desired hotel</h2>
</div>
<sec:authorize access="!isAuthenticated()">
    
    <div class="container" style="text-align: right; margin-top: 10px;">
        <a href="login">Login</a>
    </div>
</sec:authorize>
<sec:authorize access="isAuthenticated()">
	<td>|</td>
		<br>Granted Authorities: <sec:authentication property="principal.authorities"/>
		<br> loggedInUser: ${loggedInUser}
		<td></td>
		<td><a href="login?logout">Logout</a></td>
		<td><a href="booking">Bookings</a></td>
</sec:authorize>

<div class="container border rounded" style="margin:auto;padding:50px;margin-top:50px;margin-bottom:50px">
	<h3>Narrow your search results</h3>
	<div class="form-row">
	<div class="col-3">
		Hotel/City/State/Address <input class="form-control" type="text" id="searchLocation" name="searchLocation"/>
	</div>
	<div class="col-2">
		No. Rooms: <input class="form-control" type="number" id="noRooms" name="noRooms"/>
	</div>
	<div class="col-2">
		No. Guests: <input class="form-control" type="number" id="noGuests" name="noGuests"/>
	</div>
	<div class="col">
	Check-In Date: <input type="date" id="checkInDate" name="checkInDate"/>
	</div>
	<div class="col">
	Check-Out Date: <input type="date" id="checkOutDate" name="checkOutDate"/>
	</div>
	<input class="btn-sm btn-primary" type="button" id="searchBtn" value="SEARCH"/>
	</div>
</div>

<div class="row">
<div class="col-2 border rounded" style="margin-left:50px;padding:25px">
	
	<br>	
	<!--  Star Rating: 
	<select class="form-control" id="filter_starRating">
		<option value=0>Select</option>
		<option value=1>1</option>
		<option value=2>2</option>
		<option value=3>3</option>
		<option value=4>4</option>
		<option value=5>5</option>
	</select><br>--> 
	
	Star Rating:<br>
	<div class="form-check-inline">
		<label class="form-check-label">
			<input type="checkbox" class="star_rating form-check-input" id="1_star_rating" value=1>1
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label">
			<input type="checkbox" class="star_rating form-check-input" id="2_star_rating" value=2>2		
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label">
			<input type="checkbox" class="star_rating form-check-input" id="3_star_rating" value=3>3
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label">
			<input type="checkbox" class="star_rating form-check-input" id="4_star_rating" value=4>4
		</label>
	</div>
	<div class="form-check-inline">
		<label class="form-check-label">
			<input type="checkbox" class="star_rating form-check-input" id="5_star_rating" value=5>5
		</label>
	</div><br><br>
	
	Range:
	<div class="slidecontainer">
  		<input type="range" min="1" max="500" value="500" class="slider" id="priceRange">
  		<p>Price: $<span id="priceValue"></span></p>
	</div>
	
	<div class="form-check">
		<input type="checkbox" class="hotel_amenity form-check-input" id="amenity_parking" value="PARKING"/>
		<label class="form-check-label" for="amenity_parking">Parking</label><br>
		
		<input type="checkbox" class="hotel_amenity form-check-input" id="amenity_checkin_checkout" value="CHECK-IN & CHECK-OUT TIMES"/>
		<label class="form-check-label" for="amenity_checkin_checkout">Check-In & Check-Out Times</label><br>
		
		<input type="checkbox" class="hotel_amenity form-check-input" id="amenity_breakfast" value="BREAKFAST"/>
		<label class="form-check-label" for="amenity_breakfast">Breakfast</label><br>
		
		<input type="checkbox" class="hotel_amenity form-check-input" id="amenity_bar_lounge" value="BAR OR LOUNGE"/>
		<label class="form-check-label" for="amenity_bar_lounge">Bar / Lounge</label><br>
		
		<input type="checkbox" class="hotel_amenity form-check-input" id="amenity_fitness_center" value="FITNESS CENTER"/>
		<label class="form-check-label" for="amenity_fitness_center">Fitness Center</label><br>
	</div>
	
	<input style="margin-top:25px" class="btn btn-primary" type="button" id="filterBtn" value="FILTER"/>	
</div>


<div class="col-7 border rounded" style="margin-left:50px;">
	<div style='text-align:center;font-size:20px;font-family:"Trebuchet MS", Helvetica, sans-serif'>List of Hotels:</div>	
	
	<div id="listHotel">
		<table id='tblHotel' border='1'>
			<tr><th>Name</th><th>Address</th><th>Price</th><th>Image</th><th>Star</th><th>Detail</th></tr>
		</table>
	</div>
	
</div>
</div>

<div class="modal" id="myModal">
  <div class="modal-dialog">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">Search Hotel Rooms</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>

      <!-- Modal body -->
      <div class="modal-body">        
        <div class="col">
        	<input class="form-control" type="hidden" id="modal_hotelId"/>
        	Hotel Name: <input readonly="true" class="form-control" type="text" id="modal_hotelName"/>
        	No. Guests: <input class="form-control" type="number" id="modal_noGuests"/>
        	Check-In Date: <input class="form-control" type="date" id="modal_checkInDate"/>
        	Check-Out Date: <input class="form-control" type="date" id="modal_checkOutDate"/>
        	Room Type: 
        	<select class="form-control" id="select_roomTypes">
        	</select>
        	No. Rooms: <input class="form-control" type="number" id="modal_noRooms"/>
        	
        	<input style="margin-top:25px" class="btn btn-searchHotelRooms form-control btn-primary" type="button" id="" value="SEARCH"/>
        	<div style='margin-top:20px'>
	        	<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#editGuestModal" id="editGuestModalButton">
				  Edit Guest Details
				</button> 
			</div>      	
        </div>
        
      </div>

      <!-- Modal footer -->
      <div class="modal-footer" id="closeModal">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>

    </div>
  </div>
</div>

<!-- Edit Guest Modal -->
<div class="modal fade" id="editGuestModal" tabindex="-1" role="dialog" aria-labelledby="editGuestModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editGuestModalLabel">Edit Guest Details</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <!-- Container for dynamically generated content -->
                <div id="editGuestModalBody"></div>

                <!-- Form for editing guest details -->
                <form id="editGuestForm">
                    <!-- Other form fields go here -->

                    <button type="button" class="btn btn-primary" onclick="saveEditedGuest()">Save Changes</button>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<div class="modal" id="hotelRoomsModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title">Are these details correct?</h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>

      <!-- Modal body -->
      <div class="modal-body" id="hotelRooms_modalBody">        
              
      </div>

      <!-- Modal footer -->
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>

    </div>
  </div>
</div>

<div class="modal" id="bookingHotelRoomModal">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">

      <!-- Modal Header -->
      <div class="modal-header">
        <h4 class="modal-title"></h4>
        <button type="button" class="close" data-dismiss="modal">&times;</button>
      </div>

      <!-- Modal body -->
      <div class="modal-body" id="bookingRoom_modalBody">        
        	<div class="col">
       			<div><input class="form-control" type="hidden" id="booking_hotelId"/></div>
       			<div><input class="form-control" type="hidden" id="booking_hotelRoomId"/></div>
	        	<div>Hotel Name: <input readonly="true" class="form-control" type="text" id="booking_hotelName"/></div>
	        	<div>Customer Mobile: <input class="form-control" type="text" id="booking_customerMobile"/></div>
       			<div id="noGuestsDiv">No. Guests: <input readonly="true" class="form-control" type="number" id="booking_noGuests"/></div>
       			<div>Email: <input class="form-control" type="text" id="booking_userEmail" /></div>
       			<div>No. Rooms: <input readonly="true" class="form-control" type="number" id="booking_noRooms"/></div>
       			<div>Check-In Date: <input readonly="true" class="form-control" type="text" id="booking_checkInDate"/></div>
       			<div>Check-Out Date: <input readonly="true" class="form-control" type="text" id="booking_checkOutDate"/></div>
       			<div>Room Type: <input readonly="true" class="form-control" type="text" id="booking_roomType"/></div>
       			<div>Discount: <span id="booking_discount"></span>%</div>
       			<div>Price before discount: $<span id="booking_price"></span></div> 
       			<div>Total Price: $<span id="booking_totalPrice"></span></div>       			
       			<div style='margin-top:20px'>
       				<button class='btn-confirm-booking btn btn-primary' id='confirmBookingBtn'>Confirm Booking</button>
       				<button class='btn btn-primary' id="edit">Edit</button>
       			</div>
        	</div>          
      </div>

      <!-- Modal footer -->
      <div class="modal-footer" id="clsModal">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
      </div>

    </div>
  </div>
</div>

<script>
var slider = document.getElementById("priceRange");
var output = document.getElementById("priceValue");
output.innerHTML = slider.value;
slider.oninput = function() {
	output.innerHTML = this.value;
}
</script>
</body>
</html>