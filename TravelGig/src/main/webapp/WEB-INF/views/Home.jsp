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
	$(document).ready(function() {
	    $("#searchBtn").click(function() {
	        console.log("clicked");
	        var searchString = $('#searchLocation').val();
	        $.get("/searchHotel/"+searchString, {
	            "searchString": searchString
	        }, function(responseText) {
	        	console.log(responseText);
	            $.each(responseText, function(index, val) {
	                console.log(index, val);
	                $("#tblHotel").append("<tr><td>" + val.hotelName + "</td><td>" + val.address + "</td>" +
			        "<td>" + val.averagePrice + "</td><td><img class='hotel-image' length=300 width=200 src='" + val.imageURL + "' data-hotelname='" + val.hotelName + "'>" +
			        "</img></td><td>" + val.starRating + "</td>" +
			        "<td><button class='btn btn-primary btn-show-details' data-hotelname='" + val.hotelName + "'>Show Details</button></td></tr>");
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
		
		
		
	    
	    $("#tblHotel").on('click', '.btn-show-details, .hotel-image', function(){
		    let hotelName = $(this).data('hotelname');
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
						    	var discount = roomTypeDetail.discount;
						    	var price = roomTypeDetail.price;
						    	var totalPrice = roomTypeDetail.price * ((100 - discount)/100);
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
<sec:authorize access="isAuthenticated()">
	<td>|</td>
		<br>Granted Authorities: <sec:authentication property="principal.authorities"/>
		<br> loggedInUser: ${loggedInUser}
		<td></td>
		<td><a href="logout">Logout</a></td>
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
        </div>
        
      </div>

      <!-- Modal footer -->
      <div class="modal-footer" id="closeModal">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
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
       			<div>No. Rooms: <input readonly="true" class="form-control" type="number" id="booking_noRooms"/></div>
       			<div>Check-In Date: <input readonly="true" class="form-control" type="text" id="booking_checkInDate"/></div>
       			<div>Check-Out Date: <input readonly="true" class="form-control" type="text" id="booking_checkOutDate"/></div>
       			<div>Room Type: <input readonly="true" class="form-control" type="text" id="booking_roomType"/></div>
       			<div>Discount: <span id="booking_discount"></span>%</div>
       			<div>Price before discount: $<span id="booking_price"></span></div> 
       			<div>Total Price: $<span id="booking_totalPrice"></span></div>       			
       			<div style='margin-top:20px'>
       				<button class='btn-confirm-booking btn btn-primary'>Confirm Booking</button>
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