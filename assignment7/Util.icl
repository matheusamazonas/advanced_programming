// Matheus Amazonas Cabral de Andrade
// s4605640

implementation module Util

import iTasks
import iTasks.Extensions.DateTime 

selectUsers :: Task [User]
selectUsers = get users >>= \us -> enterMultipleChoice "Select Participants" [ChooseFromCheckGroup id] us

assignToMany :: (Task a) [User] -> Task [a] | iTask a
assignToMany t us = allTasks (map (\u -> u @: t) us) 
		>>* [OnAction ActionOk (always (return defaultValue))]

defaultDuration :: Time
defaultDuration = {Time| defaultValue & hour = 1}

addUnique :: a [a] -> [a] | gEq{|*|} a
addUnique a [] = [a]
addUnique a [x:xs]
	| gEq {|*|} a x = [x:xs]
	| otherwise = [x:addUnique a xs]

nextId :: Shared Int
nextId = sharedStore "next_id" 0

getNextId :: Task Int
getNextId = get nextId >>* [OnValue (hasValue giveId)]
	where
		giveId i = upd inc nextId >>| return i  

removeFromList :: (a -> Bool) [a] -> [a]
removeFromList p [] = []
removeFromList p [x:xs] 
	| p x = removeFromList p xs
	| otherwise = [x:removeFromList p xs]