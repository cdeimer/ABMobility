-- Create a function to check rate limits before insert
CREATE OR REPLACE FUNCTION check_rate_limit()
RETURNS TRIGGER AS $$
DECLARE
  submission_count INT;
BEGIN
  -- Count how many submissions this user has made in the last 10 minutes
  SELECT count(*) INTO submission_count
  FROM map_submissions
  WHERE user_identifier = NEW.user_identifier
    AND created_at > (now() - interval '10 minutes');

  -- If they have more than 5 submissions in the last 10 minutes, block it
  IF submission_count >= 5 THEN
    RAISE EXCEPTION 'Rate limit exceeded. Please wait before submitting more feedback.';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Attach the trigger to the table
CREATE TRIGGER enforce_rate_limit
BEFORE INSERT ON map_submissions
FOR EACH ROW
EXECUTE FUNCTION check_rate_limit();
