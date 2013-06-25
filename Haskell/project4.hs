{--QUESTIONS:
1) Proper way to create list
2) Proper indentation
3) Spouse Manager use filter
--}

import Data.List

-- type synonyms

type Employee = String
type Spouse = String
type Salary = Integer
type Manager = String
type Record = (Employee, Spouse, Salary, Manager)
type DB = [Record]

-- **type Root = 100,000


-- 1a.

overpaid :: DB -> [String]
overpaid db = overpaidHelper db db

overpaidHelper :: DB -> DB -> [String]
overpaidHelper [] list2 = []
overpaidHelper (x:xs) list2
	| (third x) > (third (findManager list2 (fourth x))) = (first x): (overpaidHelper xs list2)
	| otherwise = overpaidHelper xs list2

findManager :: DB -> String -> Record
findManager (x:xs) name
	| name == "Root" = ("Root", "Root", 100000, "Root")
	| (first x) == name = x
	| otherwise = findManager xs name


-- 1b.
grossly_overpaid :: DB -> [String]
grossly_overpaid db = grossly_overpaidHelper db db

grossly_overpaidHelper :: DB -> [Record] -> [String]
grossly_overpaidHelper [] list2 = []
grossly_overpaidHelper (x:xs) list2
	| (third x) > (maxManager (findManagers list2 list2 (fourth x)) (-1)) = (first x): (grossly_overpaidHelper xs list2)
	| otherwise = grossly_overpaidHelper xs list2
	
maxManager :: [Record] -> Integer -> Integer
maxManager [] max = 0
maxManager [x] max
	| third x > max = third x
	| otherwise = max
maxManager (x:xs) max
	| first x == "" = max
	| third x > max = maxManager xs (third x)
	| otherwise = maxManager xs max

findManagers :: DB -> [Record] -> String -> [Record]
findManagers (x:xs) list2 name
	| name == "" = []
	| name == "Root" = ("Root", "", 100000, "") : (findManagers list2 list2 "")
	| (first x) == name = (x): (findManagers list2 list2 (fourth x))
	| otherwise = findManagers xs list2 name


-- 2a.

spouse_manager :: DB -> [String]
spouse_manager [] = []
spouse_manager (x:xs)
	| second x == fourth x = second x: spouse_manager xs
	| otherwise = spouse_manager xs


--2b.

spouse_manager_super :: DB -> [String]
spouse_manager_super [] = []
spouse_manager_super list = spouse_manager_superHelper list list

spouse_manager_superHelper :: DB -> DB -> [String]
spouse_manager_superHelper [] list = []
spouse_manager_superHelper (x:xs) list
	| (elem x (findSpouseManagers list list (second x))) = (first x): (spouse_manager_superHelper xs list)
	| otherwise = (spouse_manager_superHelper xs list)

findRecord :: DB -> String -> Record
--findRecord [] name = ""
findRecord (x:xs) name
	| first x == name = x
	| otherwise = (findRecord xs name)

findSpouseManagers :: DB -> [Record] -> String -> [Record]
findSpouseManagers (x:xs) list2 name
	| name == "Root" = []
	| (first x) == name = (x): (findManagers list2 list2 (fourth x))
	| otherwise = findManagers xs list2 name 


-- 3a.

super_manager :: DB -> [String]
super_manager list = nub (super_managerHelper list list)

super_managerHelper :: DB -> [Record] -> [String]
super_managerHelper [] list = []
super_managerHelper (x:xs) list
	| match (findSpousesManagers list list (fourth x)) (findSpousesManagers list list (spousesManager list list(second x))) > 0 = (intersection (findSpousesManagers list list (fourth x)) (findSpousesManagers list list (spousesManager list list(second x)))) ++ (super_managerHelper xs list)
	| otherwise = (super_managerHelper xs list)

match :: [String] -> [String] -> Int
match list1 list2 = length (intersect list1 list2)

intersection :: [String] -> [String] -> [String]
intersection list1 list2 = intersect list1 list2

spousesManager :: DB -> DB -> String -> String
spousesManager [] list name = ""
spousesManager (x:xs) list name
	| first x == name = fourth x
	| otherwise = spousesManager xs list name
	
findSpousesManagers :: DB -> DB -> String -> [String]
findSpousesManagers (x:xs) list2 name
	| name == "Root" = []
	| (first x) == name = (first x): (findSpousesManagers list2 list2 (fourth x))
	| otherwise = findSpousesManagers xs list2 name


-- 4.
nepotism :: DB -> [(String, String)]
nepotism [] = []
nepotism list = nepotismHelper list list

nepotismHelper :: DB -> DB -> [(String, String)]
nepotismHelper [] list = []
nepotismHelper (x:xs) list
	| (findMatch (findEmployees list (second x)) (first x) list) == "" = nepotismHelper xs list
	| (first x) == (findMatch (findEmployees list (second x)) (first x) list) = nepotismHelper xs list
	| otherwise = ((first x), (findMatch (findEmployees list (second x)) (first x) list)): nepotismHelper xs list

findMatch :: [Record] -> String -> DB -> String
findMatch [] name list = []
findMatch (x:xs) name list
	| elem name (toString((findEmployees list (second x)))) == True = first x
	| otherwise = findMatch xs name list

toString :: [Record] -> [String]
toString [] = []
toString (x:xs) = (first x): (toString xs)

--IS THIS CORRECT? Only goes down 1 level
findEmployees :: DB -> String -> [Record]
findEmployees [] manager = []
findEmployees (x:xs) manager
	| manager == fourth x = x: (findEmployees xs manager)
	| otherwise = findEmployees xs manager


-- 5.
richSort (a1, b1, c1) (a2, b2, c2)
	| c1 < c2 = GT
	| c1 > c2 = LT
	| c1 == c2 = compare a1 a2
	
