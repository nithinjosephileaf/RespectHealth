--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2
-- Dumped by pg_dump version 14.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.admin_users (
    admin_user_id integer NOT NULL,
    user_name character varying(100),
    first_name character varying(100),
    last_name character varying(100),
    password text NOT NULL,
    qr_code character varying(255),
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    role character varying(255) DEFAULT 'basic access'::character varying
);


ALTER TABLE public.admin_users OWNER TO respect_health;

--
-- Name: admin_users_admin_user_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.admin_users_admin_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_users_admin_user_id_seq OWNER TO respect_health;

--
-- Name: admin_users_admin_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.admin_users_admin_user_id_seq OWNED BY public.admin_users.admin_user_id;


--
-- Name: authorized_devices; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.authorized_devices (
    authorized_device_id integer NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    auth_token text,
    uuid character varying(255),
    name character varying(255)
);


ALTER TABLE public.authorized_devices OWNER TO respect_health;

--
-- Name: authorized_devices_authorized_device_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.authorized_devices_authorized_device_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.authorized_devices_authorized_device_id_seq OWNER TO respect_health;

--
-- Name: authorized_devices_authorized_device_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.authorized_devices_authorized_device_id_seq OWNED BY public.authorized_devices.authorized_device_id;


--
-- Name: fitness_participation_progress; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.fitness_participation_progress (
    fitness_participation_progress_id integer NOT NULL,
    participant_id integer,
    fitness_video_set_id integer,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    current_week integer DEFAULT 1,
    current_day integer DEFAULT 1,
    started_date date NOT NULL,
    last_seen_date date NOT NULL,
    percentage_progress integer NOT NULL,
    video_stopped_at character varying(100) NOT NULL,
    days_behind integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.fitness_participation_progress OWNER TO respect_health;

--
-- Name: fitness_participation_progres_fitness_participation_progres_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.fitness_participation_progres_fitness_participation_progres_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fitness_participation_progres_fitness_participation_progres_seq OWNER TO respect_health;

--
-- Name: fitness_participation_progres_fitness_participation_progres_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.fitness_participation_progres_fitness_participation_progres_seq OWNED BY public.fitness_participation_progress.fitness_participation_progress_id;


--
-- Name: fitness_video_sets; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.fitness_video_sets (
    fitness_video_set_id integer NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    set_name character varying(255) NOT NULL,
    number_of_weeks integer NOT NULL,
    videos_in_week integer NOT NULL
);


ALTER TABLE public.fitness_video_sets OWNER TO respect_health;

--
-- Name: fitness_video_sets_fitness_video_set_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.fitness_video_sets_fitness_video_set_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fitness_video_sets_fitness_video_set_id_seq OWNER TO respect_health;

--
-- Name: fitness_video_sets_fitness_video_set_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.fitness_video_sets_fitness_video_set_id_seq OWNED BY public.fitness_video_sets.fitness_video_set_id;


--
-- Name: knex_migrations; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.knex_migrations (
    id integer NOT NULL,
    name character varying(255),
    batch integer,
    migration_time timestamp with time zone
);


ALTER TABLE public.knex_migrations OWNER TO respect_health;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.knex_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_id_seq OWNER TO respect_health;

--
-- Name: knex_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.knex_migrations_id_seq OWNED BY public.knex_migrations.id;


--
-- Name: knex_migrations_lock; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.knex_migrations_lock (
    index integer NOT NULL,
    is_locked integer
);


ALTER TABLE public.knex_migrations_lock OWNER TO respect_health;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.knex_migrations_lock_index_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.knex_migrations_lock_index_seq OWNER TO respect_health;

--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.knex_migrations_lock_index_seq OWNED BY public.knex_migrations_lock.index;


--
-- Name: participant_referral; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.participant_referral (
    referral_id integer NOT NULL,
    participant_id integer NOT NULL,
    programme_referred_to character varying(255) NOT NULL,
    referring_healthcare_professional character varying(255) NOT NULL,
    referring_healthcare_professional_role character varying(255) NOT NULL,
    notes text,
    checked_contraindications_to_exercise boolean NOT NULL,
    smoker boolean NOT NULL,
    diabetes boolean NOT NULL,
    registered_deaf boolean NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    referring_organisation character varying(100),
    participant_updated_date character varying(255)
);


ALTER TABLE public.participant_referral OWNER TO respect_health;

--
-- Name: participant_referral_referral_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.participant_referral_referral_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participant_referral_referral_id_seq OWNER TO respect_health;

--
-- Name: participant_referral_referral_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.participant_referral_referral_id_seq OWNED BY public.participant_referral.referral_id;


--
-- Name: participants; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.participants (
    participant_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    unique_device_id character varying(255) NOT NULL,
    push_notification_id character varying(255) NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    address text,
    phone_number character varying(255),
    date_of_birth date,
    email text,
    gender character varying(255),
    last_ip_address character varying(255),
    purge_cache boolean DEFAULT false NOT NULL,
    days_behind integer DEFAULT 0 NOT NULL,
    phone_number_secondary character varying(100),
    referral_updated_date character varying(255),
    language character varying(100)
);


ALTER TABLE public.participants OWNER TO respect_health;

--
-- Name: participants_participant_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.participants_participant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.participants_participant_id_seq OWNER TO respect_health;

--
-- Name: participants_participant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.participants_participant_id_seq OWNED BY public.participants.participant_id;


--
-- Name: push_notifications; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.push_notifications (
    push_notification_id integer NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    body text,
    title character varying(255) NOT NULL,
    uuid character varying(255) NOT NULL,
    push_notification_token character varying(255) NOT NULL,
    participant_id integer NOT NULL,
    participant_progress_id integer NOT NULL,
    fcm_response text NOT NULL
);


ALTER TABLE public.push_notifications OWNER TO respect_health;

--
-- Name: push_notifications_push_notification_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.push_notifications_push_notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.push_notifications_push_notification_id_seq OWNER TO respect_health;

--
-- Name: push_notifications_push_notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.push_notifications_push_notification_id_seq OWNED BY public.push_notifications.push_notification_id;


--
-- Name: seen_videos; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.seen_videos (
    seen_video_id integer NOT NULL,
    participant_id integer,
    video_id integer,
    fitness_video_set_id integer,
    day_number integer,
    week_number integer,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL
);


ALTER TABLE public.seen_videos OWNER TO respect_health;

--
-- Name: seen_videos_seen_video_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.seen_videos_seen_video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.seen_videos_seen_video_id_seq OWNER TO respect_health;

--
-- Name: seen_videos_seen_video_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.seen_videos_seen_video_id_seq OWNED BY public.seen_videos.seen_video_id;


--
-- Name: videos; Type: TABLE; Schema: public; Owner: respect_health
--

CREATE TABLE public.videos (
    video_id integer NOT NULL,
    fitness_video_set_id integer,
    week_number integer NOT NULL,
    day_number integer NOT NULL,
    title character varying(255),
    description character varying(255),
    video_length character varying(255),
    file_size character varying(255),
    file_location_path character varying(255) NOT NULL,
    created_at date DEFAULT CURRENT_TIMESTAMP(6) NOT NULL,
    video_thumbnail_url character varying(255)
);


ALTER TABLE public.videos OWNER TO respect_health;

--
-- Name: videos_video_id_seq; Type: SEQUENCE; Schema: public; Owner: respect_health
--

CREATE SEQUENCE public.videos_video_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.videos_video_id_seq OWNER TO respect_health;

--
-- Name: videos_video_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: respect_health
--

ALTER SEQUENCE public.videos_video_id_seq OWNED BY public.videos.video_id;


--
-- Name: admin_users admin_user_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN admin_user_id SET DEFAULT nextval('public.admin_users_admin_user_id_seq'::regclass);


--
-- Name: authorized_devices authorized_device_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.authorized_devices ALTER COLUMN authorized_device_id SET DEFAULT nextval('public.authorized_devices_authorized_device_id_seq'::regclass);


--
-- Name: fitness_participation_progress fitness_participation_progress_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.fitness_participation_progress ALTER COLUMN fitness_participation_progress_id SET DEFAULT nextval('public.fitness_participation_progres_fitness_participation_progres_seq'::regclass);


--
-- Name: fitness_video_sets fitness_video_set_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.fitness_video_sets ALTER COLUMN fitness_video_set_id SET DEFAULT nextval('public.fitness_video_sets_fitness_video_set_id_seq'::regclass);


--
-- Name: knex_migrations id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.knex_migrations ALTER COLUMN id SET DEFAULT nextval('public.knex_migrations_id_seq'::regclass);


--
-- Name: knex_migrations_lock index; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.knex_migrations_lock ALTER COLUMN index SET DEFAULT nextval('public.knex_migrations_lock_index_seq'::regclass);


--
-- Name: participant_referral referral_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.participant_referral ALTER COLUMN referral_id SET DEFAULT nextval('public.participant_referral_referral_id_seq'::regclass);


--
-- Name: participants participant_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.participants ALTER COLUMN participant_id SET DEFAULT nextval('public.participants_participant_id_seq'::regclass);


--
-- Name: push_notifications push_notification_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.push_notifications ALTER COLUMN push_notification_id SET DEFAULT nextval('public.push_notifications_push_notification_id_seq'::regclass);


--
-- Name: seen_videos seen_video_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.seen_videos ALTER COLUMN seen_video_id SET DEFAULT nextval('public.seen_videos_seen_video_id_seq'::regclass);


--
-- Name: videos video_id; Type: DEFAULT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.videos ALTER COLUMN video_id SET DEFAULT nextval('public.videos_video_id_seq'::regclass);


--
-- Data for Name: admin_users; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.admin_users (admin_user_id, user_name, first_name, last_name, password, qr_code, created_at, role) FROM stdin;
1	marcin10	Marcin	Walczak	$2b$10$Oy8UQxvWq04NTNmWBBOQSuOCoz70mkKI..ArmNGOjsxmM/V7B0yNq	ABXH2JKRFF3WOKJR	2021-08-23	full access
12	MarcinBasic	Marcin	Walczak	$2b$10$ynN9kR1HevTnuTd3qKa.lO4zInmMAeLHIopgM93qo9Hd0tLkWkC16	ERPCO3BVMMGGKMZP	2021-09-23	basic access
13	AdminUser	Admin	User	$2b$10$HVe.5dXijahTqm6gVIRcx.MKTy/AfBuSeppFutrljsIdZQDrxAM5m	BADC4RRHKUUHMAQA	2022-04-08	full access
\.


--
-- Data for Name: authorized_devices; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.authorized_devices (authorized_device_id, created_at, auth_token, uuid, name) FROM stdin;
14	2021-09-13	\N	e3f1894ddb50f1af	Nexus 9 - Simulator
15	2021-09-14	\N	sfdafd	sdf
16	2021-09-16	\N	afds	sdaf
13	2021-09-10	\N	539291420bffeb71	HUAWEI MediaPad T3
\.


--
-- Data for Name: fitness_participation_progress; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.fitness_participation_progress (fitness_participation_progress_id, participant_id, fitness_video_set_id, created_at, current_week, current_day, started_date, last_seen_date, percentage_progress, video_stopped_at, days_behind) FROM stdin;
\.


--
-- Data for Name: fitness_video_sets; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.fitness_video_sets (fitness_video_set_id, created_at, set_name, number_of_weeks, videos_in_week) FROM stdin;
\.


--
-- Data for Name: knex_migrations; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.knex_migrations (id, name, batch, migration_time) FROM stdin;
1	20210720072011_create_admin_user.js	1	2021-08-21 18:45:26.079+01
2	20210721062338_create_participant.js	1	2021-08-21 18:45:26.124+01
3	20210721063038_create_fitness_video_sets.js	1	2021-08-21 18:45:26.159+01
4	20210721070556_create_fitness_participation_progress.js	1	2021-08-21 18:45:26.217+01
8	20210721071058_create_videos.js	2	2021-08-21 18:48:54.837+01
9	20210721072505_create_authorized_devices.js	2	2021-08-21 18:48:54.856+01
10	20210821174205_add_uuid_to_authorized_devices.js	2	2021-08-21 18:48:54.857+01
11	20210822182036_remove_participant_id_from_videos.js	3	2021-08-22 19:22:21.113+01
12	20210823091436_add_seen_videos_table.js	4	2021-08-23 10:16:55.774+01
13	20210824070255_add_day_number_to_seen_videos.js	5	2021-08-24 08:04:13.07+01
14	20210824075634_add_week_number_to_seen_videos.js	6	2021-08-24 08:56:59.368+01
15	20210831073622_add_thumbnail_url_to_videos.js	7	2021-08-31 08:37:15.205+01
16	20210904174834_add_name_to_authorised_devices.js	8	2021-09-04 18:49:43.764+01
17	20210907071540_add_role_to_users.js	9	2021-09-07 08:17:06.198+01
18	20210907091459_add_participants_info.js	10	2021-09-07 10:16:28.607+01
19	20210909085304_add_gender_to_participants.js	11	2021-09-09 09:54:12.669+01
22	20210909104847_create_push_notifications.js	12	2021-09-09 12:12:01.19+01
23	20210914133828_add_ip_address_to_participant.js	13	2021-09-14 14:38:58.708+01
24	20210914184557_add_purge_cache_to_particpants.js	14	2021-09-14 19:48:23.021+01
26	20210923103951_add_timestamps_to_seen_videos.js	15	2021-09-23 12:14:02.596+01
35	20210929204027_add_days_behind_to_participants.js	16	2021-11-23 09:21:04.695+00
36	20211113090548_participant_referral.js	16	2021-11-23 09:21:04.714+00
37	20211116071843_add_secondary_phone_number_to_paricipant.js	16	2021-11-23 09:21:04.715+00
38	20211116074110_add_referring_organization_to_refferall.js	16	2021-11-23 09:21:04.716+00
39	20211117085411_add_updated_referall_date_to_participants.js	16	2021-11-23 09:21:04.716+00
40	20211118071805_add_paricipant_updated_date_to_participant_referalls.js	16	2021-11-23 09:21:04.717+00
41	20211118074503_add_language_to_participants.js	16	2021-11-23 09:21:04.718+00
42	20211118075121_remove_language_from_referall_table.js	16	2021-11-23 09:21:04.723+00
43	20211118075957_remove_gender_from_referall_table.js	16	2021-11-23 09:21:04.724+00
\.


--
-- Data for Name: knex_migrations_lock; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.knex_migrations_lock (index, is_locked) FROM stdin;
1	0
\.


--
-- Data for Name: participant_referral; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.participant_referral (referral_id, participant_id, programme_referred_to, referring_healthcare_professional, referring_healthcare_professional_role, notes, checked_contraindications_to_exercise, smoker, diabetes, registered_deaf, created_at, referring_organisation, participant_updated_date) FROM stdin;
\.


--
-- Data for Name: participants; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.participants (participant_id, first_name, last_name, unique_device_id, push_notification_id, created_at, address, phone_number, date_of_birth, email, gender, last_ip_address, purge_cache, days_behind, phone_number_secondary, referral_updated_date, language) FROM stdin;
35	asdf	sadf	empty	empty	2021-09-16	asdfadsf	23423423	2021-09-10	marcin.walczak@gmail.com	male	\N	f	0	\N	\N	\N
29	Merk	Valczak	empty	12344445	2021-09-14	sdfa	07932876596	2021-09-14	asdfde	male	\N	t	0	\N	\N	\N
27	Mark	Merkeks	e3f1894ddb50f1af	12344445	2021-09-14	Addr	S23333333444	2021-09-14	mark.merk@gmail.com	female	::1	f	9	\N	\N	\N
33	John	Doe	sfdafd	empty	2021-09-16	asdfasdf	sdafadsf	2021-09-16	masdf	male	\N	f	13	\N	\N	\N
36	John	Doe	afds	empty	2021-09-29	asfd	asf	2021-09-29	marcin.w@gmail.com	male	\N	f	2	\N	\N	\N
\.


--
-- Data for Name: push_notifications; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.push_notifications (push_notification_id, created_at, body, title, uuid, push_notification_token, participant_id, participant_progress_id, fcm_response) FROM stdin;
38	2021-09-09	You need to be good	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":4499521551425171500,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631195373179040%bdb83543bdb83543"}]}
39	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":2500199903283241000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631195698945143%bdb83543bdb83543"}]}
40	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":4866979836808704000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631195712575713%bdb83543bdb83543"}]}
41	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":2082169692858867000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631195824454250%bdb83543bdb83543"}]}
42	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":6095519329223722000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631195847153527%bdb83543bdb83543"}]}
43	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":7370173531994246000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631195882362865%bdb83543bdb83543"}]}
44	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":2423953527540418000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196709748884%bdb83543bdb83543"}]}
45	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":1911849871191797500,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196825868096%bdb83543bdb83543"}]}
46	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":8827397947951052000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196853245877%bdb83543bdb83543"}]}
47	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":2959717063907645400,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196877898117%bdb83543bdb83543"}]}
48	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":8475046576289619000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196917253343%bdb83543bdb83543"}]}
49	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":5453194541034414000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196931654617%bdb83543bdb83543"}]}
50	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":6173666355690713000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196947115511%bdb83543bdb83543"}]}
51	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":6246022281401761000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631196947895810%bdb83543bdb83543"}]}
52	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":1880812882163149000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197006339906%bdb83543bdb83543"}]}
53	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":562960350415392260,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197049570835%bdb83543bdb83543"}]}
54	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":1783290527052279300,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197068337448%bdb83543bdb83543"}]}
55	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":8731447391819005000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197068492898%bdb83543bdb83543"}]}
56	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":5238085231441378000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197108870105%bdb83543bdb83543"}]}
57	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":4950939748498235000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197134409674%bdb83543bdb83543"}]}
58	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":1568056417251346200,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197279938331%bdb83543bdb83543"}]}
59	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":1241720275889317000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197307158420%bdb83543bdb83543"}]}
60	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":2565707707087756300,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197334807365%bdb83543bdb83543"}]}
61	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":1723622793590440700,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197354056804%bdb83543bdb83543"}]}
62	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":7819830203670679000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197387472560%bdb83543bdb83543"}]}
63	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":5287871807354108000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197437842703%bdb83543bdb83543"}]}
64	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":547803039423457000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197464539626%bdb83543bdb83543"}]}
65	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":467940653174549440,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197551515134%bdb83543bdb83543"}]}
66	2021-09-09	REEEE	Hey man	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":2963630737215863300,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631197582634648%bdb83543bdb83543"}]}
67	2021-09-09	asdfsfd	asdf	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":6829043026073634000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631224083405848%bdb83543bdb83543"}]}
68	2021-09-09	asdfasdfasdf	ASfasdf	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":6190190596690208000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631224097781338%bdb83543bdb83543"}]}
69	2021-09-09	asdasdfasdf	TE	539291420bffeb71	el-fLo2qR8qpM0cJd9eoVE:APA91bHnUMA1vM-IBNFZa63EAD2BM7UBbe_Bi7kW8BuZWsRNGBL5ubOgPgCV2rcZ3KpWWoc7xHyfnsZnyjF-IJRG_DcExEWpXoeLb7rItP0PpU_hb1haa3CYv-v7M7X9WSEPDSQVSvFY	17	5	{"multicast_id":6038949670491468000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1631224745469629%bdb83543bdb83543"}]}
71	2021-09-29	Hello Merk, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":2500153473939222000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
72	2021-09-29	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	sfdafd	empty	33	31	{"multicast_id":7880599502453177000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
70	2021-09-29	Hello Mark, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	e3f1894ddb50f1af	12344445	27	32	{"multicast_id":2488173862027433000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
73	2021-09-29	Hello asdf, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":54138471333079810,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
74	2021-09-29	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	afds	empty	36	34	{"multicast_id":2496658574164243500,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
75	2021-12-08	dsaf	asdf	539291420BFFEB71	empty	37	35	{"multicast_id":7873818662356964000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
76	2022-02-19	Hey man this is my message	asfd	539291420BFFEB71	empty	37	35	{"multicast_id":53834574327764410,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
77	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":8845947362864699000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648222705381841%bdb83543bdb83543"}]}
78	2022-03-25	Hello Mark, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	e3f1894ddb50f1af	12344445	27	32	{"multicast_id":7936079789792717000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
79	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	afds	empty	36	34	{"multicast_id":8591071677096762000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
80	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	sfdafd	empty	33	31	{"multicast_id":8946731559309306000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
81	2022-03-25	Hello Merk, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":7508166055016827000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
82	2022-03-25	Hello asdf, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":7005794653003358000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
83	2022-03-25	Hello asdf, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":4390325426912283000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
84	2022-03-25	Hello Merk, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":75906302321826960,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
85	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	sfdafd	empty	33	31	{"multicast_id":263536050463847780,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
86	2022-03-25	Hello Mark, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	e3f1894ddb50f1af	12344445	27	32	{"multicast_id":6673373892697117000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
87	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	afds	empty	36	34	{"multicast_id":5788682655069786000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
88	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":6530718960884059000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648222726359033%bdb83543bdb83543"}]}
89	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	sfdafd	empty	33	31	{"multicast_id":782463133945179900,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
90	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	afds	empty	36	34	{"multicast_id":7228784296587069000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
91	2022-03-25	Hello Mark, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	e3f1894ddb50f1af	12344445	27	32	{"multicast_id":6549222189323063000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
92	2022-03-25	Hello Merk, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":6616389904787786000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
93	2022-03-25	Hello asdf, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":6266510758166021000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
94	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":863358557845741800,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648222756428045%bdb83543bdb83543"}]}
95	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	afds	empty	36	34	{"multicast_id":6160161771525425000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
96	2022-03-25	Hello John, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	sfdafd	empty	33	31	{"multicast_id":7749046203892184000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
97	2022-03-25	Hello Merk, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":1002424936246655600,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
98	2022-03-25	Hello asdf, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	empty	empty	35	33	{"multicast_id":7264030385182641000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
99	2022-03-25	Hello Mark, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	e3f1894ddb50f1af	12344445	27	32	{"multicast_id":5023152337136284000,"success":0,"failure":1,"canonical_ids":0,"results":[{"error":"InvalidRegistration"}]}
100	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":5219532706704770000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648222977673598%bdb83543bdb83543"}]}
101	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":8568476529173480000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648223033444285%bdb83543bdb83543"}]}
102	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":3053558365793751600,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648223080351627%bdb83543bdb83543"}]}
103	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":4832837495676817000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648225854963042%bdb83543bdb83543"}]}
104	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZq0igDuTja7rpjlWUsJ0G:APA91bF9d76OL3hDtGRYB0xWRHQqfhsli8a0yyYDzKrteAFtqG0zCi7vvmd8JnTKZaiYGs99EjfsSJWSmH-wwbn0P8jbn4Q3ZpbYCwWoxJBzkfH4KLsBsctK-ts71Bjf1KNzqx2Yk4fA	38	36	{"multicast_id":5460659052637613000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648225991669654%bdb83543bdb83543"}]}
105	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	fzfgsYnwQD6y8TNEZcnH8h:APA91bH1_Jh3LvZDQeWJa-eCYqWgKVCm2jDcw9DktmSWIm1W_lkqj80M9XGFkllw-XOgtlriOWuyPlmFHz5RcAKPAPFumozQSEeLvHN550Tclr1N5Axxa35Ltuia8F2SnY2mhhVoMkSM	38	36	{"multicast_id":6611058266802769000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648244785448839%bdb83543bdb83543"}]}
106	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	fzfgsYnwQD6y8TNEZcnH8h:APA91bH1_Jh3LvZDQeWJa-eCYqWgKVCm2jDcw9DktmSWIm1W_lkqj80M9XGFkllw-XOgtlriOWuyPlmFHz5RcAKPAPFumozQSEeLvHN550Tclr1N5Axxa35Ltuia8F2SnY2mhhVoMkSM	38	36	{"multicast_id":3480010470803764000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648245133621115%bdb83543bdb83543"}]}
107	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	fzfgsYnwQD6y8TNEZcnH8h:APA91bH1_Jh3LvZDQeWJa-eCYqWgKVCm2jDcw9DktmSWIm1W_lkqj80M9XGFkllw-XOgtlriOWuyPlmFHz5RcAKPAPFumozQSEeLvHN550Tclr1N5Axxa35Ltuia8F2SnY2mhhVoMkSM	38	36	{"multicast_id":5350875192152770000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648245883974684%bdb83543bdb83543"}]}
108	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	fzfgsYnwQD6y8TNEZcnH8h:APA91bH1_Jh3LvZDQeWJa-eCYqWgKVCm2jDcw9DktmSWIm1W_lkqj80M9XGFkllw-XOgtlriOWuyPlmFHz5RcAKPAPFumozQSEeLvHN550Tclr1N5Axxa35Ltuia8F2SnY2mhhVoMkSM	38	36	{"multicast_id":3906824418731443700,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648245954148434%bdb83543bdb83543"}]}
109	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	fzfgsYnwQD6y8TNEZcnH8h:APA91bH1_Jh3LvZDQeWJa-eCYqWgKVCm2jDcw9DktmSWIm1W_lkqj80M9XGFkllw-XOgtlriOWuyPlmFHz5RcAKPAPFumozQSEeLvHN550Tclr1N5Axxa35Ltuia8F2SnY2mhhVoMkSM	38	36	{"multicast_id":3989578889410029000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648246027959705%bdb83543bdb83543"}]}
110	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	fzfgsYnwQD6y8TNEZcnH8h:APA91bH1_Jh3LvZDQeWJa-eCYqWgKVCm2jDcw9DktmSWIm1W_lkqj80M9XGFkllw-XOgtlriOWuyPlmFHz5RcAKPAPFumozQSEeLvHN550Tclr1N5Axxa35Ltuia8F2SnY2mhhVoMkSM	38	36	{"multicast_id":146408527332853600,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648246085638651%bdb83543bdb83543"}]}
111	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	fzfgsYnwQD6y8TNEZcnH8h:APA91bH1_Jh3LvZDQeWJa-eCYqWgKVCm2jDcw9DktmSWIm1W_lkqj80M9XGFkllw-XOgtlriOWuyPlmFHz5RcAKPAPFumozQSEeLvHN550Tclr1N5Axxa35Ltuia8F2SnY2mhhVoMkSM	38	36	{"multicast_id":8154476032104309000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648246206893399%bdb83543bdb83543"}]}
112	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":471985828600603460,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648246791119477%bdb83543bdb83543"}]}
113	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":1165626884898740700,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648246882270519%bdb83543bdb83543"}]}
114	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":2262813728444725500,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247216015023%bdb83543bdb83543"}]}
115	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":3800610536858119700,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247317043125%bdb83543bdb83543"}]}
116	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":2118051576214507500,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247538358645%bdb83543bdb83543"}]}
117	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":5802979044842699000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247636161779%bdb83543bdb83543"}]}
118	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":1022234243521012000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247865949046%bdb83543bdb83543"}]}
119	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":7888692956379314000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247907268753%bdb83543bdb83543"}]}
120	2022-03-25	Hello Marcin, Just a friendly reminder to view the last video in your excercise plan 	You missed one video	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":813415305680946800,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247921319181%bdb83543bdb83543"}]}
121	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":6133268000622397000,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648247968386098%bdb83543bdb83543"}]}
122	2022-03-25	Hello Marcin, Well done! New video has been made available specially for you	New video available	539291420bffeb71	eZhZGqdtTxK8ut95pgHuq8:APA91bE74wlvdtN19apHpv9fPwCmHkBFCRlNo6Uc72hNFc0uMqppxtckJma_AlN6Q6drJoSXB1-0k8hhS9Uy2zAem7GIZU5-CvzuncKBq2V1KdMxu905JVeVrPvq451HBKzYH5Hcy_3M	38	36	{"multicast_id":1865998138182143200,"success":1,"failure":0,"canonical_ids":0,"results":[{"message_id":"0:1648248103624161%bdb83543bdb83543"}]}
\.


