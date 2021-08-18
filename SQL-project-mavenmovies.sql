
--Practical SQL project (mavenmovies)

--In this Project, we'll play the role of a business owner who just acquired Maven Movies, a brick and mortar DVD rental shop. 
--Using only a Microsoft SQL Server database, our job is to learn everything we can about our new business, 
--including inventory, staff, and customer behavior.



--Mid-course Project

--Scenario 1.1: Sending a mailer to all your staff members to notify regarding a
--	management change. In this case, you would need to pull a list of the first
--	name, last name, and email of each customers.

SELECT first_name, last_name, email, store_id
FROM staff;


--Scenario 1.2: Conducting an inventory total count of items at each store.

SELECT 
 store_id,
 COUNT(inventory_id) AS count_of_inventory
 FROM inventory
 GROUP BY store_id

 --Scenario 1.3: For holidays, management would like to provide a small gift to
		--all active customers. Pull the total count of all active customers for each store.

SELECT
 store_id,
 COUNT(customer_id) AS active_customers
 FROM customer
 WHERE active = 1
 GROUP BY store_id


 --Scenario 1.4: In line with a data breach checking, provide the count of all
	--customer email addresses stored in the database.

SELECT
 COUNT(email) AS emails
 FROM customer


 --Scenario 1.5: To identify if the your store can serve different audiences,
	--provide the count of unique titles in the inventory at each store and provide the
	--count of unique categories of films provided.

SELECT
 store_id,
 COUNT(DISTINCT film_id) AS count_unique_title
 FROM inventory
 GROUP BY store_id;
 SELECT
 COUNT(DISTINCT name) AS count_unique_categories
 FROM category;


 --Scenario 1.6: Understand the replacement cost of your film — Identify
	--replacement costs for films that are 1) least expensive to replace, 2) most
	--expensive to replace, and 3) the average replacement cost of all the films in store.

SELECT
 MIN(replacement_cost) AS least_exp_to_replace,
 MAX(replacement_cost) AS most_exp_to_replace,
 AVG(replacement_cost) AS avg_of_all_films
FROM film;


--Scenario 1.7: When monitoring current payment system to prevent staff
	--fraud, it would be useful to identify the what is the average payment being
	--process as well as the maximum payment processed so far.

SELECT
 AVG(amount) AS avg_payment,
 MAX(amount) AS max_payment
FROM payment;


--Scenario 1.8: When targeting your future customers, you may want to learn
	--more about your current customers and their rental behaviors. Provide a list of
	--all customer ids and count of rentals to-date — sorted from highest volume customers on top.

SELECT customer_id, COUNT(rental_id) AS num_of_times_rented
FROM rental
GROUP BY customer_id
ORDER BY num_of_times_rented DESC;


--Useful Exercises

--Extra1: Provide a granular view of our inventory. (Sample exercise on Inner Join)

SELECT
 film.film_id,
 film.title,
 film.description,
 inventory.store_id,
 inventory.inventory_id
FROM film
 INNER JOIN inventory
 ON film.film_id = inventory.film_id;


 --Extra2: Identify how many renowned actors are associated with each title. (Sample exercise on Left Join)

 SELECT film.title, COUNT(film_actor.actor_id) AS number_of_actors
FROM film
LEFT JOIN film_actor
 ON film.film_id = film_actor.film_id
GROUP BY film.title;


--Extra3: To easily assist customers with preference for specific actors, create a list
	--of all actors with each title they appear it. (Sample exercise on Bridging — this
	--is especially useful when connecting two tables without any common field.)

SELECT
 actor.first_name,
 actor.last_name,
 film.title
FROM actor
INNER JOIN film_actor
 ON actor.actor_id = film_actor.actor_id
INNER JOIN film
 ON film_actor.film_id = film.film_id
ORDER BY last_name, first_name


--Extra4: With the surge of new customers in Store 2, create a quick reference of
		--list of distinct titles and their descriptions available in inventory at store 2 to provide easy information about titles.

SELECT DISTINCT
 film.title, film.description
FROM film
INNER JOIN inventory
ON film.film_id = inventory.film_id
 AND store_id = 2


 --Extra5: List of all staff and advisor names, including a column to note whether they are a staff member or an advisor. (Sample exercise using Union)

 SELECT
 ‘advisor’ AS type,
 first_name,
 last_name
