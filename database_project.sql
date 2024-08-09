-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 15, 2022 at 03:01 PM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 8.1.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `database_project`
--

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `grades` varchar(255) DEFAULT NULL,
  `course_code` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `credit` int(11) DEFAULT NULL,
  `section` varchar(255) DEFAULT NULL,
  `semester` varchar(255) DEFAULT NULL,
  `stu_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`grades`, `course_code`, `status`, `credit`, `section`, `semester`, `stu_id`) VALUES
('a', 'cse 105', 'complete', 3, 'DA', '201', 201002037),
('a+', 'cse 105', 'complete', 3, 'DB', '201', 201002035),
(NULL, 'cse 310', 'ongoing', 3, 'DC', '221', 201002037);

-- --------------------------------------------------------

--
-- Table structure for table `dose_date`
--

CREATE TABLE `dose_date` (
  `emp_id` int(11) DEFAULT NULL,
  `stu_id` int(11) DEFAULT NULL,
  `date` datetime NOT NULL,
  `name_vac` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `dose_date`
--

INSERT INTO `dose_date` (`emp_id`, `stu_id`, `date`, `name_vac`) VALUES
(1, NULL, '2022-05-15 09:59:11', 'pfizer'),
(0, 201002037, '2021-05-15 00:00:00', 'cinopharm'),
(0, 201002037, '2022-05-15 00:00:00', 'cinopharm');

--
-- Triggers `dose_date`
--
DELIMITER $$
CREATE TRIGGER `3` AFTER DELETE ON `dose_date` FOR EACH ROW BEGIN

UPDATE vac_info SET no_of_doses =
(SELECT COUNT(*)
FROM dose_date 
where
emp_id= old.emp_id)
WHERE emp_id=old.emp_id;

UPDATE vac_info SET no_of_doses =
(SELECT COUNT(*)
FROM dose_date 
where
stu_id= old.stu_id)
WHERE stu_id = old.stu_id;


END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `6` AFTER INSERT ON `dose_date` FOR EACH ROW BEGIN

DECLARE a int;
DECLARE b int;

SELECT count(*) into a from dose_date where emp_id= new.emp_id;

SELECT count(*) into b from dose_date where stu_id= new.stu_id;

UPDATE vac_info SET no_of_doses =
(SELECT COUNT(*)
FROM dose_date 
where
emp_id= new.emp_id)
WHERE emp_id=new.emp_id;

UPDATE vac_info SET no_of_doses =
(SELECT COUNT(*)
FROM dose_date 
where
stu_id= new.stu_id)
WHERE stu_id = new.stu_id;

if(a>=2) THEN 
UPDATE vac_info
SET status="complete" where emp_id = new.emp_id;
end if;

if(a=1) THEN  
UPDATE vac_info
SET status="partial" where emp_id = new.emp_id;
end if;

if(a<1) THEN  
UPDATE vac_info
SET status="incomplete" where emp_id = new.emp_id;
end if;

if(a>=2) THEN 
UPDATE vac_info
SET status="complete" where stu_id = new.stu_id;
end if;

if(a=1) THEN  
UPDATE vac_info
SET status="partial" where stu_id = new.stu_id;
end if;

if(a=0) THEN  
UPDATE vac_info
SET status="incomplete" where stu_id = new.stu_id;
end if;

UPDATE vac_info SET name_vac = new.name_vac
WHERE stu_id = new.stu_id;

UPDATE vac_info SET name_vac = new.name_vac
WHERE emp_id = new.emp_id;

if(a>2) THEN  
UPDATE vac_info
SET booster="done" where stu_id = new.stu_id;
end if;

if(a>2) THEN  
UPDATE vac_info
SET booster="done" where emp_id = new.emp_id;

end if;


END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee`
--

CREATE TABLE `employee` (
  `Gender` varchar(255) DEFAULT NULL,
  `Position` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Campus_location` varchar(255) DEFAULT NULL,
  `Salary` int(11) DEFAULT NULL,
  `Phone_no` int(11) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Blood_group` varchar(255) DEFAULT NULL,
  `emp_id` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `age` varchar(255) DEFAULT NULL,
  `DOB` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`Gender`, `Position`, `Email`, `Campus_location`, `Salary`, `Phone_no`, `Address`, `Blood_group`, `emp_id`, `name`, `age`, `DOB`) VALUES
('Male', 'teacher', 't1@gmail.com', 'city', 30000, 123, 't1address', 'A+', '1', 'teacher1 ', '28', '1993-05-15 08:23:54'),
('Male', 'teacher', 't2@gmail.com', 'city', 5000, 1234, 't2address', 'B+', '2', 'teacher2', '28', '1994-05-15 08:23:54'),
('Male', 'tech support', 'support@gmail.com', 'city', 20000, 32567, 'techaddress', 'B+', '5', 'techie', '28', '1994-05-15 10:10:40');

