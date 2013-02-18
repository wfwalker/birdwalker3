CREATE TABLE `counties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` tinytext COLLATE utf8_unicode_ci,
  `state_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reference_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `families` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `latin_name` text COLLATE utf8_unicode_ci,
  `common_name` text COLLATE utf8_unicode_ci,
  `taxonomic_sort_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `TaxonomicSortIndex` (`taxonomic_sort_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reference_url` text COLLATE utf8_unicode_ci,
  `city` text COLLATE utf8_unicode_ci,
  `county_id` int(11) DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `latitude` float DEFAULT '0',
  `longitude` float DEFAULT '0',
  `photo` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `NameIndex` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `photos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notes` text COLLATE utf8_unicode_ci,
  `location_id` mediumint(9) DEFAULT NULL,
  `species_id` bigint(20) DEFAULT NULL,
  `trip_id` mediumint(9) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `original_filename` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `LocationIndex` (`location_id`),
  KEY `RatingIndex` (`rating`),
  KEY `SpeciesIndex` (`species_id`),
  KEY `TripIndex` (`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `date` date DEFAULT NULL,
  `content` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `sightings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `notes` text COLLATE utf8_unicode_ci,
  `exclude` tinyint(1) NOT NULL DEFAULT '0',
  `heard_only` tinyint(1) NOT NULL DEFAULT '0',
  `location_id` mediumint(9) DEFAULT NULL,
  `species_id` bigint(20) DEFAULT NULL,
  `trip_id` mediumint(9) DEFAULT NULL,
  `count` mediumint(9) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `ExcludeIndex` (`exclude`),
  KEY `LocationIndex` (`location_id`),
  KEY `SpeciesIndex` (`species_id`),
  KEY `TripIndex` (`trip_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `species` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `abbreviation` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latin_name` text COLLATE utf8_unicode_ci,
  `common_name` text COLLATE utf8_unicode_ci,
  `notes` text COLLATE utf8_unicode_ci,
  `reference_url` text COLLATE utf8_unicode_ci,
  `aba_countable` tinyint(1) NOT NULL DEFAULT '1',
  `family_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `aba_countableIndex` (`aba_countable`),
  KEY `AbbreviationIndex` (`abbreviation`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `states` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(16) COLLATE utf8_unicode_ci DEFAULT NULL,
  `abbreviation` varchar(2) COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `country_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `trips` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `leader` text COLLATE utf8_unicode_ci,
  `reference_url` text COLLATE utf8_unicode_ci,
  `name` text COLLATE utf8_unicode_ci,
  `notes` text COLLATE utf8_unicode_ci,
  `date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `dateIndex` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text COLLATE utf8_unicode_ci,
  `password` text COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20110827061348');

INSERT INTO schema_migrations (version) VALUES ('20130214003753');

INSERT INTO schema_migrations (version) VALUES ('20130214012230');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('6');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');