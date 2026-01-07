# Database Schema Documentation – FlexiMart

## 1. Entity-Relationship Description

### Entity: customers
**Purpose:** Stores customer personal and contact information.

**Attributes:**
- `customer_id` (Primary Key): Unique identifier for each customer
- `first_name`: Customer’s first name
- `last_name`: Customer’s last name
- `email`: Unique email address of the customer
- `phone`: Contact phone number
- `city`: City of residence
- `registration_date`: Date when the customer registered

**Relationships:**
- One customer can place many orders (1:M relationship with orders table)

---

### Entity: products
**Purpose:** Stores product catalog and inventory details.

**Attributes:**
- `product_id` (Primary Key): Unique identifier for each product
- `product_name`: Name of the product
- `category`: Product category
- `price`: Unit price of the product
- `stock_quantity`: Available stock count

**Relationships:**
- One product can appear in many order items (1:M relationship with order_items table)

---

### Entity: orders
**Purpose:** Stores order-level transaction details.

**Attributes:**
- `order_id` (Primary Key): Unique identifier for each order
- `customer_id` (Foreign Key): References customers(customer_id)
- `order_date`: Date of order placement
- `total_amount`: Total value of the order
- `status`: Order status (Pending, Completed, Cancelled)

**Relationships:**
- Each order belongs to one customer
- One order can contain multiple order items

---

### Entity: order_items
**Purpose:** Stores product-level details for each order.

**Attributes:**
- `order_item_id` (Primary Key): Unique identifier for each order item
- `order_id` (Foreign Key): References orders(order_id)
- `product_id` (Foreign Key): References products(product_id)
- `quantity`: Number of units ordered
- `unit_price`: Price per unit at time of order
- `subtotal`: Calculated as quantity × unit_price

**Relationships:**
- Many order items belong to one order
- Many order items reference one product

---

## 2. Normalization Explanation (3NF)

The database schema follows Third Normal Form (3NF) to eliminate redundancy and ensure data integrity.

- All tables have a primary key that uniquely identifies each record.
- Non-key attributes are fully functionally dependent on the primary key.
- There are no transitive dependencies; descriptive attributes are stored only in their respective tables.

For example:
- Customer details are stored only in the customers table and not repeated in orders.
- Product pricing and category information are stored only in the products table.
- Order and order item data are separated to avoid repeating order-level information for each product.

This design prevents update, insert, and delete anomalies while ensuring efficient storage and maintenance.

---

## 3. Sample Data Representation

### customers
| customer_id | first_name | last_name | email                | city       |
|------------|-----------|-----------|----------------------|------------|
| 1          | Rahul     | Sharma    | rahul@gmail.com      | Bangalore  |
| 2          | Neha      | Verma     | neha@gmail.com       | Mumbai     |

### products
| product_id | product_name        | category     | price |
|-----------|---------------------|--------------|-------|
| 1         | Samsung Galaxy S21  | Electronics  | 45999 |
| 2         | Nike Running Shoes  | Fashion      | 3499  |

### orders
| order_id | customer_id | order_date | total_amount |
|---------|-------------|------------|--------------|
| 101     | 1           | 2024-01-15 | 49498        |
| 102     | 2           | 2024-02-10 | 3499         |

### order_items
| order_item_id | order_id | product_id | quantity | subtotal |
|--------------|----------|------------|----------|----------|
| 1            | 101      | 1          | 1        | 45999    |
| 2            | 102      | 2          | 1        | 3499     |