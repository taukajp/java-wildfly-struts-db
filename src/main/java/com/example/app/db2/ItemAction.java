package com.example.app.db2;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletRequest;
import javax.sql.DataSource;

import org.apache.struts2.ServletActionContext;

import com.example.model.Item;
import com.opensymphony.xwork2.ActionSupport;

public class ItemAction extends ActionSupport {
    private String name;
    private Integer price;

    private String pname;
    private String dname;

    public String index() throws Exception {
        HttpServletRequest req = ServletActionContext.getRequest();

        List<Item> items = new ArrayList<>();

        try {
            String sql = "SELECT id, name, price, created_at, updated_at FROM item";
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:/PostgresDS");
            try (Connection conn = ds.getConnection();
                    Statement stmt = conn.createStatement();
                    ResultSet rs = stmt.executeQuery(sql);) {
                pname = conn.getMetaData().getDatabaseProductName();
                dname = conn.getMetaData().getDriverName();

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
            Context ctx = new InitialContext();
            DataSource ds = (DataSource) ctx.lookup("java:/PostgresDS");
            try (Connection conn = ds.getConnection();) {
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

    public String getPname() {
        return pname;
    }

    public void setPname(String pname) {
        this.pname = pname;
    }

    public String getDname() {
        return dname;
    }

    public void setDname(String dname) {
        this.dname = dname;
    }

}
