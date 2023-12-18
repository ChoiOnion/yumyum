package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public UserDAO() {
        try {
        	String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
            String dbID = "root";
            String dbPassword = "1234";
            String driverName = "com.mysql.jdbc.Driver";
            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int login(String id, String pwd) {
        String SQL = "SELECT pwd FROM member WHERE id = ?";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                if (rs.getString(1).equals(pwd)) {
                    return 1; // 회원가입 성공
                } else {
                    return 0; // 비밀번호 불일치
                }
            }
            return -1; // 아이디가 없음
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -2; // DB 오류
    }

    public int join(User user) {
        String SQL = "INSERT INTO member VALUES (?,?,?,?,?,?)";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, user.getId());
            pstmt.setString(2, user.getPwd());
            pstmt.setString(3, user.getMail());
            pstmt.setString(4, user.getName());
            pstmt.setString(5, user.getPhoneNum());
            pstmt.setString(6, user.getGender());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -2; // DB 오류
    }

    public String getUserName(String id) {
        String SQL = "SELECT name FROM member WHERE id = ?";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, id);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getString(1);
            }
            return "익명";
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "익명";
    }
}