--
-- Data for Name: seen_videos; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.seen_videos (seen_video_id, participant_id, video_id, fitness_video_set_id, day_number, week_number, created_at) FROM stdin;
\.


--
-- Data for Name: videos; Type: TABLE DATA; Schema: public; Owner: respect_health
--

COPY public.videos (video_id, fitness_video_set_id, week_number, day_number, title, description, video_length, file_size, file_location_path, created_at, video_thumbnail_url) FROM stdin;
\.


--
-- Name: admin_users_admin_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.admin_users_admin_user_id_seq', 13, true);


--
-- Name: authorized_devices_authorized_device_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.authorized_devices_authorized_device_id_seq', 19, true);


--
-- Name: fitness_participation_progres_fitness_participation_progres_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.fitness_participation_progres_fitness_participation_progres_seq', 36, true);


--
-- Name: fitness_video_sets_fitness_video_set_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.fitness_video_sets_fitness_video_set_id_seq', 10, true);


--
-- Name: knex_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.knex_migrations_id_seq', 43, true);


--
-- Name: knex_migrations_lock_index_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.knex_migrations_lock_index_seq', 1, true);


--
-- Name: participant_referral_referral_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.participant_referral_referral_id_seq', 2, true);


--
-- Name: participants_participant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.participants_participant_id_seq', 38, true);


