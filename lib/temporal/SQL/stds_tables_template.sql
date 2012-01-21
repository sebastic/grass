--#############################################################################
-- This SQL script generates the space time dataset tables to store time 
-- stamps and revision for SQL queries and temporal GIS support.
--
-- Author: Soeren Gebbert soerengebbert <at> googlemail <dot> com
--#############################################################################

-- STDS is a placeholder for specific space-time dataset type: strds, str3ds, stvds

--PRAGMA foreign_keys = ON;

CREATE TABLE  STDS_base (
  id VARCHAR NOT NULL,                 -- Id of the space-time dataset, name@mapset this is the primary key
  name VARCHAR NOT NULL,               -- name of the space-time dataset
  mapset VARCHAR NOT NULL,             -- mapset of the space-time dataset
  creator VARCHAR NOT NULL,            -- Name of the creator
  temporal_type VARCHAR NOT NULL,      -- The temporal type of the dataset "absolute" or "relative" 
  semantic_type VARCHAR NOT NULL,      -- The semantic data description used for aggregation/decomposition algorithm selection: min, max, mean or sum
  creation_time TIMESTAMP NOT NULL,    -- The time of creation of the space-time dataset
-- Uncommented due to performance issues
--  modification_time TIMESTAMP NOT NULL,  -- The time of the last modification of the grass map
--  revision SMALLINT NOT NULL,            -- The revision number        -- The revision number
  PRIMARY KEY (id)
);

CREATE TABLE  STDS_relative_time (
  id VARCHAR NOT NULL,            -- Id of the space-time dataset, this is the primary foreign key
  start_time INTEGER,             -- The relative valid start time 
  end_time INTEGER,               -- The relative valid end time 
  granularity INTEGER,            -- The granularity 
  unit VARCHAR,                   -- The relative time unit, available are "years, months, days, minutes, seconds"
  map_time VARCHAR,               -- The temporal type of the registered maps, may be interval, point or mixed
  PRIMARY KEY (id),  
  FOREIGN KEY (id) REFERENCES  STDS_base (id) ON DELETE CASCADE
);

CREATE TABLE  STDS_absolute_time (
  id VARCHAR NOT NULL,            -- Id of the space-time dataset, this is the primary foreign key
  start_time TIMESTAMP,           -- Start of the valid time, can be NULL if no map is registered
  end_time TIMESTAMP,             -- End of the valid time, can be NULL if no map is registered
  granularity VARCHAR,            -- The granularity "NNN seconds, NNN minutes, NNN hours, NNN days, NNN months, NNN years"
  timezone VARCHAR,      -- The timezone of the valid time stored as string. This is currently not in use. Instead the timezone is set in the datetime strings 
  map_time VARCHAR,               -- The temporal type of the registered maps, may be interval, point or mixed
  PRIMARY KEY (id),  
  FOREIGN KEY (id) REFERENCES  STDS_base (id) ON DELETE CASCADE
);

CREATE TABLE  STDS_spatial_extent (
  id VARCHAR NOT NULL,      -- Id of the space-time dataset, this is the primary foreign key
  north DOUBLE PRECISION,   -- The spatial north extent, derived from the registered maps
  south DOUBLE PRECISION,   -- The spatial south extent, derived from the registered maps
  east DOUBLE PRECISION,    -- The spatial east extent, derived from the registered maps
  west DOUBLE PRECISION,    -- The spatial west extent, derived from the registered maps
  top DOUBLE PRECISION,     -- The spatial top extent, derived from the registered maps
  bottom DOUBLE PRECISION,  -- The spatial bottom extent, derived from the registered maps
  proj VARCHAR,      -- The projection of the space time dataset (XY of LL)
  PRIMARY KEY (id),  
  FOREIGN KEY (id) REFERENCES  STDS_base (id) ON DELETE CASCADE
);

-- Create a trigger to update the modification time and revision number in case the metadata or timestanps have been updated 
-- Uncommented due to performance issues
--CREATE TRIGGER update_STDS_abs_time AFTER UPDATE ON STDS_absolute_time 
--  BEGIN
--    UPDATE STDS_base SET modification_time = datetime("NOW") WHERE id = old.id;
--    UPDATE STDS_base SET revision = (revision + 1) WHERE id = old.id;
--  END;

--CREATE TRIGGER update_STDS_rel_time AFTER UPDATE ON STDS_relative_time 
--  BEGIN
--    UPDATE STDS_base SET modification_time = datetime("NOW") WHERE id = old.id;
--    UPDATE STDS_base SET revision = (revision + 1) WHERE id = old.id;
--  END;

--CREATE TRIGGER update_STDS_spatial_extent AFTER UPDATE ON STDS_spatial_extent 
--  BEGIN
--    UPDATE STDS_base SET modification_time = datetime("NOW") WHERE id = old.id;
--   UPDATE STDS_base SET revision = (revision + 1) WHERE id = old.id;
--  END;

