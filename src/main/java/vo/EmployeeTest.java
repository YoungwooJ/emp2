package vo;

public class EmployeeTest {
	public static void main(String[] args) {
		Employee e = new Employee();
		//e.birthDate = "2000-01-01";
		e.setBirthDate("2000-01-01"); // this = e
		System.out.println(e.getBirthDate()); // this = e
		//System.out.println(e.birthDate()); // this = e
		Employee e2 = new Employee();
		//e2.birthDate = "2022-01-02";
		e2.setBirthDate("2000-01-02");
		System.out.println(e2.getBirthDate()); // this = e
	}
}