--
-- PostgreSQL database dump
--

\restrict 268WHR2fMN2iUnW3ICph91PGpLxxiIGHrbB2WbP6ZHeMzNzeZX5ffqK39TUT07F

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1

-- Started on 2026-01-16 13:44:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 868 (class 1247 OID 26542)
-- Name: user_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_role AS ENUM (
    'SUPER_ADMIN',
    'REGIONAL_ADMIN',
    'STAFF'
);


ALTER TYPE public.user_role OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 219 (class 1259 OID 26549)
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_logs (
    log_id integer NOT NULL,
    user_id integer,
    username character varying(100),
    action character varying(50) NOT NULL,
    details text,
    ip_address character varying(50),
    user_agent text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    region_id integer
);


ALTER TABLE public.audit_logs OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 26557)
-- Name: audit_logs_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_logs_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_logs_log_id_seq OWNER TO postgres;

--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 220
-- Name: audit_logs_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_logs_log_id_seq OWNED BY public.audit_logs.log_id;


--
-- TOC entry 221 (class 1259 OID 26558)
-- Name: codex_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.codex_categories (
    category_id integer NOT NULL,
    name character varying(100) NOT NULL,
    region character varying(50) DEFAULT 'Global'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.codex_categories OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 26565)
-- Name: codex_categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.codex_categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.codex_categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 222
-- Name: codex_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.codex_categories_category_id_seq OWNED BY public.codex_categories.category_id;


--
-- TOC entry 223 (class 1259 OID 26566)
-- Name: codex_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.codex_types (
    type_id integer NOT NULL,
    category_id integer,
    type_name character varying(150) NOT NULL,
    retention_period character varying(50),
    region character varying(50) DEFAULT 'Global'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.codex_types OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 26573)
-- Name: codex_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.codex_types_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.codex_types_type_id_seq OWNER TO postgres;

--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 224
-- Name: codex_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.codex_types_type_id_seq OWNED BY public.codex_types.type_id;


--
-- TOC entry 225 (class 1259 OID 26574)
-- Name: record_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_categories (
    category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text
);


ALTER TABLE public.record_categories OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 26581)
-- Name: record_categories_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_categories_category_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.record_categories_category_id_seq OWNER TO postgres;

--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 226
-- Name: record_categories_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_categories_category_id_seq OWNED BY public.record_categories.category_id;


--
-- TOC entry 227 (class 1259 OID 26582)
-- Name: record_types; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.record_types (
    type_id integer NOT NULL,
    category_id integer,
    type_name character varying(255) NOT NULL,
    retention_period character varying(100) DEFAULT '5 Years'::character varying,
    description text
);


ALTER TABLE public.record_types OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 26590)
-- Name: record_types_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_types_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.record_types_type_id_seq OWNER TO postgres;

--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 228
-- Name: record_types_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.record_types_type_id_seq OWNED BY public.record_types.type_id;


--
-- TOC entry 229 (class 1259 OID 26591)
-- Name: records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.records (
    record_id integer NOT NULL,
    title character varying(255) NOT NULL,
    region_id integer,
    category character varying(100),
    classification_rule character varying(255),
    file_path character varying(255),
    file_size bigint,
    file_type character varying(50),
    status character varying(50) DEFAULT 'Active'::character varying,
    uploaded_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    uploaded_by integer,
    retention_period character varying(50),
    disposal_date date,
    is_restricted boolean DEFAULT false,
    file_password character varying(255)
);


ALTER TABLE public.records OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 26600)
-- Name: records_record_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.records_record_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.records_record_id_seq OWNER TO postgres;

--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 230
-- Name: records_record_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.records_record_id_seq OWNED BY public.records.record_id;


--
-- TOC entry 231 (class 1259 OID 26601)
-- Name: regions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.regions (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    address character varying(255),
    status character varying(50) DEFAULT 'Active'::character varying
);


ALTER TABLE public.regions OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 26608)
-- Name: regions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.regions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.regions_id_seq OWNER TO postgres;

--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 232
-- Name: regions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.regions_id_seq OWNED BY public.regions.id;


--
-- TOC entry 235 (class 1259 OID 56377)
-- Name: system_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_settings (
    id integer NOT NULL,
    system_name character varying(100) DEFAULT 'DOST-RMS'::character varying,
    org_name character varying(150) DEFAULT 'Department of Science and Technology'::character varying,
    welcome_msg text DEFAULT 'Sign in to access the system.'::text,
    primary_color character varying(50) DEFAULT '#4f46e5'::character varying,
    secondary_color character varying(50) DEFAULT '#0f172a'::character varying,
    logo_url text,
    login_bg_url text,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT single_row_const CHECK ((id = 1))
);


ALTER TABLE public.system_settings OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 26620)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    role character varying(50) NOT NULL,
    region_id integer,
    office character varying(100),
    status character varying(20) DEFAULT 'ACTIVE'::character varying,
    full_name character varying(100),
    email character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    name character varying(255)
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 26631)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_user_id_seq OWNER TO postgres;