FROM advisor
UNION
SELECT 
 ‘staff’ AS type,
 first_name,
 last_name
FROM staff





--Final Project


--Scenario 2.1: List down the managers’ names at each store with the full address of each property (street, district, city, country)

SELECT
   staff.first_name,
   staff.last_name,
   address.address,
   address.district,
   city.city,
   country.country
FROM staff
INNER JOIN store ON staff.store_id = store.store_id
INNER JOIN address ON store.address_id = address.address_id
INNER JOIN city ON address.city_id = city.city_id
INNER JOIN country ON city.country_id = country.country_id;


--Scenario 2.2: Provide list of each inventory item, including store_id, inventory_id, title, film’s rating, rental rate, and replacement cost

SELECT
   inventory.inventory_id,
   inventory.store_id,
   film.title,
   film.rating,
   film.rental_rate,
   film.replacement_cost
FROM inventory
LEFT JOIN film
ON inventory.film_id = film.film_id;


--Scenario 2.3: Provide summary level overview of your inventory — how many inventory items you have with each rating at each store?

SELECT
   inventory.store_id,
   film.rating,
   COUNT(inventory.inventory_id) AS inventory_count
FROM inventory
LEFT JOIN film ON inventory.film_id = film.film_id
GROUP BY film.rating, inventory.store_id;


--Scenario 2.4: Extract a table containing the number of films, average replacement cost, and total replacement cost — sliced by store and film category.

SELECT
 store_id,
 name AS category,
 COUNT(film.film_id) AS count_film,
 AVG(replacement_cost) AS ave_rep_cost,
 SUM(replacement_cost) AS total_rep_cost
FROM film
LEFT JOIN inventory ON film.film_id = inventory.film_id
LEFT JOIN film_category ON inventory.film_id = film_category.film_id
LEFT JOIN category ON film_category.category_id = category.category_id
GROUP BY store_id, name
ORDER BY total_rep_cost DESC;


--Scenario 2.5: List of all customer names, which store they go to, active or inactive, full address (street address, city, and country)

SELECT
   first_name,
   last_name,
   customer.store_id,
   active,
   address,
   city,
   country
FROM customer
LEFT JOIN address ON customer.address_id = address.address_id
LEFT JOIN city ON address.city_id = city.city_id
LEFT JOIN country ON city.country_id = country.country_id;


--Scenario 2.6: List of customer names, total lifetime rentals, sum of all payments collected 
--	— order on the total lifetime value, most valuable customers on top

SELECT
   first_name,
   last_name,
   COUNT(rental.rental_id) AS total_lifetime_rental,
   SUM(payment.amount) AS total_payments_collected 
FROM customer
LEFT JOIN rental ON customer.customer_id = rental.customer_id
LEFT JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY first_name, last_name
ORDER BY total_payments_collected DESC;


--Scenario 2.7: List of advisor and investor names in one table. Indicate whether they are an investor or an advisor. 
--	If they are an investor, include the company they work with.

SELECT
   ‘advisor’ AS type,
   advisor.first_name,
   advisor.last_name,
   NULL AS company_name_if_investor
FROM advisor
UNION ALL
SELECT
   ‘investor’ AS type,
   investor.first_name,
   investor.last_name,
   company_name
FROM investor;


--Scenario 2.8: Determine the percentage of actors we have with 3 awards, 2
--	awards, and only 1 award. Maximize the combined use of CASE and GROUP BY to replicate an Excel-style PivotTable.

SELECT
  CASE
   WHEN actor_award.awards = ‘Emmy, Oscar, Tony ‘ THEN ‘3 awards’
   WHEN actor_award.awards IN (‘Emmy, Oscar’, ‘Emmy, Tony’, ‘Oscar, Tony’) THEN ‘2 awards’
   ELSE ‘1 award’ 
   END AS num_of_awards,
   AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
FROM actor_award
GROUP BY
  CASE
   WHEN actor_award.awards = ‘Emmy, Oscar, Tony ‘ THEN ‘3 awards’
   WHEN actor_award.awards IN (‘Emmy, Oscar’, ‘Emmy, Tony’, ‘Oscar, Tony’) THEN ‘2 awards’
   ELSE ‘1 award’
END;


--THANK-YOU 

