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
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %> 
<%@ page import="javax.mail.internet.MimeMessage" %>
<%@ page import="javax.activation.*" %> 
<%@ page import="java.util.Properties" %>


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
    boolean found = false;
    Long id;
    //show unsub button if subbed, show sub button if unsubbed
    if(user != null){
	    for(Subscriber sub : subs){
	    	if(sub.getEmail().equals(user.getEmail())){
	    		found = true;
	    		id = sub.getID();
	    		pageContext.setAttribute("userid", id.toString());
	    		//TODO: check types
	    	}
	    }
    }
    /////////////////////////////////////////
    //TEST EMAIL CODE
    for(Subscriber sub : subs){
    	    	Properties props = new Properties();
					Session ses = Session.getDefaultInstance(props, null);
					
					Message msg = new MimeMessage(ses);
					
					//set message attributes
					msg.setFrom(new InternetAddress("update@tutorial5-255204.appspotmail.com", "EE461L-HW4 Update"));
					msg.addRecipient(Message.RecipientType.TO, new InternetAddress(sub.getEmail()));
					msg.setSubject("New Blog Posts");
					//sb.append("\n");
					StringBuilder sb = new StringBuilder();
					for(Greeting g : greetings){
						//sb.append(g.getTitle());
						//sb.append("\n");
						sb.append(g.getContent());
						sb.append("\n");
						//sb.append("Author: " +  g.getUser().getEmail());
						//sb.append("\n");
					}
					sb.append("Thanks for subscribing.");
					msg.setText(sb.toString());
					
					//Transport.send(msg); //send out the email
    }

    
    
    
    
    
    
    
    //////////////////////////////////////////
    
    if(!found && user!=null){
    	%>
    	<form action="/subscribe" method="post">
    		<div><input type="submit" value="Subscribe" /></div>
    		<input type="hidden" name="guestbookName" value="${fn:escapeXml(guestbookName)}"/>
    	</form>
    	<%
    }else if (user!= null){
    	//delete user if subscribed
    	
    		%>
    			<form action="/unsubscribe" method="post">
		    		<div><input type="submit" value="Unsubscribe" /></div>
		    		<input type="hidden" name="userid" value="${fn:escapeXml(userid)}"/>
    			</form>
    		<%
    	
    }
    
    for(Subscriber s: subs){
    	pageContext.setAttribute("sub", s.getEmail());
    	%>
    	 <p>'${fn:escapeXml(sub)}' is Subscribed.</p>
    	<%
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
        	if(greetings.size()>i){
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
    
    

 

  </body>

</html>

