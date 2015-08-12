#!/usr/local/bin/python

import sys, os;
import traceback;
import MySQLdb;

class Address:
    def __init__(self, l1, l2, cty, st, ctry, zip):
        self.line1 = l1;
        self.line2 = l2;
        self.city = cty;
        self.state = st;
        self.country = ctry;
        self.postalCode = zip;

    def toXML(self, ind):
        xml = ('%s<address>\r\n' % ind);
        xml = ('%s%s  <lines>\r\n' % (xml, ind));
        if self.line1:
            xml = ('%s%s    <line>\r\n%s      %s\r\n%s    </line>\r\n' %
                   (xml, ind, ind, self.line1, ind));
        if self.line2:
            xml = ('%s%s    <line>\r\n%s      %s\r\n%s    </line>\r\n' %
                   (xml, ind, ind, self.line2, ind));
        xml = ('%s%s  </lines>\r\n' % (xml, ind));
        if self.city:
            xml = ('%s%s  <city>%s</city>\r\n' % (xml, ind, self.city));
        if self.state:
            xml = ('%s%s  <state>%s</state>\r\n' % (xml, ind, self.state));
        if self.country:
            xml = ('%s%s  <country>%s</country>\r\n' % (xml,ind,self.country));
        if self.postalCode:
            xml = ('%s%s  <postalCode>%s</postalCode>\r\n' %
                   (xml, ind, self.postalCode));
        xml = ('%s%s</address>\r\n' % (xml, ind));
        return xml;
    
class Customer:
    def __init__(self, cid, nom, addr):
        self.customerID = cid;
        self.name = nom;
        self.address = addr;

    def toXML(self, ind):
        xml = ('%s<customer customerID="%s">\r\n' % (ind, self.customerID));
        if self.name:
            xml = ('%s%s  <name>%s</name>\r\n' % (xml, ind, self.name));
        if self.address:
            xml = ('%s%s' % (xml, self.address.toXML(ind + '  ')));
        xml = ('%s%s</customer>\r\n' % (xml, ind));
        return xml;

class LineItem:
    def __init__(self, prd, qty, cost):
        self.product = prd;
        self.quantity = qty;
        self.unitCost = cost;

    def totalCost():
        return (self.quantity * self.unitCost);

    def toXML(self, ind):
        xml = ('%s<lineItem quantity="%s">\r\n' % (ind, self.quantity));
        xml = ('%s%s  <unitCost currency="USD">%s</unitCost>\r\n' %
               (xml, ind, self.unitCost));
        xml = ('%s%s' % (xml, self.product.toXML(ind + '  ')));
        xml = ('%s%s</lineItem>\r\n' % (xml, ind));
        return xml;
               
class Order:
    def __init__(self, oid, date, rep, cust):
        self.orderID = oid;
        self.orderDate = date;
        self.salesRep = rep;
        self.customer = cust;
        self.items = [];

    def toXML(self, ind):
        xml = ('%s<order orderID="%s" date="%s" salesRepID="%s">\r\n' %
               (ind, self.orderID, self.orderDate, self.salesRep));
        xml = ('%s%s' % (xml, self.customer.toXML(ind + '  ')));
        for item in self.items:
            xml = ('%s%s' % (xml, item.toXML(ind + '  ')));
        xml = ('%s%s</order>\r\n' % (xml, ind));
        return xml;

class Product:
    def __init__(self, pid, nom):
        self.productID = pid;
        self.name = nom;

    def toXML(self, ind):
        xml = ('%s<product productID="%s">\r\n' % (ind, self.productID));
        xml = ('%s%s  <name>%s</name>\r\n' % (xml, ind, self.name));
        xml = ('%s%s</product>\r\n' % (xml, ind));
        return xml;
    
def executeBatch(conn):
    try:
        cursor = conn.cursor();
        cursor.execute("SELECT ORDER_ID FROM ORDER_EXPORT " +
                       "WHERE LAST_EXPORT <> CURRENT_DATE()");
        orders = cursor.fetchall();
        cursor.close();
    except:
        print "Error retrieving orders.";
        traceback.print_exc();
        conn.close();
        exit(0);
            
    for row in orders:
        oid = row[0];
        try:
            cursor = conn.cursor();
            cursor.execute("SELECT CUST_ORDER.ORDER_DATE, " +
                           "CUST_ORDER.SALES_REP_ID, " +
                           "CUSTOMER.CUSTOMER_ID, " +
                           "CUSTOMER.NAME, " +
                           "CUSTOMER.ADDRESS1, " +
                           "CUSTOMER.ADDRESS2, " +
                           "CUSTOMER.CITY, " +
                           "CUSTOMER.STATE, " +
                           "CUSTOMER.COUNTRY, " +
                           "CUSTOMER.POSTAL_CODE " +
                           "FROM CUST_ORDER, CUSTOMER " +
                           "WHERE CUST_ORDER.ORDER_ID = %s " +
                           "AND CUST_ORDER.CUSTOMER_ID = CUSTOMER.CUSTOMER_ID",
                           ( oid ) );
            row = cursor.fetchone();
            cursor.close();
            addr = Address(row[4], row[5], row[6], row[7], row[8], row[9]);
            cust = Customer(row[2], row[3], addr);
            order = Order(oid, row[0], row[1], cust);
            cursor = conn.cursor();
            cursor.execute("SELECT LINE_ITEM.PRODUCT_ID, " +
                           "LINE_ITEM.QUANTITY, " +
                           "LINE_ITEM.UNIT_COST, " +
                           "PRODUCT.NAME " +
                           "FROM LINE_ITEM, PRODUCT " +
                           "WHERE LINE_ITEM.ORDER_ID = %s " +
                           "AND LINE_ITEM.PRODUCT_ID = PRODUCT.PRODUCT_ID",
                           oid);
            for row in cursor.fetchall():
                prd = Product(row[0], row[3]);
                order.items.append(LineItem(prd, row[1], row[2]));
        except:
            print "Failed to load order: ", oid;
            traceback.print_exc();
            exit(0);
            
        try:
            cursor.close();
        except:
            print "Error closing cursor, continuing...";
            traceback.print_exc();

        try:
            fname = ('%d.xml' % oid);
            xmlfile = open(fname, "w");
            xmlfile.write('<?xml version="1.0"?>\r\n\r\n');
            xmlfile.write(order.toXML(''));
            xmlfile.close();
        except:
            print ("Failed to write XML file: %s" % fname);
            traceback.print_exc();
            
        try:
            cursor = conn.cursor();
            cursor.execute("UPDATE ORDER_EXPORT " +
                           "SET LAST_EXPORT = CURRENT_DATE() " +
                           "WHERE ORDER_ID = %s", ( oid ));
        except:
            print "Failed to update ORDER_EXPORT table, continuing";
            traceback.print_exc();

if __name__ == '__main__':
    try:
        conn = MySQLdb.connect(host='carthage', user='test', passwd='test',
                               db='Test');
    except:
        print "Error connecting to MySQL:";
        traceback.print_exc();
        exit(0);

    executeBatch(conn);