--
-- Name: push_notifications_push_notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.push_notifications_push_notification_id_seq', 122, true);


--
-- Name: seen_videos_seen_video_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.seen_videos_seen_video_id_seq', 248, true);


--
-- Name: videos_video_id_seq; Type: SEQUENCE SET; Schema: public; Owner: respect_health
--

SELECT pg_catalog.setval('public.videos_video_id_seq', 71, true);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (admin_user_id);


--
-- Name: admin_users admin_users_user_name_unique; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_user_name_unique UNIQUE (user_name);


--
-- Name: authorized_devices authorized_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.authorized_devices
    ADD CONSTRAINT authorized_devices_pkey PRIMARY KEY (authorized_device_id);


--
-- Name: fitness_participation_progress fitness_participation_progress_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.fitness_participation_progress
    ADD CONSTRAINT fitness_participation_progress_pkey PRIMARY KEY (fitness_participation_progress_id);


--
-- Name: fitness_video_sets fitness_video_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.fitness_video_sets
    ADD CONSTRAINT fitness_video_sets_pkey PRIMARY KEY (fitness_video_set_id);


--
-- Name: knex_migrations_lock knex_migrations_lock_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.knex_migrations_lock
    ADD CONSTRAINT knex_migrations_lock_pkey PRIMARY KEY (index);


