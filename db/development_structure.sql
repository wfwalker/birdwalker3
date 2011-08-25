CREATE TABLE `counties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` tinytext,
  `state_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `StateIndex` (`state_id`)
) ENGINE=MyISAM AUTO_INCREMENT=70 DEFAULT CHARSET=latin1;

CREATE TABLE `countyfrequency` (
  `common_name` varchar(255) DEFAULT NULL,
  `frequency` tinyint(2) DEFAULT NULL,
  `species_id` bigint(20) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `families` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `latin_name` text,
  `common_name` text,
  `taxonomic_sort_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `TaxonomicSortIndex` (`taxonomic_sort_id`)
) ENGINE=MyISAM AUTO_INCREMENT=89 DEFAULT CHARSET=utf8;

CREATE TABLE `locations` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `reference_url` text,
  `city` text,
  `county_id` int(11) DEFAULT NULL,
  `notes` text,
  `latitude` float(15,10) DEFAULT '0.0000000000',
  `longitude` float(15,10) DEFAULT '0.0000000000',
  `photo` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `NameIndex` (`name`),
  KEY `CountyIndex` (`county_id`)
) ENGINE=MyISAM AUTO_INCREMENT=476 DEFAULT CHARSET=latin1;

CREATE TABLE `photos` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `notes` text,
  `location_id` mediumint(9) DEFAULT NULL,
  `species_id` bigint(9) DEFAULT NULL,
  `trip_id` mediumint(9) DEFAULT NULL,
  `rating` int(3) DEFAULT NULL,
  `original_filename` text,
  PRIMARY KEY (`id`),
  KEY `LocationIndex` (`location_id`),
  KEY `SpeciesIndex` (`species_id`),
  KEY `TripIndex` (`trip_id`),
  KEY `RatingIndex` (`rating`)
) ENGINE=MyISAM AUTO_INCREMENT=18808 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `sightings` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `notes` text,
  `exclude` tinyint(1) NOT NULL DEFAULT '0',
  `heard_only` tinyint(1) NOT NULL DEFAULT '0',
  `location_id` mediumint(9) DEFAULT NULL,
  `species_id` bigint(9) DEFAULT NULL,
  `trip_id` mediumint(9) DEFAULT NULL,
  `count` mediumint(7) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ExcludeIndex` (`exclude`),
  KEY `LocationIndex` (`location_id`),
  KEY `SpeciesIndex` (`species_id`),
  KEY `TripIndex` (`trip_id`)
) ENGINE=MyISAM AUTO_INCREMENT=22895 DEFAULT CHARSET=latin1;

CREATE TABLE `species` (
  `id` bigint(20) NOT NULL DEFAULT '0',
  `abbreviation` varchar(6) DEFAULT NULL,
  `latin_name` text,
  `common_name` text,
  `notes` text,
  `reference_url` text,
  `aba_countable` tinyint(1) NOT NULL DEFAULT '1',
  `family_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `AbbreviationIndex` (`abbreviation`),
  KEY `aba_countableIndex` (`aba_countable`),
  KEY `FamilyIndex` (`family_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `states` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) DEFAULT NULL,
  `abbreviation` varchar(2) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `AbbreviationIndex` (`abbreviation`)
) ENGINE=MyISAM AUTO_INCREMENT=52 DEFAULT CHARSET=latin1;

CREATE TABLE `taxonomy` (
  `id` bigint(20) NOT NULL DEFAULT '0',
  `hierarchy_level` varchar(16) DEFAULT NULL,
  `latin_name` text,
  `common_name` text,
  `notes` text,
  `reference_url` text,
  PRIMARY KEY (`id`),
  KEY `idIndex` (`id`),
  KEY `hierarchyLevelIndex` (`hierarchy_level`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `trips` (
  `id` mediumint(9) NOT NULL AUTO_INCREMENT,
  `leader` text,
  `reference_url` text,
  `name` text,
  `notes` text,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dateIndex` (`date`)
) ENGINE=MyISAM AUTO_INCREMENT=767 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) DEFAULT NULL,
  `name` text,
  `password` text
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

