package guestbook;


import com.googlecode.objectify.*;

import static com.googlecode.objectify.ObjectifyService.ofy;

import com.google.appengine.api.users.User;

import com.google.appengine.api.users.UserService;

import com.google.appengine.api.users.UserServiceFactory;

import guestbook.Subscriber;

import java.io.IOException;

import java.util.Date;

 

import javax.servlet.http.HttpServlet;

import javax.servlet.http.HttpServletRequest;

import javax.servlet.http.HttpServletResponse;

 

public class UnsubscriberServlet extends HttpServlet {
	
	

	static {

        ObjectifyService.register(Subscriber.class);

    }
	

    public void doPost(HttpServletRequest req, HttpServletResponse resp)

                throws IOException {

//        UserService userService = UserServiceFactory.getUserService();
//
//        User user = userService.getCurrentUser();
//        Subscriber sub = new Subscriber(user.getEmail());
    	Long id = Long.decode(req.getParameter("userid"));
    	ofy().delete().type(Subscriber.class).id(id);
        resp.sendRedirect("/ofyguestbook.jsp");
        
        //TODO: indicate that user is subscribed
    }

}