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
        	String dbURL = "jdbc:mysql://localhost:3306/loadDB";
            String dbID = "root";
            String dbPassword = "root";
            String driverName = "com.mysql.jdbc.Driver";
            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int login(String userID, String userPassword) {
        String SQL = "SELECT userPassword FROM user WHERE userID = ?";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                if (rs.getString(1).equals(userPassword)) {
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
        String SQL = "INSERT INTO user VALUES (?,?,?,?,?,?,?)";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, user.getUserId());
            pstmt.setString(2, user.getUserPassword());
            pstmt.setString(3, user.getUserName());
            pstmt.setString(4, user.getUserEmail());
            pstmt.setString(5, user.getUserSex());
            pstmt.setString(6, user.getUserPhone());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -2; // DB 오류
    }

    public String getUserName(String userId) {
        String SQL = "SELECT userName FROM user WHERE userId = ?";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userId);
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
