CREATE DATABASE  IF NOT EXISTS `movie`;

use `movie`;


drop table if exists IMDb_movies;

create table IMDb_movies (
	imdb_title_id varchar(255),
    title varchar(255),
    original_title varchar(255),
    year varchar(30),
    date_published date,
    genre varchar(255),
    duration_in_minutes int,
    country varchar(255),
    language varchar(255),
    director varchar(255),
    writer varchar(255),
    production_company varchar(255),
    main_actors varchar(600),
    description varchar(600),
    avg_vote float,
    votes int,
    budget varchar(100),
    usa_gross_income varchar(100),
    worlwide_gross_income varchar(100),
    metascore float,
    reviews_from_users float,
    reviews_from_critics float,
    primary key (imdb_title_id)
    );
    
LOAD DATA local INFILE '/Users/liqi/Desktop/CS3200/PROJECT/Li_project/IMDb movies.csv' 
INTO TABLE IMDb_movies 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from IMDb_movies;


drop table if exists IMDb_people;

create table IMDb_people (
	imdb_name_id varchar(100),
    name_ varchar(100),
    birth_name varchar(100),
    height_in_cm int,
    biographical_information varchar(1500),
    birth_details varchar(600),
    date_of_birth date,
    place_of_birth varchar(300),
    death_details varchar(300),
    date_of_death date,
    place_of_death varchar(100),
    reason_of_death varchar(200),
    spouses_string varchar(600),
    numbor_of_spouses int,
    number_of_divorces int,
    spouses_with_children int,
    children int,
    primary key (imdb_name_id)
);

LOAD DATA local INFILE '/Users/liqi/Desktop/CS3200/PROJECT/Li_project/IMDb names.csv' 
INTO TABLE IMDb_people 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from IMDb_people;







-- IMDb ratings
drop table if exists IMDb_ratings;
create table IMDb_ratings (
	imdb_title_id varchar(100),
    weighted_average_vote float,
    total_votes float,
    mean_vote float,
    median_vote float,
    allgenders_0age_avg_vote float,
    allgenders_18age_avg_vote float,
    allgenders_30age_avg_vote float,
    allgenders_45age_avg_vote float,
    males_allages_avg_vote float,
    males_0age_avg_vote float,
    males_18age_avg_vote float,
    males_30age_avg_vote float,
    males_45age_avg_vote float,
    females_allages_avg_vote float,
    females_0age_avg_vote float,
    females_18age_avg_vote float,
    females_30age_avg_vote float,
    females_45age_avg_vote float,
    top1000_voters_rating float,
    us_voters_rating float,
    non_us_voters_rating float,
    primary key (imdb_title_id)
);

LOAD DATA local INFILE '/Users/liqi/Desktop/CS3200/PROJECT/Li_project/CLEANED_IMDb_ratings.csv' 
INTO TABLE IMDb_ratings 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from IMDb_ratings;

  
-- 
drop table if exists IMDb_title_principals;

create table IMDb_title_principals (
	imdb_title_id varchar(100),
    order_of_importance int,
    imdb_name_id varchar(100),
    category_of_job varchar(100),
    specific_job varchar(100) null,
    name_of_the_character varchar(255),
    primary key IMDb_people(imdb_name_id),
    FOREIGN KEY (imdb_name_id) REFERENCES IMDb_people(imdb_name_id),
    foreign key (imdb_title_id) references IMDb_movies(imdb_title_id)
);

LOAD DATA local INFILE '/Users/liqi/Desktop/CS3200/PROJECT/Li_project/IMDb title_principals.csv' 
INTO TABLE IMDb_title_principals 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from IMDb_title_principals;





drop table if exists rotten_tomatoes_movies;

create table rotten_tomatoes_movies (
	rotten_tomatoes_link varchar(100),
    movie_title varchar(200),
    movie_info varchar(355),
    critics_consensus varchar(500),
    content_rating varchar(100),
    genres varchar(300),
    directors varchar(100),
    authors varchar(100),
    actors varchar(500),
    original_release_date date,
    streaming_release_date date,
    runtime int,
    production_company varchar(300),
    tomatometer_status varchar(100),
    tomatometer_rating int,
    tomatometer_count int,
    audience_status varchar(100),
    audience_rating int,
    audience_count int,
    tomatometer_top_critics_count int,
    tomatometer_fresh_critics_count int,
    tomatometer_rotten_critics_count int,
    primary key (rotten_tomatoes_link)
    );
 
 
LOAD DATA local INFILE '/Users/liqi/Desktop/CS3200/PROJECT/Li_project/rotten_tomatoes_movies.csv' 
INTO TABLE rotten_tomatoes_movies 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
  
select * from rotten_tomatoes_movies;
  

-- rotten_tomatoes_critic_reviews
  drop table if exists rotten_tomatoes_critic_reviews;
