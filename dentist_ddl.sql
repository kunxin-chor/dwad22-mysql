create database dentists;

-- if you forget to add primary key for clinics
alter table clinics add column clinic_id tinyint unsigned auto_increment primary key;

create table clinics (
    clinic_id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    opening TIME NOT NULL,
    closing TIME NOT NULL,
    street_name VARCHAR (255) NOT NULL DEFAULT "",
    unit_no VARCHAR(10) NOT NULL DEFAULT "",
    postal_code VARCHAR(10) NOT NULL DEFAULT "",
    floor_number VARCHAR(3) NOT NULL DEFAULT ""
) engine = innodb;

insert into clinics (name, opening, closing)
    VALUES ("Accent Dental", "07:00", "18:00");

create table dentists (
    dentist_id int unsigned PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    license_number VARCHAR(10) NOT NULL
) engine = innodb;

insert into dentists (name, license_number) VALUES
    ("Dr. Chua", "M102314C"),
    ("Dr. Tan", "M144145Z"),
    ("Dr. Heng", "L12234Z");

create table clinics_dentists ( 
    clinics_dentists_id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    clinic_id TINYINT UNSIGNED NOT NULL,
    dentist_id INT UNSIGNED NOT NULL,
    day varchar(10) NOT NULL,
    FOREIGN KEY (clinic_id) REFERENCES clinics(clinic_id),
    FOREIGN KEY (dentist_id) REFERENCES dentists(dentist_id)
) engine = innodb;

INSERT INTO clinics_dentists (clinic_id, dentist_id, day)
    VALUES (1, 1, "Monday"),
     (1, 1, "Tuesday"),   
     (1, 2, "Wedensday"),
     (1, 3, "Thursday"),
     (1, 3, "Friday");