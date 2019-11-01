package guestbook;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;

@Entity
public class Subscriber {
	@Id Long id;
	@Index String email;
	private Subscriber() {}
	public Subscriber(String email) {
		// TODO Auto-generated constructor stub
		this.email = email;
	}
	
	public String getEmail() {
		return this.email;
	}

}