rich :: DB -> [(String, String)]
rich [] = []
rich list = richHelper list

richHelper :: DB -> [(String, String)]
richHelper [] = []
richHelper list = rmDups(maxCouples (sortBy richSort (addSalaries list list)) 0)

maxCouples :: [(String, String, Integer)] -> Integer -> [(String, String)]
maxCouples [] max = []
maxCouples (x:xs) max
	| thirdThree x >= max = (firstThree x, secondThree x) : (maxCouples xs (thirdThree x))
	| otherwise = maxCouples xs max

addSalaries :: DB -> DB -> [(String, String, Integer)]
addSalaries [] list = []
addSalaries (x:xs) list = (first x, second x, third x + (findSpouse list (first x))): addSalaries xs list

findSpouse :: DB -> String -> Integer
findSpouse [] name = 0
findSpouse (x:xs) name
	| second x == name = third x
	| otherwise = findSpouse xs name

rmDups :: [(String, String)] -> [(String, String)]
rmDups [] = []
rmDups [x] = [x]
rmDups (x1:x2:xs)
	| (fst x1) == (snd x2) = rmDups (x1:xs)
	| otherwise = x1: rmDups (x2:xs)


-- 6a.

tuplesSort (a1, b1, c1, d1) (a2, b2, c2, d2)
	| c1 < c2 = GT
	| c1 > c2 = LT
	| c1 == c2 = compare b1 b2

sorted_salaries :: DB -> [String]
sorted_salaries [] = []
sorted_salaries list = firstSalaries(sortBy tuplesSort (managers list))

firstSalaries :: [Record] -> [String]
firstSalaries [] = []
firstSalaries (x:xs) = first x : firstSalaries xs

managers :: DB -> [Record]
managers [] = []
managers list = managersHelper1 list list

managersHelper1 :: DB -> DB -> [Record]
managersHelper1 [] list = []
managersHelper1 (x:xs) list
	| (managersHelper2 (first x) list) == "Y" = x: (managersHelper1 xs list)
	| otherwise = (managersHelper1 xs list)
	
managersHelper2 :: String -> DB -> String
managersHelper2 name [] = ""
managersHelper2 name (x:xs)
	| name == fourth x = "Y"
	| otherwise = managersHelper2 name xs


-- 6b.

rankSort (a1, b1) (a2, b2)
	| b1 < b2 = GT
	| b1 > b2 = LT
	| b1 == b2 = compare a1 a2
	
sorted_rank :: DB -> [String]
sorted_rank [] = []
sorted_rank list = firstRank(listToRecord(sortBy rankSort (sorted_rankHelper list list)) list)

firstRank :: [Record] -> [String]
firstRank [] = []
firstRank (x:xs) = first x : firstRank xs

sorted_rankHelper :: DB -> DB -> [(String, Int)]
sorted_rankHelper [] list = []
sorted_rankHelper (x:xs) list
	| length(findEmployees list (first x)) == 0 = sorted_rankHelper xs list
	| otherwise = ((first x), length(findEmployees list (first x))) : sorted_rankHelper xs list

listToRecord :: [(String, Int)] -> DB -> [Record]
listToRecord [] list = []
listToRecord (x:xs) list = (listToRecordHelper x list): listToRecord xs list

listToRecordHelper :: (String, Int) -> DB -> Record
listToRecordHelper person (x:xs)
	| fst person == first x = x
	| otherwise = listToRecordHelper person xs


-- 6c.
worthSort (a1, b1) (a2, b2)
	| b1 < b2 = GT
	| b1 > b2 = LT
	| b1 == b2 = compare a1 a2
	
sorted_worth :: DB -> [String]
sorted_worth [] = []
sorted_worth list = toWorthString(sortBy worthSort(sorted_worthHelper list list))

sorted_worthHelper :: DB -> DB -> [(String, Float)]
sorted_worthHelper [] list = []
sorted_worthHelper (x:xs) list
	| length(findEmployees list (first x)) == 0 = sorted_worthHelper xs list
	| otherwise = ((first x), (fromInteger(third x))/(fromInteger(toInteger(length(findEmployees list (first x)))))): sorted_worthHelper xs list

toWorthString :: [(String, Float)] -> [String]
toWorthString [] = []
toWorthString (x:xs) = (fst x): toWorthString xs


-- 7.

normalizeSort (a1, b1) (a2, b2)
	| b1 > b2 = GT
	| b1 < b2 = LT
	| b1 == b2 = compare a1 a2

normalize :: DB -> DB
normalize [] = []
normalize list = normalizeHelper list

normalizeHelper :: DB -> DB
normalizeHelper list = (toDB(sortBy normalizeSort(levels list list)) list)

levels :: DB -> DB -> [(String, Int)]
levels [] list = []
levels (x:xs) list = (first x, (length(findSpouseManagers list list (first x)))-1): levels xs list

toDB :: [(String, Int)] -> DB -> DB
toDB [] list = []
toDB (x:xs) list = toDBHelper x list: (toDB xs list)

toDBHelper :: (String, Int) -> DB -> Record
toDBHelper person (x:xs)
	| first x == fst person = x
	| otherwise = toDBHelper person xs



first :: (String, String, Integer, String) -> String
first (w,_,_,_) = w

firstThree :: (String, String, Integer) -> String
firstThree (w,_,_) = w

second :: (String, String, Integer, String) -> String
second (_,x,_,_) = x

secondThree :: (String, String, Integer) -> String
secondThree (_,x,_) = x

third :: (String, String, Integer, String) -> Integer
third (_,_,y,_) = y

thirdThree :: (String, String, Integer) -> Integer
thirdThree (_,_,y) = y

fourth :: (String, String, Integer, String) -> String
fourth (_,_,_,z) = z