--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 234
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- TOC entry 4898 (class 2604 OID 26632)
-- Name: audit_logs log_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs ALTER COLUMN log_id SET DEFAULT nextval('public.audit_logs_log_id_seq'::regclass);


--
-- TOC entry 4900 (class 2604 OID 26633)
-- Name: codex_categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_categories ALTER COLUMN category_id SET DEFAULT nextval('public.codex_categories_category_id_seq'::regclass);


--
-- TOC entry 4903 (class 2604 OID 26634)
-- Name: codex_types type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_types ALTER COLUMN type_id SET DEFAULT nextval('public.codex_types_type_id_seq'::regclass);


--
-- TOC entry 4906 (class 2604 OID 26635)
-- Name: record_categories category_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_categories ALTER COLUMN category_id SET DEFAULT nextval('public.record_categories_category_id_seq'::regclass);


--
-- TOC entry 4907 (class 2604 OID 26636)
-- Name: record_types type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types ALTER COLUMN type_id SET DEFAULT nextval('public.record_types_type_id_seq'::regclass);


--
-- TOC entry 4909 (class 2604 OID 26637)
-- Name: records record_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records ALTER COLUMN record_id SET DEFAULT nextval('public.records_record_id_seq'::regclass);


--
-- TOC entry 4913 (class 2604 OID 26638)
-- Name: regions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions ALTER COLUMN id SET DEFAULT nextval('public.regions_id_seq'::regclass);


