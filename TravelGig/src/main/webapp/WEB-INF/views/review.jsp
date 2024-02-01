<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Hotel Reviews</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" type="text/css" href="home.css">

<body>
    <h2>Hotel Reviews</h2>


    <c:if test="${not empty reviews}">
        <table border="1">
            <thead>
                <tr>
                    <th>Review ID</th>
                    <th>Booking ID</th>
                    <th>Text</th>
                    <th>Service Rating</th>
                    <th>Amenities Rating</th>
                    <th>Booking Process Rating</th>
                    <th>Whole Experience Rating</th>
                    <th>Overall Rating</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="review" items="${reviews}">
                    <tr>
                        <td>${review.reviewId}</td>
                        <td>${review.booking.bookingId}</td>
                        <td>${review.text}</td>
                        <td>${review.serviceRating}</td>
                        <td>${review.amenitiesRating}</td>
                        <td>${review.bookingProcessRating}</td>
                        <td>${review.wholeExpRating}</td>
                        <td>${df.format(review.overallRating)}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty reviews}">
        <p>No reviews available.</p>
    </c:if>
</body>
</html>
