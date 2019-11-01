<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%@ page import="java.util.List" %>

<%@ page import="java.util.Collections" %>

<%@ page import="com.google.appengine.api.users.User" %>

<%@ page import="com.google.appengine.api.users.UserService" %>

<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>


<%@ page import="com.googlecode.objectify.Objectify" %>

<%@ page import="com.googlecode.objectify.ObjectifyService" %>

<%@ page import="com.googlecode.objectify.*" %>

<%@ page import="guestbook.Greeting" %>


<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

 

<html>

  <head>
	<link type= "text/css" rel = "stylesheet" href="/stylesheets/main.css"/>
  </head>

 

  <body>

 

<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "default";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

%>

<h1>Welcome to the Blog!</h1>

<p>You are viewing all posts!</p>

 

<%

    ObjectifyService.register(Greeting.class);
    List<Greeting>greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
    Collections.sort(greetings);


    if (greetings.isEmpty()) {

        %>

        <p>Blog '${fn:escapeXml(guestbookName)}' has no posts yet.</p>

        <%

    } else {

        %>

        <p>Latest posts '${fn:escapeXml(guestbookName)}'.</p>

        <%

        for(Greeting greeting : greetings)
        {
	            pageContext.setAttribute("greeting_content",
	
	                                     greeting.getContent());
	
	            if (greeting.getUser() != null) {
	
	            	pageContext.setAttribute("greeting_user",
	
	                        greeting.getUser());
	
					%>
	
					<p><b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:</p>
					<blockquote>${fn:escapeXml(greeting_content)}</blockquote>
	
					<%
	
	
	            }

        }

    }

%> 

  </body>

</html>