--
-- TOC entry 4915 (class 2604 OID 26640)
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- TOC entry 5108 (class 0 OID 26549)
-- Dependencies: 219
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_logs (log_id, user_id, username, action, details, ip_address, user_agent, created_at, region_id) FROM stdin;
1	\N	System	SYSTEM_INIT	Audit Trail Module Initialized	127.0.0.1	\N	2026-01-03 15:04:19.64841	\N
2	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:09:37.230426	\N
3	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:15:24.451998	\N
5	\N	Super Admin	MANUAL_TEST	Verifying Audit System works	127.0.0.1	\N	2026-01-03 15:18:32.924652	\N
6	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:19:02.356296	\N
7	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:35:38.050531	\N
8	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:36:08.045148	\N
9	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:36:44.56488	\N
10	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:54:12.407155	\N
11	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:57:51.422162	\N
12	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:57:58.529388	\N
13	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:58:20.739579	\N
14	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:02:57.159839	\N
15	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:04:20.345946	\N
16	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:04:52.381181	\N
17	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:18:59.380171	\N
18	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:24:34.947545	\N
19	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:24:44.572335	\N
20	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:37:28.320285	\N
21	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:43:59.783333	\N
22	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:53:38.242035	\N
23	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:54:22.696881	\N
24	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 11:59:27.338258	\N
25	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:04:32.517861	\N
26	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:04:50.527847	\N
27	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:09:23.09791	\N
28	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:09:40.063351	\N
29	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:09:53.987656	\N
30	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:15:26.677902	\N
31	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:15:40.855157	\N
32	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:16:02.414735	\N
33	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-05 13:20:18.824132	\N
34	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:37:11.621138	\N
35	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:38:36.305166	\N
36	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:40:10.539351	\N
37	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-05 14:40:41.574872	\N
149	8	James	LOGIN_SUCCESS	User James logged in.	::1	\N	2026-01-13 08:53:39.163979	7
38	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 08:08:46.901773	\N
39	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 08:32:54.105554	\N
40	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 08:33:02.78504	\N
41	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 08:33:40.847553	\N
42	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 09:20:59.119986	\N
4	1	\N	UPLOAD_RECORD	Uploaded "Rich-Dad-Poor-Dad" to Region ID: 2	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-03 15:15:51.4148	1
43	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 14:55:38.653152	\N
44	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 14:56:17.054941	\N
45	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 14:57:46.595176	\N
46	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	PostmanRuntime/7.49.1	2026-01-06 14:58:20.051235	\N
47	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36	2026-01-06 14:59:35.252876	\N
48	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:20:13.788267	\N
49	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:20:36.527975	\N
50	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:20:47.762858	\N
51	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:21:06.665842	\N
52	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:21:29.820507	\N
53	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:22:53.664864	\N
54	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:23:07.132067	\N
55	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-07 13:48:22.755505	\N
56	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:52:17.609735	\N
57	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:56:51.973096	\N
58	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:56:59.385263	\N
59	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 08:57:13.44336	\N
60	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:06:35.483092	\N
61	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:07:40.843028	\N
62	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	127.0.0.1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:10:47.488315	\N
63	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:11:07.206412	\N
64	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:29:48.746987	\N
65	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:34:21.63173	\N
66	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:39:44.082272	\N
67	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 09:56:55.334981	\N
68	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:10:34.483714	\N
69	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:11:04.092441	\N
70	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:13:13.519585	\N
71	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:13:50.602701	\N
72	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:15:07.917499	\N
73	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:49:52.752991	\N
74	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:50:35.668731	\N
75	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:51:05.420251	\N
76	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:51:19.612418	\N
77	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:51:59.400004	\N
78	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 10:53:37.521154	\N
79	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:06:30.756998	\N
80	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:13:52.863572	\N
81	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:14:22.803326	\N
82	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:15:14.957309	\N
83	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:17:10.095276	\N
84	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:17:55.267706	\N
85	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:34:13.969502	\N
86	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:39:49.98711	\N
87	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:40:00.196682	\N
88	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:40:17.641114	\N
89	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:40:35.290764	\N
90	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:41:16.307192	\N
91	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:41:25.558565	\N
92	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 13:50:10.333756	\N
93	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:01:42.562486	\N
94	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:02:14.393703	\N
95	\N	Mike	LOGIN_SUCCESS	User Mike logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:12:41.116769	\N
96	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:17:52.73682	\N
97	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:19:48.471459	\N
98	\N	Ced	LOGIN_SUCCESS	User Ced logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:20:31.587512	\N
99	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:20:55.523889	\N
100	\N	Vincent	LOGIN_SUCCESS	User Vincent logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:22:00.950415	\N
101	\N	admin	LOGIN_SUCCESS	User admin logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:22:21.329579	\N
102	\N	mc	LOGIN_SUCCESS	User mc logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:24:18.413675	\N
103	\N	mc	LOGIN_SUCCESS	User mc logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:56:53.636823	\N
104	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-08 14:57:08.180017	\N
105	\N	mc	LOGIN_SUCCESS	User mc logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-09 08:14:56.519436	\N
106	\N	mc	LOGIN_SUCCESS	User mc logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 13:21:03.693724	\N
107	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 13:33:27.089981	\N
108	\N	Vincent	LOGIN_SUCCESS	User Vincent logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 13:33:50.539435	\N
109	\N	mc	LOGIN_SUCCESS	User mc logged in securely.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 13:34:06.087829	\N
110	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:05:24.443676	\N
111	\N	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:05:36.084648	\N
112	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:05:58.704716	\N
113	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:06:11.243438	\N
114	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:06:28.708399	\N
115	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:08:54.030397	\N
116	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:14:47.460369	\N
117	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:15:19.669462	\N
118	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:16:29.130471	\N
119	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:16:58.413897	\N
120	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:17:28.950042	\N
121	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:18:19.062335	\N
122	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:26:26.797721	\N
123	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:29:11.104737	\N
124	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:29:43.006287	\N
125	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:40:47.559689	\N
126	\N	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:41:25.660262	\N
127	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:43:11.695963	\N
128	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:52:23.17816	\N
129	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:52:31.596196	\N
130	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:55:37.247623	\N
131	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:55:49.505638	\N
132	\N	kim@gmail.com	LOGIN_SUCCESS	User kim@gmail.com logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 14:57:10.54137	\N
133	\N	James	LOGIN_SUCCESS	User James logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:01:13.833269	\N
134	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:01:36.298319	\N
135	\N	Steph	LOGIN_SUCCESS	User Steph logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:07:25.316725	\N
136	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:10:20.998468	\N
137	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:20:54.339677	\N
138	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:27:49.27517	\N
139	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:28:01.004256	\N
140	\N	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:28:14.479233	\N
141	\N	mc	LOGIN_SUCCESS	User mc logged in.	::1	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36 Edg/143.0.0.0	2026-01-12 15:29:14.090625	\N
142	4	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-12 15:54:37.574782	2
143	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-12 15:54:59.041401	1
144	7	kim@gmail.com	LOGIN_SUCCESS	User kim@gmail.com logged in.	::1	\N	2026-01-12 15:58:24.279174	1
145	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-12 15:58:40.245137	1
146	6	mc	UPLOAD_RECORD	Uploaded "Restricted File 1" to Region 1	::1	\N	2026-01-12 16:09:03.835446	1
147	6	mc	UPLOAD_RECORD	Uploaded "Rich-Dad-Poor-Dad" (Restricted: true)	::1	\N	2026-01-13 08:41:35.426511	1
148	6	mc	ACCESS_GRANTED	Unlocked Record ID: 11	::1	\N	2026-01-13 08:41:48.884463	1
150	9	Steph	LOGIN_SUCCESS	User Steph logged in.	::1	\N	2026-01-13 08:54:15.77711	7
151	8	James	LOGIN_SUCCESS	User James logged in.	::1	\N	2026-01-13 08:54:31.984974	7
152	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-13 09:08:49.40466	1
153	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-13 09:09:04.109054	1
154	8	James	LOGIN_SUCCESS	User James logged in.	::1	\N	2026-01-13 09:09:22.374648	7
155	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-13 09:12:23.175825	1
156	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-13 09:12:44.866293	1
157	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-13 09:16:06.946073	1
158	10	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:16:51.873605	\N
159	10	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:20:44.425824	\N
160	6	mc	LOGIN_SUCCESS	User mc logged in.	::1	\N	2026-01-13 09:20:55.159531	1
161	10	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:21:16.646617	\N
162	11	admin	LOGIN_SUCCESS	User admin logged in successfully.	::1	\N	2026-01-13 09:25:20.95444	\N
163	11	admin	LOGIN_SUCCESS	User admin logged in successfully.	::1	\N	2026-01-13 09:25:37.574761	\N
164	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:29:18.488863	\N
165	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:31:53.051531	\N
166	8	James	LOGIN_SUCCESS	User James logged in.	::1	\N	2026-01-13 09:32:14.631121	7
167	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:32:37.685805	\N
168	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:37:29.152736	\N
169	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:38:24.528174	\N
170	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:43:49.264998	\N
171	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:44:01.707372	\N
172	8	James	LOGIN_SUCCESS	User James logged in.	::1	\N	2026-01-13 09:44:28.091953	7
173	8	James	LOGIN_SUCCESS	User James logged in.	::1	\N	2026-01-13 09:44:34.040833	7
174	8	James	LOGIN_SUCCESS	User James logged in.	::1	\N	2026-01-13 09:45:15.103177	7
175	9	Steph	LOGIN_SUCCESS	User Steph logged in.	::1	\N	2026-01-13 09:45:39.713758	7
176	4	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-13 09:45:50.50882	2
177	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:51:26.320287	\N
178	12	admin	DELETE_USER	Deleted User ID: 6	::1	\N	2026-01-13 09:51:40.916432	\N
179	12	admin	DELETE_USER	Deleted User ID: 4	::1	\N	2026-01-13 09:51:48.197188	\N
180	12	admin	DELETE_USER	Deleted User ID: 8	::1	\N	2026-01-13 09:51:52.268666	\N
181	12	admin	DELETE_USER	Deleted User ID: 15	::1	\N	2026-01-13 09:52:03.534693	\N
182	12	admin	DELETE_USER	Deleted User ID: 5	::1	\N	2026-01-13 09:52:06.709616	\N
183	12	admin	DELETE_USER	Deleted User ID: 9	::1	\N	2026-01-13 09:52:09.51824	\N
184	12	admin	DELETE_USER	Deleted User ID: 14	::1	\N	2026-01-13 09:52:14.494939	\N
185	12	admin	DELETE_USER	Deleted User ID: 7	::1	\N	2026-01-13 09:52:17.351631	\N
186	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:52:55.118369	\N
187	12	admin	ADD_USER	Onboarded SUPER_ADMIN "Mike" to Region 7	::1	\N	2026-01-13 09:55:14.818802	\N
188	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 09:55:27.333758	7
189	16	Mike	UPDATE_USER	Updated User ID: 12	::1	\N	2026-01-13 09:56:07.192416	7
190	16	Mike	UPDATE_USER	Updated User ID: 12	::1	\N	2026-01-13 09:56:17.360685	7
191	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:56:25.663245	\N
192	12	admin	LOGIN_SUCCESS	User admin logged in.	::1	\N	2026-01-13 09:56:33.516482	\N
193	12	admin	DELETE_USER	Deleted User ID: 12	::1	\N	2026-01-13 09:56:40.415963	\N
194	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 09:56:54.792615	7
195	16	Mike	ADD_USER	Onboarded ADMIN "Vincent" to Region 7	::1	\N	2026-01-13 09:57:51.375731	7
196	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 09:58:01.462854	7
197	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 09:58:09.478381	7
198	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 09:58:20.17406	7
199	16	Mike	ADD_USER	Onboarded STAFF "Nerve" to Region 7	::1	\N	2026-01-13 09:58:47.759027	7
200	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-13 09:58:59.659233	7
201	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 09:59:19.364814	7
202	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 10:21:46.976347	7
203	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 10:21:58.980271	7
204	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 10:22:06.042974	7
205	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 10:22:46.957209	7
206	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 10:22:58.816894	7
207	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-13 10:23:02.748594	7
208	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 10:23:21.664755	7
209	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 10:23:26.724016	7
210	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 10:28:03.097978	7
211	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 10:28:22.136741	7
212	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:29:27.428899	7
213	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 11:29:57.090205	7
214	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-13 11:30:07.736946	7
215	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:32:33.543659	7
216	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:33:13.578441	7
217	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:35:58.441426	7
218	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 11:36:29.816398	7
219	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-13 11:36:42.768106	7
220	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:39:56.966348	7
221	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 11:41:01.934236	7
222	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:47:58.937375	7
223	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 11:48:10.444445	7
224	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:48:30.420805	7
225	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:49:34.941215	7
226	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:50:09.380703	7
227	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 11:50:32.965316	7
228	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 12:52:31.607463	7
229	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 12:52:58.258469	7
230	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 12:54:39.018366	7
231	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:03:51.945063	7
232	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 13:04:13.994989	7
233	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:04:52.563793	7
234	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:16:10.829105	7
235	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:16:19.335364	7
236	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:20:35.050301	7
237	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:21:14.411431	7
238	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:24:59.720692	7
239	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 13:29:48.262844	7
240	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:34:23.667297	7
241	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:35:19.063233	7
242	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 13:35:37.288924	7
243	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:35:46.730282	7
244	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:42:46.251716	7
245	16	Mike	ACCESS_GRANTED	Unlocked Record ID: 11	::1	\N	2026-01-13 13:43:27.346005	7
246	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:45:33.860937	7
247	16	Mike	ACCESS_DENIED	Failed password attempt for Record ID: 11	::1	\N	2026-01-13 13:56:47.025735	7
248	16	Mike	ACCESS_GRANTED	Unlocked Record ID: 11	::1	\N	2026-01-13 13:57:01.248195	7
249	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 13:59:36.203946	7
250	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 14:03:41.762681	7
251	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:12:30.989159	7
252	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-13 14:12:46.074739	7
253	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-13 14:13:08.334605	7
254	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:13:26.337387	7
255	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-13 14:14:23.337961	7
256	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:14:34.032311	7
257	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-13 14:14:56.87753	7
258	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:15:09.650207	7
259	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-13 14:15:36.882253	7
260	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:15:48.052939	7
261	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-13 14:18:16.454436	7
262	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:18:43.719236	7
263	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-13 14:34:49.656559	7
264	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:35:05.366164	7
265	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 14:36:12.336944	7
266	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:39:09.73714	7
267	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 14:39:18.114918	7
268	16	Mike	UPLOAD_RECORD	Uploaded "Rich-Dad-Poor-Dad" (Restricted: true)	::1	\N	2026-01-13 14:40:23.561065	7
269	16	Mike	ACCESS_GRANTED	Unlocked Record ID: 12	::1	\N	2026-01-13 14:40:36.101477	7
270	16	Mike	UPLOAD_RECORD	Uploaded "FINAL TEST " (Restricted: false)	::1	\N	2026-01-13 15:09:53.561484	7
271	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 15:21:11.080921	7
272	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 15:21:36.736166	7
273	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-13 16:17:21.110453	7
274	16	Mike	ARCHIVE_RECORD	Archived record: "Restricted Test Final"	::1	\N	2026-01-13 16:17:48.879645	7
275	16	Mike	RESTORE_RECORD	Restored record ID: 11	::1	\N	2026-01-13 16:17:55.086859	7
276	16	Mike	ARCHIVE_RECORD	Archived record: "Restricted Test Final"	::1	\N	2026-01-13 16:18:00.55587	7
277	16	Mike	RESTORE_RECORD	Restored record ID: 11	::1	\N	2026-01-13 16:18:07.927493	7
278	16	Mike	ARCHIVE_RECORD	Archived record: "Restricted File 1"	::1	\N	2026-01-13 16:18:13.717007	7
279	16	Mike	DELETE_RECORD	Deleted "Restricted File 1"	::1	\N	2026-01-13 16:18:19.146916	7
280	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-13 16:45:20.51676	7
281	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 08:06:04.129998	7
282	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 08:06:56.8468	7
283	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 08:14:37.768751	7
284	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 08:14:56.52483	7
285	17	Vincent	ARCHIVE_RECORD	Archived "FINAL TEST "	::1	\N	2026-01-14 08:19:05.514896	7
286	17	Vincent	DELETE_RECORD	Deleted ID: 13	::1	\N	2026-01-14 08:19:23.124505	7
287	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 08:19:52.938634	7
288	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 08:20:31.261969	7
289	16	Mike	UPDATE_BRANDING	System branding updated.	::1	\N	2026-01-14 08:21:20.187117	7
290	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 08:21:32.194041	7
291	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 08:55:14.620251	7
292	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 08:55:46.372757	7
293	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 08:56:41.304484	7
294	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 08:57:23.04975	7
295	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 09:01:12.393273	7
296	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 09:04:39.093639	7
297	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 09:04:50.249758	7
298	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 09:05:05.984993	7
299	16	Mike	UPLOAD_RECORD	Uploaded "Retention Checker"	::1	\N	2026-01-14 09:07:24.869214	7
300	16	Mike	ARCHIVE_RECORD	Archived "Retention Checker"	::1	\N	2026-01-14 09:07:50.190358	7
301	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 09:18:02.707214	7
302	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 09:18:39.374959	7
303	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 09:29:27.763527	7
304	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 09:29:46.743785	7
305	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 09:30:26.621263	7
306	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 09:31:35.779156	7
307	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 09:33:34.592709	7
308	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 09:38:18.918619	7
309	18	Nerve	UPLOAD_RECORD	Uploaded "Staff Test"	::1	\N	2026-01-14 09:39:50.839129	7
310	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 09:41:33.201288	7
311	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 09:46:01.667886	7
312	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 09:59:26.092596	7
313	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 09:59:37.56494	7
314	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 10:00:23.668154	7
315	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 10:09:01.312495	7
316	18	Nerve	ARCHIVE_RECORD	Archived "Staff Test"	::1	\N	2026-01-14 10:09:22.36102	7
317	18	Nerve	DELETE_RECORD	Deleted ID: 15	::1	\N	2026-01-14 10:11:55.207468	7
318	18	Nerve	UPLOAD_RECORD	Uploaded "Staff Test"	::1	\N	2026-01-14 10:12:50.015802	7
319	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-14 10:26:37.201072	7
320	18	Nerve	UPLOAD_RECORD	Uploaded "Staff Test 2"	::1	\N	2026-01-14 10:27:24.291291	7
321	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-14 10:33:10.577544	7
322	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 10:33:30.88905	7
323	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-14 11:26:26.9756	7
324	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-15 13:14:18.318642	7
325	18	Nerve	LOGIN_SUCCESS	User Nerve logged in.	::1	\N	2026-01-15 13:55:09.758977	7
326	17	Vincent	LOGIN_SUCCESS	User Vincent logged in.	::1	\N	2026-01-15 13:55:41.684031	7
327	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-15 13:56:24.856928	7
328	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-15 14:11:52.872955	7
329	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-16 10:54:48.853913	7
330	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-16 11:02:53.276012	7
331	16	Mike	UPLOAD_RECORD	Uploaded "TOAST TEST"	::1	\N	2026-01-16 11:03:54.39706	7
332	16	Mike	ARCHIVE_RECORD	Archived "TOAST TEST"	::1	\N	2026-01-16 11:04:11.969128	7
333	16	Mike	DELETE_RECORD	Deleted ID: 18	::1	\N	2026-01-16 11:04:24.744517	7
334	16	Mike	DELETE_RECORD	Deleted ID: 14	::1	\N	2026-01-16 11:04:27.394465	7
335	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-16 11:16:47.946571	7
336	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-16 11:20:10.897344	7
337	16	Mike	LOGIN_SUCCESS	User Mike logged in.	::1	\N	2026-01-16 12:59:22.997191	7
\.


