--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.0
-- Dumped by pg_dump version 9.6.0

-- Started on 2017-03-16 09:16:37

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 51611)
-- Name: conflict; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "conflict";


ALTER SCHEMA "conflict" OWNER TO "postgres";

SET search_path = "conflict", pg_catalog;

--
-- TOC entry 202 (class 1259 OID 51612)
-- Name: conflict_seq; Type: SEQUENCE; Schema: conflict; Owner: postgres
--

CREATE SEQUENCE "conflict_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "conflict_seq" OWNER TO "postgres";

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 203 (class 1259 OID 51614)
-- Name: connections; Type: TABLE; Schema: conflict; Owner: postgres
--

CREATE TABLE "connections" (
    "cid" integer DEFAULT "nextval"('"conflict_seq"'::"regclass") NOT NULL,
    "sid" integer NOT NULL,
    "connectionname" character varying(255) NOT NULL,
    "host" character varying(255) NOT NULL,
    "port" integer,
    "database" character varying(255) NOT NULL,
    "username" character varying(255),
    "password" character varying(255)
);


ALTER TABLE "connections" OWNER TO "postgres";

--
-- TOC entry 204 (class 1259 OID 51621)
-- Name: layers; Type: TABLE; Schema: conflict; Owner: postgres
--

CREATE TABLE "layers" (
    "lid" integer DEFAULT "nextval"('"conflict_seq"'::"regclass") NOT NULL,
    "cid" integer NOT NULL,
    "layername" character varying(255) DEFAULT ''::character varying NOT NULL,
    "schemaname" character varying(255) NOT NULL,
    "tablename" character varying(255) NOT NULL,
    "compoundid" character varying(255) NOT NULL,
    "pkid" character varying(255) NOT NULL,
    "geomid" character varying(255) NOT NULL,
    "linkid" character varying(255) DEFAULT ''::character varying NOT NULL,
    "epsg" integer NOT NULL,
    "layerlink" character varying(255) DEFAULT ''::character varying NOT NULL,
    "qlr_file" character varying(254) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "layers" OWNER TO "postgres";

--
-- TOC entry 205 (class 1259 OID 51631)
-- Name: profiles; Type: TABLE; Schema: conflict; Owner: postgres
--

CREATE TABLE "profiles" (
    "pid" integer DEFAULT "nextval"('"conflict_seq"'::"regclass") NOT NULL,
    "profilename" character varying(100) NOT NULL,
    "default_tool" integer DEFAULT 1 NOT NULL,
    "default_buffersize" double precision DEFAULT 0.0 NOT NULL,
    "default_searchtype" integer DEFAULT 0 NOT NULL,
    "profile_link" character varying(254) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "profiles" OWNER TO "postgres";

--
-- TOC entry 206 (class 1259 OID 51635)
-- Name: profiles_layers; Type: TABLE; Schema: conflict; Owner: postgres
--

CREATE TABLE "profiles_layers" (
    "lid" integer NOT NULL,
    "pid" integer NOT NULL,
    "show" boolean DEFAULT false NOT NULL
);


ALTER TABLE "profiles_layers" OWNER TO "postgres";

--
-- TOC entry 207 (class 1259 OID 51639)
-- Name: servertypes; Type: TABLE; Schema: conflict; Owner: postgres
--

CREATE TABLE "servertypes" (
    "sid" integer DEFAULT "nextval"('"conflict_seq"'::"regclass") NOT NULL,
    "servertypename" character varying(255) NOT NULL,
    "sql_overview" character varying(255),
    "sql_detail" character varying(255),
    "sql_filter" character varying(255),
    "serverconnection" character varying(255),
    "wkt_field" character varying(50) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE "servertypes" OWNER TO "postgres";

--
-- TOC entry 210 (class 1259 OID 53531)
-- Name: profiles_layers_view; Type: VIEW; Schema: conflict; Owner: postgres
--

CREATE VIEW "profiles_layers_view" AS
 SELECT "pl"."pid",
    "pl"."lid",
    "c"."cid",
    "s"."sid",
    "pl"."show",
    "p"."profilename",
    "p"."default_tool",
    "p"."default_buffersize",
    "l"."layername",
    "l"."layerlink",
    "l"."schemaname",
    "l"."tablename",
    "l"."pkid",
    "l"."compoundid",
    "l"."geomid",
    "l"."epsg",
    "l"."linkid",
    "l"."qlr_file",
    "c"."connectionname",
    "c"."host",
    "c"."port",
    "c"."username",
    "c"."password",
    "c"."database",
    "s"."servertypename",
    "s"."sql_overview",
    "s"."sql_detail",
    "s"."sql_filter",
    "s"."serverconnection",
    "p"."profile_link"
   FROM (((("profiles_layers" "pl"
     LEFT JOIN "profiles" "p" ON (("pl"."pid" = "p"."pid")))
     LEFT JOIN "layers" "l" ON (("pl"."lid" = "l"."lid")))
     LEFT JOIN "connections" "c" ON (("l"."cid" = "c"."cid")))
     LEFT JOIN "servertypes" "s" ON (("c"."sid" = "s"."sid")));


ALTER TABLE "profiles_layers_view" OWNER TO "postgres";

--
-- TOC entry 208 (class 1259 OID 51651)
-- Name: projections; Type: TABLE; Schema: conflict; Owner: postgres
--

CREATE TABLE "projections" (
    "epsg" integer NOT NULL,
    "description" character varying(255) NOT NULL
);


ALTER TABLE "projections" OWNER TO "postgres";

--
-- TOC entry 209 (class 1259 OID 53425)
-- Name: settings; Type: TABLE; Schema: conflict; Owner: postgres
--

CREATE TABLE "settings" (
    "maingroup" character varying(255) NOT NULL,
    "name" character varying(255) NOT NULL,
    "itemvalue" character varying(255) NOT NULL,
    "itemtype" character varying(255) NOT NULL
);


ALTER TABLE "settings" OWNER TO "postgres";

--
-- TOC entry 3568 (class 0 OID 0)
-- Dependencies: 202
-- Name: conflict_seq; Type: SEQUENCE SET; Schema: conflict; Owner: postgres
--

SELECT pg_catalog.setval('"conflict_seq"', 118, true);


--
-- TOC entry 3547 (class 0 OID 51614)
-- Dependencies: 203
-- Data for Name: connections; Type: TABLE DATA; Schema: conflict; Owner: postgres
--

INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (6, 1, 'lois_shadow på f-pgsql01.ad.frederikssund.dk', 'f-pgsql01.ad.frederikssund.dk', 5432, 'lois_shadow', 'postgres', 'ukulemy');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (2, 1, 'conflict på localhost', 'localhost', 5433, 'conflict', 'postgres', 'ukulemy');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (11, 1, 'conflict på localhost (5432)', 'localhost', 5432, 'conflict', 'postgres', 'ukulemy');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (20, 19, 'gis på f-sql12 (readonly)', 'f-sql12', 1433, 'gis', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (18, 9, 'gis på f-sql12', 'f-sql12', 1433, 'gis', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (53, 19, 'plansystem på f-sql12 (readonly)', 'f-sql12', 1433, 'plansystem', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (54, 9, 'plansystem på f-sql12', 'f-sql12', 1433, 'plansystem', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (55, 19, 'kp13 på f-sql12 (readonly)', 'f-sql12', 1433, 'kp13', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (56, 9, 'kp13 på f-sql12', 'f-sql12', 1433, 'kp13', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (57, 19, 'lois på f-sql12 (readonly)', 'f-sql12', 1433, 'lois', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (63, 19, 'dai på f-sql12 (readonly)', 'f-sql12', 1433, 'dai', 'qgis_reader', 'qgis_reader');
INSERT INTO "connections" ("cid", "sid", "connectionname", "host", "port", "database", "username", "password") VALUES (64, 9, 'dai på f-sql12', 'f-sql12', 1433, 'dai', 'qgis_reader', 'qgis_reader');


--
-- TOC entry 3548 (class 0 OID 51621)
-- Dependencies: 204
-- Data for Name: layers; Type: TABLE DATA; Schema: conflict; Owner: postgres
--

INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (58, 57, 'Matrikeldata,  dictionary form', '"dbo"', '"Jordstykke"', 'concat (''{''''landsejerlavskode'''': '''''',"landsejerlavskode",'''''', ''''matrikelnummer'''': '''''',"matrikelnummer",''''''}'')', '"featureID"', '"geometri"', '''NO LINK''', 25832, '''NO LINK''', '\\f-gis02\gis\Program Files\QGIS\Frederikssund temaer\005~Grunddata\Matrikeldata\Matrikelskel.qlr');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (65, 55, 'Konsekvenszoner', '"dbo"', '"Bufferzoner_KP13"', '"MI_PRINX"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (66, 20, 'Offentlige vandløb', '"dbo"', '"VANDLØB2000"', '"type"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (45, 53, 'Lokalplan', '"dbo"', '"pdk_lokalplan_vedtaget"', '"plannr"', '"ogr_fid"', '"sp_geometry"', '"doklink"', 25832, '''NO LINK''', '\\f-gis02\gis\Program Files\QGIS\Frederikssund temaer\010~Planlægning\001~Plan\Lokalplaner\Lokalplan.qlr');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (67, 20, 'Private vandløb', '"dbo"', '"vPrivate_vandløb"', '"Navn"', '"ogr_fid"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (68, 20, 'Dræn i Skibby', '"dbo"', '"DRÆN_SKIBBY"', '"korttekst"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (69, 20, 'Jupiter boringer', '"dbo"', '"jupiter_boringer_ws"', '"kode_tekst"', '"ogr_fid"', '"sp_geometry"', '"url"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (46, 53, 'Forslag til lokalplan', '"dbo"', '"pdk_lokalplan_forslag"', '"plannr"', '"ogr_fid"', '"sp_geometry"', '"doklink"', 25832, '''NO LINK''', '\\f-gis02\gis\Program Files\QGIS\Frederikssund temaer\010~Planlægning\001~Plan\Lokalplaner\Lokalplanforslag.qlr');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (70, 63, 'Beskyttede naturtyper', '"dbo"', '"bes_naturtyper"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (47, 53, 'Temalokalplan', '"dbo"', '"pdk_temalokalplan_vedtaget"', '"plannr"', '"ogr_fid"', '"sp_geometry"', '"doklink"', 25832, '''NO LINK''', '\\f-gis02\gis\Program Files\QGIS\Frederikssund temaer\010~Planlægning\001~Plan\Lokalplaner\Temalokalplan.qlr');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (71, 63, 'Beskyttede vandløb', '"dbo"', '"bes_vandloeb"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (3, 2, 'matrikeldata', 'exampledata', 'jordstykke', 'concat("matrnr",'' - '',"elavsnavn")', 'id', 'geom', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (7, 6, 'BBR bygningspunkter', 'data', 'gis_nybbr_bygningview', 'concat("VEJ_NAVN",'' '',"HusNr",'', '',"PostNr",'' '',"PostByNavn")', 'id', 'geom', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (15, 11, 'matrikeldata', 'exampledata', 'jordstykke', 'concat("matrnr",'' - '',"elavsnavn")', 'id', 'geom', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (22, 20, 'Weblager', 'dbo', 'view_frederikssund_intern_type', 'concat("aarstal",'' - '',"sagsheadline")', 'ogr_fid', 'sp_geometry', 'url', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (48, 53, 'Forslag til temalokalplan', '"dbo"', '"pdk_temalokalplan_forslag"', '"plannr"', '"ogr_fid"', '"sp_geometry"', '"doklink"', 25832, '''NO LINK''', '\\f-gis02\gis\Program Files\QGIS\Frederikssund temaer\010~Planlægning\001~Plan\Lokalplaner\Temalokalplanforslag.qlr');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (72, 63, 'Beskyttede sten- og jorddiger', '"dbo"', '"bes_sten_jorddiger"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (29, 20, 'Varmeforsyningsområde', 'dbo', 'forsyningomraade', 'concat ("forsytekst",'' /  '',"navn1203",'' /  '',"vaerdi1203")', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (73, 63, 'Boringsnære beskyttelsesområder', '"dbo"', '"bnbo"', '"status"', '"ogr_fid"', '"sp_geometry"', '"link"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (74, 63, 'NATURA 2000 Fuglebeskyttelsesområder', '"dbo"', '"fugle_bes_omr"', '"status"', '"ogr_fid"', '"sp_geometry"', '"link"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (32, 20, 'Varmetilslutningspligtområde', 'dbo', 'vw_tilslutningspligtomraade', 'concat ("navn1204",'' /  '',"vaerd1204b")', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (35, 20, 'Vandforsyningsområder', 'dbo', '"VANDFORSYNINGS_OMRÅDE"', 'concat ("Langtekst",'' /  '',"Type")', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (49, 20, 'Servitutter', '"dbo"', '"SERVITUTTER"', '"Navn"', '"MI_PRINX"', '"SP_GEOMETRY"', 'concat(''http://infokort.frederikssund.dk/dokumenter/servitutter/'',Link)', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (75, 63, 'NATURA 2000 Habitat områder', '"dbo"', '"habitat_omr"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (76, 63, 'Fredede områder', '"dbo"', '"fredede_omr"', '"status"', '"ogr_fid"', '"sp_geometry"', '"link"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (77, 63, 'Jordforurening V1', '"dbo"', '"dkjord_v1"', '"temanavn"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (78, 63, 'Jordforurening V2', '"dbo"', '"dkjord_v2"', '"temanavn"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (36, 20, 'Kloakledning', 'dbo', '"SBH_DasLedning"', '"Tematisering"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (38, 20, 'Kloak, Brønde', 'dbo', '"SBH_DasKnude"', '"Tematisering"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (39, 20, 'Fredningsforhold (BBR)', 'dbo', '"eomFREDNING_KODE"', '"FREDNING_KODE"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (40, 20, 'Højdekurver, 0.5 m. interval', 'dbo', 'hk_dhm_kurve_0_5_m', 'concat(''Højdekurve: '',kote,'' m.'')', 'ogr_fid', 'sp_geometry', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (42, 20, 'Strandbeskyttelse', '"dbo"', '"strand"', 'matrnr', 'ogr_fid', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (43, 20, 'Fredskov', '"dbo"', '"fredskov"', '"matrnr"', '"ogr_fid"', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (44, 20, 'Matrikulær vej', '"dbo"', '"fredskov"', '"matrnr"', '"ogr_fid"', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (79, 63, 'Områdeklassificering', '"dbo"', '"omr_klassificering"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (50, 55, 'Perspektivarealer', '"dbo"', '"Byzone_og_sommerhusomaader_1101"', '"plannr"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (51, 55, 'Eksisterende vindmøller', '"dbo"', '"eksisterende_moller"', '"MI_PRINX"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (52, 55, 'Vindmølleområder', '"dbo"', '"Vind_KP13"', '"MI_PRINX"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (80, 63, 'Kirkebyggelinjer', '"dbo"', '"kirkebyggelinjer"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (81, 63, 'Skovbyggelinjer (gældende)', '"dbo"', '"skovbyggelinjer"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (82, 63, 'Søbeskyttelseslinjer', '"dbo"', '"soe_bes_linjer"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (83, 63, 'Åbeskyttelseslinjer', '"dbo"', '"aa_bes_linjer"', '"status"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (84, 20, 'Fredede fortidsminder', '"dbo"', '"fundogfortid_punkt_fredet"', '"anlaegstype"', '"ogr_fid"', '"sp_geometry"', '"url"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (85, 20, 'Fortidsmindebeskyttelseslinjer', '"dbo"', '"fundogfortid_areal_beskyttelse"', '"anlaegstype"', '"ogr_fid"', '"sp_geometry"', '"url"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (86, 20, 'Fredede bygninger', '"dbo"', '"frededebygninger"', '"fredningsstatus"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (87, 20, 'Geokodningspunkter', '"dbo"', '"eomBygningspunkter"', '"Bygningsnummer"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (88, 55, 'Byzoner og sommerhusområder', '"dbo"', '"Byzone_og_sommerhusomaader_1101"', '"Type1101"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (89, 63, 'Fredede områder', '"dbo"', '"fredede_omr"', '"temanavn"', '"ogr_fid"', '"sp_geometry"', '"link"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (90, 20, 'BBR-løse geokodningspunkter', '"dbo"', '"vwBYGNING_centroid"', '"BBR_REf_txt"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (91, 20, 'Vejinteressezone', '"dbo"', '"E14210_vejinteressezone_S1"', '"beskrivelse"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (92, 20, 'Samlet sandsynlighed', '"dbo"', '"risikokort"', '"maxrisk"', '"ogr_fid"', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (93, 20, 'Fejl og rettelser spildevandsplan', '"dbo"', '"rettelser_spildevandsplan2013"', '"informatio"', '"ogr_fid"', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (94, 20, 'Bevaringsværdig Slangerup', '"dbo"', '"bevaring_slangerup"', '"type"', '"ogr_fid"', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (95, 20, 'Bygning - Fredningsstatus høj', '"dbo"', '"bygning_fredningstatus_hoej"', '"adresse"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (96, 20, 'Overordnet fokus', '"dbo"', '"fokusomraader"', '"omradenavn"', '"ogr_fid"', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (97, 20, 'tillaeg_til_spildevandsplan', '"dbo"', '"tillaeg_til_spildevandsplan"', '"navn"', '"ogr_fid"', '"ogr_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (98, 20, 'Omr kommuneatlas', '"dbo"', '"Omraader_kommuneatlas"', '"Omraade"', '"MI_PRINX"', '"SP_GEOMETRY"', '"Link"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (99, 53, 'Kommuneplantillæg', '"dbo"', '"pdk_kommuneplantillaeg_vedtaget_view"', '"plannavn"', '"ogr_fid"', '"sp_geometry"', '"doklink"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (100, 53, 'Kommuneplanramme', '"dbo"', '"pdk_kommuneplanramme_vedtaget_view"', '"plannavn"', '"ogr_fid"', '"sp_geometry"', '"doklink_kp"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (101, 55, 'Støjbelastede arealer', '"dbo"', '"Stojbelastede_arealer_1109"', '"bem"', '"MI_PRINX"', '"SP_GEOMETRY"', '"link"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (102, 55, 'Planlægningszone for risikovirksomheder', '"dbo"', '"risikovirksomheder_buffer_500m"', '"MI_PRINX"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (103, 55, 'Støjende anlæg', '"dbo"', '"Stojende_anlaeg_KP13"', '"Beskrivelse"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (105, 20, 'Matrikeldata,  dictionary form', '"dbo"', '"jordstykke"', 'concat (''{''''landsejerlavskode'''': '''''',"landsejerlavskode",'''''', ''''matrikelnummer'''': '''''',"matrikelnummer",''''''}'')', '"featureID"', '"geometri"', '''NO LINK''', 25832, '''NO LINK''', '\\f-gis02\gis\Program Files\QGIS\Frederikssund temaer\005~Grunddata\Matrikeldata\Matrikelskel.qlr');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (106, 63, 'Drikkevandsinteresser', '"dbo"', '"drikkevands_inter"', '"temanavn"', '"ogr_fid"', '"sp_geometry"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (107, 20, 'Indvindingsoplande', '"dbo"', '"Indvindingsoplande"', '"Navn"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (108, 20, 'Jordbundstype', '"dbo"', '"jordbundstype"', '"JORD_TEKST"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (109, 20, 'Jordartskort', '"dbo"', '"FRBJORD"', '"Tekst"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (111, 20, 'Kulturarvsarealer', '"dbo"', '"fundogfortid_areal_ka"', '"datering"', '"ogr_fid"', '"sp_geometry"', '"url"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (112, 55, 'Lavbundarealer', '"dbo"', '"Lavbundsarealer_1113"', '"type1113"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (113, 55, 'Lavbund - vådområder', '"dbo"', '"Lavbund_vaadomr_KP13"', '"Tekst"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (114, 20, 'Jupiter Boring m 50m buffer', '"dbo"', '"jupiter_boringer_50m_buffer"', '"formaal_tekst"', '"ogr_fid"', '"sp_geometry"', '"url"', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (115, 20, 'Sårbarhedskort', '"dbo"', '"NYSAARB"', '"Korttekst"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (116, 20, 'Indvindingsopland', '"dbo"', '"Indvindingsoplande"', '"Tekst2"', '"MI_PRINX"', '"SP_GEOMETRY"', '''NO LINK''', 25832, '''NO LINK''', '');
INSERT INTO "layers" ("lid", "cid", "layername", "schemaname", "tablename", "compoundid", "pkid", "geomid", "linkid", "epsg", "layerlink", "qlr_file") VALUES (117, 20, 'Hovedejer', '"dbo"', '"EOM_hovedejer"', '"CBSKADR"', '"featureID"', '"geometri"', '''NO LINK''', 25832, '''NO LINK''', '');


--
-- TOC entry 3549 (class 0 OID 51631)
-- Dependencies: 205
-- Data for Name: profiles; Type: TABLE DATA; Schema: conflict; Owner: postgres
--

INSERT INTO "profiles" ("pid", "profilename", "default_tool", "default_buffersize", "default_searchtype", "profile_link") VALUES (118, 'Miljø - Jordvarmetilladelser', 0, 0, 0, '');
INSERT INTO "profiles" ("pid", "profilename", "default_tool", "default_buffersize", "default_searchtype", "profile_link") VALUES (41, 'Byg - Udstykning ** TEST ** ikke færdiggjort', 0, -0.10000000000000001, 0, '');
INSERT INTO "profiles" ("pid", "profilename", "default_tool", "default_buffersize", "default_searchtype", "profile_link") VALUES (110, 'Vand - Jordsager', 0, 0, 0, '');
INSERT INTO "profiles" ("pid", "profilename", "default_tool", "default_buffersize", "default_searchtype", "profile_link") VALUES (104, 'Byg - Bebyggelsesregulerende', 2, -0.10000000000000001, 1, '');
INSERT INTO "profiles" ("pid", "profilename", "default_tool", "default_buffersize", "default_searchtype", "profile_link") VALUES (23, 'Byg - Teknik', 2, 3, 1, '');


--
-- TOC entry 3550 (class 0 OID 51635)
-- Dependencies: 206
-- Data for Name: profiles_layers; Type: TABLE DATA; Schema: conflict; Owner: postgres
--

INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (29, 23, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (22, 23, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (32, 23, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (35, 23, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (36, 23, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (38, 23, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (39, 23, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (42, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (43, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (44, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (45, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (46, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (47, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (48, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (49, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (50, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (51, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (52, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (65, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (66, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (67, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (68, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (69, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (70, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (71, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (72, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (73, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (74, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (75, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (76, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (77, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (78, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (79, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (80, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (81, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (82, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (83, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (84, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (85, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (86, 41, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (77, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (78, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (44, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (88, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (45, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (46, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (47, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (48, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (49, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (81, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (80, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (82, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (83, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (84, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (85, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (42, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (86, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (89, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (90, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (87, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (70, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (72, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (74, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (75, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (66, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (67, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (68, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (91, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (39, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (92, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (93, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (94, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (95, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (96, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (97, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (98, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (99, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (100, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (101, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (102, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (22, 104, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (79, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (77, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (78, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (106, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (73, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (107, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (108, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (109, 110, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (89, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (84, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (85, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (111, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (72, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (82, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (71, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (42, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (70, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (73, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (112, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (113, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (74, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (75, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (66, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (67, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (68, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (77, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (78, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (79, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (114, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (106, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (115, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (116, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (91, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (32, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (29, 118, true);
INSERT INTO "profiles_layers" ("lid", "pid", "show") VALUES (117, 118, true);


--
-- TOC entry 3552 (class 0 OID 51651)
-- Dependencies: 208
-- Data for Name: projections; Type: TABLE DATA; Schema: conflict; Owner: postgres
--

INSERT INTO "projections" ("epsg", "description") VALUES (25832, 'UTM32/ETRS89');
INSERT INTO "projections" ("epsg", "description") VALUES (25833, 'UTM33/ETRS89');
INSERT INTO "projections" ("epsg", "description") VALUES (4326, 'LL/WGS84');


--
-- TOC entry 3551 (class 0 OID 51639)
-- Dependencies: 207
-- Data for Name: servertypes; Type: TABLE DATA; Schema: conflict; Owner: postgres
--

INSERT INTO "servertypes" ("sid", "servertypename", "sql_overview", "sql_detail", "sql_filter", "serverconnection", "wkt_field") VALUES (1, 'QPSQL', 'select ''{}'' as layername, {} as overviewlink, count(*) as number from {}.{}', 'select ''{}'' as profilename, ''{}'' as layername,{} as layerid, {} as link, st_astext({}) as wkt_geom from {}.{}', 'st_intersects(st_buffer(st_geomfromtext(''{0}'',{1}),{2}),{3})', NULL, 'st_astext({}) as wkt_geom');
INSERT INTO "servertypes" ("sid", "servertypename", "sql_overview", "sql_detail", "sql_filter", "serverconnection", "wkt_field") VALUES (9, 'QODBC-MSSQL-INTEGRATED', 'select ''{}'' as layername, {} as overviewlink, count(*) as number from {}.{}', 'select ''{}'' as profilename, ''{}'' as layername,{} as layerid, {} as link, {}.STAsText() as wkt_geom from {}.{}', 'geometry::STGeomFromText(''{0}'',{1}).STBuffer({2}).STIntersects({3})=1', 'Driver={{SQL Server}};Server={0};Database={4};Trusted_Connection=Yes;', '{}.STAsText() as wkt_geom');
INSERT INTO "servertypes" ("sid", "servertypename", "sql_overview", "sql_detail", "sql_filter", "serverconnection", "wkt_field") VALUES (19, 'QODBC-MSSQL-USER', 'select ''{}'' as layername, {} as overviewlink, count(*) as number from {}.{}', 'select ''{}'' as profilename, ''{}'' as layername,{} as layerid, {} as link, {}.STAsText() as wkt_geom from {}.{}', 'geometry::STGeomFromText(''{0}'',{1}).STBuffer({2}).STIntersects({3})=1', 'Driver={{SQL Server}};Server={0};Database={4};Uid={2};Pwd={3};', '{}.STAsText() as wkt_geom');


--
-- TOC entry 3553 (class 0 OID 53425)
-- Dependencies: 209
-- Data for Name: settings; Type: TABLE DATA; Schema: conflict; Owner: postgres
--

INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'search_color', '#FF0000', 'str');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'search_style', '1', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'search_icon', '1', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'search_size', '30', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'buffer_style', '1', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'result_color', '#FDA040', 'str');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'result_width', '4', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'result_style', '1', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'result_icon', '4', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'result_size', '15', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'buffer_min', '0.5', 'float');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'buffer_std', '-0.1', 'float');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'adm_layer', '105', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'buffer_color', '#cccc00', 'str');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'buffer_width', '3', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'search_width', '5', 'int');
INSERT INTO "settings" ("maingroup", "name", "itemvalue", "itemtype") VALUES ('base', 'search_buffer', '19.99', 'float');


--
-- TOC entry 3403 (class 2606 OID 51655)
-- Name: connections conflict_connections_pkey; Type: CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "connections"
    ADD CONSTRAINT "conflict_connections_pkey" PRIMARY KEY ("cid");


--
-- TOC entry 3405 (class 2606 OID 51657)
-- Name: layers conflict_layers_pkey; Type: CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "layers"
    ADD CONSTRAINT "conflict_layers_pkey" PRIMARY KEY ("lid");


--
-- TOC entry 3409 (class 2606 OID 51659)
-- Name: profiles_layers conflict_profiles_layers_pkey; Type: CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "profiles_layers"
    ADD CONSTRAINT "conflict_profiles_layers_pkey" PRIMARY KEY ("lid", "pid");


--
-- TOC entry 3407 (class 2606 OID 51661)
-- Name: profiles conflict_profiles_pkey; Type: CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "profiles"
    ADD CONSTRAINT "conflict_profiles_pkey" PRIMARY KEY ("pid");


--
-- TOC entry 3413 (class 2606 OID 51663)
-- Name: projections conflict_projections_pkey; Type: CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "projections"
    ADD CONSTRAINT "conflict_projections_pkey" PRIMARY KEY ("epsg");


--
-- TOC entry 3411 (class 2606 OID 51665)
-- Name: servertypes conflict_servertypes_pkey; Type: CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "servertypes"
    ADD CONSTRAINT "conflict_servertypes_pkey" PRIMARY KEY ("sid");


--
-- TOC entry 3415 (class 2606 OID 53432)
-- Name: settings conflict_settings_pkey; Type: CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "settings"
    ADD CONSTRAINT "conflict_settings_pkey" PRIMARY KEY ("maingroup", "name");


--
-- TOC entry 3416 (class 2606 OID 51666)
-- Name: connections conflict_connections_servertypes_sid_fkey; Type: FK CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "connections"
    ADD CONSTRAINT "conflict_connections_servertypes_sid_fkey" FOREIGN KEY ("sid") REFERENCES "servertypes"("sid") ON UPDATE CASCADE;


--
-- TOC entry 3417 (class 2606 OID 51671)
-- Name: layers conflict_layers_connections_cid_fkey; Type: FK CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "layers"
    ADD CONSTRAINT "conflict_layers_connections_cid_fkey" FOREIGN KEY ("cid") REFERENCES "connections"("cid") ON UPDATE CASCADE;


--
-- TOC entry 3418 (class 2606 OID 51676)
-- Name: layers conflict_layers_projections_epsg_fkey; Type: FK CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "layers"
    ADD CONSTRAINT "conflict_layers_projections_epsg_fkey" FOREIGN KEY ("epsg") REFERENCES "projections"("epsg") ON UPDATE CASCADE;


--
-- TOC entry 3419 (class 2606 OID 51681)
-- Name: profiles_layers conflict_profiles_layers_layers_lid_fkey; Type: FK CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "profiles_layers"
    ADD CONSTRAINT "conflict_profiles_layers_layers_lid_fkey" FOREIGN KEY ("lid") REFERENCES "layers"("lid") ON UPDATE CASCADE;


--
-- TOC entry 3420 (class 2606 OID 54549)
-- Name: profiles_layers conflict_profiles_layers_profiles_pid_fkey; Type: FK CONSTRAINT; Schema: conflict; Owner: postgres
--

ALTER TABLE ONLY "profiles_layers"
    ADD CONSTRAINT "conflict_profiles_layers_profiles_pid_fkey" FOREIGN KEY ("pid") REFERENCES "profiles"("pid") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 3558 (class 0 OID 0)
-- Dependencies: 8
-- Name: conflict; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA "conflict" TO "conflict_group";
GRANT USAGE ON SCHEMA "conflict" TO "conflict";


--
-- TOC entry 3559 (class 0 OID 0)
-- Dependencies: 202
-- Name: conflict_seq; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE "conflict_seq" TO "conflict_group";


--
-- TOC entry 3560 (class 0 OID 0)
-- Dependencies: 203
-- Name: connections; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "connections" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "connections" TO "conflict_group";


--
-- TOC entry 3561 (class 0 OID 0)
-- Dependencies: 204
-- Name: layers; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "layers" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "layers" TO "conflict_group";


--
-- TOC entry 3562 (class 0 OID 0)
-- Dependencies: 205
-- Name: profiles; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "profiles" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "profiles" TO "conflict_group";


--
-- TOC entry 3563 (class 0 OID 0)
-- Dependencies: 206
-- Name: profiles_layers; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "profiles_layers" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "profiles_layers" TO "conflict_group";


--
-- TOC entry 3564 (class 0 OID 0)
-- Dependencies: 207
-- Name: servertypes; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "servertypes" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "servertypes" TO "conflict_group";


--
-- TOC entry 3565 (class 0 OID 0)
-- Dependencies: 210
-- Name: profiles_layers_view; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "profiles_layers_view" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "profiles_layers_view" TO "conflict_group";


--
-- TOC entry 3566 (class 0 OID 0)
-- Dependencies: 208
-- Name: projections; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "projections" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "projections" TO "conflict_group";


--
-- TOC entry 3567 (class 0 OID 0)
-- Dependencies: 209
-- Name: settings; Type: ACL; Schema: conflict; Owner: postgres
--

GRANT SELECT ON TABLE "settings" TO "conflict";
GRANT SELECT,REFERENCES,TRIGGER ON TABLE "settings" TO "conflict_group";


-- Completed on 2017-03-16 09:16:38

--
-- PostgreSQL database dump complete
--

