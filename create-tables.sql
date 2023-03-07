DROP DATABASE IF EXISTS CS348_MOVIE_DB; 
CREATE DATABASE CS348_MOVIE_DB; 

USE CS348_MOVIE_DB;

DROP TABLE IF EXISTS Movie;

CREATE TABLE Movie (
  id INT NOT NULL PRIMARY KEY,
  name VARCHAR(255),
  year INT,
  runtime INT,
  avg_rate DECIMAL(4,2),
  num_of_ratings INT
);

DROP TABLE IF EXISTS Actor;

CREATE TABLE Actor (
  id INT NOT NULL PRIMARY KEY,
  first_name VARCHAR(255),
  surname VARCHAR(255)
);

DROP TABLE IF EXISTS Director;

CREATE TABLE Director (
  id INT NOT NULL PRIMARY KEY,
  first_name VARCHAR(255),
  surname VARCHAR(255)
);

DROP TABLE IF EXISTS Direction;

CREATE TABLE Direction (
  did INT NOT NULL,
  mid INT NOT NULL,
  PRIMARY KEY (did, mid),
  FOREIGN KEY (did) REFERENCES Director(id),
  FOREIGN KEY (mid) REFERENCES Movie(id)
);

DROP TABLE IF EXISTS Cast;

CREATE TABLE Cast (
  aid INT NOT NULL,
  mid INT NOT NULL,
  PRIMARY KEY (aid, mid),
  FOREIGN KEY (aid) REFERENCES Actor(id),
  FOREIGN KEY (mid) REFERENCES Movie(id)
);

DROP TABLE IF EXISTS Genre;

CREATE TABLE Genre (
  id INT NOT NULL PRIMARY KEY,
  type VARCHAR(255)
);

DROP TABLE IF EXISTS Movie_Genre;

CREATE TABLE Movie_Genre (
  gid INT NOT NULL,
  mid INT NOT NULL,
  PRIMARY KEY (gid, mid),
  FOREIGN KEY (gid) REFERENCES Genre(id),
  FOREIGN KEY (mid) REFERENCES Movie(id)
);

DROP TABLE IF EXISTS Reviewer;

CREATE TABLE Reviewer (
  id INT NOT NULL PRIMARY KEY,
  username VARCHAR(255),
  num_of_ratings INT
);

DROP TABLE IF EXISTS Rating;

CREATE TABLE Rating (
  rid INT NOT NULL,
  mid INT NOT NULL,
  rate DECIMAL(2,1),
  comment VARCHAR(255),
  PRIMARY KEY (rid, mid),
  FOREIGN KEY (rid) REFERENCES Reviewer(id),
  FOREIGN KEY (mid) REFERENCES Movie(id)
);

DELIMITER $$

CREATE TRIGGER update_movie_rating
  AFTER INSERT ON Rating
  FOR EACH ROW
BEGIN
  UPDATE Movie
  SET avg_rate = (avg_rate * num_of_ratings + NEW.rate) / (num_of_ratings + 1), num_of_ratings = num_of_ratings + 1
  WHERE id = NEW.mid;
END$$



CREATE TRIGGER update_reviewer_num_of_ratings
  AFTER INSERT ON Rating
  FOR EACH ROW
BEGIN
    UPDATE Reviewer 
    SET num_of_ratings = num_of_ratings + 1 
    WHERE id = NEW.rid;
END$$

DELIMITER ;