--
-- TOC entry 5110 (class 0 OID 26558)
-- Dependencies: 221
-- Data for Name: codex_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.codex_categories (category_id, name, region, created_at) FROM stdin;
4	Administrative and Management Records	Global	2025-12-26 14:10:57.061903
11	Budget Records	Global	2026-01-03 11:00:03.396859
15	OJTs	Global	2026-01-12 14:35:40.530474
\.


--
-- TOC entry 5112 (class 0 OID 26566)
-- Dependencies: 223
-- Data for Name: codex_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.codex_types (type_id, category_id, type_name, retention_period, region, created_at) FROM stdin;
6	4	Administrative Test 1	5 years	Global	2025-12-29 12:37:40.687896
7	4	Management Test 1	Permanent	Global	2025-12-29 12:37:54.720987
8	11	Budget Record Test 1	7 years	Global	2026-01-03 11:03:44.295922
9	15	Test 1	1 year	Global	2026-01-12 14:35:52.669282
11	4	FINAL RETENTION TEST	1 Weeks	Global	2026-01-15 13:36:45.415367
\.


--
-- TOC entry 5114 (class 0 OID 26574)
-- Dependencies: 225
-- Data for Name: record_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.record_categories (category_id, name, description) FROM stdin;
1	Administrative and Management Records	\N
2	Budget Records	\N
3	Financial and Accounting Records	\N
4	Human Resource/Personnel Management Records	\N
5	Information Technology Records	\N
6	Legal Records	\N
7	Procurement and Supply Records	\N
8	Training Records	\N
\.


