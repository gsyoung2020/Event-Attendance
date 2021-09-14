-- querie to render the event attendee per event chart

SELECT "description" AS "Event", "event_location" AS "Location", COUNT("member_ids") as "Attendees"
FROM "events" INNER JOIN "events_members" 
ON "event_id" = "events_members"."event_id"
WHERE "events_members"."member_id" <> "member_ids"
GROUP BY 1
ORDER BY "events"."created_at" ASC

-- querie to render total number of users

SELECT "id", COUNT(*) FROM "members"