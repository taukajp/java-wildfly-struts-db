package com.example.app.db4;

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
import javax.transaction.UserTransaction;

import org.apache.struts2.ServletActionContext;

import com.example.model.Item;
import com.opensymphony.xwork2.ActionSupport;

public class ItemAction extends ActionSupport {
    private String name;
    private Integer price;

    private String pgPname;
    private String pgDname;

    private String msPname;
    private String msDname;

    private String orPname;
    private String orDname;

    public String index() throws Exception {
        HttpServletRequest req = ServletActionContext.getRequest();

        List<Item> pgItems = new ArrayList<>();
        List<Item> msItems = new ArrayList<>();
        List<Item> orItems = new ArrayList<>();

        try {
            String sql = "SELECT id, name, price, created_at, updated_at FROM item";
            final Context ctx = new InitialContext();
            final DataSource pgDs = (DataSource) ctx.lookup("java:/PostgresXADS");
            final DataSource msDs = (DataSource) ctx.lookup("java:/MysqlXADS");
            final DataSource orDs = (DataSource) ctx.lookup("java:/OracleXADS");

            try (Connection pgConn = pgDs.getConnection();
                    Statement pgStmt = pgConn.createStatement();
                    ResultSet pgRs = pgStmt.executeQuery(sql);
                    Connection msConn = msDs.getConnection();
                    Statement msStmt = msConn.createStatement();
                    ResultSet msRs = msStmt.executeQuery(sql);
                    Connection orConn = orDs.getConnection();
                    Statement orStmt = orConn.createStatement();
                    ResultSet orRs = orStmt.executeQuery(sql);) {

                pgPname = pgConn.getMetaData().getDatabaseProductName();
                pgDname = pgConn.getMetaData().getDriverName();
                msPname = msConn.getMetaData().getDatabaseProductName();
                msDname = msConn.getMetaData().getDriverName();
                orPname = orConn.getMetaData().getDatabaseProductName();
                orDname = orConn.getMetaData().getDriverName();

                while (pgRs.next()) {
                    Item item = new Item();
                    item.setId(pgRs.getInt("id"));
                    item.setName(pgRs.getString("name"));
                    item.setPrice(pgRs.getInt("price"));
                    item.setCreatedAt(pgRs.getTimestamp("created_at"));
                    item.setUpdatedAt(pgRs.getTimestamp("updated_at"));

                    pgItems.add(item);
                }

                while (msRs.next()) {
                    Item item = new Item();
                    item.setId(msRs.getInt("id"));
                    item.setName(msRs.getString("name"));
                    item.setPrice(msRs.getInt("price"));
                    item.setCreatedAt(msRs.getTimestamp("created_at"));
                    item.setUpdatedAt(msRs.getTimestamp("updated_at"));

                    msItems.add(item);
                }

                while (orRs.next()) {
                    Item item = new Item();
                    item.setId(orRs.getInt("id"));
                    item.setName(orRs.getString("name"));
                    item.setPrice(orRs.getInt("price"));
                    item.setCreatedAt(orRs.getTimestamp("created_at"));
                    item.setUpdatedAt(orRs.getTimestamp("updated_at"));

                    orItems.add(item);
                }
            } catch (Exception e) {
                throw e;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        req.setAttribute("pgItems", pgItems);
        req.setAttribute("msItems", msItems);
        req.setAttribute("orItems", orItems);

        return SUCCESS;
    }

    public String create() throws Exception {
        try {
            String sql = "INSERT INTO item (name, price, created_at, updated_at) values (?, ?, current_timestamp, current_timestamp)";
            final Context ctx = new InitialContext();
            final UserTransaction userTx = (UserTransaction) ctx.lookup("java:comp/UserTransaction");
            final DataSource pgDs = (DataSource) ctx.lookup("java:/PostgresXADS");
            final DataSource msDs = (DataSource) ctx.lookup("java:/MysqlXADS");
            final DataSource orDs = (DataSource) ctx.lookup("java:/OracleXADS");

            userTx.begin();

            try (Connection pgConn = pgDs.getConnection();
                    Connection msConn = msDs.getConnection();
                    Connection orConn = orDs.getConnection();) {
                try (PreparedStatement pgStmt = pgConn.prepareStatement(sql);
                        PreparedStatement msStmt = msConn.prepareStatement(sql);
                        PreparedStatement orStmt = orConn.prepareStatement(sql);) {
                    pgStmt.setString(1, name);
                    pgStmt.setInt(2, price);
                    pgStmt.executeUpdate();

                    msStmt.setString(1, name);
                    msStmt.setInt(2, price);
                    msStmt.executeUpdate();

                    orStmt.setString(1, name);
                    orStmt.setInt(2, price);
                    orStmt.executeUpdate();
                } catch (Exception e) {
                    throw e;
                }
            } catch (Exception e) {
                userTx.rollback();
                throw e;
            }

            userTx.commit();
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

    public String getPgPname() {
        return pgPname;
    }

    public void setPgPname(String pgPname) {
        this.pgPname = pgPname;
    }

    public String getPgDname() {
        return pgDname;
    }

    public void setPgDname(String pgDname) {
        this.pgDname = pgDname;
    }

    public String getMsPname() {
        return msPname;
    }

    public void setMsPname(String msPname) {
        this.msPname = msPname;
    }

    public String getMsDname() {
        return msDname;
    }

    public void setMsDname(String msDname) {
        this.msDname = msDname;
    }

    public String getOrPname() {
        return orPname;
    }

    public void setOrPname(String orPname) {
        this.orPname = orPname;
    }

    public String getOrDname() {
        return orDname;
    }

    public void setOrDname(String orDname) {
        this.orDname = orDname;
    }

}