--
-- TOC entry 5116 (class 0 OID 26582)
-- Dependencies: 227
-- Data for Name: record_types; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.record_types (type_id, category_id, type_name, retention_period, description) FROM stdin;
1	3	Disbursement Vouchers	10 Years	\N
2	3	Audit Reports	Permanent	\N
3	4	201 Files	50 Years	\N
4	1	Project Proposals	3 years after completion	\N
5	1	Acknowledgement Receipts	1 year	\N
6	1	Certifications	1 year	\N
7	1	Gate Passes	6 month	\N
8	2	Annual	3 years	\N
9	1	Official Gazett	5	\N
\.


--
-- TOC entry 5118 (class 0 OID 26591)
-- Dependencies: 229
-- Data for Name: records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.records (record_id, title, region_id, category, classification_rule, file_path, file_size, file_type, status, uploaded_at, uploaded_by, retention_period, disposal_date, is_restricted, file_password) FROM stdin;
1	Rich-Dad-Poor-Dad	1	Administrative and Management Records	Administrative Test 1	file-1767415969514-836425161.pdf	11863018	application/pdf	Active	2026-01-03 12:52:49.635512	\N	Permanent	\N	f	\N
2	Rich-Dad-Poor-Dad	7	Budget Records	Budget Record Test 1	file-1767424263164-842845210.pdf	11863018	application/pdf	Active	2026-01-03 15:11:03.388216	\N	Permanent	\N	f	\N
3	Rich-Dad-Poor-Dad	2	Administrative and Management Records	Management Test 1	file-1767424551161-871397025.pdf	11863018	application/pdf	Active	2026-01-03 15:15:51.39668	\N	Permanent	\N	f	\N
4	Rich-Dad-Poor-Dad	7	Administrative and Management Records	Administrative Test 1	file-1767840754378-646413386.pdf	11863018	application/pdf	Active	2026-01-08 10:52:34.541904	\N	Permanent	\N	f	\N
5	TEST 1.2	7	Administrative and Management Records	Administrative Test 1	file-1767840793555-936649007.pdf	11863018	application/pdf	Active	2026-01-08 10:53:13.727659	\N	Permanent	\N	f	\N
6	Final Test 1	\N	Administrative and Management Records	Administrative Test 1	file-1767849372777-83730504.pdf	11863018	application/pdf	Active	2026-01-08 13:16:12.929099	\N	Permanent	\N	f	\N
7	Final Test 1	\N	Administrative and Management Records	Administrative Test 1	file-1767849874556-598733472.pdf	11863018	application/pdf	Active	2026-01-08 13:24:34.635241	\N	Permanent	\N	f	\N
8	FINAL TEST 	7	Administrative and Management Records	Administrative Test 1	file-1767852084828-480728163.pdf	11863018	application/pdf	Active	2026-01-08 14:01:24.949414	\N	5 years	2031-01-08	f	\N
9	FINAL TEST 2	7	Budget Records	Budget Record Test 1	file-1767852644460-245689381.pdf	11863018	application/pdf	Active	2026-01-08 14:10:44.618994	\N	7 years	2033-01-08	f	\N
11	Restricted Test Final	1	Administrative and Management Records	Administrative Test 1	file-1768264895191-83259669.pdf	11863018	application/pdf	Active	2026-01-13 08:41:35.398807	\N	5 years	2031-01-13	t	$2b$10$rgcwTvxdq10UKd53s7Qnc.pdnCp0jqTl5Ms3oSHtv./mlREVgIMoK
12	Rich-Dad-Poor-Dad	7	Administrative and Management Records	Administrative Test 1	file-1768286423278-392845677.pdf	11863018	application/pdf	Active	2026-01-13 14:40:23.543521	\N	5 years	2031-01-13	t	$2b$10$Sd/vOPSIVFUP.jXanzlxyufy99zksy1p0.Bgp9M/vY0KGklnDEWSy
16	Staff Test	7	Administrative and Management Records	Administrative Test 1	file-1768356769778-95032687.pdf	11863018	application/pdf	Active	2026-01-14 10:12:50.003252	18	5 years	2031-01-14	f	\N
17	Staff Test 2	7	Administrative and Management Records	Administrative Test 1	file-1768357644014-90681609.pdf	11863018	application/pdf	Active	2026-01-14 10:27:24.280467	18	5 years	2031-01-14	f	\N
\.


