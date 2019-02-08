<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@page contentType="text/html; charset=utf-8"%>
<%@ page session="false"%>
<c:set var="path" value="${pageContext.request.contextPath}"></c:set>

<html>
<head>
<%@ include file="header.jsp"%>
<link href="${path}/css/error.css?ver=1" rel="stylesheet">
</head>
<body>
<div class="error_text">
${error}
</div>

</body>