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
<meta charset="ISO-8859-1">
<title>User Form</title>
</head>
<link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet">


<body>
<div align="center">
	<table>
	<tr>
	<sec:authorize access="isAuthenticated()">
	<td>|</td>
		<br>Granted Authorities: <sec:authentication property="principal.authorities"/>
		<br> loggedInUser: ${loggedInUser}
		<td><a href="logout">Logout</a></td>
	</sec:authorize>
	<td></td>
	<td></td>
	</tr>
	</table>
</div>


<div align="center">

<h1>User Form</h1>


<f:form action="saveUser" modelAttribute="user">
<table>
	<tr>
		<td>User Id:</td>
		<td><f:input path="userId" value="${user.userId}"/></td>
		<td><f:errors path="userId" cssClass="error" /></td>
	</tr>

	<tr>
		<td>User Name</td>
		<td><f:input  path="username" value="${user.username}"/></td>
		<td><f:errors path="username" cssClass="error" /></td>
	</tr>

	<tr>
		<td>Password</td>
		<td><f:password   path="password" value="${user.password}"/></td>
		<td><f:errors path="password" cssClass="error" /></td>
	</tr>


	<tr>
		<td>Email</td>
		<td><f:input   path="email" value="${user.email}"/></td>
		<td><f:errors path="email" cssClass="error" /></td>
	</tr>

	<tr>
		<td>Roles</td>
		<td>
			<c:forEach items="${roles}" var="role">
				<c:if test="${retrievedRole.contains(role) }" >
					<f:checkbox path="roles" label="${role.name}" value="${role.roleId}" checked="true"/>
					</c:if>
					
					<c:if test="${!retrievedRole.contains(role) }" >
					<f:checkbox path="roles" label="${role.name}" value="${role.roleId}" />
				</c:if>
			</c:forEach>
		</td>
		<td><f:errors path="roles" cssClass="error" /></td>
	</tr>

<tr>
<td colspan="2" align="center"><input  type="submit" value="submit" class="btn btn-primary"/></td>
</tr>
</table>
</f:form>

</div>

<div align="center">

<table border="1">
<thead>
<tr><td>User Id</td><td>Name</td><td>Password</td><td>Email</td>
<td>Roles</td>
<td>Action</td>
</tr>
</thead>

<c:forEach items="${users}" var="user">
<tr>
<td>${user.getUserId() }</td>
<td>${user.getUsername() }</td>
<td>${user.getPassword() }</td>
<td>${user.getEmail() }</td>

<td>
<c:forEach items="${user.getRoles()}" var="role">
${role.getName()}

</c:forEach>
</td>
<sec:authorize access="hasAuthority('Admin')">
<td>
<a href="${pageContext.request.contextPath}/update?userId=${user.getUserId() }">Update</a>
<a href="${pageContext.request.contextPath}/delete?userId=${user.getUserId() }">Delete</a>
</td>
</sec:authorize>
</tr>
</c:forEach>

</table>
</div>
</body>
</html>