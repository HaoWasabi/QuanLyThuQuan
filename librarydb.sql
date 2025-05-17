-- Xoá CSDL nếu đã tồn tại (dùng cẩn trọng khi chạy trên môi trường thực)
DROP DATABASE IF EXISTS LibraryDB;

-- Tạo CSDL mới
CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE member (
    member_id INT UNSIGNED PRIMARY KEY,  
    full_name VARCHAR(255),
    birthday DATE,
    phone_number VARCHAR(15) UNIQUE,
    email VARCHAR(255) UNIQUE,
    department VARCHAR(15), -- Khoa
    major VARCHAR(15), -- chuyên ngành
    class VARCHAR(15), -- lớp
    password VARCHAR(255),
    role ENUM('member', 'admin'),
    status TINYINT DEFAULT 1, -- 1: Active // 2: Deleted // 3: Blocked
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE seat (
    seat_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    status TINYINT DEFAULT 1 -- 1: Active // 0: Deleted // 2:Đã được đặt
);

CREATE TABLE device (
    device_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    image VARCHAR(255),
    status TINYINT DEFAULT 1, -- 1: Còn // 2: Đã mượn // 3: Đang bảo trì// 4: Ẩn Hidden (ko show lên giao diện)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE reservation ( 
    reservation_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id INT UNSIGNED,
    seat_id INT UNSIGNED DEFAULT NULL, -- NULL nếu mượn mang về
    reservation_type TINYINT CHECK (reservation_type IN (1, 2)), -- 1: tại chỗ, 2: mang về
    reservation_time DATETIME,
    due_time DATETIME,
    return_time DATETIME,
    status TINYINT DEFAULT 1, -- 1: Đang mượn // 2: Đã trả // 3:Vi Phạm// 4: Ẩn Hidden (ko show lên giao diện)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (seat_id) REFERENCES seat(seat_id)
);

CREATE TABLE reservation_detail (
    reservation_detail_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT UNSIGNED,
    device_id INT UNSIGNED,
    status TINYINT DEFAULT 1, -- 1: Đang mượn // 2: Đã trả // 3:Vi Phạm
    FOREIGN KEY (device_id) REFERENCES device(device_id),
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id)
);

CREATE TABLE log (
    log_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id VARCHAR(10),
    checkin_time DATETIME,
    status TINYINT DEFAULT 1, -- 1: Active // 2: Deleted
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE regulation (
    regulation_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255),
    type VARCHAR(255),
    description VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE violation (
    violation_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    member_id INT UNSIGNED,
    regulation_id INT UNSIGNED,
    reservation_id INT UNSIGNED,  
    penalty VARCHAR(255), -- Hình phạt
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_time DATETIME DEFAULT NULL, -- NULL: Phạt không tính thời gian, như phạt tiền
    status TINYINT DEFAULT 1, -- 1: Active // 2: Deleted
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (regulation_id) REFERENCES regulation(regulation_id),
    FOREIGN KEY (reservation_id) REFERENCES reservation(reservation_id)
);