--
-- TOC entry 5120 (class 0 OID 26601)
-- Dependencies: 231
-- Data for Name: regions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.regions (id, name, code, address, status) FROM stdin;
2	National Capital Region	NCR	\N	Active
3	Cordillera Administrative Region	CAR	\N	Active
4	Region I - Ilocos	R1	\N	Active
5	Region II - Cagayan Valley	R2	\N	Active
6	Region III - Central Luzon	R3	\N	Active
7	La Union	R1.1	SFC, La Union	Active
1	Central Office	CO	\N	Active
8	Visayas	V	Iloilo City	Active
\.


--
-- TOC entry 5124 (class 0 OID 56377)
-- Dependencies: 235
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_settings (id, system_name, org_name, welcome_msg, primary_color, secondary_color, logo_url, login_bg_url, updated_at) FROM stdin;
1	DOST-RMS	Department of Science and Technology	Sign in to access the Record Management System.	#6b42ff	#9497ff	/uploads/logo-1768284788227-865188845.png	\N	2026-01-14 08:21:20.174333
\.


--
-- TOC entry 5122 (class 0 OID 26620)
-- Dependencies: 233
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, username, password, role, region_id, office, status, full_name, email, created_at, name) FROM stdin;
16	Mike	$2b$10$69lgtsvHPAG/knaC1Khvn.md1zBYhmuwWrDAwQWIRP5wescs5rWci	SUPER_ADMIN	7	ITSM	Active	\N	\N	2026-01-13 09:55:14.797455	Mike Cedrick B. Danocup
17	Vincent	$2b$10$CHKluscCE5uaip14R.cohustao7fMVIhM9zwbxP.0TfMxV7vlkGmW	ADMIN	7	ORD	Active	\N	\N	2026-01-13 09:57:51.355212	John Vincent Joaquin
18	Nerve	$2b$10$eco3g4F0cRFFiOx248BWBOOSvqkXxyFnJ3HWOC7psoSwiw6OF0tBq	STAFF	7	ORD	Active	\N	\N	2026-01-13 09:58:47.740848	Nerve Ferrer
\.


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 220
-- Name: audit_logs_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_logs_log_id_seq', 337, true);


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 222
-- Name: codex_categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.codex_categories_category_id_seq', 15, true);


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 224
-- Name: codex_types_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.codex_types_type_id_seq', 11, true);