create table rotten_tomatoes_critic_reviews(
	rotten_tomatoes_link varchar(100),
    critic_name varchar(100),
    top_critic varchar(30),
    publisher_name varchar(300),
    review_type varchar(100),
    review_score varchar(100),
    review_date date,
    review_content varchar(10000),
    primary key rotten_tomatoes_movies(rotten_tomatoes_link),
    FOREIGN KEY (rotten_tomatoes_link) REFERENCES rotten_tomatoes_movies(rotten_tomatoes_link)
    );

LOAD DATA local INFILE '/Users/liqi/Desktop/CS3200/PROJECT/Li_project/rotten_tomatoes_critic_reviews.csv' 
INTO TABLE rotten_tomatoes_critic_reviews 
CHARACTER SET latin1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
    
select * from rotten_tomatoes_critic_reviews;







-- netflix, hulu, amazon
drop table if exists MoviesOnStreamingPlatforms_updated;

create table MoviesOnStreamingPlatforms_updated (
	ID int,
    Title varchar(100),
    Year varchar(100),
    Age varchar(30),
    IMDb float,
    Rotten_Tomatoes varchar(50),
    Netflix int,
    Hulu int,
    Prime_Video int,
    Disney_Plus int,
    Type int,
    Directors varchar(100),
    Genres varchar(100),
    Country	 varchar(150),
    Language varchar(150),
    Runtime float,
    primary key (ID)
);

LOAD DATA local INFILE '/Users/liqi/Desktop/CS3200/PROJECT/Li_project/CLEANDED_MoviesOnStreamingPlatforms_updated.csv' 
INTO TABLE MoviesOnStreamingPlatforms_updated 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from MoviesOnStreamingPlatforms_updated;




-- interaction with users

drop table if exists users;

create table users (
	username varchar(100),
    your_password varchar(100),
    primary key (username)
);


-- test data
insert into  users  values
('1','123'),
('2','123'),
('3','123'),
('4','123'),
('5','123'),
('6','123');


drop table users_favorite_list;
create table users_favorite_list (
	username varchar(100),
	movie_title varchar(255),
    imdb_title_id varchar(255) default null,
	foreign key (username) references users(username)
);

-- test data
insert into  users_favorite_list  values
('2','Miss Jerry','tt0000009'),
('1','Cleopatra','tt0002101'),
('2','Cleopatra','tt0002101'),
('1','Miss Jerry','tt0002101'),
('1',"L'Inferno",'tt0002101'),
('1',"Madame DuBarry",'tt0002101'),
('2','Independenta Romaniei','tt0002101'),
('2','Maudite soit la guerre','tt0002101'),
('3','Maudite soit la guerre','tt0002101'),
('3','Madame DuBarry','tt0002101'),
('3','Assunta Spina','tt0002101');



select * from users_favorite_list order by username;

-- User sign up
drop PROCEDURE new_username;
delimiter $$
CREATE PROCEDURE new_username(username VARCHAR(100), password_ varchar(100))
BEGIN
  DECLARE duplicate_entry_for_key TINYINT DEFAULT FALSE;
  BEGIN
    DECLARE EXIT HANDLER FOR 1062
      SET duplicate_entry_for_key = TRUE;
      
    INSERT INTO users VALUES (username, password_);
    
    SELECT 'Successful Sign up!' AS message;    
  END;
  
  IF duplicate_entry_for_key = TRUE THEN
    SELECT 'Sign up failed - duplicate username encountered.'
        AS message;
  END IF;
END$$
DELIMITER ;


call new_username('7','7645gh');


-- Update password
drop procedure update_password;
delimiter $$
CREATE PROCEDURE update_password(input_username varchar(255),new_password varchar(100))     
BEGIN
	UPDATE users 
	SET your_password = new_password
	WHERE username = input_username;
END $$
delimiter ;

call update_password('1wefw23','1');
select * from users;

-- delete account
drop procedure delete_account;
delimiter $$
create procedure delete_account(input_username varchar(100))
begin

delete from users
where username = input_username;

end$$
delimiter ;
call delete_account('7');







-- Add new movie to favorite list
drop PROCEDURE insert_into_favorite;
delimiter $$
CREATE PROCEDURE insert_into_favorite(input_username VARCHAR(100), title varchar(100), imdb_id varchar(255))
BEGIN
  DECLARE duplicate_entry_for_key TINYINT DEFAULT FALSE;
  BEGIN
    DECLARE EXIT HANDLER FOR 1062
      SET duplicate_entry_for_key = TRUE;
      
    INSERT INTO users_favorite_list VALUES (input_username, title, imdb_id);
    
    SELECT '1 movie was inserted.' AS message;    
  END;
  
  IF duplicate_entry_for_key = TRUE THEN
    SELECT 'Movie was not inserted - duplicate key encountered.'
        AS message;
  END IF;
END$$
DELIMITER ;

drop procedure delete_favotite;
delimiter $$
create procedure delete_favotite(movie_title varchar(100))
begin

delete from users
where username = input_username;

end$$
delimiter ;







-- find IMDB rating for a movie by titles
drop procedure movie_IMDB_info_search;
delimiter $$
create procedure movie_IMDB_info_search(movie_title varchar(100))
begin

declare c int;

select count(title) into c from IMDb_movies
    where title like CONCAT('%',movie_title , '%');
    
