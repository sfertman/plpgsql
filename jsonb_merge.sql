/*
This function merges (deep) source jsonb into target jsonb.
Leaf keys from 'source' that exist in 'target' will be overwritten.
At the moment it can only deal with simple jsonb objects; it assumes no arrays anywhere and was not tested for those cases.
*/

CREATE OR REPLACE FUNCTION public."jsonb_merge"(tgt JSONB, src JSONB)
RETURNS JSONB AS $$
  DECLARE
    tgt_keys  TEXT[]; -- target object keys
    src_keys  TEXT[]; -- source object keys
    s         TEXT;   -- source key 
    pth       TEXT[]; -- path to jsonb
    mrg       JSONB;  -- merged jsonb object
  BEGIN
    tgt_keys := ARRAY(SELECT jsonb_object_keys(tgt)); 
    src_keys := ARRAY(SELECT jsonb_object_keys(src));
    mrg := tgt;

    FOREACH s IN ARRAY src_keys
    LOOP
      pth := ARRAY[s];
      IF s = ANY(tgt_keys) THEN
        mrg := jsonb_set(mrg, pth, jsonb_merge(tgt#>pth, src#>pth));
      ELSE
        mrg := jsonb_set(mrg, pth, src#>pth, true);
      END IF;
    END LOOP;
    RETURN mrg;
  END;
$$ LANGUAGE plpgsql;