--
-- TOC entry 5141 (class 0 OID 0)
-- Dependencies: 226
-- Name: record_categories_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_categories_category_id_seq', 24, true);


--
-- TOC entry 5142 (class 0 OID 0)
-- Dependencies: 228
-- Name: record_types_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_types_type_id_seq', 9, true);


--
-- TOC entry 5143 (class 0 OID 0)
-- Dependencies: 230
-- Name: records_record_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.records_record_id_seq', 18, true);


--
-- TOC entry 5144 (class 0 OID 0)
-- Dependencies: 232
-- Name: regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.regions_id_seq', 8, true);


--
-- TOC entry 5145 (class 0 OID 0)
-- Dependencies: 234
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 18, true);


--
-- TOC entry 4926 (class 2606 OID 26642)
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT audit_logs_pkey PRIMARY KEY (log_id);


--
-- TOC entry 4932 (class 2606 OID 26644)
-- Name: codex_categories codex_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_categories
    ADD CONSTRAINT codex_categories_name_key UNIQUE (name);


--
-- TOC entry 4934 (class 2606 OID 26646)
-- Name: codex_categories codex_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_categories
    ADD CONSTRAINT codex_categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4936 (class 2606 OID 26648)
-- Name: codex_types codex_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_types
    ADD CONSTRAINT codex_types_pkey PRIMARY KEY (type_id);