if c = 0 then
	select "Nothing Founded" as title;
elseif c > 0 then
	select title,avg_vote, date_published, genre, duration_in_minutes, country, language, director, main_actors, description
	from IMDb_movies
    where title like CONCAT('%',movie_title , '%');
end if;

end $$
delimiter ;

call movie_IMDB_info_search('alicesdsfwf');


drop procedure filter_by_director;
delimiter $$
create procedure filter_by_director(director_name varchar(255))
begin
declare c int;
select count(title) into c
	from IMDb_movies
    where director like CONCAT('%', director_name, '%');

if c = 0 then
	select "Nothing Founded" as title;
elseif c > 0 then
select title, director, description, avg_vote
	from IMDb_movies
    where director like CONCAT('%', director_name, '%');
end if;
end$$
delimiter ;
call filter_by_director("  ");



drop procedure filter_by_mainactor;
delimiter $$
create procedure filter_by_mainactor(actor_name varchar(255))
begin
declare c int;
select count(title) into c
	from IMDb_movies
    where main_actors like CONCAT('%', actor_name, '%');
    
if c = 0 then
	select "Nothing Founded" as title;
elseif c > 0 then
	select title, main_actors,description, avg_vote
	from IMDb_movies
    where main_actors like CONCAT('%', actor_name, '%');
end if;
end$$
delimiter ;
call filter_by_mainactor("    ");


drop procedure filter_by_genre;
delimiter $$
create procedure filter_by_genre(genre_type varchar(255))
begin
declare c int;
select count(title) into c
	from IMDb_movies
        where genre like CONCAT('%', genre_type, '%');

if c = 0 then
	select "Nothing Founded" as title;
elseif c > 0 then
select title, genre, description, avg_vote
	from IMDb_movies
    where genre like CONCAT('%', genre_type, '%');
end if;

end$$
delimiter ;
call filter_by_genre("      ");









drop procedure rating_statics;
delimiter $$
create procedure rating_statics_without_runtime(movie_title varchar(255))
begin
select title,weighted_average_vote, mean_vote,median_vote,allgenders_0age_avg_vote,
allgenders_18age_avg_vote,allgenders_30age_avg_vote,allgenders_45age_avg_vote,
males_allages_avg_vote,males_0age_avg_vote,males_18age_avg_vote,males_30age_avg_vote,
males_45age_avg_vote,females_allages_avg_vote,females_0age_avg_vote,females_18age_avg_vote,
females_30age_avg_vote,females_45age_avg_vote,top1000_voters_rating,
us_voters_rating,non_us_voters_rating
	from IMDb_ratings as r left join IMDb_movies as m on r.imdb_title_id = m.imdb_title_id
		where title like CONCAT('%',movie_title,'%');

end$$
delimiter ;

call rating_statics_without_runtime('Saluto militare');

drop procedure rating_statics_with_runtime;
delimiter $$
create procedure rating_statics_with_runtime(movie_title varchar(255))
begin
select weighted_average_vote, mean_vote,median_vote,allgenders_0age_avg_vote,
allgenders_18age_avg_vote,allgenders_30age_avg_vote,allgenders_45age_avg_vote,
males_allages_avg_vote,males_0age_avg_vote,males_18age_avg_vote,males_30age_avg_vote,
males_45age_avg_vote,females_allages_avg_vote,females_0age_avg_vote,females_18age_avg_vote,
females_30age_avg_vote,females_45age_avg_vote,top1000_voters_rating,
us_voters_rating,non_us_voters_rating, duration_in_minutes
	from IMDb_ratings as r left join IMDb_movies as m on r.imdb_title_id = m.imdb_title_id
		where title like CONCAT('%',movie_title,'%');

end$$
delimiter ;

drop procedure get_genre_by_title;
delimiter $$
create procedure get_genre_by_title(input_titlee varchar(255))
begin
	select genre from IMDb_movies where title like CONCAT('%',input_titlee,'%');
end$$
delimiter ;

call get_genre_by_title('Saluto');



-- get rotten tomatoes reviews
drop procedure rotten_tomatoes_review
delimiter $$
create procedure rotten_tomatoes_review(title varchar(255))
begin
select review_content from rotten_tomatoes_critic_reviews as r left join rotten_tomatoes_movies as m
	on r.rotten_tomatoes_link = m.rotten_tomatoes_link 
	where movie_title like CONCAT('%', title , '%');
end$$
delimiter ;






-- get actor or director's bio
drop function people_bio
delimiter $$
create function people_bio(person_name varchar(100), bio varchar(500))
   RETURNS varchar(500)
   DETERMINISTIC
   CONTAINS SQL
begin

select biographical_information into bio from IMDb_people where name_ = person_name;

return (bio);
end$$
delimiter ;


drop procedure platform
delimiter $$
create procedure platform(movie_title varchar(255))
begin
select Netflix, Hulu, Disney_Plus from MoviesOnStreamingPlatforms_updated
where Title like CONCAT('%',movie_title , '%');
end$$
delimiter ;
