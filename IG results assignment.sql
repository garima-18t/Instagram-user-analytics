USE ig_clone;

# 5 oldest users of the Instagram
Select *
from users
order by created_at
limit 5;

# Users who have never posted on Instagram
Select *
from users
left join photos
on users.id=photos.user_id
where photos.id is null
order by created_at;

#Determine the contest winner with most likes
select
    likes.photo_id,
    photos.image_url,
    photos.created_dat as `Date of Photo upload`, 
    users.username,
    users.created_at as `Date of Account Creation`,
    count(likes.user_id) as `Total likes`
from likes
inner join photos on likes.photo_id = photos.id
inner join users on photos.user_id = users.id
group by likes.photo_id, photos.image_url, photos.created_dat, users.username, users.created_at
order by `Total likes` desc
limit 5;

#Top 5 hastags on Instagram
select 
    tags.id as `Tag ID`, 
    tags.created_at as `Tag creation date`,
    tags.tag_name,
    count(photo_tags.photo_id) as `Total occurences`
from photo_tags 
inner join
    tags on tags.id = photo_tags.tag_id
group by tags.tag_name
order by `Total occurences` desc
limit 5;

#Best day to launch ad campaign
select
      dayname(created_at) as `Day of week`,
      count(username) as `Number of registered users`
 from users 
 group by `Day of week`
 order by `Number of registered users` desc;
 
 #User Engagement
with userengagement as (
select
	users.id as userid,
	count(photos.id) as photoid
from users
left join
        photos on photos.user_id = users.id
group by users.id
)
select
    sum(photoid) as `Total Number of Photos`,
    count(userengagement.userid) as `Total Number of Users`,
    sum(photoid) / count(userengagement.userid) as `Total Photos / Total Users`
from userengagement;

#Bots and fake accounts
with bots as(
select users.username,
       users.id as `user ID`,
	 count(likes.photo_id) as `likes on all photos` 
     from likes 
     inner join users 
     on users.id=likes.user_id 
     group by users.username, users.id)
select username,`user ID`,`likes on all photos`
from bots 
where `likes on all photos`=(select count(*) from photos) 
order by username;





 



