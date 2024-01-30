<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Home Page of Travel Gig</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script>
	let activeTabId = 'upcomingTab';
    $(document).ready(function() {
        function showTab(tabName) {
            // Hide all tabs
            $('.tab-pane').hide();
            // Show the selected tab
            $('#' + tabName).show();

            $.ajax({
                url: 'http://localhost:8484/findAllBookings',
                method: 'GET',
                data: { tab: tabName },
                success: function(data) {
                    console.log('Data received:', data);
                    $('#' + tabName).html(renderBookingData(data, tabName));
                },
                error: function() {
                    console.error('Failed to fetch booking information.');
                }
            });
        }

         $('.nav-link').click(function() 
        {
            $('.nav-link').removeClass('active');
            $(this).addClass('active');
            activeTabId = $(this).attr('id').replace('Link', 'Tab');
            showTab(activeTabId);
        });

        $('#upcomingLink').click(function() {
            showTab('upcomingTab');
        });
        
        $('#currentLink').click(function() 
        {
            showTab('currentTab');
        });

        $('#completedLink').click(function() {
        	console.log('clicked');
            showTab('completedTab');
        });

        $('#cancelledLink').click(function() {
            showTab('cancelledTab');
        });

        function renderBookingData(data, tabName) 
        {
            let html = '<table class="table">';
            html += '<thead><tr><th>Booking ID</th><th>Customer Name</th><th>Customer Email</th><th>Customer Mobile</th><th>Room Type</th><th>Check-in Date</th><th>Check-out Date</th></tr></thead>';
            html += '<tbody>';

            for (let booking of data) {
		        if ((tabName === 'upcomingTab' && isUpcoming(booking.checkInDate) && booking.status !== 'CANCELLED') ||
		            (tabName === 'currentTab' && currentReservation(booking.checkInDate, booking.checkOutDate) && booking.status !== 'CANCELLED') ||
		            (tabName === 'completedTab' && isCompleted(booking.checkOutDate)) ||
		            (tabName === 'cancelledTab' && booking.status === 'CANCELLED')) { // Include cancelled bookings
		            console.log('Booking ID:', booking.bookingId);
		            html += '<tr>';
		            html += '<td>' + booking.bookingId + '</td>';
		            html += '<td>' + booking.customerName + '</td>';
		            html += '<td>' + booking.userEmail + '</td>';
		            html += '<td>' + booking.customerMobile + '</td>';
		            html += '<td>' + booking.roomType + '</td>';
		            html += '<td>' + booking.checkInDate + '</td>';
		            html += '<td>' + booking.checkOutDate + '</td>';
		            if (tabName === 'upcomingTab' || tabName === 'currentTab') {
		                html += '<td><button class="btn btn-danger" onclick="cancelBooking(' + booking.bookingId + ')">Cancel</button></td>';
		            }
		            html += '</tr>';
		        }
		    }

            html += '</tbody></table>';
            console.log('HTML:', html);
            return html;
        }
        
        window.cancelBooking = function(bookingId) {
	        $.ajax({
	            url: 'http://localhost:8484/cancelBooking/' + bookingId,
	            method: 'PUT',
	            success: function(response) {
	            
				    
	               console.log(activeTabId);
            	   showTab(activeTabId);
	            },
	            error: function(error) {
	                console.error('Failed to cancel booking:', error);
	            }
	        });
	    };

        function isUpcoming(checkInDate)
        {
            const currentDate = new Date().toISOString().split('T')[0];
            const upcomingDate = new Date(checkInDate).toISOString().split('T')[0];
            return upcomingDate > currentDate;
        }

        function isCompleted(checkOutDate) 
        {
            const currentDate = new Date().toISOString().split('T')[0];
            const completedDate = new Date(checkOutDate).toISOString().split('T')[0];
            return completedDate < currentDate;
        }
        
        function currentReservation(checkInDate, checkOutDate) 
        {
            const currentDate = new Date().toISOString().split('T')[0];
            const pastDate = new Date(checkInDate).toISOString().split('T')[0];
            const futureDate = new Date(checkOutDate).toISOString().split('T')[0];
            return currentDate >= pastDate && currentDate <= futureDate;
        }
    });
</script>


</head>
<body>
<div class="container" style="margin-left:100px">
    <h1>Bookings</h1>
</div>

<sec:authorize access="!isAuthenticated()">
    <div class="container" style="text-align: right; margin-top: 10px;">
        <a href="login">Login</a>
    </div>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
    <div class="container" style="text-align: right; margin-top: 10px;">
        <a href="login?logout">Logout</a>
    </div>
    
    <div class="container">
        <ul class="nav nav-tabs">
		    <li class="nav-item">
		        <a class="nav-link active" id="upcomingLink" href="#">Upcoming</a>
		    </li>
		    <li class="nav-item">
		        <a class="nav-link" id="currentLink" href="#">Current</a>
		    </li>
		    <li class="nav-item">
		        <a class="nav-link" id="completedLink" href="#">Completed</a>
		    </li>
		    <li class="nav-item">
		        <a class="nav-link" id="cancelledLink" href="#">Cancelled</a>
		    </li>
		</ul>
        
        <div class="tab-content">
            <div id="upcomingTab" class="tab-pane fade show active">
                <!-- Content for Upcoming Bookings -->
            </div>
            <div id="currentTab" class="tab-pane fade show active">
                <!-- Content for Completed Bookings -->
            </div>
            <div id="completedTab" class="tab-pane fade show active">
                <!-- Content for Completed Bookings -->
            </div>
            <div id="cancelledTab" class="tab-pane fade show active">
                <!-- Content for Cancelled Bookings -->
            </div>
        </div>
    </div>
</sec:authorize>

</body>
</html>
