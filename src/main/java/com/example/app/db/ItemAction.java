package com.example.app.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.ServletActionContext;

import com.example.model.Item;
import com.opensymphony.xwork2.ActionSupport;

public class ItemAction extends ActionSupport {
    static final String DB_URL = "jdbc:postgresql://db-postgres:5432/myappdb";
    static final String DB_USER = "docker";
    static final String DB_PASS = null;

    private String name;
    private Integer price;

    public String index() throws Exception {
        HttpServletRequest req = ServletActionContext.getRequest();

        List<Item> items = new ArrayList<>();

        try {
            String sql = "SELECT id, name, price, created_at, updated_at FROM item";
            Class.forName("org.postgresql.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getInt("id"));
                    item.setName(rs.getString("name"));
                    item.setPrice(rs.getInt("price"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));
                    item.setUpdatedAt(rs.getTimestamp("updated_at"));

                    items.add(item);
                }
            } catch (Exception e) {
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("items", items);

        return SUCCESS;
    }

    public String create() throws Exception {
        try {
            String sql = "INSERT INTO item (name, price, created_at, updated_at) values (?, ?, current_timestamp, current_timestamp)";
            Class.forName("org.postgresql.Driver");
            try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);) {
                conn.setAutoCommit(false);
                try (PreparedStatement stmt = conn.prepareStatement(sql);) {
                    stmt.setString(1, name);
                    stmt.setInt(2, price);
                    stmt.executeUpdate();
                } catch (Exception e) {
                    conn.rollback();
                    throw e;
                }
                conn.commit();
            } catch (Exception e) {
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return SUCCESS;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

}
