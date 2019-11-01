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

 

public class SubscriberServlet extends HttpServlet {
	
	

	static {

        ObjectifyService.register(Subscriber.class);

    }
	

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

        UserService userService = UserServiceFactory.getUserService();

        User user = userService.getCurrentUser();
        Subscriber sub = new Subscriber(user.getEmail());
        ofy().save().entity(sub).now();
        resp.sendRedirect("/ofyguestbook.jsp?guestbookName=" + req.getParameter("guestbookName"));
        
        //TODO: indicate that user is subscribed
    }

}