--
-- Triggers `employee`
--
DELIMITER $$
CREATE TRIGGER `4` BEFORE INSERT ON `employee` FOR EACH ROW BEGIN

if(new.position='teacher') 
THEN
insert into 
teacher(emp_id) 
VALUES (new.emp_id); 
end if;


insert into 
vac_info(emp_id) 
VALUES (new.emp_id); 

UPDATE vac_info
SET
status = "incomplete" where emp_id = new.emp_id; 



if(new.dob) THEN
SET new.age=(DATE_FORMAT(FROM_DAYS(DATEDIFF(now(),new.DOB)), '%Y')+0);
end if;

end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `5` AFTER DELETE ON `employee` FOR EACH ROW BEGIN

DELETE FROM teacher WHERE emp_id= OLD.emp_id;

DELETE FROM vac_info WHERE emp_id= OLD.emp_id;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `student`
--

CREATE TABLE `student` (
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `stu_id` int(11) DEFAULT NULL,
  `current_sem` int(11) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `cgpa` double DEFAULT NULL,
  `gender` varchar(255) DEFAULT NULL,
  `deparment` varchar(255) DEFAULT NULL,
  `Phone_no` int(11) DEFAULT NULL,
  `campus` varchar(255) DEFAULT NULL,
  `blood_group` varchar(255) DEFAULT NULL,
  `credits_completed` int(11) DEFAULT NULL,
  `advisor` varchar(255) DEFAULT NULL,
  `AGE` varchar(255) DEFAULT NULL,
  `DOB` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `student`
--

INSERT INTO `student` (`name`, `email`, `stu_id`, `current_sem`, `address`, `cgpa`, `gender`, `deparment`, `Phone_no`, `campus`, `blood_group`, `credits_completed`, `advisor`, `AGE`, `DOB`) VALUES
('stu2', 'stu2@gmail.com', 201002035, 7, 'stu2address', 3.5, 'male', 'cse', 78901, 'city', 'b+', 85, 'teacher2', '21', '2000-05-15 08:28:13'),
('student1', 'stu1@gmail.com', 201002037, 7, 'Stu1address', 3.7, 'male', 'cse', 7890, 'city', 'a+', 84, 'teacher1', '20', '2002-05-15 08:28:13'),
('stu43', 'stu43@gmail.com', 201002042, 7, 'stu43address', 3.2, 'male', 'cse', 231891, 'permanent ', 'o+', 84, 'teacher1', '27', '1995-05-15 13:18:47');

--
-- Triggers `student`
--
DELIMITER $$
CREATE TRIGGER `1` AFTER DELETE ON `student` FOR EACH ROW BEGIN

DELETE FROM
vac_info WHERE
stu_id=old.stu_id; 

end
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `2` BEFORE INSERT ON `student` FOR EACH ROW BEGIN

insert into 
vac_info(stu_id) 
VALUES(new.stu_id); 


UPDATE vac_info
SET
status = "incomplete" where stu_id = new.stu_id; 


if(new.dob) THEN
SET new.age=(DATE_FORMAT(FROM_DAYS(DATEDIFF(now(),new.DOB)), '%Y')+0);
end if;


end
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

CREATE TABLE `teacher` (
  `emp_id` int(11) DEFAULT NULL,
  `dept` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `teacher`
--

INSERT INTO `teacher` (`emp_id`, `dept`) VALUES
(1, NULL),
(2, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `teach_courses`
--

CREATE TABLE `teach_courses` (
  `name` varchar(255) DEFAULT NULL,
  `course_code` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `teach_courses`
--

INSERT INTO `teach_courses` (`name`, `course_code`) VALUES
('teacher1', 'cse 105'),
('teacher2', 'cse103');

-- --------------------------------------------------------

--
-- Table structure for table `vac_info`
--

CREATE TABLE `vac_info` (
  `stu_id` int(11) DEFAULT NULL,
  `emp_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `booster` varchar(255) DEFAULT NULL,
  `no_of_doses` int(11) NOT NULL,
  `name_vac` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `vac_info`
--

INSERT INTO `vac_info` (`stu_id`, `emp_id`, `status`, `booster`, `no_of_doses`, `name_vac`) VALUES
(NULL, 1, 'partial', NULL, 1, 'pfizer'),
(NULL, 2, 'incomplete', NULL, 0, ''),
(201002035, NULL, 'incomplete', NULL, 0, ''),
(NULL, 5, 'incomplete', NULL, 0, ''),
(201002037, NULL, 'complete', NULL, 2, 'cinopharm'),
(NULL, NULL, 'incomplete', NULL, 0, ''),
(201002042, NULL, 'incomplete', NULL, 0, '');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
