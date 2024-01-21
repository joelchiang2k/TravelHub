<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="f"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<head>
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">
<meta charset="ISO-8859-1">
<title>Role Form</title>
<style type="text/css">
.error
(
color
:red
;
)
</style>
</head>

<div align="center">
	<table>
	<tr>
	
	<sec:authorize access="isAuthenticated()">
	<td>|</td>
		<br> loggedInUser: ${loggedInUser}
		<td><a href="logout">Logout</a></td>
	</sec:authorize>
	<td></td>
	<td></td>
	</tr>
	</table>
</div>

<body>
	<div align="center">
		<h1>Role Form</h1>
		<sec:authorize access="hasAuthority('Admin')">
		<f:form action="saveRole" modelAttribute="role">
			<table>
				<tr>
					<td>Role Id:</td>
					<td><f:input path="roleId" /></td>
					<td><f:errors path="roleId" cssClass="error" /></td>
				</tr>

				<tr>
					<td>Role Name:</td>
					<td><f:input path="name" /></td>
					<td><f:errors path="name" cssClass="error" /></td>
				</tr>

				<tr>
					<td colspan="3" align="center"><input type="submit"
						value="submit"  class="btn btn-primary"/></td>
				</tr>

			</table>
		</f:form>
		</sec:authorize>
	</div>

	<div class="container-sm" align="center">
		<table class="table table-bordered border-primary">
			<thead>
				<tr>
					<td>Role Id</td>
					<td>Role Name</td>
				</tr>
			</thead>
			<c:forEach items="${roles}" var="role">

				<tr>
					<td>${role.getRoleId() }</td>
					<td>${role.getName() }</td>
				</tr>
			</c:forEach>

		</table>
	</div>
</body>
</html>