DROP database IF exists test;
CREATE database IF not exists test;
USE test;

# Bảng categories
CREATE TABLE categories
(
	id	int primary key auto_increment,
	name	varchar(100) not null unique,
	status	tinyint default 0
);

#  Bảng products
CREATE TABLE products
(
	id	int primary key auto_increment,
	name	varchar(200) not null,
	price	float not null,
	image	varchar(200),
	category_id	int,
	Constraint fk_category_id foreign key(category_id) references categories(id)
);

# Bảng customers
CREATE TABLE customers
(
	id	int primary key auto_increment,
    name	varchar(100) not null,
    email	varchar(100) not null unique,
    image	varchar(200),
    birthday	date,
    gender	tinyint
);

# Bảng Orders
CREATE TABLE orders
(
	id	int primary key auto_increment,
    customer_id int,
    created	timestamp default now(),
    status	tinyint default 0,
    Constraint fk_customer_id foreign key(customer_id) references customers(id) 
);

#  Bảng order_details
CREATE TABLE order_details
(
	order_id	int,
    product_id	int,
    quantity	int not null,
    price	float not null,
    Constraint fk_order_id foreign key(order_id) references orders(id),
    Constraint fk_product_id foreign key(product_id) references products(id)
);

INSERT INTO categories (name, status) VALUES
  ('Áo', 1),
  ('Quần', 1),
  ('Mũ', 1),
  ('Giày', 1);

INSERT INTO products (name, category_id, price) VALUES
  ('Áo sơ mi', 1, 150000),
  ('Áo khoác dạ', 1, 500000),
  ('Quần Kaki', 2, 200000),
  ('Giày tây', 4, 1000000),
  ('Mũ bảo hiểm A1', 3, 100000);

INSERT INTO customers (name, email, birthday, gender) VALUES
  ('Nguyễn Minh Khôi', 'khoi@gmail.com', '2021-12-21', 1),
  ('Nguyễn Khánh Linh', 'linh@gmail.com', '2001-12-12', 0),
  ('Đỗ Khánh Linh', 'linh2@gmail.com', '1999-01-01', 0);

INSERT INTO orders (customer_id, created, status) VALUES
  (1, '2023-11-08', 0),
  (2, '2023-11-09', 0),
  (3, '2023-11-09', 0);

INSERT INTO order_details (order_id, product_id, quantity, price) VALUES
  (1, 1, 1, 149000),
  (1, 2, 1, 499000),
  (2, 2, 2, 499000),
  (3, 3, 1, 100000);

/* Thực hiện các truy vấn dữ liệu.*/
-- 1. Hiển thị danh sách danh mục gồm id,name,status
SELECT	* 
FROM categories;

-- 2. Hiển thị danh sách sản phẩm gồm id,name,price,category_name(tên danh mục)
SELECT prod.id, prod.name, prod.price, cate.name
FROM products as prod
JOIN categories as cate ON prod.category_id = cate.id;

-- 3. Hiển thị danh sách sản phẩm có giá lớn hơn 200000
SELECT *
FROM products
WHERE price > 200000;

-- 4. Hiển thị 3 sản phẩm có giá cao nhất
SELECT *
FROM products
ORDER BY price desc
LIMIT 3;

-- 5. Hiển thị danh sách đơn hàng gồm id,customer_name,created,status.
SELECT ord.id, cus.name, ord.created, ord.status
FROM orders as ord
JOIN customers as cus ON ord.customer_id = cus.id;

-- 6. Cập nhật trạng thái đơn hàng có id là 1
UPDATE orders
SET status = 1
WHERE id = 1;

-- 7. Hiển thị chi tiết đơn hàng của đơn hàng có id là 1, 
-- bao gồm order_id,product_name,quantity,price,total_money là giá trị của (price * quantity)
SELECT detail.order_id, prod.name, detail.quantity, detail.price, (detail.price * detail.quantity) as total_monney
FROM order_details as detail
JOIN products prod ON detail.product_id = prod.id
WHERE order_id = 1;

-- 8.  Danh sách danh mục gồm, id,name,status, quantity_product(đếm trong bảng product)
SELECT cate.id, cate.name,status, count(prod.id) as quantity_product
FROM categories as cate
JOIN products as prod ON cate.id = prod.category_id
GROUP BY cate.id;