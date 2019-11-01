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
<%@ page import="guestbook.Subscriber" %>


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

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>

<p>Hello, ${fn:escapeXml(user.nickname)}! (You can

<a href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign out</a>.)</p>

<%

    } else {

%>

<h1>Welcome to the Blog!</h1>

<p><a href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign in</a>

to create you own blog posts!</p>

<%

    }

%>

 

<%

    ObjectifyService.register(Greeting.class);
    ObjectifyService.register(Subscriber.class);
    List<Greeting>greetings = ObjectifyService.ofy().load().type(Greeting.class).list();
    List<Subscriber>subs = ObjectifyService.ofy().load().type(Subscriber.class).list();
    Collections.sort(greetings);
    
    if(subs.isEmpty()){
    	%>
    	<p>No emails found</p>
    	<%
    }else{
    	for(Subscriber sub : subs){
    		pageContext.setAttribute("user_email",
    				
                    sub.getEmail());
    		%>
    			<p>'${fn:escapeXml(user_email)}' is subscribed.</p>
    		<%
    	}
    }


    if (greetings.isEmpty()) {

        %>

        <p>Blog '${fn:escapeXml(guestbookName)}' has no posts yet.</p>
       
<%

    } else {

%>

        <p>Latest posts '${fn:escapeXml(guestbookName)}'.</p>

        <%

        for (int i = 0; i < 5; i++) 
        //for(Greeting greeting : greetings)
        {
        	if(greetings.get(i)!=null){
	        	Greeting greeting = greetings.get(i);
	
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

    }

%>

	<form action="allposts.jsp" method="get">
		<input type="submit" value="View All Posts" name="viewall" id="viewposts">
	</form>

    <form action="/ofysign" method="post">

      <div><textarea name="content" rows="3" cols="60"></textarea></div>

      <div><input type="submit" value="Submit Post" /></div>

      <input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>

    </form>
    
    <form action="/subscribe" method="post">
    	<div><input type="submit" value="Subscribe" /></div>
    </form>

 

  </body>

</html>

