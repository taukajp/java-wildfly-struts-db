<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<html>
<head>
  <title>DB Sample</title>
</head>
<body>
<h2>Use Class.forName</h2>

<s:form action="create" >
  <s:textfield name="name" />
  <s:textfield name="price" />
  <s:submit value="登録" />
</s:form>

<h3>Item Detail</h3>
<table border="1">
  <tr><th>id</th><th>name</th><th>price</th><th>created_at</th><th>updated_at</th></tr>
<c:forEach var="item" items="${items}">
  <tr>
    <td style="text-align: right;"><c:out value="${item.id}"/></td>
    <td><c:out value="${item.name}"/></td>
    <td style="text-align: right;"><fmt:formatNumber value="${item.price}" /></td>
    <td><fmt:formatDate value="${item.createdAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
    <td><fmt:formatDate value="${item.updatedAt}" pattern="yyyy-MM-dd HH:mm:ss" /></td>
  </tr>
</c:forEach>
</table>
</body>
</html>
