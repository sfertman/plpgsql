CREATE OR REPLACE FUNCTION fn_jbset(_ks text[])
  RETURNS jsonb
  LANGUAGE sql AS
$BODY$
  SELECT jsonb_object_agg(t, TRUE)
  FROM unnest(_ks) t;
$BODY$

CREATE OR REPLACE FUNCTION fn_jbset_conj(_set jsonb, _ks text[])
  RETURNS jsonb
  LANGUAGE sql AS
$BODY$
  SELECT _set||jsonb_object_agg(t, TRUE)
  FROM unnest(_ks) t;
$BODY$

CREATE OR REPLACE FUNCTION fn_jbset_disj(_set jsonb, _ks text[])
  RETURNS jsonb
  LANGUAGE sql AS
$BODY$
  SELECT _set-_ks;
$BODY$

