SELECT *
FROM MavenAirlines..PassengerSatisfaction


--THE AVERAGE AGE OF A PASSENGER

SELECT ROUND(AVG(Age),0)
FROM MavenAirlines..PassengerSatisfaction


--WHAT PERCENTAGE OF PASSENGERS ARE MALE, FEMALE

SELECT Gender, COUNT(*) *100.0 / SUM(Count(*)) OVER () AS GenderPercentage
FROM MavenAirlines..PassengerSatisfaction
GROUP BY Gender

--PERCENTAGE OF CUSTOMERS BY TYPE OF TRAVEL

SELECT [Type of Travel], COUNT(*) *100.0 / SUM(Count(*)) OVER () AS Percentage
FROM MavenAirlines..PassengerSatisfaction
GROUP BY [Type of Travel]
ORDER BY 1


--NUMBER OF PASSENGERS PER AGE

SELECT Age, COUNT(*) AS NumberOfPassengers
FROM MavenAirlines..PassengerSatisfaction
GROUP BY Age
ORDER BY 2 DESC 


--CREATING THE AGE DISTRIBUTION OF THE PASSENGERS

SELECT 
CASE WHEN Age >= 1 AND AGE <10 THEN 'Gen Alpha'
	 WHEN Age >=11 AND AGE <26 THEN 'Gen Z'
     WHEN Age >=27 AND AGE <42 THEN 'Millenials'
	 WHEN Age >=43 AND AGE <58 THEN 'Gen X'
	 WHEN Age >=59 AND AGE <77 THEN 'Baby Boomers'
     WHEN Age >=78 AND AGE <95 THEN 'Silent Generation'
ELSE 'Post Silent' END AS AgeGen
FROM MavenAirlines..PassengerSatisfaction



--USING CTE TO DETERMINE THE AGE DISTRIBUTION OF THE PASSENGERS in % (EACH GENERATION HAS ITS OWN NEEDS WHEN IT COMES TO TRAVELLING)

WITH AgeClass (AgeGen)
AS 
(SELECT 
CASE WHEN Age >= 1 AND AGE <11 THEN 'Gen Alpha'
	 WHEN Age >=11 AND AGE <27 THEN 'Gen Z'
     WHEN Age >=27 AND AGE <43 THEN 'Millenials'
	 WHEN Age >=43 AND AGE <59 THEN 'Gen X'
	 WHEN Age >=59 AND AGE <78 THEN 'Baby Boomers'
     WHEN Age >=78 AND AGE <95 THEN 'Silent Generation'
ELSE 'Post Silent' END AS AgeGen
FROM MavenAirlines..PassengerSatisfaction
)

SELECT AgeGen, ROUND (COUNT(*) *100.0 / SUM(Count(*)) OVER (),0) AS PercentageDistribution
FROM AgeClass
GROUP BY AgeGen
ORDER BY 2 DESC

--LOOKING AT THE RATE OF SATISFIED/NEUTRAL OR DISSATISFIED ACROSS THE GENERATION 

WITH AgeClass (AgeGen, Satisfaction)
AS 
(SELECT 
CASE WHEN Age >= 1 AND AGE <11 THEN 'Gen Alpha'
	 WHEN Age >=11 AND AGE <27 THEN 'Gen Z'
     WHEN Age >=27 AND AGE <43 THEN 'Millenials'
	 WHEN Age >=43 AND AGE <59 THEN 'Gen X'
	 WHEN Age >=59 AND AGE <78 THEN 'Baby Boomers'
     WHEN Age >=78 AND AGE <95 THEN 'Silent Generation'
ELSE 'Post Silent' END AS AgeGen, Satisfaction
FROM MavenAirlines..PassengerSatisfaction
)

SELECT AgeGen, ROUND (COUNT(*) *100.0 / SUM(Count(*)) OVER (),1) AS SharePercent, Satisfaction
FROM AgeClass
GROUP BY AgeGen, Satisfaction
ORDER BY 2 DESC
--//TAKE NOTE OF THE SHAREPERCENT OF GEN X THAT ARE SATISFIED


--//A LOOK AT THE RATINGS OF SOME SPECIFIC SERVICES BY AGE

WITH AgeClass (AgeGen, EaseOfOnlineBooking, CheckinService, OnlineBoarding, GateLocation, OnboardService)
AS 
(SELECT 
CASE WHEN Age >= 1 AND AGE <11 THEN 'Gen Alpha'
	 WHEN Age >=11 AND AGE <27 THEN 'Gen Z'
     WHEN Age >=27 AND AGE <43 THEN 'Millenials'
	 WHEN Age >=43 AND AGE <59 THEN 'Gen X'
	 WHEN Age >=59 AND AGE <78 THEN 'Baby Boomers'
     WHEN Age >=78 AND AGE <95 THEN 'Silent Generation'
ELSE 'Post Silent' END AS AgeGen, EaseOfOnlineBooking, CheckinService, 
                          OnlineBoarding, GateLocation, OnboardService
FROM MavenAirlines..PassengerSatisfaction
)