--
-- Name: knex_migrations knex_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.knex_migrations
    ADD CONSTRAINT knex_migrations_pkey PRIMARY KEY (id);


--
-- Name: participant_referral participant_referral_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.participant_referral
    ADD CONSTRAINT participant_referral_pkey PRIMARY KEY (referral_id);


--
-- Name: participants participants_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.participants
    ADD CONSTRAINT participants_pkey PRIMARY KEY (participant_id);


--
-- Name: push_notifications push_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.push_notifications
    ADD CONSTRAINT push_notifications_pkey PRIMARY KEY (push_notification_id);


--
-- Name: seen_videos seen_videos_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.seen_videos
    ADD CONSTRAINT seen_videos_pkey PRIMARY KEY (seen_video_id);


--
-- Name: videos videos_pkey; Type: CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_pkey PRIMARY KEY (video_id);


--
-- Name: fitness_participation_progress fitness_participation_progress_fitness_video_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.fitness_participation_progress
    ADD CONSTRAINT fitness_participation_progress_fitness_video_set_id_foreign FOREIGN KEY (fitness_video_set_id) REFERENCES public.fitness_video_sets(fitness_video_set_id);


--
-- Name: fitness_participation_progress fitness_participation_progress_participant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.fitness_participation_progress
    ADD CONSTRAINT fitness_participation_progress_participant_id_foreign FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id);


--
-- Name: participant_referral participant_referral_participant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.participant_referral
    ADD CONSTRAINT participant_referral_participant_id_foreign FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id);


--
-- Name: seen_videos seen_videos_fitness_video_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.seen_videos
    ADD CONSTRAINT seen_videos_fitness_video_set_id_foreign FOREIGN KEY (fitness_video_set_id) REFERENCES public.fitness_video_sets(fitness_video_set_id);


--
-- Name: seen_videos seen_videos_participant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.seen_videos
    ADD CONSTRAINT seen_videos_participant_id_foreign FOREIGN KEY (participant_id) REFERENCES public.participants(participant_id);


--
-- Name: seen_videos seen_videos_video_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.seen_videos
    ADD CONSTRAINT seen_videos_video_id_foreign FOREIGN KEY (video_id) REFERENCES public.videos(video_id);


--
-- Name: videos videos_fitness_video_set_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: respect_health
--

ALTER TABLE ONLY public.videos
    ADD CONSTRAINT videos_fitness_video_set_id_foreign FOREIGN KEY (fitness_video_set_id) REFERENCES public.fitness_video_sets(fitness_video_set_id);


--
-- PostgreSQL database dump complete
--