--
-- TOC entry 4938 (class 2606 OID 26650)
-- Name: record_categories record_categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_categories
    ADD CONSTRAINT record_categories_name_key UNIQUE (name);


--
-- TOC entry 4940 (class 2606 OID 26652)
-- Name: record_categories record_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_categories
    ADD CONSTRAINT record_categories_pkey PRIMARY KEY (category_id);


--
-- TOC entry 4942 (class 2606 OID 26654)
-- Name: record_types record_types_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types
    ADD CONSTRAINT record_types_pkey PRIMARY KEY (type_id);


--
-- TOC entry 4944 (class 2606 OID 26656)
-- Name: records records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_pkey PRIMARY KEY (record_id);


--
-- TOC entry 4946 (class 2606 OID 26658)
-- Name: regions regions_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_code_key UNIQUE (code);


--
-- TOC entry 4948 (class 2606 OID 26660)
-- Name: regions regions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.regions
    ADD CONSTRAINT regions_pkey PRIMARY KEY (id);


--
-- TOC entry 4954 (class 2606 OID 56391)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4950 (class 2606 OID 26664)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4952 (class 2606 OID 26666)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4927 (class 1259 OID 26667)
-- Name: idx_audit_action; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_action ON public.audit_logs USING btree (action);


--
-- TOC entry 4928 (class 1259 OID 26668)
-- Name: idx_audit_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_date ON public.audit_logs USING btree (created_at);


--
-- TOC entry 4929 (class 1259 OID 26669)
-- Name: idx_audit_region; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_region ON public.audit_logs USING btree (region_id);


--
-- TOC entry 4930 (class 1259 OID 26670)
-- Name: idx_audit_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_user ON public.audit_logs USING btree (username);


--
-- TOC entry 4956 (class 2606 OID 26671)
-- Name: codex_types codex_types_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.codex_types
    ADD CONSTRAINT codex_types_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.codex_categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 4955 (class 2606 OID 26676)
-- Name: audit_logs fk_audit_region; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_logs
    ADD CONSTRAINT fk_audit_region FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- TOC entry 4958 (class 2606 OID 26696)
-- Name: records fk_uploader; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT fk_uploader FOREIGN KEY (uploaded_by) REFERENCES public.users(user_id) ON DELETE SET NULL;


--
-- TOC entry 4957 (class 2606 OID 26681)
-- Name: record_types record_types_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.record_types
    ADD CONSTRAINT record_types_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.record_categories(category_id) ON DELETE CASCADE;


--
-- TOC entry 4959 (class 2606 OID 26686)
-- Name: records records_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.records
    ADD CONSTRAINT records_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


--
-- TOC entry 4960 (class 2606 OID 26691)
-- Name: users users_region_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_region_id_fkey FOREIGN KEY (region_id) REFERENCES public.regions(id);


-- Completed on 2026-01-16 13:44:04

--
-- PostgreSQL database dump complete
--

\unrestrict 268WHR2fMN2iUnW3ICph91PGpLxxiIGHrbB2WbP6ZHeMzNzeZX5ffqK39TUT07F