SELECT AgeGen, ROUND (COUNT(*) *100.0 / SUM(Count(*)) OVER (),1) AS SharePercent, ROUND (AVG(EaseOfOnlineBooking),0) AS EaseOfOnlineBooking, 
	   ROUND (AVG(CheckinService),0) AS CheckinService, ROUND (AVG(OnlineBoarding),0) AS OnlineBoarding,
	   ROUND (AVG(GateLocation),0) AS GateLocation, ROUND (AVG(OnboardService),0) AS OnboardService
FROM AgeClass
GROUP BY AgeGen
ORDER BY 2 DESC



--//A LOOK AT THE FLIGHT DISTANCE AND THE RATINGS OF THE IN-FLIGHT SERVICES & PRODUCTS THAT AFFECT THE PASSENGER  

SELECT ROUND(AVG([Flight Distance]),0)
FROM MavenAirlines..PassengerSatisfaction


WITH FlightCategory (FlightLength, SeatComfort, LegRoomService, Cleanliness, FoodandDrink, InflightService, InflightWifiService,
     BaggageHandling)
AS 
(SELECT 
CASE WHEN [Flight Distance] >1 AND [Flight Distance] < 1501 THEN 'Short-Haul'
     WHEN [Flight Distance] >=1501 AND [Flight Distance] < 4100 THEN 'Medium-Haul'
	 WHEN [Flight Distance] >=4100 AND [Flight Distance] < 6501 THEN 'Long-Haul'
ELSE 'Ultra-Long-Haul' END AS FlightCategory, SeatComfort, LegRoomService, Cleanliness, FoodandDrink, InflightService, 
                              InflightWifiService, BaggageHandling
FROM MavenAirlines..PassengerSatisfaction
)
SELECT FlightLength, ROUND (COUNT(*) *100.0 / SUM(Count(*)) OVER (),1) AS SharePercent, ROUND (AVG(SeatComfort),0) AS SeatComfort,
       ROUND (AVG(LegRoomService),0) AS LegRoomService, ROUND (AVG(Cleanliness),0) AS Cleanliness,
	   ROUND (AVG(FoodandDrink),0) AS FoodandDrink, ROUND (AVG(InflightService),0) AS InflightService,
	   ROUND (AVG(InflightWifiService),0) AS InflightWifi, ROUND (AVG(BaggageHandling),0) AS BaggageHandling
FROM FlightCategory
GROUP BY FlightLength 
ORDER BY 2 DESC

--//FROM THE QUERIES ABOVE, MORE THAN 50 PER CENT OF THE AIRLINE DESTINATIONS ARE SHORT-HAUL WHILE SLIGHTLY OVER 30 PER CENT IS MEDIUM-HAUL


--A LOOK AT THE DEPARTURE TIMES TO SEE WHAT PERCENTAGE OF THE FLIGHTS ARE ON TIME/LATE 

SELECT 
CASE WHEN DepartureDelay >0 AND DepartureDelay < 15 THEN 'On Time'
     WHEN DepartureDelay >= 15 AND DepartureDelay < 45 THEN 'Medium Delay'
	 WHEN DepartureDelay >= 45 AND DepartureDelay < 60 THEN ' Large Delay'
	 WHEN DepartureDelay > 60 THEN 'Extreme Delay'
ELSE 'Cancelled' END AS DepTime
FROM MavenAirlines..PassengerSatisfaction


With DepPerformance (DepTime)
AS 
(
SELECT 
CASE WHEN DepartureDelay >= 0 AND DepartureDelay < 15 THEN 'On Time'
     WHEN DepartureDelay >= 15 AND DepartureDelay < 45 THEN 'Medium Delay'
	 WHEN DepartureDelay >= 45 AND DepartureDelay < 60 THEN ' Large Delay'
	 WHEN DepartureDelay >= 60 THEN 'Extreme Delay'
ELSE 'Cancelled' END AS DepTime
FROM MavenAirlines..PassengerSatisfaction
)

SELECT DepTime, ROUND (COUNT(*) *100.0 / SUM(Count(*)) OVER (),1) AS SharePercent
FROM DepPerformance
GROUP BY DepTime
ORDER BY 1 DESC


