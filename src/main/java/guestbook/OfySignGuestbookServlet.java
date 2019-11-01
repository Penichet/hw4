package guestbook;


import com.googlecode.objectify.*;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.UserService;

import com.google.appengine.api.users.UserServiceFactory;

 

import java.io.IOException;

import java.util.Date;

 

import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

 

public class OfySignGuestbookServlet extends HttpServlet {
	
	

	static {

        ObjectifyService.register(Greeting.class);

    }
	

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();
        
        Greeting nuser = new Greeting(user, req.getParameter("content"), req.getParameter("guestbookName"));

        ofy().save().entity(nuser).now();
        
 
        resp.sendRedirect("/ofyguestbook.jsp?guestbookName=" + req.getParameter("guestbookName"));

    }

}